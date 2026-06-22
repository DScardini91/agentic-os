#!/usr/bin/env bash
# validate-harness.sh — agentic OS harness integrity check
#
# Verifies harness integrity in under 5s to catch drift early:
#   1. SKILL.md frontmatter — has required fields (name, description)
#   2. Agent spec frontmatter — has required fields (name, description, tools)
#   3. State files exist for non-read-only agents
#   4. Memory frontmatter — YAML-ish OK in control-plane/memory/auto/
#
# Exit 0 if all OK; exit 1 if any errors. Pure instrumentation; zero side
# effects on the harness. Prerequisite for Darwin proposing edits without
# breaking downstream consumers.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
SCOPE="${1:-all}"

ERRORS=0
WARNINGS=0

red()    { printf "\033[31m%s\033[0m" "$1"; }
yellow() { printf "\033[33m%s\033[0m" "$1"; }
green()  { printf "\033[32m%s\033[0m" "$1"; }

err()  { echo "  $(red ✗) $1"; ERRORS=$((ERRORS+1)); }
warn() { echo "  $(yellow ⚠) $1"; WARNINGS=$((WARNINGS+1)); }
ok()   { echo "  $(green ✓) $1"; }

validate_frontmatter() {
  local file="$1"
  local required="$2"
  python3 -c "
import sys, re
try:
    with open('$file') as f:
        text = f.read()
    if not text.startswith('---'):
        print('no-frontmatter'); sys.exit(1)
    parts = text.split('---', 2)
    if len(parts) < 3:
        print('malformed-frontmatter'); sys.exit(1)
    fm_block = parts[1]
    required = '$required'.split()
    missing = [k for k in required if not re.search(r'^\s*' + re.escape(k) + r'\s*:', fm_block, re.MULTILINE)]
    if missing:
        print(f'missing-fields:{\",\".join(missing)}'); sys.exit(1)
    print('ok')
except Exception as e:
    print(f'error:{str(e)[:80]}'); sys.exit(1)
" 2>/dev/null
}

validate_skills() {
  echo ""
  echo "== Skills frontmatter =="
  local total=0 pass=0
  for f in "$ROOT"/.claude/skills/*/SKILL.md; do
    [ -f "$f" ] || continue
    total=$((total+1))
    local skill_name
    skill_name=$(basename "$(dirname "$f")")
    local result
    result=$(validate_frontmatter "$f" "name description")
    case "$result" in
      ok) pass=$((pass+1)) ;;
      *)  err "$skill_name: $result" ;;
    esac
  done
  echo "Skills: $pass/$total OK"
}

validate_agents() {
  echo ""
  echo "== Agent specs frontmatter =="
  local total=0 pass=0
  for f in "$ROOT"/.claude/agents/*.md "$ROOT"/control-plane/.claude/agents/*.md; do
    [ -f "$f" ] || continue
    local agent_name
    agent_name=$(basename "$f" .md)
    # Skip interface agent (it's the session voice, not an invocable subagent)
    case "$agent_name" in
      kowalski|interface-agent) continue ;;
    esac
    total=$((total+1))
    local result
    result=$(validate_frontmatter "$f" "name description tools")
    case "$result" in
      ok) pass=$((pass+1)) ;;
      *)  err "$agent_name: $result" ;;
    esac
  done
  echo "Agents: $pass/$total OK"

  echo ""
  echo "== State file coverage =="
  local missing_state=0
  for f in "$ROOT"/.claude/agents/*.md "$ROOT"/control-plane/.claude/agents/*.md; do
    [ -f "$f" ] || continue
    local agent_name
    agent_name=$(basename "$f" .md)
    case "$agent_name" in
      kowalski|interface-agent) continue ;;
    esac
    if [ ! -f "$ROOT/control-plane/memory/$agent_name/state.md" ] \
       && [ ! -f "$ROOT/control-plane/agent-state/$agent_name.md" ]; then
      warn "$agent_name: missing state.md"
      missing_state=$((missing_state+1))
    fi
  done
  [ "$missing_state" -eq 0 ] && ok "all primary agents have state.md"
}

validate_memory() {
  echo ""
  echo "== Memory frontmatter (auto/) =="
  local total=0 pass=0 no_fm=0
  for f in "$ROOT"/control-plane/memory/auto/*.md; do
    [ -f "$f" ] || continue
    [ "$(basename "$f")" = "MEMORY.md" ] && continue
    total=$((total+1))
    local name
    name=$(basename "$f" .md)
    local has_fm
    has_fm=$(head -1 "$f" | grep -c "^---$")
    if [ "$has_fm" -eq 0 ]; then
      no_fm=$((no_fm+1)); continue
    fi
    local result
    result=$(validate_frontmatter "$f" "name description")
    case "$result" in
      ok) pass=$((pass+1)) ;;
      *)  warn "$name: $result" ;;
    esac
  done
  echo "Memory (auto/): $pass/$((total - no_fm)) with frontmatter OK, $no_fm without (legacy)"
}

echo "Validating agentic OS harness — scope: $SCOPE"

case "$SCOPE" in
  all)     validate_skills; validate_agents; validate_memory ;;
  skills)  validate_skills ;;
  agents)  validate_agents ;;
  memory)  validate_memory ;;
  *)       echo "Usage: $0 [all|skills|agents|memory]" >&2; exit 1 ;;
esac

echo ""
echo "============================================================"
if [ "$ERRORS" -eq 0 ] && [ "$WARNINGS" -eq 0 ]; then
  echo "$(green '✓ All checks passed')"
  exit 0
elif [ "$ERRORS" -eq 0 ]; then
  echo "$(yellow "⚠ $WARNINGS warning(s), 0 errors")"
  exit 0
else
  echo "$(red "✗ $ERRORS error(s), $WARNINGS warning(s)")"
  exit 1
fi
