#!/usr/bin/env bash
# inject-concept-routing.sh — SessionStart hook
#
# Same freshness-cache pattern as inject-skill-routing.sh:
# Recompiles only when any _cards/*.md or the compiler is newer than the
# cached manifest. On warm cache, just cats the file.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
CARDS_DIR="$ROOT/control-plane/concepts/_cards"
COMPILER="$ROOT/control-plane/scripts/compile-concept-routing.py"
CACHE_DIR="$ROOT/control-plane/memory/concepts"
CACHE_FILE="$CACHE_DIR/concept-routing-index.md"

emit_empty() {
  jq -n '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:""}}'
  exit 0
}

command -v jq >/dev/null 2>&1 || exit 0
[ -d "$CARDS_DIR" ] || emit_empty

mkdir -p "$CACHE_DIR"

stale=0
if [ ! -f "$CACHE_FILE" ]; then
  stale=1
else
  newest=$(find "$CARDS_DIR" -name "*.md" -type f -newer "$CACHE_FILE" -print -quit 2>/dev/null)
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
