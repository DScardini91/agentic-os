# Pattern: Interface agent

## Role

The **single point of contact** between the principal and the rest of the system. Everything the principal says enters through the interface agent. Everything the system returns to the principal exits through the interface agent. No specialist talks to the principal directly.

This is the COO of the OS. It does not have to do every task — it has to route work, coordinate specialists, and surface a single coherent voice.

## When to instantiate one

Always. Every installation of this OS has exactly one interface agent. It is the most load-bearing role.

## When NOT to instantiate

- Never instantiate a second interface agent in parallel. The single-interface property is what makes context coherent. Two interface agents = two competing voices, fragmentation guaranteed.
- Don't conflate the interface agent with a specialist. If the interface agent is doing all the work itself, the harness is not actually multi-agent — it is a single agent with extra files.

## Template

The interface agent's spec ships with this template as `.claude/agents/kowalski.md`. Rename it to whatever fits — the role is canonical, the name is decorative.

The full spec covers:
- The conclusion-first output discipline (see [best-practices/conclusion-first.md](../best-practices/conclusion-first.md))
- The agentic-by-default delegation pattern (see [best-practices/agentic-by-default.md](../best-practices/agentic-by-default.md))
- The senior-advisor escalation triggers
- The entity-guardian checkpoint
- The output structure for the principal

## Worked example in this template

**`kowalski`** (`.claude/agents/kowalski.md`).

To rename: the `os-bootstrap` skill asks the operator for the interface agent's name in Block 2 and applies the rename across the repo.

## How to customize

After bootstrap:
1. Edit `.claude/agents/<your-name>.md` to adjust tone, escalation thresholds, output preferences.
2. Edit `control-plane/memory/<your-name>/` to refine the operating mandate, delegation model, execution standards, reporting rules.
3. The mandate lives in memory, not in the agent spec — that way you can evolve how the interface agent operates without re-editing the spec each time.

## Anti-patterns

- **Putting the principal's identity in the interface agent's spec.** The principal is described in `control-plane/memory/self/`. The interface agent describes how it operates, not who it serves.
- **Treating the interface agent as omniscient.** It is the COO, not a god. It delegates aggressively and pressure-tests before responding to the principal on strategic items.
- **Letting the interface agent merge to main without a PR.** Even when the operator is solo, the no-direct-merge rule applies to repos with external visibility. See [best-practices/no-direct-merge.md](../best-practices/no-direct-merge.md).
