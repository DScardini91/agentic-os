# Progressive disclosure in agent specs

**Rule:** an agent spec has two reading tiers. The interface agent reads them in order:
1. **Fast path — `state.md`** at `control-plane/memory/<agent>/state.md` or `control-plane/agent-state/<agent>.md`. Always read at invocation. Contains live context: open threads, last handoff, active blockers.
2. **Deep context — full spec** at `.claude/agents/<agent>.md`. Read **only when** the fast path indicates the task requires the agent's full frameworks, rules, or pipelines.

## Why

Loading every agent's full spec at every invocation burns context budget on work the task doesn't need. A 2000-line agent spec dragged into a 30-second factual lookup means the next real work has less room to breathe.

The fast-path / deep-context split mirrors how humans operate: a colleague checks their notes (state.md) before re-reading the org chart (full spec). The OS should do the same.

## How to apply

- **Writing an agent spec:** put live, frequently-changing context in `state.md`. Put stable role definition, frameworks, and procedures in the full spec.
- **Reading an agent spec:** start with `state.md`. Open the full spec only when the task explicitly needs it (a deep-mode invocation, a first-time invocation, a complex framework application).
- **`validate-harness.sh`** checks that every non-read-only agent has a `state.md` file. Missing state files are flagged.

## Anti-pattern

- Putting time-sensitive context (current sprint, open blockers, recent decisions) in the full agent spec. It ages instantly and pollutes context every invocation.
- Bloating `state.md` past one screen. If it grows, consolidate into the auto-memory tier or archive older entries.

## TTL behavior

`state.md` has a **30-day TTL** for the full file (auto-reset by `memory-ttl-compaction.sh`) and a **7-day TTL** for the "Handoff — last execution" section specifically (auto-cleared by `session-start-violations.sh`). These are guardrails against stale state polluting future reads — not data-loss events. Anything load-bearing belongs in `memory/auto/` or `memory/decisions/`, not in a transient handoff block.
