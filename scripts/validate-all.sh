#!/usr/bin/env bash
# validate-all.sh — run the full validation suite locally
#
# Runs every check that CI runs. Use before pushing.
# Mirrors .github/workflows/validate.yml.

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

red()   { printf "\033[31m%s\033[0m\n" "$1"; }
green() { printf "\033[32m%s\033[0m\n" "$1"; }
bold()  { printf "\033[1m%s\033[0m\n" "$1"; }

FAILED=0

run_check() {
  local name="$1"
  shift
  bold "→ $name"
  if "$@" >/dev/null 2>&1; then
    green "  ✓ pass"
  else
    red "  ✗ fail — re-run without redirect for details:"
    echo "    $*"
    FAILED=$((FAILED + 1))
  fi
  echo ""
}

bold "agentic-os validation suite"
echo "============================"
echo ""

run_check "validate-harness (frontmatter + state.md coverage)" \
  bash control-plane/scripts/validate-harness.sh

run_check "block-pr-merge regex fixtures (15 cases)" \
  bash control-plane/scripts/tests/test-block-pr-merge.sh

run_check "compile skill routing" \
  python3 control-plane/scripts/compile-skill-routing.py

run_check "compile concept routing" \
  python3 control-plane/scripts/compile-concept-routing.py

run_check "YAML configs parse cleanly" \
  python3 -c "
import sys, pathlib
try:
    import yaml
except ImportError:
    print('PyYAML not installed — skip'); sys.exit(0)
errors = []
for p in pathlib.Path('control-plane/config').glob('*.yaml'):
    try:
        yaml.safe_load(p.read_text())
    except yaml.YAMLError as e:
        errors.append(f'{p}: {e}')
if errors:
    for e in errors: print(e)
    sys.exit(1)
"

run_check "Markdown links resolve (control-plane + root)" \
  python3 -c "
import re, pathlib, sys
ROOT = pathlib.Path('.')
broken = []
scan = list(ROOT.glob('*.md')) + list(ROOT.rglob('control-plane/**/*.md'))
for f in scan:
    text = f.read_text()
    for m in re.finditer(r'\[[^\]]+\]\(([^)]+)\)', text):
        link = m.group(1).split('#')[0]
        if not link or link.startswith(('http', 'mailto:')):
            continue
        target = (f.parent / link).resolve()
        if not target.exists():
            broken.append(f'{f}: {link}')
if broken:
    for b in broken: print(b)
    sys.exit(1)
"

echo "============================"
if [ "$FAILED" -eq 0 ]; then
  green "All checks passed."
  exit 0
else
  red "$FAILED check(s) failed."
  exit 1
fi
