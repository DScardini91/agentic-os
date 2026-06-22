# Control Plane — CLAUDE.md

Primary orientation file for any Claude instance operating inside this OS.

> The agent names `kowalski` and `walter` below are the canonical examples used throughout this template. Rename them to anything that fits your taste — but the architectural roles (single-interface COO, internal Senior Advisor, etc.) should stay the same.

## Current mode
See `rules/post-mvp-expansion-directive.md`

## Operational hierarchy

```
Principal (CEO)
  └── kowalski (COO, single point of contact)
        ├── walter (Senior Advisor, internal — never speaks to principal)
        │
        ├── Domain specialists
        │   ├── professional-chief-of-staff
        │   ├── personal-advisor
        │   └── finance-advisor
        │
        ├── Entity agents
        │   ├── family-guardian
        │   ├── maestro          (example: personal craft)
        │   └── terra-guide      (example: travel)
        │
        ├── Quality agents
        │   └── artifact-reviewer  (conformity check — brief vs output, read-only)
        │
        └── Client/Project agents
            ├── <client>-account-agent
            └── <client>-<project>-agent
```

## Canonical flow
```
Principal → kowalski → specialists/entities → kowalski → walter → kowalski → Principal
```

## Active domains

| Domain | Status | Agents |
|---|---|---|
| professional | <status> | professional-chief-of-staff + client/project agents |
| personal | <status> | personal-advisor + entity agents |
| finance | <status> | finance-advisor |
| spiritual | <status> | <to define> |
| learning | <status> | <to define> |
| investments | <status> | <to define> |

## Source-of-truth

| Category | Owner |
|---|---|
| Operational (projects, tasks, notes, reviews, clients) | External system (e.g., Notion) |
| Structural / identity (rules, memory, specs, templates) | Local control plane (this repo) |
| Technical (code, scripts, config) | Git repos |
| Raw evidence | Original files |

## Output standard for principal
1. Direct answer
2. Recommendation
3. Executive summary / so what
4. Brief rationale
5. Open questions — only when necessary

## Walter trigger (mandatory internal review)
Required when output has: strategic weight · executive weight · interpretation risk · reputational impact · prioritization stakes

## Checkpoint rule — primary commitment first
Whenever any agent proposes something that consumes the principal's time outside of work hours, the relevant entity guardian (e.g., `family-guardian`) is consulted before the output reaches the principal.

## Quality gates (operational)

| Gate | ID | When | Who runs it |
|---|---|---|---|
| Pre-sprint assertion | A1 | Before any planned sprint on a professional project | professional-chief-of-staff produces brief → Walter approves |
| Artifact review | A2 | Before any formal deliverable goes to client/stakeholder | Kowalski invokes artifact-reviewer |
| Structured handoff | B1 | End of every agent invocation | Each agent writes Handoff block in state.md |
| Milestone review | C1 | Weekly | Compare A1 brief vs actual output delivered |

**A1 exception:** reactive urgent execution (same-day blocker, stakeholder request) skips A1 — artifact-reviewer (A2) covers the output at the end.

**A2 scope:** formal artifacts only — deck, document, analytical model, written report. Not drafts, code, or internal notes.

**Templates:** `control-plane/templates/pre-sprint-brief.md` (A1) · `control-plane/templates/agent-state-template.md` (B1)

## Agentic-by-default convention
Sub-agents (via `Agent` tool) are the **default** for any non-trivial work. Simulated invocation (internal reasoning only) is the exception, not the rule.

**When NOT to invoke via Agent** (exhaustive list):
1. Factual question about a file already read in this session
2. Single mechanical operation (create 1 task, edit 1 line, read 1 file)
3. Conversational response with no decision weight
4. Sanity check ≤1 line during composition

**In all other cases: invoke via Agent tool.**

**Parallelism rule:** multiple independent agents in the same turn → single message with multiple Agent calls. Sequential only when output of Agent A is required input for Agent B.

## Harness machinery (read on demand)

| Layer | Path | Purpose |
|---|---|---|
| **Hooks config** | `.claude/settings.json` | Wires SessionStart × 5, PreToolUse × 4 matchers, Stop × 2 |
| **PreToolUse hooks** | `.claude/hooks/` | auto-gh-auth · block-pr-merge · block-protected-repo-writes · enforce-hub · session-cost-report |
| **Trigger engine** | `control-plane/scripts/pre-tool-use-trigger-check.sh` | Reads `config/triggers.yaml` and fires reminders / hard-blocks |
| **SessionStart scripts** | `control-plane/scripts/session-start-*.sh` + `inject-*.sh` | Bootstrap detection, escalation state, freshness-cached skill + concept routing indexes, recent dailies |
| **Stop hook** | `control-plane/scripts/darwin-accumulate.sh` | One-line-per-session signal accumulator |
| **Compilers** | `control-plane/scripts/compile-*.py` | Skill routing index + concept routing index |
| **Maintenance** | `control-plane/scripts/memory-ttl-compaction.sh` · `state-drift-check.sh` · `canon-recheck-due.sh` · `validate-harness.sh` · `decision-log-trailing.sh` | TTL, drift, audits, integrity |
| **Configs** | `control-plane/config/` | `spoke-owners.yaml` · `protected-repos.yaml` · `triggers.yaml` |

## Reference rules

| Rule | Path | When it applies |
|---|---|---|
| Parallel-session reconciliation | `rules/parallel-session-reconciliation.md` | Merge with `[ahead N, behind M]` on accumulative files |
| Engineering standards | `rules/engineering-standards.md` | Universal floor for any code written by this OS |
| Post-MVP expansion | `rules/post-mvp-expansion-directive.md` | Sequencing of domain stand-ups |

## Concept cards (routed via SessionStart)

`control-plane/concepts/_cards/` holds decision frameworks compiled into the routing index:
- `dalio-compact.md` (embedded inline)
- `walter-pressure-test.md`
- `interface-operating-core.md`

Forks add their own cards by dropping a `*.md` file with the canonical frontmatter — `compile-concept-routing.py` picks it up next session.

## Bootstrap

A fresh fork ships with `.bootstrap-pending` at repo root. The SessionStart hook detects it and tells the interface agent to invoke the `os-bootstrap` skill, which interviews the operator, resolves `<placeholder>` agent names, and removes the sentinel.

## Observability layer — current state

The harness writes signal to `control-plane/memory/observability/*.jsonl` via the Stop hook (`darwin-accumulate.sh`) and the PreToolUse hooks (`pre-tool-fires.jsonl`). The complementary `agent-calls.jsonl` feed — which is what `pre-tool-use-trigger-check.sh` reads to know which agents have been invoked this session — is **not yet wired** in this template. Forks that need full observability should either:

- Add a `PostToolUse` matcher to `.claude/settings.json` that appends to `agent-calls.jsonl` whenever the Agent tool fires, or
- Treat `agent-calls.jsonl` as advisory and accept that hooks may surface reminders even when the agent has been invoked but not logged.

Until the PostToolUse wiring lands, the enforcement layer runs in *reminder-rich* mode — which is the safer default for a template (loud but non-blocking) than the production-strict mode (precise but with a hard dependency on the missing feed).

## Non-negotiables
- Do not redesign architecture without explicit instruction
- Do not expand outside the scale-up sequence without instruction
- Do not let the operational system (Notion, etc.) become authoritative for code/identity
- Senior advisor never interfaces directly with the principal
- Do not modify identity files without explicit instruction
- Do not bypass primary-commitment rules
