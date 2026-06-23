---
title: Harness Engineering — Self-audit (worked example)
canon: _example_harness-engineering-canon.md
ingested: 2026-06-22
last_scored: 2026-06-22
status: example_for_template
---

# Harness Engineering — Self-audit

> Worked example of the self-audit that ships paired with a canon. Demonstrates: per-principle scoring, gap identification, and the `Re-check: YYYY-MM-DD` field that `canon-recheck-due.sh` scans for.

Pair lives at: [`_example_harness-engineering-canon.md`](_example_harness-engineering-canon.md).

## Scoring methodology

Each principle from the canon is scored against the **current OS state**, not against the prior audit. The anti-anchor rule: re-derive each finding from canon and current state. Previous audit is reference, not premise.

Scale:
- **✅ Aligned** — observable in current code/docs, working as canon prescribes.
- **🟡 Partial** — present but with documented gaps or transition state.
- **⏳ Pending** — not yet implemented, with a re-check date.
- **❌ Misaligned** — implemented in a way that contradicts the canon; needs surfacing as a Darwin proposal.

## Score sheet

### P1 — Determinism > politeness
**Status:** ✅ Aligned (as of 2026-06-22)
- `.claude/hooks/block-pr-merge.sh` returns `permissionDecision: deny` on `git push origin main` and `gh pr merge` variants. 15/15 fixture tests pass.
- `block-protected-repo-writes.sh` and `enforce-hub.sh` ship in reminder mode by default; transition to deny mode requires populating `protected-repos.yaml` + `spoke-owners.yaml` post-bootstrap.
- **Re-check: 2026-09-22** — after 3 months of operation, verify hooks are still firing on real violations vs being routinely overridden via the `HARNESS_*_OVERRIDE` env vars.

### P2 — Progressive disclosure
**Status:** ✅ Aligned
- Every agent has a state.md (the fast path) separate from `.claude/agents/<agent>.md` (the deep context). `validate-harness.sh` checks state.md coverage.
- Agents shipped: 10/10 with frontmatter, 10/10 with state.md or read-only flag.
- **Re-check: 2026-12-22** — verify no agent spec has accumulated > 200 lines (a smell that fast/deep tiers conflated).

### P3 — Two-rhythm governance
**Status:** 🟡 Partial
- Light mode (`darwin-accumulate.sh` Stop hook) shipped and wired. Writes to `darwin-accumulator.jsonl`.
- Housekeeping mode (`darwin-housekeeping` skill) shipped and uses the fixed checklist.
- Deep mode requires manual invocation; the 7-day frequency lock is in the agent spec but not enforced by a script.
- **Gap:** anti-anchor rule on canon re-check is a prompt-level guardrail, not deterministic. `canon-recheck-due.sh` lists due items but does not enforce reading the canon vs the prior audit.
- **Re-check: 2026-08-22** — after first 2 weekly governance passes, evaluate whether the prompt-level guardrail held or whether deterministic enforcement is needed.

### P4 — Canon + self-audit pairing
**Status:** 🟡 Partial (this very file demonstrates the pattern but is the only example shipped)
- `learning/canon/` directory exists with this canon + self-audit pair as the worked example.
- `canon-recheck-due.sh` scans for `Re-check:` lines in `*-self-audit.md` files and flags due items in housekeeping mode.
- **Gap:** only one canon shipped. Forks should add real canons (engineering standards, frameworks, certifications) and their self-audits.
- **Re-check: 2026-09-22** — after 3 months, verify forks are creating real canon+audit pairs.

### P5 — Single interface, internal pressure-test
**Status:** ✅ Aligned
- `kowalski` is the single interface agent. `walter` is the internal senior advisor with `tools: Read` (no edit/write access — cannot ship output directly).
- The pattern doc ([`agent-patterns/senior-advisor.md`](../../control-plane/agent-patterns/senior-advisor.md)) explicitly forbids the senior advisor from delivering output.
- **Re-check: 2026-12-22** — verify the senior advisor's voice has not leaked to principal-facing output by sampling 10 recent responses.

### P6 — Deliberate accretion
**Status:** ✅ Aligned
- Documented in [`best-practices/canon-self-audit-pair.md`](../../control-plane/best-practices/canon-self-audit-pair.md) and in the OS evolution principle in root CLAUDE.md.
- Darwin's housekeeping mode includes agent coverage audit — flags agents with no state.md or no invocations.
- **Gap:** the "30 days without invocation → re-evaluate" rule is documented but not yet automated. Darwin's deep mode lists candidate components but does not auto-archive.
- **Re-check: 2026-10-22** — after 4 months of operation, decide whether automation is needed or manual review is sufficient.

## Open questions for the principal

- (None as of 2026-06-22 — initial audit is exploratory and reflects template state at first ingestion.)

## Anti-anchor disclaimer

This audit was scored on 2026-06-22 against the canon as of that date. If either the canon or the OS state changes materially, this audit is invalidated and must be re-scored from scratch — not edited incrementally from this version. The anti-anchor rule prevents the loop "audit re-derives from audit" failure mode.
