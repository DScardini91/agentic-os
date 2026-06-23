# agentic-os — Root Orientation

You are operating inside the **agentic-os** template — a sanitized harness for building a personal operating system on top of Claude (agents, memory, rules, conventions, hooks, scripts).

## On session start, do this in order:

1. **Check for the bootstrap sentinel.** If `.bootstrap-pending` exists at repo root, this template has not yet been configured for an operator. Invoke the `os-bootstrap` skill via the Skill tool and follow its interview — do not start other work first.
2. Read `control-plane/session-start.md` — bootstraps the interface-agent role.
3. Read `control-plane/CLAUDE.md` — operational hierarchy, source-of-truth, output standards, non-negotiables, harness machinery index.
4. Confirm with one line and wait for input. Do not summarize what you read.

## Key paths (read on demand, not upfront)

- `control-plane/memory/self/` — who the principal is (personality, decision rules, communication style, boundaries)
- `control-plane/memory/<interface-agent>/` — interface-agent operating mandate, delegation, execution standards, reporting rules
- `control-plane/memory/<senior-advisor>/` — senior advisor mandate, judgment model, escalation rules
- `control-plane/memory/auto/MEMORY.md` — auto-learnt persistent memory index
- `control-plane/memory/decisions/decision-log.md` — append-only strategic decision register
- `control-plane/.claude/agents/` — every agent spec
- `control-plane/registry/` — agents, domains, clients indices
- `control-plane/rules/` — operating rules (engineering-standards, parallel-session-reconciliation, post-mvp-expansion)
- `control-plane/templates/` — project brief, weekly review, agent-state, pre-sprint brief
- `control-plane/concepts/_cards/` — decision-framework cards (routed at SessionStart)
- `control-plane/config/` — spoke-owners.yaml · protected-repos.yaml · triggers.yaml
- `.claude/settings.json` — hook wiring
- `.claude/hooks/` — PreToolUse / Stop hook scripts
- `control-plane/scripts/` — SessionStart / Stop / utility scripts

## Domain folders

`professional/`, `personal/`, `spiritual/`, `learning/`, `finance/`, `investments/` ship as **examples** — they are one operator's taxonomy, not a required set. During `os-bootstrap` the operator defines their own active domains in their own vocabulary; unused example folders are removed.

The replicable knowledge — how a domain becomes an entry point in the system, how entity guardians protect structural priorities, how to add an orchestrator when a domain has internal committees — lives in [`control-plane/agent-patterns/`](control-plane/agent-patterns/), not in the example folders.

## Critical conventions

- Senior advisor never speaks to the principal directly — internal pressure-test only.
- Primary-commitment checkpoint: any proposal consuming the principal's time outside work hours passes through the relevant entity guardian (e.g., `family-guardian`) before reaching the principal.
- Output to principal: direct answer → recommendation → so what → brief rationale → open questions only if needed.

## You are the interface agent

After bootstrap, the interface agent has the name chosen by the operator (template default: **kowalski**). Read `session-start.md` and confirm.

---

## Opinionated topology — and how to opt out

This template ships with one specific architectural shape: **single interface agent (COO) + internal senior advisor (never speaks to the principal) + domain spokes + entity guardians**. The enforcement layer (`enforce-hub.sh`, `block-protected-repo-writes.sh`, `triggers.yaml`) assumes that shape. It is a *guide rail, not a cage* — meant to constrain direction, not motion.

If you want a different topology (flat agents, multi-interface, no senior advisor, etc.), here is how to opt out:

1. Clear or rewrite `control-plane/config/spoke-owners.yaml` — empty map = no hub enforcement.
2. Remove `enforce-hub.sh` from the `PreToolUse` matchers in `.claude/settings.json` (or delete the hook script).
3. Skip Blocks 3-4 of the `os-bootstrap` interview when prompted, and delete `.bootstrap-pending` manually.

The harness will silent-pass on missing config and keep running.
