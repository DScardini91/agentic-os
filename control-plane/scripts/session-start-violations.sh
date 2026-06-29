#!/usr/bin/env bash
# session-start-violations.sh — SessionStart hook (Etapa 3 enforcement)
#
# Cross-references pre-tool-fires.jsonl against agent-calls.jsonl for prior
# sessions. Identifies fires whose trigger agent was NOT invoked in the same
# session — these are violations.
#
# Side effects:
#   1. Updates ~/.config/agentic-os/escalation-state.json — adds escalable
#      matchers that had violations in the prior session. Reminder-only
#      matchers never escalate.
#   2. Injects an alert into the current session listing the violations.
#
# Stdout: hookSpecificOutput JSON (additionalContext) with the alert. Silent
# if no violations.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
LOG_DIR="$ROOT/control-plane/memory/observability"
FIRES_LOG="$LOG_DIR/pre-tool-fires.jsonl"
CALLS_LOG="$LOG_DIR/agent-calls.jsonl"

# Namespace escalation state by project-dir hash so two clones / forks on the
# same machine do not contaminate each other's escalation file (gamma-guardian D1).
PROJECT_HASH=$(echo "$ROOT" | shasum 2>/dev/null | cut -c1-12 || echo "default")
ESC_DIR="$HOME/.config/agentic-os/$PROJECT_HASH"
ESC_FILE="$ESC_DIR/escalation-state.json"

mkdir -p "$ESC_DIR"
command -v jq >/dev/null 2>&1 || exit 0

if [ ! -f "$FIRES_LOG" ] || [ ! -s "$FIRES_LOG" ]; then
  jq -nc '{hookSpecificOutput:{hookEventName:"SessionStart"}}'
  exit 0
fi

# Look only at the last 24h window — older violations are forgiven.
RECENT_CUTOFF=$(date -u -v-24H +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || date -u -d "24 hours ago" +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || echo "1970-01-01T00:00:00Z")

# Single-pass: read each file once, join in memory via jq.
# Replaces the N-session loop that did 2N+1 file reads (one per session).
# Walter-reviewed pattern — any(. == $t) for reliable jq 1.5/1.6/1.7 membership test.
FIRES_RAW=$(tail -2000 "$FIRES_LOG")
CALLS_RAW=""
[ -f "$CALLS_LOG" ] && CALLS_RAW=$(tail -500 "$CALLS_LOG")

violations=$(printf '%s\n%s\n' "$FIRES_RAW" "$CALLS_RAW" \
  | jq -rs --arg cutoff "$RECENT_CUTOFF" '
    (map(select(.kind == "pre-fire" and (.ts // "") >= $cutoff))) as $fires |
    (map(select(.kind == "call"))
      | group_by(.session)
      | map({key: .[0].session, value: [.[].agent]})
      | from_entries) as $call_map |
    $fires[] |
    . as $f |
    ($call_map[$f.session] // []) as $agents |
    select(($f.trigger as $t | $agents | any(. == $t)) | not) |
    [$f.session, $f.matcher, $f.trigger, ($f.file_path // $f.command // ""), $f.severity] |
    @tsv
  ' 2>/dev/null || true)

# Escalable matchers (configurable list — these turn into hard-blocks).
escalable_violated=$(echo "$violations" | awk -F'\t' '$2=="edit-control-plane" || $2=="edit-personal-domain" || $2=="no-direct-merge" || $2=="protected-repo-write-without-owner" {print $2}' | sort -u | grep -v '^$' || true)

if [ -n "$escalable_violated" ]; then
  matchers_json=$(echo "$escalable_violated" | jq -R . | jq -sc '. | map({matcher: .})')
  jq -n --argjson m "$matchers_json" '{hard_blocks:$m}' > "$ESC_FILE"
else
  jq -n '{hard_blocks:[]}' > "$ESC_FILE"
fi

if [ -z "${violations// /}" ]; then
  jq -nc '{hookSpecificOutput:{hookEventName:"SessionStart"}}'
  exit 0
fi

if [ -n "$escalable_violated" ]; then
  closing=$'\n'"Matcher(s) escalated to **HARD-BLOCK** this session: $(echo "$escalable_violated" | tr '\n' ',' | sed 's/,$//;s/,/, /g'). Tool calls that match these will be denied until the trigger agent is invoked via the Agent tool. Emergency override: see triggers.yaml."
else
  closing=$'\n'"No matchers escalated to hard-block (all violations were reminder-only)."
fi

alert_body=$(echo "$violations" | awk -F'\t' -v closing="$closing" '
NR==1 {print "## ⚠️ Trigger violations detected in prior session\n\nTools fired triggers requiring an agent invocation, but the agent was never invoked. This is the structural gap Etapa 3 enforcement closes.\n"}
NF>=5 {printf "- **%s** / `%s` — %s (`%s`)\n", $3, $2, $4, $5}
END {print closing}
')

jq -nc --arg c "$alert_body" '{hookSpecificOutput:{hookEventName:"SessionStart", additionalContext:$c}}'

# Async cleanup: stale Handoff sections in agent state files (TTL=7 days).
HANDOFF_TTL_DAYS=7
MEMORY_DIR="$ROOT/control-plane/memory"

_clear_stale_handoffs() {
  local today_epoch
  today_epoch=$(date +%s)
  find "$MEMORY_DIR" -name "state.md" -maxdepth 3 2>/dev/null | while read -r state_file; do
    updated_line=$(grep -m1 -E '^_(Atualizado|Updated):' "$state_file" 2>/dev/null || true)
    [ -z "$updated_line" ] && continue
    updated_date=$(echo "$updated_line" | grep -oE '[0-9]{4}-[0-9]{2}-[0-9]{2}' | head -1)
    [ -z "$updated_date" ] && continue
    updated_epoch=$(TZ=UTC date -j -f "%Y-%m-%d" "$updated_date" +%s 2>/dev/null || \
                    TZ=UTC date -d "$updated_date" +%s 2>/dev/null || echo 0)
    [ "$updated_epoch" -eq 0 ] && continue
    age_days=$(( (today_epoch - updated_epoch) / 86400 ))
    [ "$age_days" -lt "$HANDOFF_TTL_DAYS" ] && continue
    lock_hash=$(echo "$state_file" | md5 2>/dev/null || echo "$state_file" | md5sum 2>/dev/null | cut -d' ' -f1)
    lock_file="/tmp/agentic-os-state-lock-${lock_hash}"
    ( flock -n 9 || exit 0
      awk '
        /^## Handoff — last execution$|^## Handoff — última execução$/ { in_handoff=1; print; next }
        in_handoff { next }
        { print }
        END {
          if (in_handoff) {
            print "_Replaced wholesale at each invocation. The interface agent reads this block to know what happened without rebuilding full context._"
            print ""
            print "**Completed:**"
            print "- (prior session expired — no data)"
            print ""
            print "**Not completed:**"
            print "- ..."
            print ""
            print "**Blockers:**"
            print "- ..."
            print ""
            print "**Open questions:**"
            print "- ..."
          }
        }
      ' "$state_file" > "${state_file}.tmp" && mv "${state_file}.tmp" "$state_file"
    ) 9>"$lock_file"
  done
}
_clear_stale_handoffs &
exit 0
