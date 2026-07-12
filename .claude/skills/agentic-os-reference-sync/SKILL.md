---
name: agentic-os-reference-sync
description: Orchestrates safe updates to the public agentic-os template from a private reference implementation. Use when syncing architecture, runtime contracts, README/Roadmap/Changelog, skills, agent patterns, hooks, or governance practices from a lived private OS into the sanitized public repo without leaking personal, client, or path-specific context. Triggers — "sync agentic-os from reference"; "update agentic-os based on the reference implementation"; "public template sync"; "sanitize reference changes for agentic-os"; "release agentic-os from reference"; "/agentic-os-reference-sync".
---

# Skill: agentic-os-reference-sync

## Mission

Convert advances from a private reference OS into a public, reusable `agentic-os` update. Preserve the architectural pattern, remove private implementation detail, and leave the public repo coherent across docs, skills, validation, and release notes.

## Preconditions

- You have read the public repo's root orientation and current `README.md`, `ARCHITECTURE.md`, `CHANGELOG.md`, and `ROADMAP.md`.
- You know the private reference repo path or have been given a summarized delta.
- The public repo is on a branch, not direct `main`, unless the principal explicitly authorizes a direct release.
- If the sync touches governance files, run a senior-advisor pressure-test before finalizing the recommendation.

## Workflow

### 1. Establish Current State

In the public repo:

```bash
git status --short --branch
git rev-list --left-right --count HEAD...origin/main
git log --oneline -8
```

Flag untracked archives, local commits ahead of origin, and dirty files before editing. Preserve unrelated work.

### 2. Inventory The Reference Delta

Read only the bounded surfaces needed for the sync:

- Recent commits or release notes in the private reference.
- Runtime contracts (`AGENTS.md`, `CLAUDE.md`, hook docs) when the delta concerns execution behavior.
- Skills and agent patterns when the delta concerns reusable workflow.
- Observability, telemetry, decision-log, and context-budget docs when the delta concerns governance.

Do not copy private memory, client domains, personal identity, absolute paths, transcripts, or generated bundles.

### 3. Classify Each Candidate

Use this decision table:

| Candidate | Public action |
|---|---|
| Generic architecture principle | Add to `ARCHITECTURE.md`, `control-plane/best-practices/`, or agent-pattern docs |
| Reusable workflow | Add/update `.claude/skills/<skill>/SKILL.md` |
| Runtime-specific behavior | Add to `CLAUDE.md`, `AGENTS.md`, or `control-plane/AGENTS.md` with runtime caveat |
| Validation or hook behavior | Update script/config only if it can run in a fresh fork without private dependencies |
| Private identity/client/path detail | Exclude; mention only as "reference implementation" if needed |
| Generated artifact | Rebuild from source or leave unchanged with rationale |

### 4. Apply Sanitization

Before writing public docs, read `references/sanitization-checklist.md`. The minimum bar:

- Replace names, clients, employers, absolute paths, account IDs, and private repo names with generic roles.
- Convert "Kowalski does X" into "the reference implementation proved pattern X."
- Keep hooks and scripts dependency-light; no private CLIs, local usernames, or one-off scheduler paths.
- Distinguish implemented public behavior from reference-only behavior.
- Avoid claiming parity across runtimes unless validated in that runtime.

### 5. Update Public Surfaces Together

For a material sync, keep these files coherent:

- `README.md` — reader-facing pitch, quickstart, counts, status.
- `ARCHITECTURE.md` — canonical architecture and design principles.
- `CHANGELOG.md` — release entry with user-facing rationale.
- `ROADMAP.md` — latest version and next bets.
- `control-plane/CLAUDE.md` / `AGENTS.md` — runtime contracts, only when runtime behavior changes.
- `.claude/skills/` — orchestrating skills for repeated workflow.
- `control-plane/best-practices/README.md` — index updates for new practices.

If only one surface changes, document why the others do not need updates.

### 6. Validate

Run the public validation suite:

```bash
bash scripts/validate-all.sh
```

If a new or edited skill was added, also run:

```bash
python3 /path/to/skill-creator/scripts/quick_validate.py .claude/skills/<skill-name>
```

If validation fails, fix before declaring the sync ready.

### 7. Release Staging

Prepare the branch for review:

```bash
git status --short
git diff --stat
git diff --check
```

Do not push directly to `main` for a public repo unless the no-direct-merge ritual has been explicitly satisfied. Prefer a PR with:

- What advanced in the reference implementation.
- What was deliberately excluded.
- Validation results.
- Any runtime caveats.

## Output Format

Return:

```markdown
## agentic-os reference sync

**Implemented:** <files / surfaces>
**Sanitized out:** <private/reference-only items excluded>
**Validation:** <commands + pass/fail>
**Release posture:** <branch, PR status, merge caveat>
**Open issues:** <only blockers or explicit follow-ups>
```

## Anti-Patterns

- Copying private memory or client-specific agents into the public template.
- Updating `ARCHITECTURE.md` without aligning README status and changelog.
- Claiming a runtime feature is shipped when only orientation docs were added.
- Bumping release docs while validation is failing.
- Direct-pushing to `main` on the public repo without the no-direct-merge ritual.
