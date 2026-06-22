# Best practices

Universal operating rules that ship as canonical with the template. These are not memories (which the OS learns over time from feedback) — they are starting-point conventions distilled from production use of the source OS.

Each file is one rule. The interface agent reads this directory when:
- Writing code or documentation (engineering and communication rules apply)
- Producing output for an external stakeholder (communication and review rules apply)
- Committing or merging (git discipline rules apply)
- Building a new agent or skill (architecture rules apply)

After bootstrap, the operator can add, remove, or override any of these files. The principle they enforce (the "why") is documented in each — so an override is an informed choice, not an accident.

## Index

### Communication
- [conclusion-first.md](conclusion-first.md) — Lead every output with the conclusion, not the setup.
- [no-emoji-no-emdash.md](no-emoji-no-emdash.md) — External / formal output: no emoji, no em-dash, no second-person pronouns by default.

### Engineering
- [git-stage-surgical.md](git-stage-surgical.md) — Never bulk-add (`git add .`, `-A`, `-u`, `<dir>/`); stage file by file.
- [no-direct-merge.md](no-direct-merge.md) — Merges to main on shared / public repos require pressure-test + explicit approval.
- [atomic-commits.md](atomic-commits.md) — One concern per commit; commit message answers "why", not "what".
- [code-ownership-respect.md](code-ownership-respect.md) — Do not edit another developer's open PR directly; surface the blocker to the author.

### Architecture
- [agentic-by-default.md](agentic-by-default.md) — Sub-agents are the default for non-trivial work; simulated reasoning is the exception.
- [progressive-disclosure.md](progressive-disclosure.md) — Agent spec has two tiers — fast path (state.md) and deep context (full spec).
- [canon-self-audit-pair.md](canon-self-audit-pair.md) — Every absorbed canon ships with a living self-audit; the pair is the unit.

### Output discipline
- [no-half-finished.md](no-half-finished.md) — Don't ship half-finished implementations; explicit defer is better than silent partial.
- [comments-explain-why.md](comments-explain-why.md) — Comments document the non-obvious "why"; code shows the "what".
