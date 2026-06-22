# Pattern: Domain entry agent

## Role

A domain entry agent is the **first reader** for any work that touches a specific area of the principal's life. It triages, routes to deeper specialists if needed, and produces a domain-shaped response. The interface agent never enters a domain directly — it goes through the entry agent.

## When to instantiate one

- The principal has a recurring area of work or life with **its own vocabulary, stakeholders, and trade-offs** (work, finance, learning, health, relationships, a craft, an investment portfolio).
- That area generates more than incidental work — at least one task per week, or one decision per month.
- The interface agent has been simulating the domain's reasoning in-context, and the context burn or the quality drop is noticeable.

If the area is touched twice a year, do not instantiate. The interface agent handles it inline.

## When NOT to instantiate

- The area is purely informational and produces no decisions (e.g. "I keep a list of books I've read"). A note file is enough.
- The area belongs to someone else (e.g. a co-worker's project) — that is **not your domain**.
- Two areas are entangled enough that one agent covers both better than two specialists (e.g. "finance" and "investments" can be one agent until the volume separates them).

## Template (copy into `.claude/agents/<your-name>.md`)

```markdown
---
name: <domain-slug>-advisor
description: <Domain> entry agent. First reader for any <domain>-related work — triages, routes deeper if needed, produces domain-shaped response. Reports to the interface agent. Emoji: <pick one>
tools: Read, Write, Edit, Bash, Agent
---

# <Domain> advisor

You are the entry point for the principal's <domain> work. Your job is not to do every <domain> task yourself — it is to route, triage, and synthesize.

## On invocation (mandatory)
1. Read `control-plane/memory/<domain-slug>-advisor/state.md` — handoff + active threads.
2. Execute.
3. Update `state.md` before returning.

## Position in hierarchy
```
Interface agent (COO)
  └── <Domain> advisor (you)
        ├── (optional) deeper specialists in the same domain
        └── outputs → interface agent → senior advisor (if strategic weight) → principal
```

## Domain scope
- **In scope:** <list 3-5 concrete examples of work this agent owns>
- **Out of scope:** <list 2-3 things adjacent that go elsewhere>

## Key vocabulary
- <term>: <definition>

## Recurring decision shapes
- <decision shape 1>: <how to approach>
- <decision shape 2>: <how to approach>

## Sub-agents this agent may invoke
- (none initially; add as the domain fans out)

## State file location
`control-plane/memory/<domain-slug>-advisor/state.md`

## Emoji: <one emoji>
```

## Worked examples in this template

- **`professional-chief-of-staff`** (`.claude/agents/professional-chief-of-staff.md`) — first reader for professional / client / project work.
- **`personal-advisor`** (`.claude/agents/personal-advisor.md`) — first reader for personal life outside work, routes to entity guardians (family, craft, travel).
- **`finance-advisor`** (`.claude/agents/finance-advisor.md`) — first reader for personal finance, statements, anomaly sweep.

## How to instantiate (5 steps)

1. **Copy** `professional-chief-of-staff.md` (or the closest existing entry agent) to `.claude/agents/<your-domain>-advisor.md`.
2. **Rename** in the frontmatter and edit the description, scope, vocabulary.
3. **Create** `control-plane/memory/<your-domain>-advisor/` directory with a `state.md` (use the [agent-state template](../templates/agent-state-template.md)).
4. **Register** in `control-plane/registry/agents.md` and `control-plane/registry/domains.md`.
5. **Add a row** to `control-plane/CLAUDE.md` § "Active domains".

Walter check before merging the agent: the description is concrete enough that a fresh reader knows what the agent does without re-reading the body.

## Anti-patterns

- **Naming the agent after a tool, not a domain.** `notion-agent` is wrong; `professional-chief-of-staff` is right. The domain is what's stable; the tools change.
- **Listing every possible task in scope.** The scope statement is for triage, not for exhaustive enumeration. Keep it to the top 3-5 work shapes.
- **Instantiating two domain entry agents that overlap by > 30%.** Merge them or split the overlap into a third agent that both delegate to.
