#!/usr/bin/env bash
# state-drift-check.sh — detect-correct loop for state.md files.
#
# Detects drift between agent state files and recent decision-log entries /
# commits. Run on-demand or as a SessionStart hook. Emits a reminder when
# state has not been updated but the agent appears in recent activity —
# guards against state-vs-reality flip-flopping.

set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="${CLAUDE_PROJECT_DIR:-$(git -C "$SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null)}"
ROOT="${ROOT:-$(cd "$SCRIPT_DIR/../.." && pwd)}"
MEMORY_DIR="$ROOT/control-plane/memory"
DECISION_LOG="$MEMORY_DIR/decisions/decision-log.md"
TODAY=$(date +%Y-%m-%d)
DRIFT_WINDOW_DAYS=14
REPORT_FILE="/tmp/agentic-os-state-drift-$TODAY.report"

LAST_DECISION_DATE=""
if [ -f "$DECISION_LOG" ]; then
  LAST_DECISION_DATE=$(grep -oE '\| 2[0-9]{3}-[0-9]{2}-[0-9]{2} \|' "$DECISION_LOG" 2>/dev/null | sort -u | tail -1 | tr -d '| ' || true)
fi

{
  echo "# State drift report — $TODAY"
  echo ""
  echo "Drift window: $DRIFT_WINDOW_DAYS days"
  echo "Last decision-log entry: ${LAST_DECISION_DATE:-none}"
  echo ""
  echo "## Agent state files"
  echo ""
} > "$REPORT_FILE"

drift_count=0
for state_file in "$MEMORY_DIR"/*/state.md; do
  [ -f "$state_file" ] || continue
  agent_name=$(basename "$(dirname "$state_file")")

  state_mtime=$(stat -f "%Sm" -t "%Y-%m-%d" "$state_file" 2>/dev/null || stat -c "%y" "$state_file" 2>/dev/null | cut -d' ' -f1)
  if [[ "$OSTYPE" == "darwin"* ]]; then
    state_epoch=$(stat -f "%m" "$state_file" 2>/dev/null)
  else
    state_epoch=$(stat -c "%Y" "$state_file" 2>/dev/null)
  fi
  now_epoch=$(date +%s)
  days_since=$(( (now_epoch - state_epoch) / 86400 ))

  last_commit_with_agent=""
  if [ -d "$ROOT/.git" ]; then
    last_commit_with_agent=$(cd "$ROOT" && git log --since="$DRIFT_WINDOW_DAYS days ago" --grep="$agent_name" --format=%cs 2>/dev/null | head -1)
  fi

  if [ "$days_since" -gt "$DRIFT_WINDOW_DAYS" ] && [ -n "$last_commit_with_agent" ]; then
    echo "⚠️  **$agent_name** — state mtime: $state_mtime ($days_since days ago) BUT recent commits mention agent ($last_commit_with_agent)" >> "$REPORT_FILE"
    drift_count=$((drift_count + 1))
  elif [ "$days_since" -gt "$DRIFT_WINDOW_DAYS" ]; then
    echo "ℹ️  $agent_name — state mtime: $state_mtime ($days_since days ago), no recent commit activity" >> "$REPORT_FILE"
  else
    echo "✅ $agent_name — state mtime: $state_mtime ($days_since days ago)" >> "$REPORT_FILE"
  fi
done

{
  echo ""
  echo "## Summary"
  echo ""
  echo "Drift count (state stale BUT activity present): **$drift_count**"
} >> "$REPORT_FILE"

if [ "$drift_count" -gt 0 ]; then
  echo "⚠️  State drift detected ($drift_count agents) — see $REPORT_FILE"
  grep "^⚠️" "$REPORT_FILE"
else
  echo "✅ No state drift detected ($TODAY)"
fi
exit 0
