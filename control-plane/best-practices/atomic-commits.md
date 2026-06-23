# Atomic commits — one concern per commit

**Rule:** each commit addresses one concern. Multiple concerns in one commit get split before pushing.

The commit message answers **why**, not **what** — the diff already shows the what.

## Why

- Atomic commits are revertable in isolation. A bug introduced in one commit is bisected and reverted without touching unrelated work.
- They are reviewable. A reviewer can hold one concept in their head; mixing concerns forces them to context-switch within a single diff.
- They are diff-clean. A merge or rebase touches the smallest possible surface.

The commit message answering "why" turns `git log` into a decision history, not a redundant restatement of the diff.

## How to apply

- Before committing, ask: "Does this change have exactly one purpose?" If no, split.
- If a refactor and a feature are both in the tree, commit the refactor first, then the feature on top.
- Commit messages: subject = one short imperative line (≤ 70 chars). Body = the why. Skip the body only for the most trivial changes (typo fix, formatting).

## Anti-patterns

- "Fix bug + add feature + cleanup" — three commits, not one.
- Commit message = restatement of diff: `add lines to config.py` → bad. Better: `enable feature X for cohort Y because regression in W is fixed`.
- Commits with no body when the change has any subtlety: the reader has to reverse-engineer the intent from the diff.

## Boy Scout exception

A PR may include opportunistic cleanup in the touched files (rename, dead code removal, comment removal). Those count as part of the main commit's concern if minor; if substantial, they get their own commit.
