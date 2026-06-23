# Git stage surgically — file by file

**Rule:** never use bulk-staging commands. Forbidden by default:
- `git add .`
- `git add -A`
- `git add -u`
- `git add <directory>/`

**Required:** stage explicitly, file by file, with `git add <path1> <path2> ...`. Verify with `git diff --staged --name-status` before committing.

## Why

When multiple Claude sessions or parallel tasks share a working tree without isolated git worktrees, bulk-add absorbs unrelated work into the wrong commit. This has happened — one well-documented case: a single commit that shipped a feature, plus an unrelated experimental change from another session, plus a personal note that should not have been in the work repo at all. Cleaning it up after the fact is expensive; preventing it is free.

Bulk-add also makes it easy to commit secrets (`.env`, credentials) or large binaries that should not be in the repo.

## How to apply

- Always run `git status` first to see what is dirty.
- Stage only what belongs to the current commit's intent: `git add path/to/file.py path/to/test.py`.
- Run `git diff --staged --name-status` and confirm the list matches the intent before `git commit`.
- If multiple unrelated changes are in the tree, make multiple commits (each surgically staged), not one big one.

## Override

There is no legitimate override for this rule in shared / parallel-session workflows. In a truly solo workflow with a single session and a clean tree, bulk-add is permissible but still discouraged — the muscle memory generalizes badly.
