# Pattern: Senior advisor

## Role

An **internal** pressure-tester for strategic, executive-weight, or interpretation-risk output. The senior advisor reads the interface agent's draft, attacks it across three lenses (behavioral / randomness / systems), and returns either `approved` or `refine and return`. The senior advisor **never speaks to the principal directly** — the refined output goes back through the interface agent.

The split matters: internal pressure-testing is a different cognitive act than delivering. Mixing both in one agent produces softer outputs, because the same voice loses its critical edge when it has to also be diplomatic.

## When to instantiate one

Always. Every installation has exactly one senior advisor. The role is canonical.

## When NOT to instantiate

- Never let the senior advisor address the principal directly. Once it does, the role collapses and you lose the pressure-test.
- Never instantiate a second one. Two pressure-testers produce conflicting verdicts and the interface agent has no way to integrate them.

## What triggers a senior-advisor pass

Any output with:
- Strategic weight (multi-month implications)
- Executive weight (will be seen by a senior stakeholder)
- Interpretation risk (could be read multiple ways)
- Reputational impact
- Prioritization stakes (between two real trade-offs, not false choices)
- ≥ 300 words with embedded strategic decision
- Proposal that changes `control-plane/` structure
- Final artifact to an external stakeholder

If none of those apply, skip the senior advisor — it adds noise without signal.

## The three lenses

See [`concepts/_cards/walter-pressure-test.md`](../concepts/_cards/walter-pressure-test.md) for the full framework. Summary:

1. **Behavioral** — are we confusing cognitive bias with objective reality? (Kahneman + Ariely + Dalio Assumptions)
2. **Randomness** — what tail event invalidates the entire story? (Taleb: Fooled / Swan / Antifragile)
3. **Systems** — is accountability aligned? Who has real power vs formal authority? (Pfeffer + Covey + Dalio Skin)

## Template

The senior advisor's spec ships as `.claude/agents/walter.md`. Rename via the `os-bootstrap` skill.

## Worked example

**`walter`** (`.claude/agents/walter.md`).

## How to customize

The pressure-test thresholds live in `control-plane/memory/<senior-advisor>/`. To tighten the threshold (more passes, more refinement), lower the bar in `escalation-rules.md`. To relax it (fewer passes), raise the bar.

The default threshold is calibrated against the canonical observation that **over-invocation is cheaper to fix than under-invocation**, because over-invocation surfaces immediately as latency while under-invocation surfaces as drift weeks later. Start with a tight threshold and relax based on actual drift.

## Anti-patterns

- **The senior advisor "approves" without listing what they pressure-tested.** Verdict without rationale teaches the interface agent nothing.
- **The interface agent invokes the senior advisor for trivia.** A 50-word factual reply does not need a 3-lens analysis.
- **The senior advisor's name leaks to the principal's output.** "Walter says..." is a smell — the interface agent owns the final voice; the senior advisor's contribution is invisible by design.
- **The senior advisor delivers the bad news.** If a recommendation must be hardened or rejected, the interface agent delivers it. The senior advisor's job ended when it returned the verdict.
