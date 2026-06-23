# Observability

This directory holds machine-written JSONL feeds used by the Darwin loop and the enforcement layer.

## Files (created on demand by hooks/scripts)

| File | Writer | Purpose |
|------|--------|---------|
| `agent-calls.jsonl` | (logged by Agent invocations — populated organically) | One line per Agent tool call; `pre-tool-use-trigger-check.sh` reads this to know which agents were invoked in the current session |
| `pre-tool-fires.jsonl` | PreToolUse hooks (trigger-check, enforce-hub, block-protected) | One line per trigger fire; severity, matcher, file path |
| `darwin-accumulator.jsonl` | `darwin-accumulate.sh` (Stop hook) | One line per session: agents invoked, violations, duration, infra agents |
| `session-cost.jsonl` | `session-cost-report.sh` (Stop hook, threshold-gated) | Per-session token usage + estimated cost; only above threshold |
| `memory-compaction.jsonl` | `memory-ttl-compaction.sh` | Records of state.md resets and scratchpad cleanups |

## Conventions

- One JSON object per line; trailing newline.
- Every entry must carry `ts` (UTC ISO-8601) and a `kind` field naming the event type.
- Writers should use `flock` for race-free appends when multiple sessions can fire simultaneously.
- Readers should tolerate malformed lines (skip on `jq` parse error).
- These files are git-ignored — they are local telemetry, not committed history. Compress / archive into `darwin/` if you want long-term retention.
