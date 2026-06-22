# Agent templates

Instantiable templates the operator (or `os-bootstrap`) uses to create new agents. Each template is a `.template.md` file with `<placeholder>` markers the operator fills in.

| Template | Pattern doc | When to instantiate |
|---|---|---|
| [domain-entry.template.md](domain-entry.template.md) | [agent-patterns/domain-entry-agent.md](../../agent-patterns/domain-entry-agent.md) | Operator defined a domain that recurs (≥ 1 task/week or 1 decision/month) and the interface agent has been simulating it inline |
| [entity-guardian.template.md](entity-guardian.template.md) | [agent-patterns/entity-guardian.md](../../agent-patterns/entity-guardian.md) | Operator has a chronically under-defended structural priority |

## How `os-bootstrap` uses these

During Block 3 (domain selection) and the entity-guardian step:

1. Operator names their own domains and structural priorities.
2. For each one that needs an agent, `os-bootstrap` copies the relevant template into `.claude/agents/<chosen-name>.md`.
3. The interview fills the `<placeholder>` markers via Q&A (slug, domain name, scope bullets, vocabulary, etc.).
4. `control-plane/memory/<chosen-name>/state.md` is created from `templates/agent-state-template.md`.
5. The new agent is registered in `control-plane/registry/agents.md`.

## Why templates separate from pattern docs

- **Pattern docs** (`agent-patterns/*.md`) explain the role, when to instantiate, and anti-patterns. They are reference reading.
- **Templates** (`templates/agents/*.template.md`) are the concrete files copied at instantiation time.

Splitting them lets pattern docs evolve without breaking the instantiation flow, and lets templates be edited without re-writing the pedagogy.

## Operator override

Operators can edit templates freely after bootstrap. A common change: adopting a different state-file location convention, or adding a fixed footer block (emoji policy, escalation rules) every new domain agent should inherit.

When editing templates, keep the `<placeholder>` markers — `os-bootstrap` and future `os-bootstrap-extend` flows depend on them to know where to fill in.
