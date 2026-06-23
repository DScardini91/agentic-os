#!/usr/bin/env bash
# darwin-accumulate.sh — Stop hook (light-mode accumulator)
#
# Runs at every session end. Appends one metrics line to
# control-plane/memory/observability/darwin-accumulator.jsonl. Pure bash;
# never calls Claude. Heavy analysis happens in deep mode (weekly or
# on-demand reconciliation).

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
LOG_DIR="$ROOT/control-plane/memory/observability"
CALLS_LOG="$LOG_DIR/agent-calls.jsonl"
FIRES_LOG="$LOG_DIR/pre-tool-fires.jsonl"
ACCUMULATOR="$LOG_DIR/darwin-accumulator.jsonl"

mkdir -p "$LOG_DIR"
command -v jq >/dev/null 2>&1 || exit 0

# Skip if dedup/migration in progress.
[ -f /tmp/darwin-accumulate-DEDUP.lock ] && exit 0

input=$(cat)
session=$(echo "$input" | jq -r '.session_id // ""' 2>/dev/null)
[ -z "$session" ] && exit 0

TODAY=$(date +%Y-%m-%d)
NOW_TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Fast-path dedup.
if [ -f "$ACCUMULATOR" ] && grep -qF "\"session\":\"$session\"" "$ACCUMULATOR" 2>/dev/null; then
  exit 0
fi

# Infra agents are tracked separately so they don't inflate the
# domain-agent denominator (utilization metrics stay honest).
INFRA_AGENTS='["Explore","general-purpose"]'

agents_invoked="[]"
infra_agents_invoked="[]"
if [ -f "$CALLS_LOG" ]; then
  all_agents=$(grep -F "\"session\":\"$session\"" "$CALLS_LOG" 2>/dev/null \
    | jq -cs '[.[].agent] | unique' 2>/dev/null || echo "[]")
  echo "$all_agents" | jq -e . >/dev/null 2>&1 || all_agents="[]"
  agents_invoked=$(echo "$all_agents" \
    | jq -c --argjson infra "$INFRA_AGENTS" '[.[] | select(. as $a | $infra | index($a) | not)]' 2>/dev/null || echo "[]")
  infra_agents_invoked=$(echo "$all_agents" \
    | jq -c --argjson infra "$INFRA_AGENTS" '[.[] | select(. as $a | $infra | index($a))]' 2>/dev/null || echo "[]")
fi

violations=0
violation_matchers="[]"
reminder_only_fires=0
if [ -f "$FIRES_LOG" ]; then
  session_fires=$(grep -F "\"session\":\"$session\"" "$FIRES_LOG" 2>/dev/null || true)
  if [ -n "$session_fires" ]; then
    real_fires=$(echo "$session_fires" | grep -v '"severity":"reminder-only"' || true)
    ro_fires=$(echo "$session_fires" | grep '"severity":"reminder-only"' || true)
    violations=$([ -n "$real_fires" ] && echo "$real_fires" | wc -l | tr -d ' ' || echo 0)
    reminder_only_fires=$([ -n "$ro_fires" ] && echo "$ro_fires" | wc -l | tr -d ' ' || echo 0)
    violation_matchers=$(echo "${real_fires:-}" | jq -cs '[.[].matcher] | unique' 2>/dev/null || echo "[]")
  fi
fi

# Duration: time between first agent call and now (UTC-aware).
duration_min=-1
agent_calls=0
if [ -f "$CALLS_LOG" ]; then
  agent_calls=$(grep -F "\"session\":\"$session\"" "$CALLS_LOG" 2>/dev/null \
    | grep -c '"kind":"call"' 2>/dev/null || echo 0)
  agent_calls=$(echo "$agent_calls" | tr -cd '0-9'); agent_calls=${agent_calls:-0}
  first_ts=$(grep -F "\"session\":\"$session\"" "$CALLS_LOG" 2>/dev/null \
    | jq -r 'select(.kind=="call") | .ts // empty' 2>/dev/null | head -1)
  if [ -n "$first_ts" ]; then
    first_epoch=$(TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%SZ" "$first_ts" "+%s" 2>/dev/null || echo "0")
    now_epoch=$(date +%s)
    if [ "$first_epoch" -gt 0 ] && [ "$now_epoch" -ge "$first_epoch" ]; then
      duration_min=$(( (now_epoch - first_epoch) / 60 ))
    fi
  fi
fi

# Strip non-digits and default empties.
agent_count=$(echo "$agents_invoked" | jq -r 'length' 2>/dev/null | head -1)
agent_count=$(echo "${agent_count:-0}" | tr -cd '0-9'); agent_count=${agent_count:-0}
infra_count=$(echo "$infra_agents_invoked" | jq -r 'length' 2>/dev/null | head -1)
infra_count=$(echo "${infra_count:-0}" | tr -cd '0-9'); infra_count=${infra_count:-0}
violations=$(echo "${violations:-0}" | tr -cd '0-9'); violations=${violations:-0}
reminder_only_fires=$(echo "${reminder_only_fires:-0}" | tr -cd '0-9'); reminder_only_fires=${reminder_only_fires:-0}

# Skip trivially empty sessions.
if [ "$agent_count" -eq 0 ] && [ "$infra_count" -eq 0 ] && [ "$violations" -eq 0 ] && [ "$reminder_only_fires" -eq 0 ]; then
  exit 0
fi

# Atomic append via flock.
LOCKFILE="/tmp/darwin-accumulate-${session}.lock"
(
  flock -n 9 || exit 0
  if [ -f "$ACCUMULATOR" ] && grep -qF "\"session\":\"$session\"" "$ACCUMULATOR" 2>/dev/null; then
    exit 0
  fi
  jq -nc \
    --arg session "$session" --arg date "$TODAY" --arg ts "$NOW_TS" \
    --argjson agents_invoked "$agents_invoked" \
    --argjson infra_agents_invoked "$infra_agents_invoked" \
    --argjson violations "$violations" \
    --argjson violation_matchers "$violation_matchers" \
    --argjson reminder_only_fires "$reminder_only_fires" \
    --argjson duration_min "$duration_min" \
    --argjson agent_calls "${agent_calls:-0}" \
    '{
      session:$session, date:$date, ts:$ts, source:"stop-hook",
      agents_invoked:$agents_invoked, infra_agents_invoked:$infra_agents_invoked,
      violations:$violations, violation_matchers:$violation_matchers,
      reminder_only_fires:$reminder_only_fires,
      duration_min:$duration_min, agent_calls:$agent_calls,
      notes: ""
    }' >> "$ACCUMULATOR"
) 9>"$LOCKFILE"

exit 0
