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

### Block 3 — Domain selection

Ask the operator which of the six template domains to keep:

- `professional/` (default: yes)
- `personal/`
- `finance/`
- `investments/`
- `learning/`
- `spiritual/`

For each kept domain: leave the folder. For each removed domain: `rm -rf` the folder and remove its row from `control-plane/CLAUDE.md` § "Active domains" table and from `spoke-owners.yaml`.

Ask each kept domain whether the operator wants the default agent (e.g., `professional-chief-of-staff`, `finance-advisor`) or a renamed one. Apply the rename if asked.

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
