#!/usr/bin/env bash
# session-cost-report.sh — Stop hook (session telemetry)
#
# At session close, append a single line summary to
# control-plane/memory/observability/session-cost.jsonl with model usage,
# tokens, and approximate cost when above threshold. Async, never blocks
# session delivery.
#
# Threshold ($USD): writes line only if cost >= HARNESS_COST_THRESHOLD
# (default 0.10). Below threshold = noise, skipped.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
LOG="$ROOT/control-plane/memory/observability/session-cost.jsonl"
THRESHOLD="${HARNESS_COST_THRESHOLD:-0.10}"

command -v jq >/dev/null 2>&1 || exit 0

payload=$(cat)
[ -z "$payload" ] && exit 0
echo "$payload" | jq -e . >/dev/null 2>&1 || exit 0

# Stop hook payload includes: session_id, transcript_path, stop_hook_active, etc.
session=$(echo "$payload" | jq -r '.session_id // "unknown"')
ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
transcript=$(echo "$payload" | jq -r '.transcript_path // empty')

# Extract usage from transcript if available. JSONL transcript — sum input/output tokens.
input_tokens=0
output_tokens=0
cache_read=0
cache_write=0
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  while IFS= read -r line; do
    usage=$(echo "$line" | jq -r 'select(.message.usage) | .message.usage' 2>/dev/null)
    [ -z "$usage" ] && continue
    [ "$usage" = "null" ] && continue
    it=$(echo "$usage" | jq -r '.input_tokens // 0')
    ot=$(echo "$usage" | jq -r '.output_tokens // 0')
    cr=$(echo "$usage" | jq -r '.cache_read_input_tokens // 0')
    cw=$(echo "$usage" | jq -r '.cache_creation_input_tokens // 0')
    input_tokens=$((input_tokens + it))
    output_tokens=$((output_tokens + ot))
    cache_read=$((cache_read + cr))
    cache_write=$((cache_write + cw))
  done < "$transcript"
fi

# Rough cost estimate (Opus 4 pricing; adjust if your model changes):
# input  $15/M, output $75/M, cache read $1.50/M, cache write $18.75/M
cost=$(awk -v i="$input_tokens" -v o="$output_tokens" -v cr="$cache_read" -v cw="$cache_write" \
  'BEGIN { printf "%.4f", (i*15 + o*75 + cr*1.5 + cw*18.75) / 1000000 }')

# Threshold gate
above=$(awk -v c="$cost" -v t="$THRESHOLD" 'BEGIN { print (c+0 >= t+0) ? "1" : "0" }')
[ "$above" = "0" ] && exit 0

mkdir -p "$(dirname "$LOG")"
jq -nc \
  --arg ts "$ts" --arg session "$session" \
  --argjson it "$input_tokens" --argjson ot "$output_tokens" \
  --argjson cr "$cache_read" --argjson cw "$cache_write" \
  --arg cost "$cost" \
  '{kind:"session-cost", ts:$ts, session:$session, input_tokens:$it, output_tokens:$ot, cache_read:$cr, cache_write:$cw, cost_usd:($cost|tonumber)}' \
  >> "$LOG"

exit 0
