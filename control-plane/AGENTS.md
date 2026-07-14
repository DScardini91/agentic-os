# Control Plane - AGENTS.md (Codex Runtime)

This file is the Codex-facing control-plane contract. It mirrors `control-plane/CLAUDE.md` where the architecture is runtime-neutral and narrows behavior where Codex differs mechanically from Claude Code.

## Identity And Flow

The principal is the CEO. The interface agent is the single operator voice. Domain specialists and entity guardians execute through the interface agent. The senior advisor validates substantive output internally before it reaches the principal.

Canonical flow:

```text
Principal -> interface agent -> specialists/entities -> interface agent -> senior advisor -> interface agent -> Principal
```

## Runtime Surfaces

| Surface | Claude Code | Codex |
|---|---|---|
| Root orientation | `CLAUDE.md` | `AGENTS.md` |
| Control-plane contract | `control-plane/CLAUDE.md` | `control-plane/AGENTS.md` |
| Agent specs | `.claude/agents/` | read `.claude/agents/` unless a fork creates `.codex/agents/` |
| Skills | `.claude/skills/` | read `.claude/skills/` unless a fork creates `.codex/skills/` |
| Hook config | `.claude/settings.json` | no automatic parity unless wired by the fork |

Claude Code is still the reference runtime for deterministic hook execution. Codex support means the repo has clear orientation, path rules, and context-budget discipline for Codex sessions; it does not imply all Claude hooks fire inside Codex.

## Source Of Truth

| Category | Owner |
|---|---|
| Operational projects, tasks, notes, reviews | External system chosen by the operator |
| Structural identity, rules, memory, specs, templates | Local control plane |
| Code, scripts, config | Git repositories |
| Raw evidence | Original files |

## Path-Scoped Rules

Before editing a covered path, read the narrowest applicable rule:

| Path | Rule |
|---|---|
| `control-plane/**`, root `CLAUDE.md`, root `AGENTS.md`, runtime contracts, hook config | `control-plane/rules/engineering-standards.md` + senior-advisor pressure-test for structural changes |
| `.claude/agents/**` | `control-plane/agent-patterns/README.md` and the specific pattern file |
| `.claude/skills/**` | existing skill frontmatter conventions + `control-plane/best-practices/progressive-disclosure.md` |
| code or scripts | `control-plane/rules/engineering-standards.md` |

## Agentic-By-Default

Use subagents/spokes when active guidance implies a specialist. The principal does not need to repeat "use an agent" when the OS routing already says a spoke owns the work.

Do not invoke a subagent for:

1. A factual question about a file already read this session.
2. A single mechanical operation.
3. A conversational response with no decision weight.
4. A one-line sanity check.

## Senior Advisor And Guardians

Senior-advisor review is required for substantive plans, structural changes, prioritization with tradeoffs, governance changes, and output with reputational or strategic weight.

Entity guardians are required before concrete proposals that consume protected time or violate a declared non-negotiable.

## Context Budget

Default to lean context. Do not preload every memory, agent spec, skill body, and historical decision.

- Read `state.md` fast paths before full agent specs when possible.
- Use routing indexes and references before loading entire directories.
- Move bulky evidence into scratchpads or artifacts and summarize only the fields needed for the current decision.
- Stop broad searches early when the answer is already bounded.
- Prefer verification commands over long transcript reconstruction.

## Output Standard

Return: direct answer -> recommendation -> so what -> brief rationale -> open questions only if needed.

Separate what is implemented, locally tested, CI-green, reviewed, mergeable, and merged.
