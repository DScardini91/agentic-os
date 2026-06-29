# Hook Performance Fix — v2.2.1

> Apply this if your agentic-os fork is based on any version before 2.2.1 and you're experiencing slow session startup (~20s) or sessions that freeze indefinitely.

---

## What was wrong

### 1. Session startup taking 20+ seconds

`session-start-violations.sh` reads two log files on every session start to detect governance violations. The original implementation looped over each recent session and re-read the full file for each one — O(2N+1) file reads where N is the number of sessions in the last 24h.

On a mature repo with active use, this adds 15–25 seconds to every startup.

### 2. Sessions freezing indefinitely

All hooks had `timeout=none`. If any hook hangs (network call, slow filesystem, unresponsive subprocess), the session waits forever without accepting new input.

### 3. Redundant hook executions

`state-drift-check.sh` and `memory-ttl-compaction.sh` were registered in both `SessionStart` and `Stop` — running twice per session for no benefit.

---

## Fix 1 — Rewrite `session-start-violations.sh` (single-pass)

Replace the loop section (lines ~40–61) with a single jq slurp pass.

**Find this block:**
```bash
prev_sessions=$(jq -r --arg cutoff "$RECENT_CUTOFF" 'select(.ts >= $cutoff) | .session // empty' "$FIRES_LOG" 2>/dev/null | sort -u | grep -v '^$' || true)

violations=""
for sess in $prev_sessions; do
  fires=$(jq -c --arg s "$sess" 'select(.kind=="pre-fire" and .session==$s)' "$FIRES_LOG" 2>/dev/null || true)
  ...
done
```

**Replace with:**
```bash
FIRES_RAW=$(tail -2000 "$FIRES_LOG")
CALLS_RAW=""
[ -f "$CALLS_LOG" ] && CALLS_RAW=$(tail -500 "$CALLS_LOG")

violations=$(printf '%s\n%s\n' "$FIRES_RAW" "$CALLS_RAW" \
  | jq -rs --arg cutoff "$RECENT_CUTOFF" '
    (map(select(.kind == "pre-fire" and (.ts // "") >= $cutoff))) as $fires |
    (map(select(.kind == "call"))
      | group_by(.session)
      | map({key: .[0].session, value: [.[].agent]})
      | from_entries) as $call_map |
    $fires[] |
    . as $f |
    ($call_map[$f.session] // []) as $agents |
    select(($f.trigger as $t | $agents | any(. == $t)) | not) |
    [$f.session, $f.matcher, $f.trigger, ($f.file_path // $f.command // ""), $f.severity] |
    @tsv
  ' 2>/dev/null || true)
```

**Why `any(. == $t)` instead of `index($t)`:** `index/1` on a jq array checks for a sub-array, not an element. Behavior is inconsistent across jq 1.5/1.6/1.7. `any(. == $t)` is unambiguous.

**Result:** 2 file reads total regardless of N sessions. Startup drops from ~20s to <1s.

---

## Fix 2 — Add timeouts to all hooks in `settings.json`

Every hook entry needs a `"timeout"` field. Without it, a single hung hook freezes the session forever.

**Recommended values:**

| Event | Hook type | Timeout |
|---|---|---|
| SessionStart | Context injection (dailies, skills, concepts) | `10` |
| SessionStart | Violations check | `20` |
| SessionStart | Fast checks (canon-recheck, etc.) | `5` |
| SessionStart | Harness validation | `10` |
| PreToolUse | All guards (trigger-check, block-*, enforce-*) | `5` |
| PostToolUse | Logging | `5` |
| Stop | Reports, accumulate, drift, compaction | `10` |

**Example — before:**
```json
{
  "type": "command",
  "command": "bash \"$CLAUDE_PROJECT_DIR/control-plane/scripts/session-start-violations.sh\""
}
```

**Example — after:**
```json
{
  "type": "command",
  "timeout": 20,
  "command": "bash \"$CLAUDE_PROJECT_DIR/control-plane/scripts/session-start-violations.sh\""
}
```

Apply this to every hook in `settings.json`. No hook should have `timeout=none` or omit the field entirely.

---

## Fix 3 — Remove `state-drift-check` and `memory-ttl-compaction` from `SessionStart`

These two scripts run on Stop to clean up at session end. They don't need to run on SessionStart too.

In `settings.json`, remove these two entries from the `SessionStart` hooks array (keep them in `Stop`):

```json
{
  "type": "command",
  "command": "bash \"$CLAUDE_PROJECT_DIR/control-plane/scripts/state-drift-check.sh\" 2>/dev/null || true"
},
{
  "type": "command",
  "command": "bash \"$CLAUDE_PROJECT_DIR/control-plane/scripts/memory-ttl-compaction.sh\" 2>/dev/null || true"
}
```

---

## Fix 4 — Consolidate PreToolUse matchers (optional)

If your `settings.json` has separate `Write`, `Edit`, and `MultiEdit` matcher blocks with identical hooks, consolidate them:

**Before (3 blocks, 8 entries):**
```json
{ "matcher": "Write",     "hooks": [ hook-A, hook-B, hook-C ] },
{ "matcher": "Edit",      "hooks": [ hook-A, hook-B, hook-C ] },
{ "matcher": "MultiEdit", "hooks": [ hook-B, hook-C ] }
```

**After (1 block, 3 entries):**
```json
{ "matcher": "Write|Edit|MultiEdit", "hooks": [ hook-A, hook-B, hook-C ] }
```

Note: this also adds `hook-A` coverage to `MultiEdit` if it was missing — which is typically the correct behavior.

---

## Verify

After applying, benchmark your startup:

```bash
time bash control-plane/scripts/session-start-violations.sh < /dev/null > /dev/null
```

Expected: under 2 seconds. If still slow, check that `pre-tool-fires.jsonl` isn't very large — rotate it with:

```bash
python3 -c "
import json
from datetime import datetime, timezone, timedelta
cutoff = (datetime.now(timezone.utc) - timedelta(days=7)).strftime('%Y-%m-%dT')
lines = [l for l in open('control-plane/memory/observability/pre-tool-fires.jsonl')
         if json.loads(l.strip()).get('ts','') >= cutoff]
open('control-plane/memory/observability/pre-tool-fires.jsonl','w').write('\n'.join(l.rstrip() for l in lines)+'\n')
print(f'Kept {len(lines)} lines')
"
```

---

## Reference

- PR: [#9 — fix(hooks): session startup performance + reliability](https://github.com/DScardini91/agentic-os/pull/9)
- Version: `v2.2.1`
- Date: 2026-06-28
