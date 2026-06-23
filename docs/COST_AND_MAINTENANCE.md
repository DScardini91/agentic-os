<div align="center">

# ⏱️ Cost and Maintenance

### Honest time and dollar budget by rung.

[← README](../README.md) · [📅 A Monday](A_MONDAY.md) · [🪜 Evolution Path](../EVOLUTION_PATH.md)

</div>

---

## TL;DR

| Rung range | Time per week | Token cost per week | What you get back |
|---|---|---|---|
| 1–3 (setup + first decisions) | 30 min one-time bootstrap + 5 min/day | ~$2–5/week (Claude API) | Persistent context across sessions |
| 4–7 (foundations) | 10–20 min/week | $5–15/week | Decisions don't drift; one domain stays coherent |
| 8–11 (compounding) | 30–60 min/week | $15–40/week | Frameworks from your reading apply themselves |
| 12–17 (mastery) | 1–2 hours/week | $40–100/week | Strategic decisions land in minutes; reputational risk structurally managed |
| 18–22 (authorship) | 2–4 hours/week | $100–300+/week | You're authoring canon others ingest |

> 💰 **Dollar figures assume Claude Sonnet pricing as of 2026-06.** Re-derive from Anthropic's current rate card if pricing has shifted — these numbers are directional, not contractual. The $2,000/year line in the 12-month TCO section below inherits the same caveat.

The system is designed to **earn back its overhead** at every rung. If at any rung the weekly cost feels like overhead-without-payoff, that's the signal to **stop climbing** (not to push harder).

---

## ⏱️ Time cost — honest breakdown

### One-time setup costs

| What | Time |
|---|---|
| Read README + WHO_IS_THIS_FOR.md + A_MONDAY.md | ~25 min |
| Read DATA_AND_PRIVACY.md and decide your posture | ~10 min |
| Install prerequisites (jq, gh, python3) — if not already installed | ~5–15 min |
| `bash scripts/install.sh` | ~30 seconds |
| `os-bootstrap` interview (Blocks 1–4) | ~15 min |
| **Total one-time** | **~60 min** |

If you're a non-engineer who needs help with the prerequisites, add ~30 min the first time. After that, it's transferable knowledge.

### Recurring time cost by rung

#### Foundations (Rungs 1–5)

- Per session: ~30 seconds (the OS does the loading)
- Decision-log entry when something material happens: ~1 min each, 2–4× per week
- Daily log (optional but recommended): ~5 min/day
- **Total: 10–20 min/week active**

#### Compounding (Rungs 6–11)

- Same per-session and decision-log costs
- Weekly governance ritual (Darwin deep mode): ~30 min on Sunday or Friday
- First canon ingestion (one-time per book): ~20–30 min
- Canon re-checks: ~10 min/month per canon
- **Total: 30–60 min/week active**

#### Mastery (Rungs 12–17)

- All the above
- Orchestrator design (one-time per orchestrator): ~2 hours initial + 30 min/month upkeep
- Custom concept card authoring (one-time per card): ~1 hour
- Quality gate (artifact-reviewer) before client delivery: ~5 min per artifact
- CI maintenance (if your fork has CI like the upstream): ~15 min/month
- **Total: 1–2 hours/week active**

#### Authorship (Rungs 18–22)

- All the above
- Custom canon authoring: ~3–8 hours per canon, spread over weeks
- Multi-school orchestrator (10+ specialists): ~1 week to build, ~30 min/week to maintain
- Public canon publication: variable
- **Total: 2–4 hours/week active**

### What the time gets you back

This is the half no one quantifies in productivity-tool reviews. Concretely:

| Hour spent maintaining the OS | Hours saved elsewhere |
|---|---|
| 10 min decision-log entry | ~30 min not re-explaining the decision 3 months later |
| 30 min weekly governance | ~2 hours not rebuilding the cross-week picture from scratch on Monday |
| 20 min canon ingestion | ~5 hours not re-reading the book to apply it 6 months later |
| 2 hours orchestrator setup | ~10 min per invocation × 14 invocations/quarter = ~2.5 hours/quarter (orchestrator pays itself back in 1 quarter) |

**The payback is real but not immediate.** Plan for ~4–6 weeks before the system is net-positive at any rung.

---

## 💵 Token cost (Claude API)

### How costs accrue

agentic-os runs on Claude Code. Every session uses Claude API tokens, billed at Anthropic's standard rates. **agentic-os does not add a separate fee.**

The OS does affect token usage in two directions:

| Direction | Effect |
|---|---|
| **Increases** tokens per session | SessionStart hooks inject ~3–8k tokens of context (daily logs, skill index, concept routing, recent decisions) |
| **Decreases** tokens per session | You don't have to re-explain context; one focused session replaces multiple unfocused ones |

Net effect for most operators: **5–15% higher per-session token cost, 20–40% lower total token cost** (because the sessions accomplish more per token).

### Rough weekly budgets

At Anthropic's current Claude Sonnet pricing (Nov 2026), assuming 5–15 sessions per week:

| Rung range | Sessions/week | Tokens/week | Estimated cost |
|---|---|---|---|
| 1–3 | 3–8 | ~50k–200k | $2–8 |
| 4–7 | 5–15 | ~150k–600k | $5–25 |
| 8–11 | 10–25 | ~400k–1.2M | $15–50 |
| 12–17 | 15–30 | ~800k–2.5M | $30–100 |
| 18–22 | 20–40 | ~1.5M–4M | $60–150+ |

**Major cost driver beyond rung:** orchestrator agents (Rung 12+) invoke multiple sub-agents per call, multiplying token usage per invocation.

### How to control cost if it spikes

1. **Disable session-cost telemetry threshold** isn't the issue — it costs ~0 tokens. Look at heavy-context skills first.
2. **Reduce daily-log injection depth** — by default the last 2 dailies are injected. Edit `inject-recent-dailies.sh` to inject 1.
3. **Move heavy skills to "invoke explicitly only"** — instead of triggering on every relevant phrase, require operator typing.
4. **Audit orchestrator invocations weekly** — if a 10-school CIO orchestrator is firing on routine decisions, route those through a simpler path.

---

## 🛠️ Maintenance vs operational overhead

Two kinds of "weekly time":

### Maintenance — keeping the OS healthy

- Darwin housekeeping (daily run, automatic via Stop hook + occasional 5-min check)
- Weekly governance ritual (~30 min)
- Canon re-checks (~10 min per due item)
- Decision-log trailing review (~15 min/week)

**Estimated maintenance budget:** 30 min/week at Rung 8; 1 hour/week at Rung 15.

### Operational overhead — using the OS

- Decision-log entries (1 min each, 2–5× per week)
- Per-session 30 seconds of orientation
- Skill invocations (free — happens during work you'd do anyway)

**Estimated operational overhead:** 5–15 min/week regardless of rung.

**If your weekly total exceeds 2 hours and you're below Rung 15, something is wrong.** Likely candidates: bloated `auto/` memory tier, too many active agents, decision-log not being read by Darwin properly, or an orchestrator firing on inappropriate triggers. Run `darwin-housekeeping` and read the FLAG output.

---

## 🚨 When the cost is too high

Signals that the system is over-engineered for you:

- You spend more time maintaining than getting back (after the 4–6 week ramp).
- You're at Rung 8+ but still avoiding the weekly ritual.
- Your `auto/` memory tier has > 200 entries with no obvious recency in their `Re-check` dates.
- You've added 5+ agents in the last month and none are being invoked.
- You feel guilty about not using the OS — that's a sign of misfit, not laziness.

**The right response is to stop climbing — or to drop down a rung.** Settle where the cost matches the payback. The ladder is built to support this; the "Settle at rung N" pattern is documented in EVOLUTION_PATH.md.

---

## 📊 Rough total cost of ownership — 12 months

For an operator who reaches Rung 12 and stays there:

| Category | 12-month total |
|---|---|
| One-time setup | 1 hour |
| Weekly maintenance (avg 45 min × 52 weeks) | ~40 hours |
| Claude API tokens (avg $40/week × 52 weeks) | ~$2,000 |
| **Total time investment** | **~41 hours** |
| **Total dollar investment** | **~$2,000** |

What it produces over the same year:

- ~200–400 decisions logged with rationale and review dates
- 5–10 canons ingested with paired audits
- 1–3 custom orchestrators or concept cards authored
- A 12-month behavioral history Darwin can analyze for drift
- A defensible operating discipline that other senior peers will notice

**Whether that math works is your call.** For a senior knowledge worker billing > $200/hour, even a 5% productivity gain (~104 hours/year) covers the time + dollar cost ~5× over.

---

<div align="center">

*The system pays itself back when the time you save not re-explaining context exceeds the time you spend maintaining the context.*

</div>
