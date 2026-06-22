---
name: branch-cleanup
description: Sweep orphan remote branches (no open PR), group by age and author, identify safe deletes, and propose a batch delete via gh CLI. Reduces repo noise without losing history — commits stay in reflog and main.
triggers:
  - "clean up branches"
  - "branch cleanup"
  - "delete old branches"
  - "which branches can I delete?"
---

# Skill: branch-cleanup

## When to use

The repo has accumulated remote branches without open PRs — leftovers from squash-merged PRs, abandoned work, or old sessions.

NOT for:
- Deleting a local branch — use `git branch -D` directly.
- Deleting a branch with an open PR — close the PR first.
- Force-deleting a branch with unique unmerged commits — escalate to the principal (risk of loss).

---

## Inputs

- **`repo_path`** (optional) — defaults to cwd.
- **`age_days`** (optional) — last-commit age threshold, default 14.
- **`dry_run`** (optional) — defaults to `true`. Lists without deleting. `false` deletes after confirmation.

---

## Sequence

### Step 1 — Collect remote branches
```bash
cd <repo_path>
git fetch --prune origin
git branch -r | grep -v HEAD | grep -vE 'origin/(main|master)$'
```

### Step 2 — Filter out branches with open PRs
For each remote branch, check open PR status:
```bash
gh pr list --head <branch_name> --state open --json number --jq '.[].number'
```
If a number is returned → has an open PR → **do not include** in the cleanup list.

### Step 3 — Collect metadata per branch
```bash
git log <branch> -1 --pretty=format:'%cs|%an|%H'
git merge-base --is-ancestor <branch_sha> origin/main
# exit 0 = merged ancestor, exit 1 = unique commits
```

### Step 4 — Categorize

| Category | Criterion | Default action |
|---|---|---|
| **🟢 Safe delete** | Merged into main + age ≥ `age_days` | Propose delete |
| **🟡 Stale but unique** | Not merged + age ≥ 30 days | List for principal to decide |
| **🔴 Recent** | Age < `age_days` | Skip (likely active work) |

### Step 5 — Structured output

```
## Branch cleanup — repo <name>

🟢 Safe to delete (merged + stale ≥ {age_days}d): N
  - <branch>  · {age}d  · {author}  · merged

🟡 Unique commits, stale ≥ 30d: M
  - <branch>  · {age}d  · {author}  · {n} unique commits

🔴 Recent (skip): K

Total candidates: N+M
```

### Step 6 — Confirm + execute

If `dry_run=true`, stop after Step 5. Hand off the table to the principal.
If `dry_run=false`, ask: *"Delete N safe branches? (yes/no)"*. On yes:
```bash
for branch in <safe_list>; do
  git push origin --delete "$branch"
done
```

Never auto-delete 🟡 (unique commits) — those require explicit principal approval per branch.

---

## Anti-patterns

- Deleting a branch with unique commits because "it's old" — those commits exist only on that branch; deletion loses them. Always require explicit per-branch approval.
- Bulk-delete without showing the table first — the principal needs to scan the list, not trust a count.
- Including main/master in the candidate list — defensive grep filter required.

---

## Why it matters

`git branch -r` output bloats over time. A repo with 50+ stale branches makes `gh pr list` and IDE branch pickers noisy. Periodic cleanup keeps the working surface small without losing history (everything stays in the reflog and on main if merged).
