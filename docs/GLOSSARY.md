<div align="center">

# 📖 Glossary

### For readers who are not full-time engineers.

[← README](../README.md) · [📅 A Monday](A_MONDAY.md) · [👤 Who is this for?](WHO_IS_THIS_FOR.md)

</div>

---

> The README and the ladder use vocabulary borrowed from engineering. Most of it is the right word for what it describes — but if you don't engineer for a living, three or four terms may slow you down. This page exists to remove that friction. Skim what you need, ignore the rest.

---

## Top 12 terms

### Agent

A specialized "role" inside the OS. Not a piece of software — a **specification** that tells Claude: *"when you're acting in this role, here's how you think, what you care about, and what tools you can use."* Examples: the interface agent (your main point of contact), the senior advisor (internal pressure-tester), the family guardian (protector of a structural priority).

**Real-world analogy:** like a job description for a member of your imaginary staff. The OS lets Claude play many of those roles, one at a time, with consistent memory.

### Bootstrap

The 10–15 minute interview you go through the first time you open the system. Sets up your name preferences, your communication style, your active domains, and removes the "this is a fresh template" sentinel file. You only do this once.

**Real-world analogy:** like onboarding a new hire — they need to know who you are, how you work, and what's in your portfolio before they can be useful.

### Canon

A body of external knowledge (a book, a framework, a methodology) that you've absorbed into the OS — distilled into a markdown file the OS reads at relevant moments. Always paired with a **self-audit** that scores your current behavior against the canon's prescriptions.

**Real-world analogy:** like keeping notes on a book you read AND scoring yourself against its rules. Without the score, the notes decay into shelfware.

### Concept card

A small markdown file that encodes a decision framework (e.g., Pyramid Principle, Dalio's recurring-decision rule, Walter's 3-lens pressure-test). When a relevant decision type comes up in a session, the framework is surfaced automatically.

**Real-world analogy:** like having post-it notes of your favorite decision frameworks that magically appear at the right moment, instead of you having to remember which framework applies when.

### Decision log

An append-only markdown file (`memory/decisions/decision-log.md`) where every strategic decision you make is captured with date, rationale, and review date. Across months, becomes a quarterly-review artifact.

**Real-world analogy:** like a journal — but structured, queryable, and used by the system to detect when your stated decisions drift from your actual behavior.

### Domain

A folder at repo root representing a recurring area of your life (`professional/`, `finance/`, `personal/`, `learning/`, or any name you choose). Each active domain has its own **entry agent** that owns first reads of work in that domain.

**Real-world analogy:** like the major life buckets (work, family, finances, health) — but with a designated specialist for each.

### Entity guardian

A read-only agent that protects something you've declared non-negotiable (family time, a craft, a health protocol). Surfaces concrete observations when proposals would draw from the protected category — never abstractions like "balance."

**Real-world analogy:** like an old-school chief of staff who tells you *"this would be the 4th evening this week"* instead of platitudes about work-life balance.

### Fork

To make your own copy of a public repository. Once forked, you can edit your copy without affecting the original. agentic-os assumes you'll fork it (via GitHub) and then run it on your machine.

**Real-world analogy:** like photocopying a workbook so you can write in your own answers.

### Harness

The structural environment around the model — agents, memory, hooks, skills, configs — that turns Claude from a generic assistant into an operator-shaped tool. The word emphasizes that the *structure* does most of the work, not any specific prompt.

**Real-world analogy:** like the difference between giving someone smart advice ("be disciplined") versus building them an actual operating discipline they can run inside.

### Hook

A small script that runs **before or after a tool fires** during a Claude Code session. Examples: when you try to merge to main, the hook can block you and ask for senior-advisor approval first. When a session starts, hooks inject recent context automatically.

**Real-world analogy:** like guardrails on a highway — they don't prevent you from steering, they prevent you from accidentally driving off the cliff.

### Skill

A reusable workflow that Claude can invoke. A skill has a name, a trigger condition, and a sequence of steps. Examples: `os-bootstrap` (the onboarding interview), `decision-log-entry` (capture a decision verbatim), `pr-review` (structured PR review with verdict).

**Real-world analogy:** like a recipe — Claude follows the steps when the relevant situation arises.

### Walter / senior advisor

A specific kind of agent that pressure-tests strategic output **internally**, before it reaches you. Never speaks to you directly. Three lenses: behavioral bias, tail risk, accountability alignment. The default name in the template is "walter" (after Walter White, in this operator's reference); you can rename it during bootstrap.

**Real-world analogy:** like having a smart skeptic in your head review every important email before you hit send — except the skeptic is actually there, with frameworks.

---

## Secondary terms (encountered less often)

| Term | Plain-language meaning |
|---|---|
| **Anti-anchor rule** | When re-checking a self-audit, you re-read the canon, not the prior audit. Prevents the system from following itself in circles. |
| **CI** (Continuous Integration) | A workflow on GitHub that runs tests every time someone proposes changes. The OS uses CI to make sure documentation links work and scripts behave. |
| **Compounding** | The idea that small operating disciplines, sustained, multiply in value over months and years. The OS is built to be a compounding asset. |
| **Darwin** | The name of the OS-analyst agent — the one that observes the system over weeks and proposes structural improvements. "Darwin" because it evolves the OS itself. |
| **Deterministic enforcement** | A rule that's checked by code (e.g., a hook that blocks a merge) — not a soft reminder the model might forget under pressure. |
| **Orchestrator** | An agent that coordinates 3+ named specialists into a single synthesis. Used when a decision has multiple lenses (e.g., should I accept this engagement? → committee of strategic-fit · capacity · relationship · risk lenses). |
| **Rung** | A milestone in the 22-step evolution ladder. You climb rungs in order; you stop wherever. |
| **Self-audit** | A markdown file that scores your current OS state against a canon's prescriptions, with re-check dates per item. Always paired with a canon. |
| **Sentinel** | A small marker file (`.bootstrap-pending`) that signals "this fork hasn't been configured yet." Removed automatically when bootstrap completes. |
| **State file** | A small markdown file at `memory/<agent>/state.md` that holds an agent's current handoff state, open threads, and last update. Read at the start of each invocation. |
| **TTL** (Time To Live) | A timer on certain files. Example: state files auto-reset after 30 days of no update; scratchpad files auto-delete after 48 hours. Keeps the OS from accumulating dead context. |

---

## How to ask if you get stuck

If a term in the docs leaves you confused:

1. Check this glossary first.
2. If it's not here, open a [GitHub Discussion](https://github.com/DScardini91/agentic-os/discussions) and ask — answering "what does X mean for a non-engineer?" is how this glossary grows.
3. If the term *should* be in this glossary, that's a bug. Open an issue with `glossary-gap` label.

---

<div align="center">

*Vocabulary is a tax on entry. This page is a refund.*

</div>
