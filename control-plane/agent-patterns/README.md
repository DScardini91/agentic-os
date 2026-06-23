# Agent patterns

Five canonical agent roles distilled from production use of the source OS. Each pattern documents:

- **What the role is for** — the structural job it does inside the harness.
- **When to instantiate one** — concrete signals that a new agent of this shape is needed.
- **When NOT to instantiate** — anti-signals.
- **Template** — a ready-to-fill agent spec.
- **Worked example** — one or two agents in the template that already follow the pattern.

The patterns are descriptive, not prescriptive. **You do not need every pattern.** Most installations of this OS use 3-5 agents total in early life; the patterns scale to dozens only when the operator's work genuinely fans out.

## Index

| Pattern | One-line role | Template ships with |
|---|---|---|
| [Interface agent](interface-agent.md) | Single point of contact between the principal and everything else | `kowalski` |
| [Senior advisor](senior-advisor.md) | Internal pressure-test for strategic output; never speaks to the principal | `walter` |
| [Domain entry agent](domain-entry-agent.md) | First reader / triager for a domain (professional, personal, finance, etc.) | `professional-chief-of-staff`, `personal-advisor`, `finance-advisor` |
| [Entity guardian](entity-guardian.md) | Hard gate protecting a non-negotiable structural priority (family, craft, health, etc.) | `family-guardian`, `maestro`, `terra-guide` |
| [Quality gate](quality-gate.md) | Read-only conformity check between artifact and brief | `artifact-reviewer` |
| [OS analyst](os-analyst.md) | Observes the OS over time, surfaces drift, proposes structural change | `darwin` |
| [Orchestrator](orchestrator.md) | Coordinates a committee of multiple specialists into a single synthesis | none (see worked-example pointer) |
| [Fallback](fallback.md) | Catch-all for tasks no specialist owns; documents the call so coverage gaps surface | none (see worked-example pointer) |

## Pattern ↔ shipped agent crosswalk

Every shipped agent is a worked example of exactly one pattern. When the patterns library says "see the worked example", this is the mapping:

| Pattern | Shipped agent(s) | Notes |
|---|---|---|
| Interface agent | `kowalski` | Canonical. Exactly one per installation. |
| Senior advisor | `walter` | Canonical. Exactly one per installation. |
| Domain entry agent | `professional-chief-of-staff`, `personal-advisor`, `finance-advisor` | Three example domains. Operator instantiates more via `templates/agents/domain-entry.template.md`. |
| Entity guardian | `family-guardian`, `maestro`, `terra-guide` | Three example protected categories (household, craft, travel). Operator instantiates more via `templates/agents/entity-guardian.template.md`. |
| Quality gate | `artifact-reviewer` | Single conformity gate; customize rather than fork. |
| OS analyst | `darwin` | Canonical governance agent. |
| Orchestrator | _(none shipped)_ | Instantiate when a domain has 3+ named lenses voting independently. Pattern doc has the template. |
| Fallback | _(none shipped)_ | Instantiate when the OS has > 5 specialists and Darwin flags coverage gaps. |

If a shipped agent is not listed above, the registry is wrong; update both.

## How to use this directory

1. **Read [domain-entry-agent.md](domain-entry-agent.md) first** if you are adding a domain. The pattern explains how a domain becomes an entry-point in the system.
2. **Use the worked example as your starting point**, not the template. The example is already-functional in this repo; copy, rename, and edit.
3. **Document your instantiation in `control-plane/registry/agents.md`** so Darwin can audit coverage.
4. **One pattern at a time.** Adding three agents at once dilutes the test of whether the first one was needed.

## Anti-pattern

Instantiating every pattern "to be safe" produces a top-heavy system where most agents are never invoked. Darwin will flag uninvoked agents in the weekly housekeeping. If an agent has not been invoked in 30 days, it is either premature or the wrong shape — re-evaluate, do not preserve.

The [OS evolution principle](../../CLAUDE.md#opinionated-topology--and-how-to-opt-out) says the OS grows by deliberate accretion. That includes agents: each new agent earns its place by being invoked.
