# 🔬 EVOLUTION.md — How this repo evolves

The template encodes one operator's working discipline at one point in time. It will be wrong about some things, incomplete about others, and outdated in places within months of any release. This document is **how the repo stays sharp without bloating**.

---

## 🎼 The two-rhythm governance pattern

Two complementary cadences, each doing what the other cannot:

<table>
<tr>
<th width="30%">Rhythm</th>
<th width="20%">Cadence</th>
<th width="25%">What it does</th>
<th width="25%">What it never does</th>
</tr>
<tr>
<td>🐕 <b>Watchdog</b><br/><i>(light + housekeeping)</i></td>
<td>Continuous / daily</td>
<td>Per-session signal append, fixed daily checklist (TTL compaction, state drift, agent coverage, canon re-check). Detects FLAGs.</td>
<td>Deliberates. Generates structural proposals. Speaks to the principal unless an ALERT fires.</td>
</tr>
<tr>
<td>🧬 <b>Reconciliation ritual</b><br/><i>(deep mode)</i></td>
<td>Weekly or on-demand</td>
<td>Reads accumulated signal + decision-log + state files. Produces an OS Health Report with ≤ 5 prioritized proposals.</td>
<td>Runs continuously. Fires automatically. Skips the 7-day frequency lock.</td>
</tr>
</table>

> ⚠️ **Mixing the rhythms produces noise (continuous deliberation) or blindness (deliberation without accumulated signal).** See [`agent-patterns/os-analyst.md`](control-plane/agent-patterns/os-analyst.md) for the full canonical reference.

---

## 📅 Weekly sync ritual

Once a week, the operator invokes Darwin's deep mode:

```bash
# (after os-bootstrap has run and the system has accumulated ≥ 7 days of signal)
# In Claude Code:
"darwin, deep mode now"
```

### 📥 Deep mode reads:
- 📊 `control-plane/memory/observability/darwin-accumulator.jsonl` — light-mode session metrics
- 🚨 `control-plane/memory/observability/pre-tool-fires.jsonl` — hook fires (reminders + violations)
- 📜 `control-plane/memory/decisions/decision-log.md` — strategic decisions
- 🧠 `control-plane/memory/darwin/state.md` — own past proposals + status
- 📚 `learning/canon/*-self-audit.md` — canon audits

### 📤 Deep mode produces:
- 📋 `control-plane/memory/darwin/os-health-report-YYYY-MM-DD.md`
- 🎯 Top 3 proposals routed through the interface agent → senior advisor → principal

### 🎯 The principal decides for each:

| Verdict | Action |
|---|---|
| ✅ **Approved** | Implement, log in `decision-log.md`, mark `state.md` follow-through |
| ❌ **Rejected** | Write **reopening criteria** to `control-plane/memory/darwin/rejected-with-reopening-criteria.md`. *Without criteria, the same proposal resurfaces every cycle* |
| ⏸️ **Parked** | Defer with explicit re-evaluation date |

---

## 📚 Canon + self-audit pairing

Every body of external knowledge absorbed into the OS (engineering standard, framework, certification) ships as **two files**:

1. 📖 **The canon** — distilled content, stable until source revises
2. 🔍 **The self-audit** — items prescribed by the canon vs current OS state, with `Re-check: YYYY-MM-DD` per item

`canon-recheck-due.sh` (run by housekeeping mode and on-demand) flags items due within 7 days.

> 🚫 **The anti-anchor rule:** re-check by reading the **canon**, not the prior audit. Otherwise the loop becomes confirmation theater.

See [`best-practices/canon-self-audit-pair.md`](control-plane/best-practices/canon-self-audit-pair.md).

---

## 📤 How upstream changes land in this template

Three categories:

### 1️⃣ Bug fixes
Direct PR against `main`. Reviewed via the `pr-review` skill, senior-advisor pressure-test if cross-cutting.

### 2️⃣ New patterns / best practices / skills
Proposed first as a GitHub Discussion with **N≥2 evidence** of the pattern's value. Promoted to the template only after observable use.

### 3️⃣ Structural changes
Memory tiers, hook architecture, harness machinery — require a Darwin deep-mode proposal + senior-advisor pressure-test + explicit principal approval logged in `decision-log.md`.

> 🌱 **The principle is deliberate accretion.** Subtraction requires justification; accretion is the default — but each retained component must justify its place by being invoked or referenced. Components that go 30 days without invocation are surfaced by Darwin for re-evaluation.

---

## 🚫 What does NOT evolve via this loop

- 🔒 **Operator-specific identity** (`control-plane/memory/self/*`) — operator's own diary, not template content
- 📋 **Active project state** — lives in your tracker (Notion, Linear, etc.), not in the template
- 🌐 **Domain folders the operator added post-bootstrap** — fork-specific

> 🎯 The template covers the **shape**, not the **substance**.

---

## 🏷️ Versioning

Semantic versioning:

| Bump | Trigger | Migration notes |
|---|---|---|
| 🚨 **Major (X.0.0)** | Breaking changes to harness machinery (hook schema, settings.json structure, memory tier layout) | Required |
| ✨ **Minor (X.Y.0)** | New patterns, new skills, new best practices | Backward-compatible |
| 🩹 **Patch (X.Y.Z)** | Bug fixes, doc clarifications, sanitization improvements | None |

Every release tagged `vX.Y.Z` with release notes in [`CHANGELOG.md`](CHANGELOG.md).

---

<div align="center">

🧬 **The system is alive when the operator + Darwin + the senior advisor are all reading the same signal.**

</div>
