---
name: os-bootstrap-extend
description: Add a new domain, agent, or entity guardian to an already-bootstrapped OS. Same Q&A discipline as os-bootstrap but scoped to a single addition. Triggers — "add a new domain", "instantiate a new agent", "I need a guardian for X".
triggers:
  - "add a new domain"
  - "instantiate a new agent"
  - "I need a guardian for"
  - "new spoke for"
  - "extend the OS"
---

# Skill: os-bootstrap-extend

## When to use

The OS is already bootstrapped (`.bootstrap-pending` absent, agents named, base configs resolved). The operator wants to add ONE of:

- A new domain (with optional entry agent + optional entity guardian).
- A new entity guardian for an existing structural priority.
- A new domain entry agent for an existing domain folder that doesn't have one yet.
- An orchestrator over an existing committee of specialists.
- A fallback agent (when the OS has > 5 specialists and Darwin flags coverage gaps).

NOT for:
- Initial bootstrap → use `os-bootstrap`.
- Renaming the interface agent or senior advisor → invasive, do via direct edits + decision-log entry.
- Removing an agent → use `git rm` + registry cleanup; if the agent has accumulated state, surface to the senior advisor first.

## Preconditions

- `.bootstrap-pending` is NOT present (system is bootstrapped).
- The operator knows what they want to add (one concrete kind: domain / guardian / orchestrator / fallback).
- Agent patterns are read or referenced: `control-plane/agent-patterns/<pattern>.md`.

## Sequence

### Step 1 — Identify the addition kind

Ask: *"What are you adding — a domain (with or without an agent), an entity guardian, an orchestrator, or a fallback?"*

Each kind routes to a different sub-flow below.

### Step 2 (domain) — Domain micro-loop

Same as `os-bootstrap` Block 3 micro-loop, scoped to one domain:

1. **Slug** — `kebab-case`. Confirm with the operator.
2. **Entry agent?** — read out the trigger signal from [`agent-patterns/domain-entry-agent.md`](../../../control-plane/agent-patterns/domain-entry-agent.md): "yes if ≥ 1 task/week or 1 decision/month and the interface agent has been simulating it inline".
3. If yes:
   - Ask the operator for the agent's name (default suggestion: `<slug>-advisor`).
   - Copy `control-plane/templates/agents/domain-entry.template.md` to `.claude/agents/<chosen-name>.md`.
   - Fill placeholders via Q&A (description, scope in/out, vocabulary, recurring decisions).
   - Create `control-plane/memory/<chosen-name>/state.md` from `templates/agent-state-template.md`.
   - Register in `control-plane/registry/agents.md` and `control-plane/registry/domains.md`.
   - Add to `control-plane/config/spoke-owners.yaml`.
4. **Entity guardian?** — same logic via `entity-guardian.template.md` if applicable.
5. Create `<slug>/` folder at repo root with a stub `domain.md` describing scope, vocabulary, stakeholders.

### Step 3 (guardian only) — Entity guardian micro-loop

For a new entity guardian on an existing domain or cross-domain:

1. **What is being protected?** — concrete description (the protected thing, not abstract "balance").
2. **What concrete observations will the guardian make?** — write 3-5 example observations the guardian will reference ("hasn't slept 7h since Tuesday", "this is the Mth evening this week").
3. **Agent name** — operator chooses (default: `<thing>-guardian`).
4. Copy `templates/agents/entity-guardian.template.md`. Fill placeholders.
5. Register + add to interface agent's primary-commitment checkpoint rules in `control-plane/memory/<interface-agent>/`.

### Step 4 (orchestrator) — Orchestrator micro-loop

For an orchestrator over an existing committee:

1. **Existing specialists** — list the 3+ agents that already exist for this committee.
2. **Integration rule** — explicit (weighted average / veto power / majority + minority / tie → senior advisor).
3. **Agent name** — operator chooses.
4. Copy the orchestrator template (see [`agent-patterns/orchestrator.md`](../../../control-plane/agent-patterns/orchestrator.md)) — Note: not yet shipped as a `.template.md` file; copy the inline template from the pattern doc.
5. Register.

### Step 5 (fallback) — Fallback micro-loop

1. Confirm Darwin has flagged ≥ 2 "interface agent did non-trivial work itself" in recent governance passes.
2. **Agent name** — operator chooses (default: `interface-fallback`).
3. Copy the inline template from [`agent-patterns/fallback.md`](../../../control-plane/agent-patterns/fallback.md).
4. Update the interface agent's routing rules so the fallback is the last hop.
5. Add `interface-fallback` state file to Darwin's input list.

### Step 6 — Log the addition

For any of the above, write a decision-log entry:

```markdown
## D-NNN · YYYY-MM-DD · architecture · Added <agent-name> via os-bootstrap-extend
- **Decider:** principal
- **Context:** <one line why the addition is needed>
- **Decision:** Instantiated <pattern> as <agent-name>; registered in agents.md, domains.md (if domain), state.md created
- **Rationale:** <signal that triggered the addition — Darwin flag, recurring inline work, etc.>
- **Linked:** templates/agents/<template-used>.md, agent-patterns/<pattern>.md
- **Review (target +14d):** verify the agent has been invoked at least once; if not, re-evaluate or remove
```

### Step 7 — Validate

Run:
```bash
bash control-plane/scripts/validate-harness.sh
```

Expect: passes 10/10 (or +1 for the new agent). If the new agent fires a warning, fix the frontmatter or state.md before declaring done.

## Anti-patterns

- **Adding without a signal.** "I might need this someday" is not a signal. Real triggers: Darwin flagged it, the interface agent has been simulating it inline, the operator hit it twice in a week.
- **Skipping the decision-log entry.** Future Darwin passes won't know why the agent exists.
- **Forgetting to validate.** A new agent without state.md will fire warnings on every session start until fixed.
- **Adding more than one thing in one invocation.** Each addition gets its own pass through this skill. Bundling makes the decision-log entry vague.
