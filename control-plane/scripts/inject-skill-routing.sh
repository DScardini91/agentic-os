#!/usr/bin/env bash
# inject-skill-routing.sh — SessionStart hook
#
# Injects the Skill Routing Index into Claude's context. The heavy work
# (parsing every SKILL.md frontmatter) is done by compile-skill-routing.py,
# which writes a cached manifest. This hook only recompiles when the cache
# is stale — i.e. when any SKILL.md (or the compiler itself) is newer than
# the cached manifest.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
SKILLS_DIR="$ROOT/.claude/skills"
COMPILER="$ROOT/control-plane/scripts/compile-skill-routing.py"
CACHE_DIR="$ROOT/control-plane/memory/skills"
CACHE_FILE="$CACHE_DIR/skill-routing-index.md"

emit_empty() {
  jq -n '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:""}}'
  exit 0
}

command -v jq >/dev/null 2>&1 || exit 0
[ -d "$SKILLS_DIR" ] || emit_empty

mkdir -p "$CACHE_DIR"

stale=0
if [ ! -f "$CACHE_FILE" ]; then
  stale=1
else
  newest=$(find "$SKILLS_DIR" -name SKILL.md -type f -newer "$CACHE_FILE" -print -quit 2>/dev/null)
  if [ -n "$newest" ]; then
    stale=1
  elif [ -f "$COMPILER" ] && [ "$COMPILER" -nt "$CACHE_FILE" ]; then
    stale=1
  fi
fi

if [ "$stale" -eq 1 ] && [ -f "$COMPILER" ]; then
  python3 "$COMPILER" >/dev/null 2>&1 || true
fi

[ -f "$CACHE_FILE" ] || emit_empty
manifest=$(cat "$CACHE_FILE" 2>/dev/null)
[ -n "$manifest" ] || emit_empty

jq -n --arg c "$manifest" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$c}}'
