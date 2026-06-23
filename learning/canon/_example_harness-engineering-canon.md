---
title: Harness Engineering — Canon (worked example)
source: Distilled from production use of multi-agent harnesses on top of LLMs (2025-2026)
ingested: 2026-06-22
source_revision_tracked: false
status: example_for_template
---

# Harness Engineering — Canon

> Worked example of an absorbed canon. Demonstrates the canon-shipped-with-self-audit pattern. Delete and replace with your own canons after bootstrap.

## What "harness" means here

A **harness** is the structured environment around a model that turns generic capability into operator-specific competence. Three components:

1. **Design-time** — agent specs, memory tier definitions, hook configurations, skill contracts. *What the system is.*
2. **Execution** — runtime invocations, tool dispatch, context management. *What the system does.*
3. **Signal** — observability feeds, governance accumulators, decision-log. *What the system reports.*

Each component has a distinct maintenance rhythm. Conflating them produces drift.

## Principles

### P1 — Determinism > politeness
Hook-level enforcement of rules beats reminders the model can ignore. If a rule is real (no-direct-merge, no edit in protected paths), encode it as a hook that returns `permissionDecision: deny`, not as a soft prompt.

### P2 — Progressive disclosure
An agent has a fast path (live state, current threads, last handoff) and a deep context (frameworks, rules, full spec). The fast path is read every invocation; the deep context only when the task requires it. Mixing the two burns context on work that didn't need it.

### P3 — Two-rhythm governance
Continuous signal accumulation (per-session, light) is distinct from periodic deliberation (weekly or on-demand, deep). Mixing the rhythms produces noise or blindness — each fails at the other's job.

### P4 — Canon + self-audit pairing
Every absorbed canon ships with a living self-audit that scores current state against canon prescriptions, with explicit `Re-check: YYYY-MM-DD` dates. Canon without audit decays into shelfware; audit without canon drifts into vibes. The pair is the unit.

### P5 — Single interface, internal pressure-test
The system has one voice that talks to the principal. Pressure-testing happens internally, in a separate agent that never delivers — because the cognitive act of attacking a recommendation is different from the act of presenting one, and mixing them produces softer outputs.

### P6 — Deliberate accretion, not unbounded growth
Components earn their place by being invoked. The system grows by addition with justification; subtraction is permitted but requires the same justification. Darwin flags components that go 30 days without invocation for re-evaluation.

## What this canon does NOT cover

- How to write the model's prompts (different surface; lives in agent specs and skill bodies).
- How to evaluate model output quality (different surface; lives in quality-gate agents and review skills).
- How to integrate with specific external systems (Notion, Linear, etc.) (operator-specific).

## Source of the canon

This example consolidates lessons from the operator's production use of multi-agent harnesses. Real canons in your fork should cite real sources — engineering standards, frameworks, certifications, books, papers — with publisher, edition, and a hash or revision identifier so re-checks are deterministic.

---

> **For the paired self-audit, see [`_example_harness-engineering-self-audit.md`](_example_harness-engineering-self-audit.md).**
