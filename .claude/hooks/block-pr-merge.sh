#!/usr/bin/env bash
# block-pr-merge.sh — PreToolUse hook (no-direct-merge enforcement)
#
# Blocks direct merges to main/master without senior-advisor pressure-test
# and explicit human approval. Catches:
#   git push <remote> main|master         (direct push to default branch)
#   gh pr merge <args>                    (PR merge via gh CLI)
#
# Override (vacation/emergency): export HARNESS_MERGE_OVERRIDE=1
#
# Companion to pre-tool-use-trigger-check.sh, which logs but only reminds.
# This hook actively denies the tool call (returns permissionDecision=deny).

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
FIRES_LOG="$ROOT/control-plane/memory/observability/pre-tool-fires.jsonl"

command -v jq >/dev/null 2>&1 || exit 0

payload=$(cat)
[ -z "$payload" ] && exit 0
echo "$payload" | jq -e . >/dev/null 2>&1 || exit 0

tool_name=$(echo "$payload" | jq -r '.tool_name // empty')
[ "$tool_name" = "Bash" ] || exit 0

command=$(echo "$payload" | jq -r '.tool_input.command // empty')
[ -z "$command" ] && exit 0

# Override active → silent pass.
[ "${HARNESS_MERGE_OVERRIDE:-}" = "1" ] && exit 0

block=false
matcher=""
if echo "$command" | grep -qE 'git[[:space:]]+push[[:space:]].*[[:space:]]origin[[:space:]]+(main|master)'; then
  block=true
  matcher="git-push-main"
elif echo "$command" | grep -qE 'gh[[:space:]]+pr[[:space:]]+merge([[:space:]]|$)'; then
  block=true
  matcher="gh-pr-merge"
fi

[ "$block" = "false" ] && exit 0

session=$(echo "$payload" | jq -r '.session_id // "unknown"')
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
mkdir -p "$(dirname "$FIRES_LOG")"
jq -nc \
  --arg ts "$ts" --arg session "$session" \
  --arg matcher "$matcher" --arg cmd "$command" \
  '{kind:"pre-fire", ts:$ts, session:$session, tool:"Bash", trigger:"<senior-advisor>", matcher:$matcher, severity:"block", command:$cmd}' \
  >> "$FIRES_LOG"

msg="🛑 **Direct merge blocked.**

Merges to main/master require senior-advisor pressure-test + explicit human approval.
→ Invoke the senior advisor agent for pressure-test.
→ Get explicit approval from the principal.
→ Log the decision in the decision-log.
→ Override (vacation/emergency only): \`export HARNESS_MERGE_OVERRIDE=1\`."

jq -nc --arg msg "$msg" '{hookSpecificOutput:{hookEventName:"PreToolUse", permissionDecision:"deny", permissionDecisionReason:$msg}}'
exit 0
