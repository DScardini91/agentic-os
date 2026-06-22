# Darwin governance memory

This directory holds artifacts the Darwin OS-analyst agent reads and writes during the reconciliation ritual (weekly or on-demand deep pass).

## Two rhythms recap

- **Watchdog** is continuous and per-session — it accumulates signal into `control-plane/memory/observability/darwin-accumulator.jsonl` via the Stop hook. Watchdog never deliberates; it only logs.
- **Reconciliation ritual** runs weekly or when invoked. It reads accumulator + decision-log + state files, produces a health report, raises proposals.

Conflating the rhythms produces noise (continuous deliberation) or blindness (deliberation without accumulated signal).

## Files (created on demand)

- `health-report-YYYY-MM-DD.md` — weekly snapshot: agent utilization, violation patterns, drift signals.
- `proposals/` — open proposals from past reconciliation passes; each with status (open / approved / rejected / parked).
- `rejected-with-reopening-criteria.md` — register of rejected proposals + the conditions under which they become valid again. Darwin reads this before raising a new pass so the same proposal doesn't resurface every cycle.

## Convention

Reconciliation passes must follow the **anti-anchor rule**: re-derive each finding from the canon and current state, not from the previous pass's conclusion. Otherwise the loop becomes confirmation theater.
