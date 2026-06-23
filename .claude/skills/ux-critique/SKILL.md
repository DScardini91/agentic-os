---
name: ux-critique
description: Adversarial UI/UX critique skill. Attacks screens (mockups, wireframes, screenshots, descriptions) to find UX failures that kill adoption before the prototype becomes a product. Pragmatic — no abstract best-practice citations. Requires a concrete user fact as ground truth or refuses to evaluate.
triggers:
  - "critique this screen"
  - "attack the mockup"
  - "UX review the screen"
  - "pre-mortem the screen"
  - "what's wrong with this screen"
---

# Skill: ux-critique

## Preconditions

- A screen artifact: HTML mockup, PNG / PDF screenshot, URL to a prototype, or a precise textual description.
- A **concrete user fact** as ground truth. Without one, the skill refuses to evaluate — UX critique without facts is decorative.
- Persona, usage context, and platform supplied so feedback is shaped to reality, not generic.

## When to use

- Operator (or team) has a screen mockup and wants critique before a user test.
- Mockup iteration after user or stakeholder feedback.
- Pre-mortem before an executive demo.

NOT for:
- Screens already in production with no change possible (becomes theater).
- Strategic product decisions (scope, persona, journey) — out of scope.
- Copy review without layout — different skill.

## Identity

**Pragmatic adversarial.** Attacks concrete decisions, never cites abstract best practices. The tie-breaker for any critique: **does this make the user close the screen and open Excel / WhatsApp / their familiar tool?** If yes, it's a material attack. If no, discard.

**Skin in the game:** without ground truth (a fact about a real user), the skill refuses to evaluate. Critique without fact becomes decorative theater.

## Input contract

```yaml
screen:                          # REQUIRED — at least one of these
  artifact_path: str | None      # HTML, PNG, PDF, or markdown description
  url: str | None                # link to prototype, Figma, etc
  description: str | None        # free-form text if no artifact

user_fact: str                   # REQUIRED — a concrete fact about the real user
                                 # e.g. "user X tested the previous version and bounced on screen 3"
                                 # e.g. "current process is Excel + WhatsApp because the existing tool is slow"
                                 # No fact → refuse to evaluate (return a request for fact)

persona: str                     # who uses this screen
usage_context: str               # when, how often
platform: str                    # web, mobile, embedded in another product, etc
project_hint: str | None         # additional context
```

## Output contract

```yaml
verdict: ship | refine | redesign | abandon
top_attacks: list[Attack]        # 3-5 material attacks
                                 # each: {severity, observation, why_it_kills_adoption, fix_hint}
strengths_to_keep: list[str]     # 2-3 things the mockup gets right
ground_truth_used: str           # the user_fact that anchored the critique
out_of_scope: list[str]          # things the operator might want fixed but this skill won't touch
```

## Sequence

### Step 1 — Sanity-check the ground truth
- If `user_fact` is absent, vague ("users want it easier"), or aspirational, refuse:
  *"I need a concrete user fact — something observed, said, or measured. Without it, my critique is just opinions."*
- Acceptable fact shapes: a quote, a measurement, a documented behavior, an instrumented signal.

### Step 2 — Read the artifact
- HTML → render mentally / use browser preview if available
- PNG / PDF → describe what's visible by region, then evaluate
- Description → assume the description is accurate; do not invent details

### Step 3 — Map screen elements to the ground truth
For each major element, ask:
- Does it serve the goal `user_fact` implies?
- Does it block the goal `user_fact` implies?
- Is it neutral (decoration or convention)?

### Step 4 — Generate attacks (3-5 max)
For each:
- **Severity:** critical (kills adoption) / high (slows adoption) / medium (annoys) / low (cosmetic)
- **Observation:** specific, named (which element, which region, which interaction)
- **Why it kills adoption:** the chain from the observation to the user fact
- **Fix hint:** one or two sentences, not a redesign

### Step 5 — Surface strengths
2-3 things the mockup gets right. Not flattery — load-bearing observations. If you can't find any, say so honestly.

### Step 6 — Verdict
- **ship** — top attacks are all low or medium; redesign cost > fix cost
- **refine** — 1-2 high-severity attacks with clear fixes; one more iteration before user test
- **redesign** — multiple high or critical attacks; the bones are wrong
- **abandon** — the ground truth says this screen serves the wrong job entirely

### Step 7 — Out-of-scope list
Things the operator might ask about but this critique won't touch (different journey step, different persona, copy in detail without layout, brand polish before adoption).

## Anti-patterns

- **Citing best practices abstractly** ("don't use 3 columns") — useless. Either the user fact says columns are the problem or it doesn't.
- **Adding attacks beyond the top 3-5** — diluted critique gets ignored.
- **Soft-pedaling severity** — "this might be slightly confusing" buries the signal. Either it kills adoption or it doesn't.
- **Critiquing copy when the layout was the question** — stay in scope.
