#!/usr/bin/env bash
# inject-recent-dailies.sh — SessionStart hook
#
# Injects the last 2 daily logs into Claude's context. Daily logs live in
# control-plane/memory/daily/ matching the pattern 20*.md (date-prefixed).
# Sorted reverse-chronologically; top 2 included.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
DAILY_DIR="$ROOT/control-plane/memory/daily"

# Graceful degradation on hosts without jq — emit nothing rather than break SessionStart.
command -v jq >/dev/null 2>&1 || exit 0

ctx=""
SIZE_CAP=8000
if [ -d "$DAILY_DIR" ]; then
  recent=$(ls -1 "$DAILY_DIR"/20*.md 2>/dev/null | sort -r | head -2)
  if [ -n "$recent" ]; then
    while IFS= read -r f; do
      [ -z "$f" ] && continue
      name=$(basename "$f" .md)
      body=$(cat "$f")
      if [ ${#body} -gt $SIZE_CAP ]; then
        body="${body:0:$SIZE_CAP}"$'\n\n[...truncated for context window — full log in daily/'"$name"$'.md]'
      fi
      ctx+=$'\n\n=== '"$name"$' ===\n\n'"$body"
    done <<< "$recent"
  fi
fi

if [ -z "$ctx" ]; then
  ctx=$'(no recent daily logs found — system is fresh or just installed)'
fi

header=$'## Recent daily logs (last 2 entries)\n\n_Auto-injected by SessionStart hook. Narrative digests; operational state lives elsewhere._'
full_ctx="$header$ctx"

jq -n --arg c "$full_ctx" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$c}}'
