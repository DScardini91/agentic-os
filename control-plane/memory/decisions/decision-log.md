# Decision Log

_Every senior-advisor-approved strategic decision lands here. Decision-log closes the governance loop: Darwin reads past decisions to detect drift between what was decided and what was executed._

_Entries are append-only. To revise a prior decision, write a new entry that explicitly references and supersedes the earlier one._

## Format

| ID    | Date       | Domain | Decision | Implemented? | Linked artifact |
|-------|------------|--------|----------|--------------|-----------------|
| D-001 | YYYY-MM-DD | …      | …        | yes/partial/no | path or URL    |

## Anti-anchor rule

When reviewing entries for relevance or status, **re-derive status from current code and state**, not from the implementation column above. The column is a snapshot at write time and may have drifted.

## Trailing review

Run `bash control-plane/scripts/decision-log-trailing.sh` to extract entries aged 7-30 days for a still-correct / drifted / wrong audit. Sampling beats advisor-driven re-reading because it avoids "advisor auditing advisor" circular bias.

---

| ID | Date | Domain | Decision | Implemented? | Linked artifact |
|----|------|--------|----------|--------------|-----------------|
| D-000 | 2026-06-22 | meta | Template v1.0 launched with maximalist port from source OS (harness machinery + 8 agent patterns + 11 best practices + 13 skills + Darwin agent + os-bootstrap interview + Done Contract) | yes | [PR #1](https://github.com/DScardini91/agentic-os/pull/1), [DONE_CONTRACT.md](../../../DONE_CONTRACT.md) |
| D-001 | 2026-06-22 | meta | Direct merge of PR #1 to main authorized: scope is the inaugural release; senior-advisor pressure-test completed (two rounds, approved-with-conditions then approved-for-push); operator explicit approval given; no second-pair reviewer exists (solo-public repo). HARNESS_MERGE_OVERRIDE invoked as the documented escape valve for this exact case. | yes | this file |
| D-002 | 2026-06-23 | meta | Direct merge of PR #3 (v1.1.0) to main authorized. Walter pressure-test completed specifically for this PR (approved-with-conditions). Two load-bearing conditions evaluated: (1) skill↔script contract drift risk — deferred as post-merge open item ("dry-run os-bootstrap end-to-end in throwaway fork, 10 min"); (2) migration note for mid-bootstrap v1.0 forks — fixed in CHANGELOG before merge. Three nitpicks (chmod idempotence, PNG size, README first-paint) dropped as non-load-bearing. Override env vars deferred deliberately: minimalist contract first, complexity on demand. HARNESS_MERGE_OVERRIDE invoked under operator explicit approval. | yes | PR #3, Walter agentId aa6cc0c8fd06f038e |
| D-004 | 2026-06-27 | meta | Bootstrap interview methodology refined: Passo 1 expanded to show full agent ecosystem (Kowalski + Walter + Darwin + domain specialists + entity guardians + quality gates); Passo 5.5 added explaining three-layer memory architecture (episódica/procedural/longo-prazo) with manual consolidate-memory control. Identity clarified: mechanistic-first (not soft/skill-heavy like Maestro), operator agency explicit, no false automation expectations. Walter pressure-test completed and resolved three issues: (1) removed emoji softening from architecture explanation, (2) clarified "você invoca a skill consolidate-memory", (3) added "Você é responsável por quando isso acontece". Ready for trial bootstrap run. | yes | feat commit, this file |
| D-006 | 2026-06-27 | meta | Bootstrap Passo 1 genericized: agent names changed from hardcoded (Kowalski/Walter/Darwin) to operator-defined (Interface Agent/Senior Advisor/System Observer). Added "Nota sobre nomes" section explaining that names reflect operational accountability, not cosmetics; examples given (Jarvis, Kowalski, Walter, Darwin) demonstrate meaningful naming patterns. Maintains full replicability and operator agency. Walter pressure-test approved (2026-06-27); ready for team distribution. | yes | SKILL.md (Passo 1, lines 34–78) |
| D-007 | 2026-06-27 | meta | Version bump to v1.2.0: Passo 1 genericization now production-ready. Bootstrap methodology fully operator-centric (agent names defined by operator, meaningful examples guide naming without prescription). Supports full replicability across teams. Ready for distribution. All governance checkpoints passed (D-006 Walter approval + D-004 methodology). | yes | agentic-os-v1.2.0.zip |
| D-005 | _(fill after first bootstrap)_ | meta | OS bootstrap complete — operator interviewed, identity/voice/agents resolved | _pending_ | this file |
