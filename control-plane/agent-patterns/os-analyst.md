# Pattern: OS analyst

## Role

A governance agent that observes the OS over weeks and months, identifies drift between intent and practice, surfaces coverage gaps, and proposes structural improvements. Operates on a slower horizon than any other agent in the system.

The analyst does not execute. It observes, synthesizes, and proposes. Proposals flow through the interface agent and the senior advisor before reaching the principal.

## When to instantiate one

Always. Every installation that has been alive for more than a few weeks needs governance. Without it, the OS accumulates entropy: stale state files, agents that are never invoked, rules that exist on paper but not in practice, decisions that drift from what was actually implemented.

The analyst is the **reconciliation rhythm** in the [two-rhythm governance pattern](../../ARCHITECTURE.md#darwin-two-rhythm-watchdog--reconciliation-ritual). The complementary watchdog rhythm runs continuously via Stop hook; the analyst runs weekly or on demand.

## When NOT to instantiate

- In the first week of a fresh installation. The analyst needs accumulated signal to work — at least 7 days of session telemetry. Before that, governance proposals are speculation, not analysis.

## Three modes

| Mode | Frequency | Cost | Output |
|---|---|---|---|
| **Light** | Every session (Stop hook) | ~0.5 min | Append one line to `darwin-accumulator.jsonl` |
| **Housekeeping** | Daily or on-demand | ~3 min | Triage table (PASS / FLAG / ALERT per check) |
| **Deep** | Weekly or on-demand | ~15 min | OS health report with ≤ 5 prioritized proposals |

The light mode is **pure append** — no analysis, no proposal. The housekeeping mode runs a fixed checklist and updates state files; it never escalates to the principal if all checks pass. The deep mode is the only one that generates structural proposals, and only one deep pass is allowed per 7-day window.

The separation matters: continuous deliberation produces noise; deliberation without accumulated signal produces blindness.

## Template

The OS analyst's spec ships as `.claude/agents/darwin.md`. The full role definition includes:
- The three-mode hybrid model
- The fixed housekeeping checklist
- The deep-mode OS Health Report structure
- The anti-anchor rule for canon re-check
- The rejected-with-reopening-criteria protocol

## Worked example

**`darwin`** (`.claude/agents/darwin.md`).

## How to customize

- Rename via `os-bootstrap` if `darwin` does not fit the operator's vocabulary.
- Edit the housekeeping checklist in `darwin.md` to add domain-specific checks (e.g. "check that the `client-engagements/` folder has a state.md per active engagement").
- The 7-day frequency lock on deep mode is enforced in `state.md` — `last_deep_mode_date` field. To temporarily allow more frequent deep passes (e.g. during a launch crisis), the operator clears the field; otherwise the lock holds.

## Anti-patterns

- **Allowing the analyst to execute proposals.** Once it executes, the analyst is no longer auditing — it is an interested party. Verdict integrity collapses.
- **Deep mode every session.** Continuous deliberation produces analytic spam. The 7-day lock exists for a reason; do not bypass it without a specific event.
- **Rejecting proposals without reopening criteria.** Without criteria, the same proposal resurfaces every cycle and the analyst's signal degrades into noise.
- **Anchoring on the previous audit.** When re-checking canon items, the analyst reads the canon, not the prior audit. Otherwise the loop becomes "the OS follows the OS".
