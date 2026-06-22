# Pattern: Orchestrator

## Role

A specialist that coordinates a **committee** of multiple deeper specialists into a single synthesis. The orchestrator does not produce the underlying content — it invokes the committee, integrates votes / verdicts / outputs, and returns a coherent recommendation to its caller.

This pattern appears when a domain has internal multi-lens validation: investment portfolios with multiple schools of thought voting on an allocation; a writing pipeline with substance / voice / structure / adversarial layers; theological exegesis with exegetical / contextual / homiletical / pastoral layers.

## When to instantiate one

- The domain has **3+ named lenses or schools** that must each evaluate the same input independently.
- The synthesis is **non-trivial** — i.e. simple majority or unanimity is not the answer; the orchestrator weighs and integrates.
- The committee is reusable across multiple invocations — i.e. you would invoke the same 3+ specialists repeatedly, so wrapping them in an orchestrator saves coordination overhead.

If the synthesis is just "ask three people and report the answers verbatim", you don't need an orchestrator — you need a skill that calls three agents and reports.

## When NOT to instantiate

- For sequential pipelines. A → B → C is not an orchestrator; it's a workflow. Use a skill.
- For ad-hoc parallel queries. If the committee changes each time, an orchestrator over-specifies. Have the interface agent fan out directly.
- Before the committee specialists exist. The orchestrator depends on them; instantiate the specialists first, observe how they get used together, then promote the coordination into an orchestrator.

## Template

```markdown
---
name: <domain>-<orchestrator-role>
description: Orchestrator for the <domain> committee — coordinates <N> specialists (<list>) into a single synthesis. Does not produce the underlying content; weighs and integrates. Reports to the interface agent.
tools: Read, Write, Edit, Bash, Agent
---

# <Domain> <orchestrator role>

You are the synthesizer of the <domain> committee. Your job is not to be the deepest expert on any single lens — it is to coordinate the lenses and integrate their outputs.

## On invocation
1. Read `control-plane/memory/<this-orchestrator>/state.md` — handoff + active threads.
2. Read the input that needs committee evaluation.
3. Fan out to the committee in parallel (single message, multiple Agent calls):
   - Agent(<specialist-1>) — <lens>
   - Agent(<specialist-2>) — <lens>
   - Agent(<specialist-3>) — <lens>
   - ...
4. Integrate their verdicts using <integration rule>.
5. Return a single synthesized recommendation.
6. Update `state.md`.

## Integration rule
Describe explicitly how disagreement is resolved:
- Weighted average with weights declared upfront
- Veto power for one lens (e.g. adversarial lens can hold a "do not ship")
- Majority + minority report
- Tie → escalate to senior advisor

## Committee members
- **<specialist-1>** — <lens>
- **<specialist-2>** — <lens>
- ...

## Output format
A 1-paragraph synthesis + a table showing each lens's verdict. The principal reads the synthesis; the table provides traceability.
```

## Worked example pointer

The template does not ship with a pre-built orchestrator because the committee depends entirely on what the operator's domain needs. For inspiration, the source OS has examples:

- An investments CIO orchestrating 10 voting schools (Buffett / Graham / Damodaran / Markowitz / Fama-French / Black-Litterman / Bogle / Momentum / Fisher / Ensemble Quant) + 4 consultative modules.
- A writing editor orchestrating 5 layers (substance / voice / craft / adversarial / distribution-coherence) with 10 specialists.
- A theological educator orchestrating 8 layers with 25 specialists.

These exist as architectural references, not as code to copy. The pattern is the lesson; the specific committees are domain choices.

## How to instantiate

1. **First instantiate the committee specialists** (3+ separate agents, each one a deep specialist on its lens).
2. **Observe two or three invocations** where the interface agent calls them in parallel. If the synthesis pattern stabilizes, promote it.
3. **Write the orchestrator spec** with the integration rule explicit. Vague integration ("synthesize the inputs") collapses to interface-agent inline reasoning and the orchestrator becomes ceremonial.
4. **Test that disagreement is handled well.** Send the orchestrator an input where you predict the committee will split. Verify the output explains the split honestly, not papers over it.

## Anti-patterns

- **Orchestrator that produces content itself.** Then it is a specialist, not an orchestrator. Verdict integrity collapses because the orchestrator is integrating its own contribution alongside the committee's.
- **Hidden weights.** If the orchestrator privileges one lens over another, that weight is documented in the spec — not hidden in the integration step.
- **Committee membership that drifts silently.** Adding or removing committee members changes the synthesis. The orchestrator spec lists the canonical members; changes are decisions logged in the decision-log.
- **Unanimity requirement.** If every lens must agree before the orchestrator returns, the orchestrator never returns. Decide upfront whether disagreement is resolved, escalated, or surfaced verbatim.
