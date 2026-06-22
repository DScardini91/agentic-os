#!/usr/bin/env bash
# block-protected-repo-writes.sh — PreToolUse hook (least-privilege gate)
#
# Detects Write/Edit/MultiEdit in repos/paths declared protected in
# control-plane/config/protected-repos.yaml, when the designated owner agent
# has NOT been invoked in the current session.
#
# Reads agent invocations from control-plane/memory/observability/agent-calls.jsonl
# (populated by log-agent-call.sh as a SessionStart hook).
#
# Stdin:  PreToolUse JSON { session_id, tool_name, tool_input, ... }
# Stdout: hookSpecificOutput JSON (or empty = pass)
#
# Emergency override: export HARNESS_PROTECTED_WRITE_OVERRIDE=1

set -uo pipefail

# Resolve repo root via $CLAUDE_PROJECT_DIR (Claude Code provides this).
ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
CONFIG="$ROOT/control-plane/config/protected-repos.yaml"
CALLS_LOG="$ROOT/control-plane/memory/observability/agent-calls.jsonl"
FIRES_LOG="$ROOT/control-plane/memory/observability/pre-tool-fires.jsonl"

# Skip silently if config or required tools are missing.
[ -f "$CONFIG" ] || exit 0
command -v jq  >/dev/null 2>&1 || exit 0

payload=$(cat)
[ -z "$payload" ] && exit 0
echo "$payload" | jq -e . >/dev/null 2>&1 || exit 0

tool_name=$(echo "$payload" | jq -r '.tool_name // empty')
session=$(echo "$payload" | jq -r '.session_id // "unknown"')
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

case "$tool_name" in
  Write|Edit|MultiEdit) ;;
  *) exit 0 ;;
esac

[ "${HARNESS_PROTECTED_WRITE_OVERRIDE:-}" = "1" ] && exit 0

file_path=$(echo "$payload" | jq -r '.tool_input.file_path // .tool_input.old_file_path // empty')
[ -z "$file_path" ] && exit 0

# Parse YAML config (lightweight — expects awk-friendly indent).
# Reads "path: <substring>", "owner: <agent>", "label: <label>" triples.
owner_agent=""
repo_label=""
while IFS= read -r line; do
  case "$line" in
    *"- path:"*)
      cur_path=$(echo "$line" | sed -E 's/.*- path:[[:space:]]*//')
      ;;
    *"owner:"*)
      cur_owner=$(echo "$line" | sed -E 's/.*owner:[[:space:]]*//')
      ;;
    *"label:"*)
      cur_label=$(echo "$line" | sed -E 's/.*label:[[:space:]]*//')
      if [ -n "${cur_path:-}" ] && [[ "$file_path" == *"$cur_path"* ]]; then
        owner_agent="$cur_owner"
        repo_label="$cur_label"
        break
      fi
      ;;
  esac
done < "$CONFIG"

[ -z "$owner_agent" ] && exit 0

owner_called=false
if [ -f "$CALLS_LOG" ]; then
  if grep -F "\"session\":\"$session\"" "$CALLS_LOG" 2>/dev/null \
     | jq -e --arg a "$owner_agent" 'select(.kind=="call" and .agent==$a)' >/dev/null 2>&1; then
    owner_called=true
  fi
fi

[ "$owner_called" = "true" ] && exit 0

mkdir -p "$(dirname "$FIRES_LOG")"
jq -nc \
  --arg ts "$ts" \
  --arg session "$session" \
  --arg tool "$tool_name" \
  --arg trigger "$owner_agent" \
  --arg matcher "protected-repo-write-without-owner" \
  --arg severity "reminder" \
  --arg file_path "$file_path" \
  '{kind:"pre-fire", ts:$ts, session:$session, tool:$tool, trigger:$trigger, matcher:$matcher, severity:$severity, file_path:$file_path, agent_already_called:false}' \
  >> "$FIRES_LOG"

msg="⚙️ **Protected-repo reminder** — ${tool_name} in \`${repo_label}\` without \`${owner_agent}\` invoked this session.

Interface agent should not edit protected paths directly. Route through the owner agent:
→ Correct: invoke \`${owner_agent}\` first, then perform the edit.
→ If you ARE the owner agent: ignore (call may not be logged yet).
→ Emergency: \`export HARNESS_PROTECTED_WRITE_OVERRIDE=1\` and retry."

jq -nc --arg c "$msg" '{hookSpecificOutput:{hookEventName:"PreToolUse", additionalContext:$c}}'
exit 0
