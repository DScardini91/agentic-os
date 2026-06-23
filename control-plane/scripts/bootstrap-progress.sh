#!/usr/bin/env bash
# bootstrap-progress.sh — read/write the .bootstrap-progress.json contract
#
# Invoked by the os-bootstrap skill at three points per block:
#   bootstrap-progress.sh status              — print current state as JSON
#   bootstrap-progress.sh next                — print next pending block name, or "done"
#   bootstrap-progress.sh start <block-name>  — mark <block-name> as in_progress
#   bootstrap-progress.sh complete <block-name> — mark <block-name> as completed; if all done, prints "ALL_COMPLETE"
#   bootstrap-progress.sh reset               — delete the file (operator opt-in)
#
# The 4 blocks (canonical order):
#   1_identity, 2_harness_naming, 3_domains, 4_technical_wiring
#
# File location: $CLAUDE_PROJECT_DIR/.bootstrap-progress.json
# Gitignored — local-only per fork.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
PROGRESS_FILE="$ROOT/.bootstrap-progress.json"
SENTINEL="$ROOT/.bootstrap-pending"
# Marker: every agentic-os install ships this file. Its presence (or any of
# the other markers below) identifies the directory as an agentic-os repo.
# Used by `status` / `next` to refuse to fabricate a bootstrapped answer
# when called accidentally outside an agentic-os clone.
REPO_MARKERS=(
  "$ROOT/control-plane/CLAUDE.md"
  "$ROOT/control-plane/scripts/bootstrap-progress.sh"
  "$ROOT/.claude/settings.json"
)

# Exit codes:
#   0 — success
#   1 — missing prerequisite (jq)
#   2 — usage error (missing argument)
#   3 — wrong-state error (sentinel absent when start/complete called)
#   4 — not-an-agentic-os-repo (no markers detected)

command -v jq >/dev/null 2>&1 || { echo "jq required" >&2; exit 1; }

BLOCKS=("1_identity" "2_harness_naming" "3_domains" "4_technical_wiring")

# ── Marker check — is this an agentic-os repo? ────────────────────────────
_is_agentic_os_repo() {
  local marker
  for marker in "${REPO_MARKERS[@]}"; do
    [ -f "$marker" ] && return 0
  done
  return 1
}

# ── Initialize file if absent ──────────────────────────────────────────────
# Only initializes if the sentinel is present (system is virgin or mid-bootstrap).
# Without sentinel = already bootstrapped (or placeholder mode chosen); creating
# a progress file here would be wrong — it would re-trigger phantom blocks.
_init_if_missing() {
  [ -f "$PROGRESS_FILE" ] && return
  if [ ! -f "$SENTINEL" ]; then
    return  # bootstrapped state — do not init
  fi
  local now; now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  jq -n --arg now "$now" '{
    started_at: $now,
    blocks: {
      "1_identity": "pending",
      "2_harness_naming": "pending",
      "3_domains": "pending",
      "4_technical_wiring": "pending"
    },
    last_updated: $now
  }' > "$PROGRESS_FILE"
}

# ── Subcommand: status ────────────────────────────────────────────────────
_status() {
  if ! _is_agentic_os_repo; then
    echo '{"state":"not-an-agentic-os-repo","note":"no markers found at $CLAUDE_PROJECT_DIR"}'
    exit 4
  fi
  if [ ! -f "$SENTINEL" ] && [ ! -f "$PROGRESS_FILE" ]; then
    echo '{"state":"bootstrapped","note":"no sentinel and no progress file present"}'
    return
  fi
  _init_if_missing
  cat "$PROGRESS_FILE"
}

# ── Subcommand: next ──────────────────────────────────────────────────────
_next() {
  if ! _is_agentic_os_repo; then
    echo "not-an-agentic-os-repo" >&2
    exit 4
  fi
  # If sentinel is absent (bootstrapped) and no progress file lingering,
  # the answer is "done" — do not synthesize a fresh progress file.
  if [ ! -f "$SENTINEL" ] && [ ! -f "$PROGRESS_FILE" ]; then
    echo "done"
    return
  fi
  _init_if_missing
  if [ ! -f "$PROGRESS_FILE" ]; then
    echo "done"
    return
  fi
  for blk in "${BLOCKS[@]}"; do
    state=$(jq -r --arg b "$blk" '.blocks[$b]' "$PROGRESS_FILE")
    if [ "$state" != "completed" ]; then
      echo "$blk"
      return
    fi
  done
  echo "done"
}

# ── Subcommand: start <block> ─────────────────────────────────────────────
_start() {
  local blk="$1"
  [ -z "$blk" ] && { echo "usage: $0 start <block-name>" >&2; exit 2; }
  if [ ! -f "$SENTINEL" ]; then
    echo "refused: system is already bootstrapped (no .bootstrap-pending). To re-bootstrap, recreate the sentinel first." >&2
    exit 3
  fi
  _init_if_missing
  local now; now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local tmp; tmp=$(mktemp)
  jq --arg b "$blk" --arg now "$now" \
    '.blocks[$b] = "in_progress" | .last_updated = $now' \
    "$PROGRESS_FILE" > "$tmp" && mv "$tmp" "$PROGRESS_FILE"
  echo "started: $blk"
}

# ── Subcommand: complete <block> ──────────────────────────────────────────
_complete() {
  local blk="$1"
  [ -z "$blk" ] && { echo "usage: $0 complete <block-name>" >&2; exit 2; }
  if [ ! -f "$SENTINEL" ] && [ ! -f "$PROGRESS_FILE" ]; then
    echo "refused: system is already bootstrapped — nothing to complete." >&2
    exit 3
  fi
  _init_if_missing
  local now; now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local tmp; tmp=$(mktemp)
  jq --arg b "$blk" --arg now "$now" \
    '.blocks[$b] = "completed" | .last_updated = $now' \
    "$PROGRESS_FILE" > "$tmp" && mv "$tmp" "$PROGRESS_FILE"
  echo "completed: $blk"

  # If all 4 blocks completed → cleanup sentinel + progress file
  local all_done
  all_done=$(jq '[.blocks[] | select(. == "completed")] | length' "$PROGRESS_FILE")
  if [ "$all_done" -eq 4 ]; then
    rm -f "$SENTINEL"
    rm -f "$PROGRESS_FILE"
    echo "ALL_COMPLETE — sentinel and progress file removed"
  fi
}

# ── Subcommand: reset ─────────────────────────────────────────────────────
_reset() {
  rm -f "$PROGRESS_FILE"
  echo "reset: $PROGRESS_FILE removed"
}

# ── Dispatch ──────────────────────────────────────────────────────────────
cmd="${1:-status}"
case "$cmd" in
  status)   _status ;;
  next)     _next ;;
  start)    _start "${2:-}" ;;
  complete) _complete "${2:-}" ;;
  reset)    _reset ;;
  *)
    echo "Usage: $0 {status|next|start <block>|complete <block>|reset}" >&2
    exit 2
    ;;
esac
