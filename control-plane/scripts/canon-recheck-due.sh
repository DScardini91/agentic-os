#!/usr/bin/env bash
# canon-recheck-due.sh
#
# Scans learning/canon/*-self-audit.md for items with `Re-check: YYYY-MM-DD`
# ≤ today + 7 days. Prints the due items per audit file. Invoked by Darwin
# housekeeping and on-demand.
#
# Honors the canon+self-audit pairing principle: each absorbed canon ships
# with a living audit; this script surfaces audits that are due for re-scoring.

set -euo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
CANON_DIR="$ROOT/learning/canon"
TODAY=$(date +%Y-%m-%d)
WINDOW_END=$(date -v+7d +%Y-%m-%d 2>/dev/null || date -d "+7 days" +%Y-%m-%d)

if [[ ! -d "$CANON_DIR" ]]; then
  echo "canon-recheck-due: no canon dir at $CANON_DIR — nothing to scan"
  exit 0
fi

shopt -s nullglob
audits=("$CANON_DIR"/*-self-audit.md)
if [[ ${#audits[@]} -eq 0 ]]; then
  echo "canon-recheck-due: no self-audit files in $CANON_DIR"
  exit 0
fi

found_any=0
echo "canon-recheck-due — window: $TODAY → $WINDOW_END"
echo

for audit in "${audits[@]}"; do
  rel=$(basename "$audit")
  due_lines=$(grep -nE '[Rr]e-check[*:]*[[:space:]]*[0-9]{4}-[0-9]{2}-[0-9]{2}' "$audit" || true)
  [[ -z "$due_lines" ]] && continue
  printed_header=0
  while IFS= read -r line; do
    date_str=$(echo "$line" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
    [[ -z "$date_str" ]] && continue
    if [[ "$date_str" < "$WINDOW_END" || "$date_str" == "$WINDOW_END" ]]; then
      if [[ "$printed_header" -eq 0 ]]; then
        echo "── $rel ──"
        printed_header=1
      fi
      lineno=$(echo "$line" | cut -d: -f1)
      header=$(awk -v ln="$lineno" 'NR<=ln && /^###/ {h=$0} END {print h}' "$audit")
      echo "  [$date_str] $header"
      echo "      → $audit:$lineno"
      found_any=1
    fi
  done <<< "$due_lines"
  [[ "$printed_header" -eq 1 ]] && echo
done

if [[ "$found_any" -eq 0 ]]; then
  echo "No re-check items due within 7-day window."
else
  echo "→ Re-derive status from canon, not from previous audit entry (anti-anchor rule)."
fi
exit 0
