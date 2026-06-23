#!/usr/bin/env bash
# decision-log-trailing.sh — D1 trailing signal (Darwin proposal)
#
# Reads control-plane/memory/decisions/decision-log.md and extracts entries
# aged 7-30 days for the weekly review. The principal re-reads each entry
# and marks: still-correct / drifted / wrong.
#
# Resolves "advisor auditing advisor" circular bias — temporal sampling beats
# advisor-driven re-reading.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
DECISION_LOG="$ROOT/control-plane/memory/decisions/decision-log.md"
TODAY=$(date +%Y-%m-%d)
MIN_DAYS=7
MAX_DAYS=30
REPORT_FILE="/tmp/decision-trailing-$TODAY.md"

[ -f "$DECISION_LOG" ] || { echo "decision-log.md not found at $DECISION_LOG" >&2; exit 1; }

if [[ "$OSTYPE" == "darwin"* ]]; then
  min_epoch=$(date -j -v-${MAX_DAYS}d +%s 2>/dev/null)
  max_epoch=$(date -j -v-${MIN_DAYS}d +%s 2>/dev/null)
else
  min_epoch=$(date -d "$MAX_DAYS days ago" +%s)
  max_epoch=$(date -d "$MIN_DAYS days ago" +%s)
fi

cat > "$REPORT_FILE" <<EOF
# Decision-log trailing review — $TODAY

_Auto-generated. Entries dated between $MIN_DAYS-$MAX_DAYS days ago._
_For each entry: re-read and mark **still-correct** / **drifted** / **wrong** + a note if applicable._

---

EOF

count=0
while IFS= read -r line; do
  date_str=$(echo "$line" | grep -oE '2[0-9]{3}-[0-9]{2}-[0-9]{2}' | head -1)
  [ -z "$date_str" ] && continue
  if [[ "$OSTYPE" == "darwin"* ]]; then
    entry_epoch=$(date -j -f "%Y-%m-%d" "$date_str" +%s 2>/dev/null || echo "0")
  else
    entry_epoch=$(date -d "$date_str" +%s 2>/dev/null || echo "0")
  fi
  if [ "$entry_epoch" -ge "$min_epoch" ] && [ "$entry_epoch" -le "$max_epoch" ]; then
    {
      echo "## $date_str"
      echo
      echo "$line"
      echo
      echo "**Review:** [ ] still-correct · [ ] drifted · [ ] wrong"
      echo "**Note:** "
      echo
      echo "---"
      echo
    } >> "$REPORT_FILE"
    count=$((count + 1))
  fi
done < "$DECISION_LOG"

{
  echo "## Summary"
  echo
  echo "**Entries to review:** $count"
  echo "**Window:** $MIN_DAYS to $MAX_DAYS days ago"
} >> "$REPORT_FILE"

echo "📋 Trailing review prep: $count entries → $REPORT_FILE"
if [ "$count" -eq 0 ]; then
  echo "(No entries in the $MIN_DAYS-$MAX_DAYS day window.)"
fi
exit 0
