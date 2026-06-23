# EVOLUTION.md — How this repo evolves

The template encodes one operator's working discipline at one point in time. It will be wrong about some things, incomplete about others, and outdated in places within months of any release. EVOLUTION.md documents how the repo stays sharp without bloating.

## The two-rhythm governance pattern

Two complementary cadences, each doing what the other cannot:

| Rhythm | Cadence | What it does | What it never does |
|---|---|---|---|
| **Watchdog** (light + housekeeping) | Continuous / daily | Per-session signal append, fixed daily checklist (TTL compaction, state drift, agent coverage, canon re-check). Detects FLAGs. | Deliberates. Generates structural proposals. Speaks to the principal unless ALERT fires. |
| **Reconciliation ritual** (deep mode) | Weekly or on-demand | Reads accumulated signal + decision-log + state files. Produces an OS Health Report with ≤ 5 prioritized proposals. | Runs continuously. Fires automatically. Skips the 7-day frequency lock. |

Mixing the rhythms produces noise (continuous deliberation) or blindness (deliberation without accumulated signal). See [`agent-patterns/os-analyst.md`](control-plane/agent-patterns/os-analyst.md) for the full canonical reference.

## Weekly sync ritual

Once a week, the operator invokes Darwin's deep mode:

```bash
# (after `os-bootstrap` has run and the system has accumulated ≥ 7 days of signal)
# In Claude Code:
"darwin, deep mode now"
```

Deep mode reads:
- `control-plane/memory/observability/darwin-accumulator.jsonl` — light-mode session metrics
- `control-plane/memory/observability/pre-tool-fires.jsonl` — hook fires (reminders + violations)
- `control-plane/memory/decisions/decision-log.md` — strategic decisions
- `control-plane/memory/darwin/state.md` — own past proposals + status
- `learning/canon/*-self-audit.md` — canon audits

Produces:
- `control-plane/memory/darwin/os-health-report-YYYY-MM-DD.md`
- Top 3 proposals routed through the interface agent → senior advisor → principal

The principal decides for each:
- **Approved** → implement, log in `decision-log.md`, mark `state.md` follow-through.
- **Rejected** → write **reopening criteria** to `control-plane/memory/darwin/rejected-with-reopening-criteria.md`. Without criteria, the same proposal resurfaces every cycle and the analyst's signal degrades.
- **Parked** → defer with explicit re-evaluation date.

## Canon + self-audit pairing

Every body of external knowledge absorbed into the OS (engineering standard, framework, certification) ships as two files: the canon and a self-audit. The self-audit lists items prescribed by the canon vs current OS state, with `Re-check: YYYY-MM-DD` per item.

`canon-recheck-due.sh` (run by housekeeping mode and on-demand) flags items due within 7 days. The anti-anchor rule: re-check by reading the **canon**, not the prior audit. Otherwise the loop becomes confirmation theater.

See [`best-practices/canon-self-audit-pair.md`](control-plane/best-practices/canon-self-audit-pair.md).

## How upstream changes land in this template

Three categories:

1. **Bug fixes** — direct PR against `main`. Reviewed via the `pr-review` skill, senior-advisor pressure-test if cross-cutting.
2. **New agent patterns / best practices / skills** — proposed first as a GitHub Discussion with N≥2 evidence of the pattern's value. Promoted to the template only after observable use.
3. **Structural changes** (memory tiers, hook architecture, harness machinery) — require a Darwin deep-mode proposal + senior-advisor pressure-test + explicit principal approval logged in `decision-log.md`.

The principle is **deliberate accretion**. Subtraction requires justification; accretion is the default — but each retained component must justify its place by being invoked or referenced. Components that go 30 days without invocation are surfaced by Darwin for re-evaluation. See [`best-practices/canon-self-audit-pair.md`](control-plane/best-practices/canon-self-audit-pair.md) and the [OS evolution principle](CLAUDE.md#opinionated-topology--and-how-to-opt-out).

## What does NOT evolve via this loop

- **Operator-specific identity** (`control-plane/memory/self/*`) — that is the operator's own diary, not template content.
- **Active project state** — lives in the operator's tracker (Notion, Linear, etc.), not in the template.
- **Domain folders the operator added post-bootstrap** — those are fork-specific.

The template covers the **shape**, not the **substance**.

## Versioning

Semantic versioning:
- **Major (X.0.0)** — breaking changes to the harness machinery (hook schema, settings.json structure, memory tier layout). Migration notes required.
- **Minor (X.Y.0)** — new patterns, new skills, new best practices. Backward-compatible.
- **Patch (X.Y.Z)** — bug fixes, doc clarifications, sanitization improvements.

Every release tagged `vX.Y.Z` with release notes in [`CHANGELOG.md`](CHANGELOG.md) (created at first release).
