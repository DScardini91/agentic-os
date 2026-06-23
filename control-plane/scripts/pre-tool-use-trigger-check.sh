#!/usr/bin/env bash
# pre-tool-use-trigger-check.sh — PreToolUse hook (agentic-by-default)
#
# Detects tool calls that fire registered triggers (per control-plane/config/triggers.yaml)
# and injects a reminder (or hard block) BEFORE the tool executes. Logs each
# fire to pre-tool-fires.jsonl for cross-referencing with agent-calls.jsonl.
#
# Severity logic:
#   reminder       — injects additionalContext, lets tool proceed
#   reminder-only  — same, never escalates
#   block          — permissionDecision=deny until the agent is invoked
#
# Hard-block activates when session-start-violations.sh detects that the
# previous session had a fire WITHOUT a corresponding Agent call for the
# same matcher. Hard-block is "released" once the agent is invoked in the
# current session (verified via agent-calls.jsonl).

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
LOG_DIR="$ROOT/control-plane/memory/observability"
FIRES_LOG="$LOG_DIR/pre-tool-fires.jsonl"
CALLS_LOG="$LOG_DIR/agent-calls.jsonl"
TRIGGERS="$ROOT/control-plane/config/triggers.yaml"
# Namespace by project hash (matches session-start-violations.sh)
PROJECT_HASH=$(echo "$ROOT" | shasum 2>/dev/null | cut -c1-12 || echo "default")
ESC_FILE="$HOME/.config/agentic-os/$PROJECT_HASH/escalation-state.json"

mkdir -p "$LOG_DIR"
[ -f "$TRIGGERS" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

payload=$(cat)
[ -z "$payload" ] && exit 0
echo "$payload" | jq -e . >/dev/null 2>&1 || exit 0

tool_name=$(echo "$payload" | jq -r '.tool_name // empty')
session=$(echo "$payload" | jq -r '.session_id // "unknown"')
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
file_path=$(echo "$payload" | jq -r '.tool_input.file_path // empty')
command=$(echo "$payload" | jq -r '.tool_input.command // empty')

# Helper: parse triggers.yaml top-to-bottom. This is a lightweight parser that
# expects the canonical layout in the shipped file — one rule per "- tool:"
# block, with the keys we look for declared at fixed indent. Forks that hand-
# edit triggers.yaml should preserve the format.
trigger_agent=""
matcher=""
severity=""
override_env=""

current_tools=""
current_path=""
current_excludes=""
current_command_regex=""
current_agent=""
current_matcher=""
current_severity="reminder"
current_override=""

emit_check() {
  local match=false

  # Tool match
  if [ -n "$current_tools" ]; then
    if echo "$current_tools" | tr ',' '\n' | grep -qx "$tool_name"; then
      match=true
    else
      return
    fi
  fi
  [ "$match" = "true" ] || return

  # Path match (Edit/Write family)
  if [ -n "$current_path" ]; then
    [[ "$file_path" == *"$current_path"* ]] || return
    if [ -n "$current_excludes" ]; then
      while IFS= read -r ex; do
        [ -z "$ex" ] && continue
        [[ "$file_path" == *"$ex"* ]] && return
      done <<< "$current_excludes"
    fi
  fi

  # Command regex (Bash)
  if [ -n "$current_command_regex" ]; then
    echo "$command" | grep -qE "$current_command_regex" || return
  fi

  # Override env var
  if [ -n "$current_override" ] && [ "${!current_override:-}" = "1" ]; then
    return
  fi

  trigger_agent="$current_agent"
  matcher="$current_matcher"
  severity="$current_severity"
  override_env="$current_override"
}

state="start"
while IFS= read -r line; do
  # New rule marker
  if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*tool: ]]; then
    # Evaluate previous rule before starting a new one
    [ "$state" = "in_rule" ] && emit_check
    [ -n "$trigger_agent" ] && break
    current_tools=""
    current_path=""
    current_excludes=""
    current_command_regex=""
    current_agent=""
    current_matcher=""
    current_severity="reminder"
    current_override=""
    state="in_rule"

    # tool: may be scalar or list on same line — capture inline `[X, Y]` form
    val=$(echo "$line" | sed -E 's/.*tool:[[:space:]]*//')
    if [[ "$val" =~ ^\[ ]]; then
      current_tools=$(echo "$val" | tr -d '[]' | tr -d ' ')
    elif [ -n "$val" ]; then
      current_tools="$val"
    fi
    continue
  fi

  [ "$state" = "in_rule" ] || continue

  case "$line" in
    *"match_path:"*)        current_path=$(echo "$line"          | sed -E 's/.*match_path:[[:space:]]*//') ;;
    *"match_command_regex:"*)
                            current_command_regex=$(echo "$line" | sed -E "s/.*match_command_regex:[[:space:]]*'?//;s/'$//") ;;
    *"trigger_agent:"*)     current_agent=$(echo "$line"         | sed -E 's/.*trigger_agent:[[:space:]]*//') ;;
    *"matcher:"*)           current_matcher=$(echo "$line"       | sed -E 's/.*matcher:[[:space:]]*//') ;;
    *"severity:"*)          current_severity=$(echo "$line"      | sed -E 's/.*severity:[[:space:]]*//') ;;
    *"override_env:"*)      current_override=$(echo "$line"      | sed -E 's/.*override_env:[[:space:]]*//') ;;
    *"  - "*)               # exclude path item
      if [ -n "$current_excludes" ]; then
        current_excludes="${current_excludes}
$(echo "$line" | sed -E 's/.*-[[:space:]]+//')"
      else
        current_excludes="$(echo "$line" | sed -E 's/.*-[[:space:]]+//')"
      fi
      ;;
  esac
done < "$TRIGGERS"
# Final rule
[ -z "$trigger_agent" ] && [ "$state" = "in_rule" ] && emit_check

[ -z "$trigger_agent" ] && exit 0
[[ "$trigger_agent" == \<*\> ]] && exit 0   # unresolved placeholder = template not yet bootstrapped

# Check if trigger_agent was called in this session.
agent_called=false
if [ -f "$CALLS_LOG" ]; then
  if grep -F "\"session\":\"$session\"" "$CALLS_LOG" 2>/dev/null \
     | jq -e --arg a "$trigger_agent" 'select(.kind=="call" and .agent==$a)' >/dev/null 2>&1; then
    agent_called=true
  fi
fi
[ "$agent_called" = "true" ] && exit 0

# Hard-block lookup
final_severity="$severity"
if [ -f "$ESC_FILE" ]; then
  in_block=$(jq -r --arg m "$matcher" '.hard_blocks // [] | map(select(.matcher==$m)) | length' "$ESC_FILE" 2>/dev/null || echo 0)
  [ "$in_block" -gt 0 ] && [ "$severity" != "reminder-only" ] && final_severity="block"
fi

# Log fire
mkdir -p "$(dirname "$FIRES_LOG")"
jq -nc \
  --arg ts "$ts" --arg session "$session" --arg tool "$tool_name" \
  --arg trigger "$trigger_agent" --arg matcher "$matcher" --arg severity "$final_severity" \
  --arg file_path "$file_path" --arg cmd "$command" \
  '{kind:"pre-fire", ts:$ts, session:$session, tool:$tool, trigger:$trigger, matcher:$matcher, severity:$severity, file_path:$file_path, command:$cmd, agent_already_called:false}' \
  >> "$FIRES_LOG"

if [ "$final_severity" = "block" ]; then
  msg="🛑 **Hard block — trigger \`${matcher}\` for agent \`${trigger_agent}\`.**

Previous session fired this trigger without invoking \`${trigger_agent}\`. The block clears once you invoke the agent in this session.
→ Invoke \`${trigger_agent}\` via the Agent tool, then retry.
→ Emergency: override env vars per triggers.yaml."
  jq -nc --arg m "$msg" '{hookSpecificOutput:{hookEventName:"PreToolUse", permissionDecision:"deny", permissionDecisionReason:$m}}'
  exit 0
fi

msg="🦉 **Trigger \`${matcher}\` detected** — operation maps to agent \`${trigger_agent}\`.

Have you consulted \`${trigger_agent}\` in this session? If not, invoke it NOW before proceeding.
Ignoring this reminder is logged and may escalate to hard-block in the next session."

jq -nc --arg m "$msg" '{hookSpecificOutput:{hookEventName:"PreToolUse", additionalContext:$m}}'
exit 0
