#!/usr/bin/env bash
# session-start-placeholder-check.sh — SessionStart hook
#
# Detects when `<placeholder>` strings remain in active config files but the
# bootstrap sentinel is NOT present — i.e. the operator deleted `.bootstrap-pending`
# without running `os-bootstrap`, or `os-bootstrap` failed mid-run.
#
# In that state, every hook that depends on those configs silently passes
# (because hooks have `[[ "$x" == \<*\> ]] && exit 0` as graceful degradation).
# Without this check, the operator believes the harness is enforcing — but it
# is in fact dormant.
#
# Loud warning injected as additionalContext. Never blocks.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
SENTINEL="$ROOT/.bootstrap-pending"

command -v jq >/dev/null 2>&1 || exit 0

# If sentinel is present, the bootstrap-check hook already alerts the operator.
# Don't double-fire.
[ -f "$SENTINEL" ] && exit 0

# Active config files to scan.
configs=(
  "$ROOT/control-plane/config/spoke-owners.yaml"
  "$ROOT/control-plane/config/triggers.yaml"
  "$ROOT/control-plane/config/protected-repos.yaml"
  "$ROOT/CLAUDE.md"
  "$ROOT/control-plane/CLAUDE.md"
)

# Pattern: `<word-with-dashes-or-underscores>` not preceded by a backtick
# (so example placeholders inside code blocks don't trigger).
unresolved=()
for f in "${configs[@]}"; do
  [ -f "$f" ] || continue
  matches=$(grep -nE '(^|[^\`])<[a-z][a-z0-9_-]*>' "$f" 2>/dev/null | grep -v '^[[:space:]]*#' || true)
  if [ -n "$matches" ]; then
    unresolved+=("$f")
  fi
done

[ ${#unresolved[@]} -eq 0 ] && exit 0

# Build report
files_list=""
for f in "${unresolved[@]}"; do
  rel="${f#$ROOT/}"
  files_list+=$'\n- '"\`$rel\`"
done

msg="⚠️ **Bootstrap incomplete — placeholders remain in active configs.**

The \`.bootstrap-pending\` sentinel is absent, but \`<placeholder>\` strings still exist in:${files_list}

Hooks that depend on these configs are silent-passing on every invocation. The harness appears wired but is in fact dormant for the unresolved placeholders.

**To fix:**
- If you intended to bootstrap → re-create \`.bootstrap-pending\` (\`touch .bootstrap-pending\`) and invoke the \`os-bootstrap\` skill.
- If you intended to skip bootstrap → resolve the placeholders manually by editing the files above. Replace each \`<name>\` with your chosen agent name, or remove the row entirely.

This warning fires until the placeholders are resolved."

jq -nc --arg c "$msg" '{hookSpecificOutput:{hookEventName:"SessionStart", additionalContext:$c}}'
