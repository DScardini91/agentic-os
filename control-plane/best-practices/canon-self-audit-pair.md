# Canon + self-audit as paired artifacts

**Rule:** every body of external knowledge absorbed into the OS (engineering standard, framework, methodology, certification material) is stored as **two** artifacts:
1. The **canon** — the source content distilled into the OS's vocabulary, treated as stable until the source revises.
2. A **self-audit** — a living document scoring the OS's current state against the canon, listing gaps with explicit `Re-check: YYYY-MM-DD` dates.

The pair is the unit. Neither half is load-bearing alone.

## Why

- **Canon without self-audit** decays into shelfware. Someone absorbed it once, the file exists, no one ever revisits whether the OS actually follows it. Adoption is theatrical, not real.
- **Self-audit without canon** drifts into vibes. Without an external anchor, the audit re-derives from yesterday's audit, which re-derived from the day before, until "the OS follows these principles" means "the OS follows the OS".
- **The pair** keeps both halves honest: the audit grounds the canon in current state; the canon grounds the audit in the source.

## How to apply

- When absorbing a canon, create both files in `learning/canon/`:
  - `<topic>-canon.md` — the distillation. Frontmatter includes source, absorption date, source revision tracked.
  - `<topic>-self-audit.md` — items the canon prescribes vs current OS state, each item with `Re-check: YYYY-MM-DD`.
- The re-check date is enforced by `canon-recheck-due.sh`, which Darwin housekeeping runs and flags due items.
- **Anti-anchor rule on re-check:** when re-checking, read the **canon** (not the prior audit) and re-derive status from scratch. The previous audit is reference, not premise.

## Status of this principle in the template

This is an **emerging practice**, not a foundational rule. Observed twice (mid-2026) on engineering-flavoured canons; not yet tested on domain-flavoured canons. Documented here so forks can opt in and contribute back evidence — not prescribed as mandatory.
