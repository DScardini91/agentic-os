---
name: darwin-path-mode
description: Invokes the Darwin OS analyst in proactive path mode — reads EVOLUTION_PATH.md, evaluates which of the 22 rungs the operator has completed, and surfaces the next 2-3 recommended rungs with importance/effort/benefit framing. Never pushes; the operator can settle anywhere on the ladder.
triggers:
  - "where am I on the ladder"
  - "what's next on the path"
  - "path mode"
  - "darwin proactive"
  - "what should I do next in the OS"
  - "evolution path"
  - "/darwin-path-mode"
---

# Skill: darwin-path-mode

## Preconditions

- `EVOLUTION_PATH.md` exists at repo root (shipped with the template from v2.0).
- The OS has at least passed Rung 1 (bootstrap complete) — otherwise the only recommendation is "complete bootstrap first".
- The Darwin agent (`.claude/agents/darwin.md`) is available.

## When to use

- The operator wants to see **where they are** on the evolution ladder and **what's next**.
- The operator hit a milestone (finished a domain, ingested a canon, ran first weekly ritual) and wants to know what compounds next.
- The operator has been at the same rung for a while and wants a nudge.

NOT for:
- Routine drift / housekeeping → use `darwin-housekeeping`.
- Deep governance with OS Health Report → use Darwin deep mode directly.
- Decision logging → use `decision-log-entry`.

## Sequence

### Step 1 — Invoke Darwin in path mode

```
Agent(darwin) with the following framing:
"Path mode — read EVOLUTION_PATH.md and evaluate where the operator currently sits.
Produce the canonical path-mode report (current settled rung + Done + Next 2-3 + Visible but distant + Not applicable yet).
End with the never-push line. Do not propose any rung the operator hasn't passed prerequisites for."
```

### Step 2 — Surface the report

Pass Darwin's output through to the operator unmodified except for any sensitive references Walter would flag.

### Step 3 — If the operator picks a rung

If the operator responds with *"let's do rung N"* or equivalent:
- Invoke the relevant downstream skill / agent for that specific rung. Examples:
  - **Rung 1** → `os-bootstrap`
  - **Rung 3** → `decision-log-entry`
  - **Rung 4** → `os-bootstrap-extend` (domain micro-loop)
  - **Rung 7** → `os-bootstrap-extend` (entity guardian micro-loop)
  - **Rung 8** → `ingest-content` then create canon+self-audit pair manually
  - **Rung 10** → `memory-consolidate`
  - **Rung 12** → `os-bootstrap-extend` (orchestrator micro-loop)
- Update the relevant trackers when the rung completes (decision-log entry + agent registry + memory updates).

### Step 4 — If the operator says "I'm settled at rung N"

- Write a `decision-log-entry` with `type: meta` recording the settled choice.
- Confirm Darwin will stop surfacing next-rung proposals until (a) explicit re-invocation, or (b) ≥ 30 days + new operating signal.

## Anti-patterns

- **Pushing.** If the report becomes a sales pitch, the skill fails. The operator's freedom to stop is the design.
- **Surfacing rungs whose prerequisites aren't met.** Darwin must filter, not just enumerate.
- **Ignoring the "Scardini's practice" mirror.** The reference exists because pattern-only descriptions feel abstract; an embodied example calibrates expectations.
- **Treating this as deep mode.** Deep mode is drift detection. Path mode is direction proposal. Mixing them produces either drift-blind growth or growth-blind drift.

## Example output

```
## 🪜 Where you are on the Evolution Path

**Current settled rung:** 7 · First entity guardian instantiated
**Phase:** Compounding

### ✅ Done
- Rung 1-5 · Foundations complete
- Rung 6 · Second domain (`finance/`) activated 2026-06-10
- Rung 7 · `family-guardian` instantiated 2026-06-15

### 🎯 Next 2-3 — ready + recommended
1. **Rung 8 · First canon ingested + self-audit paired**
   - Importance: high
   - Effort: M (~2 hours per canon, then re-check on the prescribed date)
   - Benefit vs current state: durable absorption of external knowledge — not just reading it once
   - Scardini's practice: first canon was Pyramid Principle (Minto); current shelf includes Dalio, Pfeffer, Kahneman, Taleb tetralogy, Ariely, Covey
2. **Rung 9 · Weekly governance ritual**
   - Importance: high
   - Effort: S to set up (~30 min), L to maintain (weekly forever)
   - Benefit vs current state: drift detection becomes automatic
   - Scardini's practice: Friday 17:00, Walter pressure-tests every proposal

### 🔮 Visible but distant
- Rung 11 · Concept cards — needs at least 2 ingested canons first

### 🚫 Not applicable yet
- Rung 12 · Orchestrator — requires 3+ named specialists in one domain

---

*You can settle anywhere on this ladder. Tell me the rung you want to stop at and I'll stop surfacing the next ones.*
```

## Coherence with other skills

This skill is **complementary** to:
- `os-bootstrap` — bootstraps Rung 1.
- `os-bootstrap-extend` — operates Rungs 4, 6, 7, 12, 19, 20 (any new agent/domain/guardian/orchestrator/fallback).
- `darwin-housekeeping` — watchdog rhythm; runs daily independent of path mode.
- `memory-consolidate` — operates Rung 10 (auto-memory curation).
- `ingest-content` + manual canon authoring → Rungs 8, 13, 18.
- `decision-log-entry` → Rung 3 + meta entries for rung-settlement choices.

The skill is **mutually exclusive** with Darwin deep mode in the same turn — they answer different questions and merging them would dilute both.
