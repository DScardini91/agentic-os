#!/usr/bin/env bash
# log-agent-call.sh — PostToolUse hook
#
# Logs every Agent tool invocation to control-plane/memory/observability/agent-calls.jsonl.
# This feed is read by:
#   - block-protected-repo-writes.sh (was the owner agent invoked this session?)
#   - enforce-hub.sh (was the spoke owner invoked this session?)
#   - pre-tool-use-trigger-check.sh (was the trigger agent invoked this session?)
#   - session-start-violations.sh (cross-reference with pre-tool-fires)
#   - darwin-accumulate.sh (agent invocation patterns per session)
#
# Without this feed populated, the entire enforcement layer falls back to
# reminder-rich mode (loud but non-blocking). With it, the system reaches
# production-strict mode (precise — fires only when the agent was genuinely
# not invoked).
#
# Stdin: PostToolUse JSON { session_id, tool_name, tool_input, tool_response, ... }
# Stdout: empty (silent hook, no context injection)

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
LOG_DIR="$ROOT/control-plane/memory/observability"
CALLS_LOG="$LOG_DIR/agent-calls.jsonl"

command -v jq >/dev/null 2>&1 || exit 0

payload=$(cat)
[ -z "$payload" ] && exit 0
echo "$payload" | jq -e . >/dev/null 2>&1 || exit 0

tool_name=$(echo "$payload" | jq -r '.tool_name // empty')
[ "$tool_name" = "Agent" ] || exit 0

session=$(echo "$payload" | jq -r '.session_id // "unknown"')
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
agent=$(echo "$payload" | jq -r '.tool_input.subagent_type // .tool_input.agent_type // "general-purpose"')
description=$(echo "$payload" | jq -r '.tool_input.description // ""' | head -c 200)

# Append atomically (flock if available; fall back to plain append).
mkdir -p "$LOG_DIR"
LOCKFILE="/tmp/agentic-os-agent-calls-${session}.lock"

write_entry() {
  jq -nc \
    --arg ts "$ts" --arg session "$session" --arg agent "$agent" --arg description "$description" \
    '{kind:"call", ts:$ts, session:$session, agent:$agent, description:$description}' \
    >> "$CALLS_LOG"
}

if command -v flock >/dev/null 2>&1; then
  (
    flock -n 9 || exit 0
    write_entry
  ) 9>"$LOCKFILE"
else
  write_entry
fi

exit 0
