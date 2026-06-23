# Contributing to agentic-os

Thanks for considering a contribution. This repo is a template — most "contributions" are forks where you adapt the template to your own operating discipline. But upstream improvements are welcome if they generalize.

## What belongs upstream

- **Bug fixes** in hooks, scripts, validators, or compilers.
- **New agent patterns** that are genuinely canonical (i.e. you've used the pattern in 2+ different domains and the abstraction holds).
- **New best practices** that are universal (not "I prefer X" — but "X compounds over time and not doing X has a documented cost").
- **Better setup automation** — anything that reduces the gap between `git clone` and a running, bootstrapped system.
- **Documentation clarifications** for any place a fresh reader gets stuck.

## What does NOT belong upstream

- Your own operator-specific agents, domain folders, or memories. Those go in your fork, not in this template.
- Domain-specific skills (e.g. "anomaly-sweep for Brazilian bank statements") unless they are genuinely generic.
- New canonical principles based on N=1 evidence. The template prefers underclaiming.

## How to propose a change

1. Open an issue first if the change is non-trivial. State the problem, your proposed fix, and which surfaces of the [Done Contract](DONE_CONTRACT.md) it affects.
2. Fork the repo, create a branch with a descriptive name (`feat/`, `fix/`, `docs/`).
3. Make atomic commits — one concern per commit. Each commit message answers "why", not "what" (see [`best-practices/atomic-commits.md`](control-plane/best-practices/atomic-commits.md)).
4. Stage surgically — `git add <path>`, not `git add .` (see [`best-practices/git-stage-surgical.md`](control-plane/best-practices/git-stage-surgical.md)).
5. Run the validation suite before pushing:
   ```bash
   bash control-plane/scripts/validate-harness.sh
   bash control-plane/scripts/tests/test-block-pr-merge.sh
   python3 control-plane/scripts/compile-skill-routing.py
   python3 control-plane/scripts/compile-concept-routing.py
   ```
6. Push your branch and open a PR against `main`.

## PR expectations

- **Title** — short, imperative. Under 70 characters.
- **Description** — what changed, why, and what it affects. Reference any issue.
- **Test plan** — the bullet list reviewers will check. Be specific.
- **Scope** — one concern per PR. If your change touches multiple unrelated surfaces, split.

The maintainer (Daniel) reviews via the `pr-review` skill: APPROVE / REFINE & RETURN / REJECT verdict with concrete reasoning. The senior-advisor pressure-test fires automatically on cross-cutting or governance-class PRs (anything touching `control-plane/`, `.claude/`, root `CLAUDE.md`, hooks, or rules).

## Hooks and the no-direct-merge rule

This repo has external visibility, so all merges to main require a PR. The `block-pr-merge.sh` hook enforces this at the tool level. Override env var `HARNESS_MERGE_OVERRIDE=1` exists for vacation or emergency, not for routine work. Every override use leaves a fire in `pre-tool-fires.jsonl` for Darwin to surface in the next governance pass.

## Weekly evolution ritual

A weekly governance pass keeps the template from drifting. See [`EVOLUTION.md`](EVOLUTION.md) for the cadence, the Darwin deep-mode protocol, and how rejected proposals get reopening criteria.

## Code of Conduct

Be direct, specific, and respectful. Surface issues concretely; assume good intent in others. If a contribution is rejected, the maintainer states why and what would make it acceptable. If a maintainer rejects your work badly, raise it explicitly.

## Questions

Open a GitHub Discussion or an issue. There is no Slack or Discord by design — async, durable text leaves an audit trail that ephemeral channels don't.
