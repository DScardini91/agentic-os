# Agent state directory

One `state.md` file per non-trivial agent. Read at agent invocation as the **fast path** (progressive disclosure pattern) — live context, open handoffs, active threads — without loading the full agent spec from `.claude/agents/`.

## Template

See [agent-state-template.md](../templates/agent-state-template.md) for the canonical layout. Each state file should contain:

1. **Frontmatter** — agent name, last updated date, current mandate version.
2. **Active threads** — what the agent is currently working on, with pointers.
3. **Open questions** — items the agent has flagged for the principal.
4. **Handoff section** — what was done in the last invocation; cleared (or aged out) by the SessionStart Handoff TTL cleanup (7-day TTL by default).

## Naming

The file is named after the agent slug from `.claude/agents/<agent-slug>.md`. The state-file location must match `control-plane/agent-state/<agent-slug>.md` or `control-plane/memory/<agent-slug>/state.md` — `validate-harness.sh` checks both.

## TTL behavior

- The Handoff section is auto-cleared by `session-start-violations.sh` after 7 days of no update.
- The entire file is reset to template by `memory-ttl-compaction.sh` after 30 days of no update.
- These are guardrails against stale state polluting future reads — not data-loss events. Anything load-bearing should live in `memory/auto/` (long-term) or `memory/decisions/` (decision log), not in transient handoff blocks.
