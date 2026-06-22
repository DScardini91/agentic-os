# No direct merges on shared or public repos

**Rule:** in repos with **multi-operator OR external visibility OR shared runtime**, merges to main require a Pull Request, senior-advisor pressure-test, and explicit principal approval. The interface agent must not run `git push origin main`, `git push <remote> main`, or `gh pr merge` directly.

Repos that are solo + private + not part of any production runtime are exempt — those can self-merge.

## Why

A direct merge to main on a shared or public repo:
- Bypasses peer review (or self-review with a 24-hour cool-off, for solo-but-public).
- Skips the senior-advisor pressure-test that would catch over-rotation or unsound commits.
- Leaves no audit trail beyond the commit itself — the PR description, reviewers, and conversation are the durable record.

For public repos with potential forks, this is also a credibility signal: external observers can see whether the project is operated with discipline.

## How to apply

- The ritual is: open PR → senior advisor pressure-test → principal approval → merge.
- The `block-pr-merge.sh` hook in `.claude/hooks/` enforces this at the tool level — it denies `git push <remote> main` and `gh pr merge` commands.
- Override env var for vacation / emergency: `HARNESS_MERGE_OVERRIDE=1`. Use only when justified; the override leaves a fire in `pre-tool-fires.jsonl` for Darwin to surface in the next governance pass.

## When the principle bends

- Self-merge of a small documentation fix on a public repo with no PR-eligible reviewer: acceptable; still record in the decision log if it touched governance files.
- Cherry-pick to main on a governance-fence file (control-plane/, .claude/, CLAUDE.md, hook scripts) when the senior advisor already pressure-tested in a prior session: the decision-log entry replaces the PR diff as the audit trail (`parallel-session-reconciliation.md` Principle 3).
