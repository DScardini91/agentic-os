#!/usr/bin/env bash
# auto-gh-auth.sh — PreToolUse hook
#
# When a `gh` command is about to run, verify gh is authenticated. If not,
# inject a reminder so the agent surfaces a clear next step instead of letting
# gh fail with an opaque error mid-pipeline.
#
# Read-only: never blocks. Adds context only when auth state is broken.

set -uo pipefail

command -v jq >/dev/null 2>&1 || exit 0
command -v gh >/dev/null 2>&1 || exit 0

payload=$(cat)
[ -z "$payload" ] && exit 0
echo "$payload" | jq -e . >/dev/null 2>&1 || exit 0

tool_name=$(echo "$payload" | jq -r '.tool_name // empty')
[ "$tool_name" = "Bash" ] || exit 0

command=$(echo "$payload" | jq -r '.tool_input.command // empty')
echo "$command" | grep -qE '(^|[^a-zA-Z])gh[[:space:]]' || exit 0

# Probe gh auth without blocking on prompt.
if gh auth status >/dev/null 2>&1; then
  exit 0
fi

msg="🔐 **gh not authenticated.** The next command uses \`gh\` but gh CLI is not logged in.

→ Authenticate first: \`gh auth login\`
→ Or switch identity: \`gh auth switch -u <username>\`

This hook does not block — the gh command may still fail. Surfacing early so the next step is obvious."

jq -nc --arg c "$msg" '{hookSpecificOutput:{hookEventName:"PreToolUse", additionalContext:$c}}'
exit 0
