#!/usr/bin/env bash
# session-start-bootstrap-check.sh — SessionStart hook
#
# Detects whether this is a virgin install of the agentic-os template.
# If virgin, injects a strong directive: invoke the os-bootstrap skill to
# interview the operator and configure the system before doing other work.
#
# Virgin signal: presence of the sentinel file `.bootstrap-pending` at repo
# root. The os-bootstrap skill removes the sentinel when configuration
# completes.

set -uo pipefail

ROOT="${CLAUDE_PROJECT_DIR:-$PWD}"
SENTINEL="$ROOT/.bootstrap-pending"

[ -f "$SENTINEL" ] || exit 0

msg='# ⚠️ Bootstrap pending

This appears to be a virgin install of the `agentic-os` template — the sentinel `.bootstrap-pending` is present.

**Before doing other work**, invoke the **`os-bootstrap`** skill via the Skill tool. It will:

1. Interview the operator about identity, voice, decision rules.
2. Resolve placeholders for the interface agent and senior advisor names.
3. Select active domains and remove unused scaffolds.
4. Wire hooks, settings, and minimal scripts.
5. Remove this sentinel file.

If the operator wants to defer setup and use the system as-is in placeholder mode, delete `.bootstrap-pending` manually — but be aware that hooks and routing relying on agent names will silent-pass (placeholders are detected and skipped).'

jq -n --arg c "$msg" '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$c}}'
