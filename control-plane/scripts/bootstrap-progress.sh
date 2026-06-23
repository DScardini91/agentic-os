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

command -v jq >/dev/null 2>&1 || { echo "jq required" >&2; exit 1; }

BLOCKS=("1_identity" "2_harness_naming" "3_domains" "4_technical_wiring")

# ── Initialize file if absent ──────────────────────────────────────────────
_init_if_missing() {
  [ -f "$PROGRESS_FILE" ] && return
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
  _init_if_missing
  cat "$PROGRESS_FILE"
}

# ── Subcommand: next ──────────────────────────────────────────────────────
_next() {
  _init_if_missing
  local nxt
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
