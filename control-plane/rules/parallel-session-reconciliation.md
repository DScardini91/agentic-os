# Parallel Session Reconciliation — Ritual

_Canonical merge ritual for repos where parallel Claude sessions share a working tree without git worktrees._

## Context

When parallel sessions edit the same working tree, they can produce overlapping work on common files. When local diverges from `origin/main` in files where parallel PRs landed, there is tension between **preserving local work** and **aligning with production**.

**Trigger conditions:**
- Local has diverged from origin/main (`git status -sb` shows `[ahead N, behind M]`)
- Files overlap with parallel PRs (same paths on both branches)

## Four principles (apply in this order)

### Principle 1 — UNION for accumulative state

For files whose content is a **growing list** (decision-log, state.md open proposals, daily logs, follow-through tracking), the merge result is the **union** of both versions. Neither side loses entries.

**Concrete application:**
- `decision-log.md` — entries from both branches coexist by date.
- agent `state.md` "Open proposals" — sections from both branches preserved.
- `MEMORY.md` index — bullets from both branches preserved.

### Principle 2 — LAYERING for diagnostics

For files whose content is **a hypothesis or diagnosis about an object** (open hypotheses, root-cause analyses, post-mortems), the result is **temporal layering**: the prior hypothesis is preserved as history, with the newer version appended as an update.

**Canonical format:**
```markdown
- **<Bug> — HYPOTHESIS (<date>) → FALSIFIED + RESOLVED (<date>):**
  - **Hypothesis (<date>):** <original text>
  - **Empirical falsification (<date>):** <data that falsified>
  - **Fix applied:** <concrete action>
  - **Structural lesson:** <auditable generalization>
```

**Explicit applicability criterion:** layering is valid only when both versions **can coexist in the historical record** — one as "prior state", the other as "falsified or refined state". If both claim to be the current state, apply Principle 4.

### Principle 3 — Decision-log entry as the auditable artifact

When the merge involves **direct cherry-pick to main on a governance fence** (and the senior-advisor ritual has been completed in prior sessions), the entry in `decision-log.md` is the auditable artifact that replaces the PR diff.

**Required entry content:**
- Reason for the direct cherry-pick (fence touched + senior-advisor content gate satisfied + no second-pair review value).
- Agent IDs / dates of the relevant senior-advisor checkpoints.
- Rationale for any non-trivial conflict resolution.

**Why:** Darwin reads decision-log in the weekly reconciliation pass — that is the audit path, not the PR diff. For a single-operator repo, the PR becomes a self-merge without second-pair review.

### Principle 4 — GENUINE CONTRADICTION → mandatory escalation to the principal

When UNION or LAYERING would produce **mutually exclusive state** (branches assert facts that are factually incompatible about the same object at the same moment), **do not resolve locally**. Escalate via a decision-log entry containing:

- Both conflicting statements (verbatim).
- Why this is not layering (both claim to be the current state, not "prior + falsified").
- A concrete question for the principal to decide.

**Why:** layering applied to a genuine contradiction masks inconsistency under the appearance of "I preserved everything" — the exact anti-pattern that defense-in-depth creates when a guard absorbs the wrong call without a visible signal.

**Litmus test:** if the two versions can coexist as "before/after" or "branch A vs branch B about different objects" → layering. If both assert "this is the correct state right now about this object" → contradiction. Escalate.

## Order of application during merge

1. Classify each conflicting file: accumulative list → P1 · diagnosis → P2 · governance fence → P3 also applies.
2. Before applying P1/P2, check P4 (genuine contradiction). If so, stop and escalate.
3. Resolve conflicts via P1 or P2.
4. If a governance fence was touched, write a decision-log entry (P3) in the same resolution.

## Non-applicability

This rule does **not** apply to:
- Multi-operator repos — those follow the no-direct-merge rule (PR required).
- Purely logical files (code, configs with unique semantics) — use traditional merge or explicit rebase.
- Dirty working tree before the conflict — resolve/stash first, then apply this ritual.
