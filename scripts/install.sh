#!/usr/bin/env bash
# install.sh — fork-time setup for agentic-os
#
# Run once after cloning the repo. Idempotent — safe to re-run.
# Verifies prerequisites, makes scripts executable, primes routing caches,
# and instructs the operator to open Claude Code for the bootstrap interview.
#
# Usage:
#   bash scripts/install.sh           # standard install
#   bash scripts/install.sh --check   # verify prerequisites only, no changes
#   bash scripts/install.sh --quiet   # minimal output

set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-install}"
QUIET=false
[ "$MODE" = "--quiet" ] && QUIET=true && MODE="install"

red()    { printf "\033[31m%s\033[0m\n" "$1"; }
green()  { printf "\033[32m%s\033[0m\n" "$1"; }
yellow() { printf "\033[33m%s\033[0m\n" "$1"; }
bold()   { printf "\033[1m%s\033[0m\n" "$1"; }
say()    { [ "$QUIET" = "true" ] || echo "$@"; }

ERRORS=0
WARNINGS=0

# ── Prerequisites ──────────────────────────────────────────────────────────
say ""
bold "Checking prerequisites"
say ""

check_tool() {
  local name="$1"
  local install_hint="$2"
  local optional="${3:-required}"
  if command -v "$name" >/dev/null 2>&1; then
    local version
    version=$("$name" --version 2>&1 | head -1 || echo "")
    say "  $(green ✓) $name ${version}"
  else
    if [ "$optional" = "required" ]; then
      red "  ✗ $name — required, not found"
      echo "    Install: $install_hint"
      ERRORS=$((ERRORS + 1))
    else
      yellow "  ⚠ $name — optional, not found"
      echo "    Install: $install_hint"
      WARNINGS=$((WARNINGS + 1))
    fi
  fi
}

check_tool "bash"    "ships with macOS and Linux"     required
check_tool "git"     "https://git-scm.com/downloads"  required
check_tool "jq"      "brew install jq (macOS) · apt install jq (Linux)" required
check_tool "python3" "ships with macOS 12+ · apt install python3 (Linux)" required
check_tool "gh"      "brew install gh (macOS) · https://cli.github.com/" required
check_tool "yq"      "brew install yq · optional, used by some YAML linters" optional

say ""

if [ "$ERRORS" -gt 0 ]; then
  red "$ERRORS required prerequisite(s) missing. Install them and re-run this script."
  exit 1
fi

if [ "$MODE" = "--check" ]; then
  green "Prerequisites OK ($WARNINGS optional warnings). No changes made."
  exit 0
fi

# ── Make scripts executable ────────────────────────────────────────────────
bold "Making scripts executable"
chmod +x "$ROOT"/.claude/hooks/*.sh 2>/dev/null || true
chmod +x "$ROOT"/control-plane/scripts/*.sh 2>/dev/null || true
chmod +x "$ROOT"/control-plane/scripts/*.py 2>/dev/null || true
chmod +x "$ROOT"/control-plane/scripts/tests/*.sh 2>/dev/null || true
chmod +x "$ROOT"/scripts/*.sh 2>/dev/null || true
say "  $(green ✓) executable bits set on .claude/hooks/, control-plane/scripts/, scripts/"
say ""

# ── Prime routing caches ───────────────────────────────────────────────────
bold "Priming routing caches"
if python3 "$ROOT/control-plane/scripts/compile-skill-routing.py" >/dev/null 2>&1; then
  say "  $(green ✓) skill routing compiled"
else
  yellow "  ⚠ skill routing compile failed — non-fatal; runs at SessionStart"
  WARNINGS=$((WARNINGS + 1))
fi

if python3 "$ROOT/control-plane/scripts/compile-concept-routing.py" >/dev/null 2>&1; then
  say "  $(green ✓) concept routing compiled"
else
  yellow "  ⚠ concept routing compile failed — non-fatal; runs at SessionStart"
  WARNINGS=$((WARNINGS + 1))
fi
say ""

# ── Validate harness ───────────────────────────────────────────────────────
bold "Validating harness"
if bash "$ROOT/control-plane/scripts/validate-harness.sh" >/dev/null 2>&1; then
  say "  $(green ✓) harness clean (skills + agents + memory + state coverage)"
else
  yellow "  ⚠ harness validation reported issues — run for details:"
  echo "    bash control-plane/scripts/validate-harness.sh"
  WARNINGS=$((WARNINGS + 1))
fi
say ""

# ── Verify sentinel ────────────────────────────────────────────────────────
bold "Bootstrap sentinel"
if [ -f "$ROOT/.bootstrap-pending" ]; then
  say "  $(green ✓) .bootstrap-pending present — Claude Code will prompt you to invoke os-bootstrap on first session"
else
  yellow "  ⚠ .bootstrap-pending absent"
  echo "    The system thinks it's already bootstrapped."
  echo "    If this is a fresh clone, recreate the sentinel:"
  echo "      touch .bootstrap-pending"
  WARNINGS=$((WARNINGS + 1))
fi
say ""

# ── Finish ─────────────────────────────────────────────────────────────────
echo "═══════════════════════════════════════════════════════════"
if [ "$WARNINGS" -eq 0 ]; then
  green "Install complete. Zero warnings."
else
  yellow "Install complete with $WARNINGS warning(s) above."
fi
echo "═══════════════════════════════════════════════════════════"
say ""
bold "Next step"
say ""
say "  Open Claude Code in this directory:"
say ""
say "      cd $ROOT"
say "      claude"
say ""
say "  Claude will detect .bootstrap-pending and prompt you to invoke the"
say "  os-bootstrap skill — a 4-block interview (identity, naming, domains,"
say "  technical wiring) that completes the configuration."
say ""
say "  The interview takes ~10-15 minutes and can be paused / resumed."
say ""
exit 0
