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
| D-001 | <fill after first bootstrap> | meta | OS bootstrap complete — operator interviewed, identity/voice/agents resolved | yes | this file |
