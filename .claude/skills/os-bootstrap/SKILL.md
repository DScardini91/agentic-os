---
name: os-bootstrap
description: Interview the operator on a fresh fork of the agentic-os template and configure the system end-to-end — identity, voice, agent names, active domains, hooks, settings, sentinel removal. Triggers — "set up the os", "bootstrap", ".bootstrap-pending detected", any first session on a virgin clone.
version: 1.0
category: bootstrap
triggers:
  - "set up the os"
  - "bootstrap the agentic-os"
  - "configure the system"
  - "fresh fork"
  - ".bootstrap-pending detected"
---

# os-bootstrap

The first skill any new fork of the agentic-os template invokes. Interviews the operator, populates memory tier scaffolds, resolves `<placeholder>` agent names across the repo, removes the `.bootstrap-pending` sentinel, and leaves the harness ready to run.

This skill is mandatory on a fresh clone — the `SessionStart` bootstrap-check hook injects a directive into the session prompting it to run.

## When to invoke

- The very first session opened in a freshly cloned / unzipped agentic-os template (sentinel `.bootstrap-pending` is present at repo root).
- The operator explicitly says "set up the OS", "bootstrap", or equivalent.
- The interface agent detects unresolved `<placeholder>` strings in `control-plane/config/` and the sentinel is still present.

If the sentinel is absent and configs are resolved, the system is already bootstrapped — do **not** re-run unless the operator explicitly requests a re-bootstrap.

---

## Output

By the end of this skill, the following are true:

1. `control-plane/memory/self/` is populated with files describing the principal (personality, communication-style, decision-rules, boundaries) — content drawn from the operator's interview answers.
2. `control-plane/memory/<interface-agent>/` and `control-plane/memory/<senior-advisor>/` are renamed and populated with their canonical mandates (templates filled with chosen agent names).
3. `control-plane/config/spoke-owners.yaml` and `triggers.yaml` no longer contain `<placeholder>` strings — every placeholder is resolved to a real agent name or commented out.
4. Domain folders the operator chose to disable are removed from the working tree; active domains have stub `domain.md` files.
5. `control-plane/memory/decisions/decision-log.md` has its first real entry: "D-001 — os-bootstrap complete, operator X, on YYYY-MM-DD".
6. `.bootstrap-pending` is deleted.
7. `control-plane/memory/auto/MEMORY.md` has its first entries: user profile, communication style, working patterns drawn from the interview.

---

## Resumability — `.bootstrap-progress.json`

The interview persists progress after each completed block via a dedicated helper script. The progress file lives at repo root and tracks which of the 4 blocks are done.

**File shape:**
```json
{
  "started_at": "2026-06-22T14:30:00Z",
  "blocks": {
    "1_identity": "completed",
    "2_harness_naming": "in_progress",
    "3_domains": "pending",
    "4_technical_wiring": "pending"
  },
  "last_updated": "2026-06-22T14:42:00Z"
}
```

**Helper script:** `control-plane/scripts/bootstrap-progress.sh` — read/write contract:

```bash
# at start of session, find where to resume
bash control-plane/scripts/bootstrap-progress.sh next       # prints next pending block or "done"
bash control-plane/scripts/bootstrap-progress.sh status     # prints full JSON

# at the start of each block
bash control-plane/scripts/bootstrap-progress.sh start 1_identity

# at the end of each block (atomically updates state + last_updated)
bash control-plane/scripts/bootstrap-progress.sh complete 1_identity

# when Block 4 completes, the script prints "ALL_COMPLETE" and removes
# BOTH .bootstrap-pending AND .bootstrap-progress.json automatically

# operator opt-in: start over from scratch
bash control-plane/scripts/bootstrap-progress.sh reset
```

**Skill invocation flow:**
1. Run `bootstrap-progress.sh next` to find the resume point.
2. If output is `done`, sanity-check the sentinel state and report to operator.
3. Otherwise, run `bootstrap-progress.sh start <block>` and execute that block.
4. On block completion, run `bootstrap-progress.sh complete <block>`.
5. If the script's output contains `ALL_COMPLETE`, the bootstrap is finished — sentinel and progress file already cleaned.
6. If interrupted mid-block, the operator re-invokes `os-bootstrap` and the next run resumes from the same block (marked `in_progress` until completion).

---

## Interview script

Run the interview in **four blocks**, in this order. Use one Agent + Skill turn per block when possible to keep the operator's cognitive load low.

### Block 1 — Identity

Ask, in this order:

1. **Name and role.** *"How should I refer to you, and what is your professional context (consultant, engineer, founder, student, other)?"*
2. **Primary use cases.** *"What is the first thing you want this OS to help with — work, personal life, finances, all of them?"*
3. **Communication style.** *"Do you prefer conclusion-first, terse responses, or do you want me to walk through reasoning? Are there words / styles I should never use (profanity, emoji, em-dash, second person)?"*
4. **Non-negotiables.** *"Anything I should refuse or never recommend? (Examples some operators set: 'never suggest alcohol', 'never use em-dash in external comms', 'no profanity'.)"*

Write the answers to:
- `control-plane/memory/self/personality.md`
- `control-plane/memory/self/communication-style.md`
- `control-plane/memory/self/boundaries.md`
- `control-plane/memory/self/decision-rules.md` (if the operator volunteers any)

Also create the first auto-memory file `control-plane/memory/auto/user_profile.md` with frontmatter `type: user` summarizing the answers.

### Block 2 — Harness naming

Resolve the two placeholder agent roles. Ask:

1. **Interface agent name** (template default: `kowalski`). *"What should I call your interface / COO agent? This is the single point of contact between you and the rest of the system. Default: kowalski."*
2. **Senior advisor name** (template default: `walter`). *"What should I call your senior advisor — the internal pressure-tester that never speaks to you directly? Default: walter."*
3. **Family / entity guardian present?** If the operator has primary commitments outside work (family, partner, recurring care responsibility), ask for an entity-guardian agent name and what it protects. Otherwise skip — the slot can stay empty.

Apply the chosen names across the repo via search-and-replace on `<interface-agent>`, `<senior-advisor>`, `<family-guardian>`, `<spiritual-agent>`, `<learning-agent>` in:
- `control-plane/config/spoke-owners.yaml`
- `control-plane/config/triggers.yaml`
- `control-plane/CLAUDE.md`
- `CLAUDE.md` (root)
- Agent spec files in `.claude/agents/` and `control-plane/.claude/agents/`

Rename memory folders: `control-plane/memory/kowalski/` → `<interface-agent>/`, `control-plane/memory/walter/` → `<senior-advisor>/`.

### Block 3 — Domain selection (operator's own taxonomy)

The template ships with six example domain folders (`professional/`, `personal/`, `finance/`, `investments/`, `learning/`, `spiritual/`). **These are examples, not a required set.** Ask the operator to define their own active domains in their own vocabulary.

Open the interview by reading [`control-plane/agent-patterns/domain-entry-agent.md`](../../../control-plane/agent-patterns/domain-entry-agent.md) signals to the operator:

> *"A domain is a recurring area of work or life with its own vocabulary, stakeholders, and trade-offs — generating at least one task per week or one decision per month. What are yours? List them in your own words."*

Then for each domain the operator names, walk this micro-loop:

1. **Pick a slug** in `kebab-case` (operator chooses, e.g. `health`, `coaching`, `side-business`, `learning`).
2. **Want a first-reader agent for this domain?** Read out [`agent-patterns/domain-entry-agent.md`](../../../control-plane/agent-patterns/domain-entry-agent.md) signal: "yes if the domain has ≥ 1 task/week or 1 decision/month and you notice the interface agent simulating it inline; no if it's lighter than that".
   - **If yes:** ask the operator what to call the agent (default suggestion: `<slug>-advisor` or `<slug>-curator`, but the operator picks). Then copy `control-plane/templates/agents/domain-entry.template.md` to `.claude/agents/<chosen-name>.md` and fill the `<placeholder>` markers via Q&A (description, scope in/out, vocabulary, recurring decisions). Also create `control-plane/memory/<chosen-name>/state.md` from `templates/agent-state-template.md`.
   - **If no:** skip — interface agent handles the domain inline.
3. **Want an entity guardian for this domain?** Same logic via [`agent-patterns/entity-guardian.md`](../../../control-plane/agent-patterns/entity-guardian.md). Instantiate via `control-plane/templates/agents/entity-guardian.template.md` if yes.
4. **Create the folder** `<slug>/` at repo root (if it doesn't exist) with a `domain.md` describing scope, vocabulary, stakeholders.
5. **Register** every newly instantiated agent in `control-plane/registry/agents.md` and `control-plane/registry/domains.md`.

**For each of the six template-shipped folders the operator does NOT want** (`professional/`, `personal/`, `finance/`, `investments/`, `learning/`, `spiritual/`): `rm -rf <folder>` and remove its row from `control-plane/CLAUDE.md` § "Active domains" and `spoke-owners.yaml`.

**For each shipped agent the operator does NOT want** (e.g. `maestro` if no craft, `terra-guide` if no travel, `finance-advisor` if folded into a single domain): delete the agent spec, the memory folder, and the registry row.

**Do not assign names yourself.** Every domain agent and every entity guardian gets a name from the operator — even if the operator says "use the default", confirm the suggestion before writing. Names are sticky; one Q&A turn is the cheapest insurance against weeks of awkward re-reading.

**Do not pressure the operator** to keep any specific shipped domain or agent. The template ships one operator's example; the patterns are the replicable knowledge.

### Block 4 — Technical wiring

This block is mostly automatic; the skill performs the actions and confirms with the operator.

1. **Verify hook scripts are executable.** `chmod +x` everything under `.claude/hooks/` and `control-plane/scripts/`.
2. **Test SessionStart compilers.** Run `python3 control-plane/scripts/compile-skill-routing.py` and `compile-concept-routing.py` once to populate `memory/skills/` and `memory/concepts/`. If either fails, surface the error and ask the operator how to proceed (skip silently or fix Python env first).
3. **Validate harness.** Run `bash control-plane/scripts/validate-harness.sh`. Report any errors or warnings to the operator; offer to fix or defer.
4. **Write the first decision-log entry** ("D-001 — os-bootstrap complete") with date and operator name.
5. **Remove the sentinel.** `rm .bootstrap-pending`.
6. **Confirm done.** One-line summary to the operator: who was registered, which domains are active, which scripts are running.

---

## Failure handling

If the operator interrupts during Block 1 or Block 2 and asks to defer:
- Save partial answers to the relevant memory files (don't lose anything).
- Leave `.bootstrap-pending` in place so the next session knows bootstrap is incomplete.
- Tell the operator: "Bootstrap paused. Re-invoke `os-bootstrap` at any session to continue from where we stopped."

If a Python script (compiler) fails:
- Don't block bootstrap on it. The SessionStart hooks gracefully degrade when compilers are missing (they emit empty additionalContext).
- Note the failure in `control-plane/memory/auto/MEMORY.md` as a project memory ("Python compilers not functional on first bootstrap — investigate").

If the operator wants to skip bootstrap and use the template in placeholder mode:
- Confirm they understand: hooks and routing will silent-pass on unresolved `<placeholder>` strings, so half the harness is inert.
- Delete `.bootstrap-pending` manually.
- Note the choice in MEMORY.md so future sessions know placeholder-mode was intentional.

---

## What to NOT do

- Do **not** ask the operator to write code or edit config files manually. The skill performs all writes.
- Do **not** ask 50 questions at once. Block 1 is 4 questions max; Block 2 is 3; Block 3 is 6; Block 4 is automatic with confirmation.
- Do **not** preserve the agentic-os example agent names if the operator chose different ones. Stale references break the enforcement layer's owner-agent lookup.
- Do **not** push to remote during bootstrap. The first push is the operator's call after they review what was generated.
