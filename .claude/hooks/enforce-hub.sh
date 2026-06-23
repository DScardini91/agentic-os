#!/usr/bin/env bash
# enforce-hub.sh — PreToolUse hook (hub-and-spoke enforcement)
#
# Interface agent (Kowalski equivalent) is a hub: edits in domain folders
# (professional/, personal/, finance/, etc.) should pass through the
# designated spoke owner agent, not happen directly from the hub.
#
# Mapping lives in control-plane/config/spoke-owners.yaml. Spoke owners that
# have been invoked this session pass silently; missing-owner writes log a
# fire and inject a reminder (severity: warn).
#
# Allowlist (always-pass paths):
#   /control-plane/**
#   /.claude/**
#   root-level *.md (daily logs, session files)
#
# Override per-invocation: include a line "razão: <reason>" or
# "reason: <reason>" in the file content — logs as direct-override.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
CONFIG="$ROOT/control-plane/config/spoke-owners.yaml"
CALLS_LOG="$ROOT/control-plane/memory/observability/agent-calls.jsonl"
FIRES_LOG="$ROOT/control-plane/memory/observability/pre-tool-fires.jsonl"

[ -f "$CONFIG" ] || exit 0
command -v jq >/dev/null 2>&1 || exit 0

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

[ "${HARNESS_HUB_OVERRIDE:-}" = "1" ] && exit 0

file_path=$(echo "$payload" | jq -r '.tool_input.file_path // empty')
[ -z "$file_path" ] && exit 0

# Only enforce within the project tree.
case "$file_path" in
  "$ROOT"/*|*"$(basename "$ROOT")"/*) ;;
  *) exit 0 ;;
esac

# Allowlist: governance and meta paths.
rel="${file_path#$ROOT/}"
case "$rel" in
  control-plane/*|.claude/*|CLAUDE.md|*.md) exit 0 ;;
esac
# Also allow root-level *.md regardless of how the path was rendered.
if [[ "$file_path" =~ /[^/]+\.md$ ]] && [[ "$file_path" != */professional/* ]] \
   && [[ "$file_path" != */personal/*  ]] && [[ "$file_path" != */finance/* ]] \
   && [[ "$file_path" != */investments/* ]] && [[ "$file_path" != */spiritual/* ]] \
   && [[ "$file_path" != */learning/* ]]; then
  exit 0
fi

# Resolve spoke owner from config.
spoke_owner=""
domain_label=""
while IFS=':' read -r key value; do
  key=$(echo "$key" | tr -d ' \t')
  value=$(echo "$value" | sed -E 's/^[[:space:]]+//;s/[[:space:]]+$//')
  [ -z "$key" ] && continue
  [[ "$key" == \#* ]] && continue
  if [[ "$file_path" == *"/${key}/"* ]]; then
    spoke_owner="$value"
    domain_label="${key}/"
    break
  fi
done < <(grep -E '^[a-z-]+:' "$CONFIG")

[ -z "$spoke_owner" ] && exit 0
[[ "$spoke_owner" == \<*\> ]] && exit 0   # unresolved placeholder = template not yet bootstrapped

# Check if spoke owner was invoked this session.
owner_called=false
if [ -f "$CALLS_LOG" ]; then
  if grep -F "\"session\":\"$session\"" "$CALLS_LOG" 2>/dev/null \
     | jq -e --arg a "$spoke_owner" 'select(.kind=="call" and .agent==$a)' >/dev/null 2>&1; then
    owner_called=true
  fi
fi
[ "$owner_called" = "true" ] && exit 0

# Detect per-invocation override in content.
content=$(echo "$payload" | jq -r '.tool_input | (.content // "") + (.old_string // "") + (.new_string // "")' 2>/dev/null)
override_detected=false
if echo "$content" | grep -qiE '^razão:|^razao:|^reason:|hub direct:' 2>/dev/null; then
  override_detected=true
fi

mkdir -p "$(dirname "$FIRES_LOG")"
severity="warn"
matcher="hub-mandate-violation"
if [ "$override_detected" = "true" ]; then
  severity="direct-override"
  matcher="hub-direct-override"
fi

jq -nc \
  --arg ts "$ts" --arg session "$session" --arg tool "$tool_name" \
  --arg trigger "$spoke_owner" --arg matcher "$matcher" --arg severity "$severity" \
  --arg file_path "$file_path" --arg domain "$domain_label" \
  '{kind:"pre-fire", ts:$ts, session:$session, tool:$tool, trigger:$trigger, matcher:$matcher, severity:$severity, file_path:$file_path, domain:$domain, agent_already_called:false}' \
  >> "$FIRES_LOG"

[ "$override_detected" = "true" ] && exit 0

msg="🪧 **Hub mandate reminder [warn-only]** — ${tool_name} in \`${domain_label}\` without \`${spoke_owner}\` invoked this session.

Interface agent is the hub — writes in spoke domains should pass through the owner.
→ Correct: invoke \`${spoke_owner}\` → spoke executes the write.
→ Per-invocation override: include \`reason: <motivation>\` in the content and retry.
→ Session-wide override: \`export HARNESS_HUB_OVERRIDE=1\`."

jq -nc --arg c "$msg" '{hookSpecificOutput:{hookEventName:"PreToolUse", additionalContext:$c}}'
exit 0
