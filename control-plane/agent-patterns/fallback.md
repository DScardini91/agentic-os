# Pattern: Fallback

## Role

A documented catch-all for tasks that **no specialist owns**. The fallback agent exists so that uncovered work has a named home — every invocation surfaces a coverage gap that Darwin can audit.

Without a fallback, the interface agent silently absorbs uncovered work. The work gets done, but the gap never gets seen, and the system never learns where it needs new specialists.

## When to instantiate one

- The OS has at least 5 specialists. Below that, coverage gaps are obvious; no fallback is needed.
- Darwin has flagged "interface agent did non-trivial work itself" more than twice in recent governance passes.
- The operator wants observability into where the harness is incomplete — i.e. wants the system to surface its own gaps.

## When NOT to instantiate

- Before the OS has any structure. A fallback in a 3-agent system is a vanity agent.
- As a replacement for routing. The fallback is the **last resort**, not the **first option**. If the interface agent routes most work to the fallback, the specialists are wrong-shaped — fix the routing.

## How it works

```
Interface agent receives a task
        ↓
Routes through skill routing + concept routing + agent registry
        ↓
No match found
        ↓
Invoke fallback
        ↓
Fallback agent:
  - Executes the task with read-write tools
  - LOGS the invocation as a coverage gap to its state.md
  - Returns the output to the interface agent
        ↓
Darwin reads the log in the next governance pass
        ↓
Proposes either:
  - A new specialist for this category of work, OR
  - An extension to an existing specialist's scope, OR
  - The work is genuinely one-off; leave it in the fallback's log
```

## Template

```markdown
---
name: interface-fallback
description: Catch-all for tasks no specialist owns. Executes the work and logs the invocation as a coverage-gap signal for the OS analyst. Reports to the interface agent.
tools: Read, Write, Edit, Bash, Agent
---

# Interface fallback

You exist because some tasks have no specialist home. Your job is twofold:
1. Execute the task competently.
2. Log the invocation so the OS analyst can see where coverage is missing.

## On invocation
1. Read `control-plane/memory/interface-fallback/state.md` (current coverage-gap log).
2. Execute the task.
3. **Append a coverage-gap entry** to `state.md`:
   ```
   - YYYY-MM-DD · <one-line task description> · category: <best guess at what specialist would have owned this>
   ```
4. Return the output.

## What you are not
- Not a specialist. You do not develop deep expertise in any area; the moment a pattern emerges, the OS analyst should propose a real specialist.
- Not the senior advisor. Pressure-testing belongs elsewhere.
- Not the interface agent. You are invoked by the interface agent, not the other way around.

## What you do well
- Read context broadly, execute with reasonable competence, surface the gap.
- Resist the temptation to deepen — that is the OS analyst's call, not yours.

## State file
`control-plane/memory/interface-fallback/state.md` — append-only coverage-gap log. Darwin reads this in deep-mode passes.
```

## Worked example

The template does not ship with a concrete fallback agent. Instantiate it once the OS reaches > 5 specialists and Darwin's audit suggests it would help.

## How to instantiate

1. **Wait until the OS has enough specialists** that coverage gaps are non-obvious. Premature fallback is bloat.
2. **Copy the template above** into `.claude/agents/interface-fallback.md` (or whatever name fits).
3. **Create `control-plane/memory/interface-fallback/state.md`** with a header and an empty coverage-gap log.
4. **Update the interface agent's routing rules** so the fallback is the last hop, not the first.
5. **Wire Darwin to read the fallback's state file** in deep mode — add it to the input list in `darwin.md`.

## Anti-patterns

- **Fallback that grows specialization.** The moment the fallback gets good at one category, that category needs a real specialist. The fallback's growth is a Darwin signal, not a victory.
- **Fallback used as the default.** If > 20% of invocations land here, the routing is broken.
- **Fallback that does not log.** Then it is just another specialist with no clear scope. The log is the whole point.
