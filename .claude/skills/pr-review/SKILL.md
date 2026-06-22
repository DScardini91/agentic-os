---
name: pr-review
description: Structured Pull Request review — collects diff + description, identifies owner / scope / risks, invokes the senior advisor when strategic weight is present, produces a verdict and a suggested PR comment. Atomic skill, reusable in any repo where the principal is a reviewer.
triggers:
  - "review PR #"
  - "review the PR"
  - "look at the PR"
  - "pulse of PR"
  - "evaluate this PR"
---

# Skill: pr-review

## When to use

Whenever a PR shows up that the principal needs to review — own repo or any repo where review is needed.

NOT for: mechanical merge (`gh pr merge`), full-repo analysis (escalate to a specific agent), reviewing a non-PR artifact (deck, doc → use `deck-review` or `artifact-reviewer`).

---

## Inputs

- **`pr_number`** (required) — PR number.
- **`repo`** (optional) — `owner/repo` if not in the PR's cwd; defaults to current repo.
- **`depth`** (optional) — `"quick"` (summary only), `"standard"` (default — analysis + senior advisor if applicable), `"deep"` (senior advisor always + architectural diff).

---

## Output structure

```
## PR #N — <title> (author: <login>)

**Scope:** diff +X / -Y across N files | branch `<head>` | mergeState: `<status>`

**Strengths:**
- ...

**Points to validate (non-blocking):**
- ...

**Material risk identified:**
- ... (or "none")

**Senior-advisor recommendation?** Yes/No — <one-line justification>

**Verdict:** APPROVE / REFINE & RETURN / REJECT — <one line>

**Suggested PR comment** (if REFINE):
> [text ready to paste into `gh pr comment`]
```

If `depth >= standard` and strategic weight is present → the senior advisor is invoked and its output is integrated.

---

## Sequence

### Step 1 — Collect PR data

```bash
gh pr view <pr_number> --json title,author,headRefName,mergeable,additions,deletions,changedFiles,body,baseRefName
gh pr diff <pr_number>
gh pr checks <pr_number>
```

### Step 2 — Read context

If the repo has a `decisions-locked.md`, `decision-log.md`, or `OPEN_QUESTIONS.md`, scan for entries that this PR touches. Cross-reference scope to known locked premises.

### Step 3 — Identify scope and risk class

| Class | Criterion | Default depth |
|---|---|---|
| Trivial | Doc-only, formatting, one-line | quick |
| Standard | Single module / spec scope, < 200 LOC | standard |
| Cross-cutting | Touches > 3 modules OR architectural decision OR spec amendment | deep |
| Governance | Touches `control-plane/`, `.claude/`, hooks, CLAUDE.md, rules/ | deep + senior advisor |

### Step 4 — Senior-advisor invocation

Invoke the senior advisor (Walter equivalent) when **any** of:
- Cross-cutting or governance class.
- Reviewer flags carry strategic weight or interpretation risk.
- The PR proposes a deviation from a locked decision.
- Author and reviewer disagree in the comments and the disagreement is not yet resolved.

Skip the senior advisor when:
- Trivial / doc-only changes with no policy implication.
- Mechanical refactor with full test coverage.
- Author has already addressed prior senior-advisor pressure-test in commits.

### Step 5 — Produce verdict

- **APPROVE** — no material risk, scope clear, tests adequate (if applicable). Comment optional.
- **REFINE & RETURN** — at least one material issue with a concrete remediation path. Suggested comment ready to paste.
- **REJECT** — fundamental scope or correctness problem. Recommend the author close the PR or restart with a different approach. Comment explains why.

### Step 6 — Hand off

Always end with a concrete next step:
- *"Suggested action: paste the comment above, then ping the author."*
- *"Auto-merge candidate — would you like me to merge after CI passes?"*
- *"Escalate to senior-advisor pressure-test (depth=deep)?"*

---

## Anti-patterns

- **Approving without reading the diff.** A summary is not a review.
- **Bypassing the senior advisor on governance-class PRs** — even if it feels routine.
- **Suggesting changes that exceed the PR's scope** — refactor proposals belong in a new PR, not in this comment.
- **Vague verdicts** — "looks fine" is not a verdict. APPROVE / REFINE / REJECT and one sentence of justification.

---

## Integration with the no-direct-merge rule

This skill never merges. Merging requires `gh pr merge`, which is blocked by `block-pr-merge.sh` for repos with shared / public visibility. The reviewer's job is to APPROVE or REFINE; the principal still holds the merge decision.
