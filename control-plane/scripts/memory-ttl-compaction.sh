#!/usr/bin/env bash
# memory-ttl-compaction.sh — TTL-based memory housekeeping
#
# Two passes:
#   1. state.md reset (30-day TTL) — agent state files reset to template
#      when untouched for 30+ days.
#   2. Scratchpads cleanup (48h TTL) — workspace temporary files removed.
#
# Run manually or via cron. Logs to control-plane/memory/observability/memory-compaction.jsonl.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
MEMORY_DIR="$ROOT/control-plane/memory"
LOG_FILE="$MEMORY_DIR/observability/memory-compaction.jsonl"
DAYS_TTL=30
SCRATCHPAD_DIR="$MEMORY_DIR/scratchpads"

mkdir -p "$(dirname "$LOG_FILE")"
mkdir -p "$SCRATCHPAD_DIR"

ts_now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
command -v jq >/dev/null 2>&1 || { echo "jq required" >&2; exit 1; }

# ─── Pass 2: Scratchpads cleanup (48h TTL) ──────────────────────────────────
if [ -d "$SCRATCHPAD_DIR" ]; then
  find "$SCRATCHPAD_DIR" -mindepth 2 -type f -mmin +2880 -print | while read -r f; do
    jq -nc --arg ts "$ts_now" --arg file "$f" \
      '{kind:"scratchpad-cleanup", ts:$ts, file:$file, ttl_hours:48}' \
      >> "$LOG_FILE"
    rm -f "$f"
    echo "🗑️  Scratchpad cleanup: $f"
  done
  find "$SCRATCHPAD_DIR" -mindepth 1 -type d -empty -delete 2>/dev/null || true
fi

# ─── Pass 1: state.md reset (30-day TTL) ────────────────────────────────────
find "$MEMORY_DIR" -name "state.md" -type f -mtime +$DAYS_TTL | while read -r state_file; do
  agent_name=$(basename "$(dirname "$state_file")")
  reset_date=$(date -u +%Y-%m-%d)
  cat > "$state_file" <<EOF
---
title: State File (TTL Reset)
date_reset: $reset_date
---

# State — $agent_name

_Auto-reset via memory-ttl-compaction.sh after 30-day TTL._

## Last deep invocation
- Date: (pending next invocation)
- Blockers: (none)
- Metrics baseline: (pending)

## Notes
State file reset. Awaiting next session invocation for fresh metadata capture.
EOF
  jq -nc --arg ts "$ts_now" --arg agent "$agent_name" --arg file "$state_file" \
    --argjson ttl "$DAYS_TTL" \
    '{kind:"memory-ttl-reset", ts:$ts, agent:$agent, file:$file, ttl_days:$ttl}' \
    >> "$LOG_FILE"
  echo "🗑️  Reset: $agent_name"
done

echo "✓ Memory TTL compaction complete."
