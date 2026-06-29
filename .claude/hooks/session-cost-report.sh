#!/usr/bin/env bash
# Stop hook — session cost & token report
#
# Fires at session close. Displays usage summary if the session exceeded
# MIN_TOKENS or MIN_SECONDS. Appends to ~/.claude/usage-log.jsonl.
#
# To suppress for a specific session:
#   export HARNESS_SKIP_COST_REPORT=1

[ "${HARNESS_SKIP_COST_REPORT:-0}" = "1" ] && exit 0

INPUT=$(cat 2>/dev/null || true)

python3 - "$INPUT" << 'PYEOF'
import json, sys, os
from datetime import datetime, timezone

# ── Config ──────────────────────────────────────────────────────────────────
MIN_TOKENS   = 50_000   # show report above 50k tokens
MIN_SECONDS  = 300      # or above 5 minutes
USAGE_LOG    = os.path.expanduser("~/.claude/usage-log.jsonl")

# Anthropic pricing (USD per 1M tokens) — update if pricing changes
PRICING = {
    "default": {
        "input":         3.00,
        "output":       15.00,
        "cache_write":   3.75,
        "cache_read":    0.30,
    },
    "claude-opus": {
        "input":        15.00,
        "output":       75.00,
        "cache_write":  18.75,
        "cache_read":    1.50,
    },
    "claude-haiku": {
        "input":         0.80,
        "output":        4.00,
        "cache_write":   1.00,
        "cache_read":    0.08,
    },
}

def get_pricing(model: str) -> dict:
    m = (model or "").lower()
    if "opus"  in m: return PRICING["claude-opus"]
    if "haiku" in m: return PRICING["claude-haiku"]
    return PRICING["default"]

# ── Parse hook input ─────────────────────────────────────────────────────────
raw_input = sys.argv[1] if len(sys.argv) > 1 else ""
try:
    hook_data = json.loads(raw_input)
except Exception:
    hook_data = {}

transcript_path = hook_data.get("transcript_path", "")
session_id      = hook_data.get("session_id", "unknown")

if not transcript_path or not os.path.isfile(transcript_path):
    sys.exit(0)

# ── Parse transcript ─────────────────────────────────────────────────────────
input_tokens  = 0
output_tokens = 0
cache_write   = 0
cache_read    = 0
tool_calls    = 0
first_ts      = None
last_ts       = None
model_used    = "default"

with open(transcript_path) as f:
    for line in f:
        try:
            entry = json.loads(line.strip())
        except Exception:
            continue

        ts = entry.get("timestamp")
        if ts:
            if first_ts is None:
                first_ts = ts
            last_ts = ts

        if entry.get("type") == "assistant":
            msg = entry.get("message", {})
            if msg.get("model"):
                model_used = msg["model"]
            usage = msg.get("usage", {})
            input_tokens  += usage.get("input_tokens", 0)
            output_tokens += usage.get("output_tokens", 0)
            cache_write   += usage.get("cache_creation_input_tokens", 0)
            cache_read    += usage.get("cache_read_input_tokens", 0)

        if entry.get("type") == "assistant":
            content = entry.get("message", {}).get("content", [])
            if isinstance(content, list):
                tool_calls += sum(1 for c in content if isinstance(c, dict) and c.get("type") == "tool_use")

# ── Elapsed time ─────────────────────────────────────────────────────────────
elapsed_secs = 0
elapsed_str  = "?"
if first_ts and last_ts:
    try:
        def parse_ts(s):
            s = s[:26].rstrip("Z")
            return datetime.fromisoformat(s).replace(tzinfo=timezone.utc)
        t0 = parse_ts(first_ts)
        t1 = parse_ts(last_ts)
        elapsed_secs = int((t1 - t0).total_seconds())
        h, rem = divmod(elapsed_secs, 3600)
        m, s   = divmod(rem, 60)
        if h:
            elapsed_str = f"{h}h {m:02d}m {s:02d}s"
        elif m:
            elapsed_str = f"{m}m {s:02d}s"
        else:
            elapsed_str = f"{s}s"
    except Exception:
        pass

# ── Threshold check ───────────────────────────────────────────────────────────
total_tokens = input_tokens + output_tokens
if total_tokens < MIN_TOKENS and elapsed_secs < MIN_SECONDS:
    sys.exit(0)

# ── Cost calculation ──────────────────────────────────────────────────────────
p = get_pricing(model_used)
cost = (
    (input_tokens  / 1_000_000) * p["input"]       +
    (output_tokens / 1_000_000) * p["output"]      +
    (cache_write   / 1_000_000) * p["cache_write"] +
    (cache_read    / 1_000_000) * p["cache_read"]
)

# ── Print report ──────────────────────────────────────────────────────────────
CYAN  = "\033[96m"
GREY  = "\033[90m"
BOLD  = "\033[1m"
RESET = "\033[0m"

def p_(label, value, unit=""):
    print(f"│  {GREY}{label:<18}{RESET}  {BOLD}{value}{RESET}{unit}", file=sys.stderr)

print("", file=sys.stderr)
print(f"{CYAN}┌─ Session Usage ──────────────────────────────────────────{RESET}", file=sys.stderr)
p_("Model",        model_used)
p_("Elapsed",      elapsed_str)
p_("Tool calls",   f"{tool_calls:,}")
p_("Input tokens", f"{input_tokens:>12,}", "")
p_("Output tokens",f"{output_tokens:>12,}", "")
if cache_write or cache_read:
    p_("Cache write",  f"{cache_write:>12,}", "")
    p_("Cache read",   f"{cache_read:>12,}", "")
p_("Total tokens", f"{total_tokens:>12,}", "")
print(f"│  {'─'*50}", file=sys.stderr)
p_("Est. cost",    f"$ {cost:>9.4f}", "  USD")
print(f"{CYAN}└──────────────────────────────────────────────────────────{RESET}", file=sys.stderr)
print("", file=sys.stderr)

# ── Append to usage log ───────────────────────────────────────────────────────
log_entry = {
    "ts":             last_ts or first_ts or datetime.now(timezone.utc).isoformat(),
    "session_id":     session_id,
    "model":          model_used,
    "elapsed_secs":   elapsed_secs,
    "tool_calls":     tool_calls,
    "input_tokens":   input_tokens,
    "output_tokens":  output_tokens,
    "cache_write":    cache_write,
    "cache_read":     cache_read,
    "total_tokens":   total_tokens,
    "cost_usd":       round(cost, 6),
}
try:
    with open(USAGE_LOG, "a") as f:
        f.write(json.dumps(log_entry) + "\n")
except Exception:
    pass

PYEOF
