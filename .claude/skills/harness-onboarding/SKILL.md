---
name: harness-onboarding
description: Bootstrap pack for a new developer joining the project — reads context-packs, specs, recent decision-log entries, and decisions-locked, then produces a role-tailored onboarding pack (executive summary + sequenced reading + first-task suggestions). Reduces time-to-first-PR.
triggers:
  - "onboarding pack for"
  - "brief the new developer"
  - "new dev joining — prepare context"
  - "produce onboarding for"
---

# Skill: harness-onboarding

## When to use

A new developer is joining the project and needs to absorb context before contributing. Without a structured pack, week 1 is spent asking the obvious instead of producing a PR.

NOT for:
- Re-briefing an existing dev on a new scope → use `pr-review` or direct conversation.
- Onboarding a non-technical stakeholder → produce a different artifact (slide deck, not technical pack).

---

## Inputs

- **`dev_name`** (required) — the developer's name.
- **`role`** (required) — expected role (owner of module X, contributor to layer Y, etc.).
- **`project`** (optional) — the project subfolder; defaults to repo root.
- **`depth`** (optional) — `"essential"` (~1h reading) or `"deep"` (~1 day reading).

---

## Sequence

### Step 1 — Map harness inputs

For a project with a `docs/harness/` structure, locate and read:
- `docs/harness/README.md` — entry point
- `docs/harness/context-packs/project-state.md` — current state
- `docs/harness/context-packs/decisions-locked.md` — locked premises
- `docs/harness/context-packs/stakeholders.md` — who is who
- `docs/harness/context-packs/<domain>.md` — business vocabulary
- `docs/harness/decision-log.md` — recent decisions (last 20)
- `docs/harness/specs/<relevant-to-role>.md` — spec of the module / feature the dev will own

For projects without a formal harness, read the equivalents: README, ARCHITECTURE.md, recent commits, OPEN_QUESTIONS.md, any `decisions/` folder.

### Step 2 — Filter by role

Do not dump everything. For each role, prioritize:

**Module owner:**
- The canonical spec for the module the dev will own.
- Operational docs in `src/<module>/docs/*`.
- Decisions-locked entries that fix the design.
- Adjacent specs that the module consumes or produces.

**Pipeline / DS owner:**
- Data layer READMEs (raw → preprocessed → domain → features).
- Decisions-locked about data conventions.
- Spec-free convention docs (pipeline is convention, not module).

**Harness / governance owner:**
- Full `docs/harness/README.md`.
- All `workflows/` and `signals/` docs.
- The entire decision-log (to learn the entry pattern).

**Other role:** ask the principal to map → do not improvise.

### Step 3 — Identify current blockers

Read `decisions-locked.md` and look for entries with status `pending` or known blockers. The output: a list of what the new dev **does not need to resolve** (already in flight) and what is **waiting externally**.

### Step 4 — Map first tasks

By role, suggest 2-3 realistic first PRs:

**Module owner:**
1. Read docs, open a PR adding `OPEN_QUESTIONS.md` to `src/<module>/` capturing initial questions.
2. Set up local environment and run the existing pipeline end-to-end with a dummy snapshot.
3. First skeleton of `build()` calling the correct inputs (even without real logic).

**Harness / governance owner:**
1. Read decision-log + decisions-locked → entry "post-reading review" in the decision-log (verifies comprehension).
2. Audit context-packs vs decision-log for drift.
3. Propose one harness improvement via PR.

### Step 5 — Output: onboarding pack

```markdown
# Onboarding pack — <dev_name>

**Role:** <role>
**Project:** <project>
**Estimated reading:** ~Xh (depth=<>)

## Sequenced reading
1. <file> — <why this first>
2. <file> — <why next>
...

## Locked premises that affect <dev_name>
- D-NNN: <decision> — relevance to role
- D-NNN: ...

## Known blockers (not <dev_name>'s problem)
- B-NN: <blocker> — owner / waiting on

## First three PRs
1. <PR scope> — <expected outcome>
2. ...
3. ...

## Who to ask what
- <person> — <area of authority>

## Anti-patterns to avoid (project-specific)
- <pattern> — why it bites
```

### Step 6 — Hand off

Save as `docs/harness/onboarding-<dev_name>-YYYY-MM-DD.md` and share the link. Offer a 30-min walkthrough as a follow-up if the dev wants it.

---

## Anti-patterns

- **Dumping the whole repo** — defeats the purpose. Filter aggressively by role.
- **Skipping the blockers section** — new devs accidentally re-solve already-resolved problems if they don't know the lock-in.
- **Vague first tasks** — "explore the codebase" is not a first task. Give 2-3 concrete PRs the dev can ship in week 1.
- **No "who to ask" section** — the dev hits a question, has no idea who owns the answer, posts in the wrong channel.
