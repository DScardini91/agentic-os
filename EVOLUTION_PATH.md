<div align="center">

# 🪜 Evolution Path

### Your ladder from fresh install to compounding operating system.

[← README](README.md) · [Architecture](ARCHITECTURE.md) · [Roadmap](ROADMAP.md) · [Changelog](CHANGELOG.md)

</div>

---

## 🎯 What this document is

A guided ladder. You stop wherever you want. If you go deep, the ladder takes you further than where the template ships out of the box.

Every rung tells you:

- **What you'll have** after this rung
- **Why it matters** (in operator terms, not theory)
- **Recommended? Optional? Already done?**
- **Scardini's practice** — a concrete example from how Daniel Scardini operates his own OS, so you can see the pattern compound, not just sit on a page
- **Other operator shapes** — for select rungs, alternative archetypes that take the same rung in a different direction, so the example doesn't lock you into one operator's choices

> 💡 The template starts you at **Rung 0**. Most operators stop somewhere around **Rung 8–10**. Scardini aims for Rungs 18–20 — and honestly **settles around 14–16 most weeks** (Mastery, not Authorship-on-tap). You decide where you settle.

> ⚠️ **Read "Scardini's practice" as mirror, not prescription.** The specific books, ratios, and choices below are one operator's. **The pattern is the canon; the instances are personal.** Adopt the *shape* of the discipline, then fill it with your own content. This is the only disclaimer needed — it applies to every "Scardini's practice" block below; we don't repeat it.

---

## 📑 The ladder at a glance

| Phase | Rungs | Theme |
|---|---|---|
| 🌱 **Foundations** | 1–5 | Bootstrap. First domain. First decision. First habit. |
| 🌿 **Compounding** | 6–11 | Second domain. Canon. Entity guardians. Weekly ritual. |
| 🌳 **Mastery** | 12–17 | Orchestrators. Custom canons. Concept cards. Governance rigor. |
| 🌲 **Authorship** | 18–22 | Multi-school committees. Visibility-as-deliverable. Books → decisions. |

You read the rungs in order, but you implement only as many as compound real value in your life. Bloat is the enemy of accretion.

---

# 🌱 Phase 1 — Foundations

> Rungs 1–5. The minimum for the OS to begin compounding. Most operators reach Rung 5 in their first week.

---

### 🪜 Rung 1 — Bootstrap interview completed

**What you'll have:** A working interface agent named your way, a senior advisor named your way, populated `memory/self/*` (personality · communication-style · decision-rules · boundaries), no remaining `<placeholder>` strings.

**Why it matters:** Without this, every session re-derives who you are from scratch and the harness layer silent-passes on unresolved names. The system is inert until bootstrap completes.

**Recommended?** ✅ Required.

**Scardini's practice:** Daniel runs the same interview every time he forks the template for a peer. He treats `memory/self/communication-style.md` as the single load-bearing file — *"if Claude reads only one thing about me, it reads this"* — and updates it on every real correction.

---

### 🪜 Rung 2 — First daily log written

**What you'll have:** One narrative entry in `control-plane/memory/daily/YYYY-MM-DD.md` capturing what you actually worked on, what surprised you, what you decided.

**Why it matters:** Daily logs are the lowest-cost loop. They're injected into every session's context for the next 7 days, so the OS starts knowing what you did yesterday without you re-explaining.

**Recommended?** ✅ Strongly recommended.

**Scardini's practice:** Daniel writes 200–500 words a day. Never a task list — always a narrative ("what I learned about myself today" is a recurring section). The discipline took ~3 weeks to stick.

---

### 🪜 Rung 3 — First decision logged

**What you'll have:** Entry `D-001` in `control-plane/memory/decisions/decision-log.md` with date · domain · decision · linked artifact.

**Why it matters:** Without a decision log, you re-litigate the same calls every few weeks. With it, Darwin can detect drift between what you said you'd do and what actually shipped.

**Recommended?** ✅ Required for any non-trivial operation.

**Scardini's practice:** Daniel uses the `decision-log-entry` skill so the model captures **verbatim quotes** — *"polished paraphrase is the #1 failure mode"*. His decision log on his private OS sits at D-150+ after a year.

---

### 🪜 Rung 4 — One active domain

**What you'll have:** One folder at repo root (`professional/`, `personal/`, `finance/`, or a name you choose) with a `domain.md` describing scope, vocabulary, and stakeholders. One domain entry agent owning it.

**Why it matters:** Domains are where real work lives. Without an active one, the OS is a museum.

**Recommended?** ✅ Required. Start with **one**. Resist the urge to seed three.

**Scardini's practice:** Daniel started with only `professional/` for the first month. Added `finance/` only when his monthly close started taking real time. The other four shipped folders sat untouched until they earned activation.

**Other operator shapes for Rung 4:**
- *A solo founder* might activate only `business/` first — collapses professional + finance into one because the boundary doesn't exist yet.
- *A grad student* might start with `research/` + `learning/`, leaving `finance/` deferred until thesis defense closes.
- *A creative* might activate `craft/` first (writing, music, design) — domain where most decisions actually compound — and treat `professional/` as a service domain that exists to fund the craft.

---

### 🪜 Rung 5 — First Darwin housekeeping pass

**What you'll have:** A clean output from `bash control-plane/scripts/darwin-housekeeping.sh` — TTL compaction, state drift, agent coverage, canon recheck. Silence if everything passes.

**Why it matters:** Housekeeping is the **watchdog rhythm**. It catches accumulating entropy before the weekly governance pass even fires.

**Recommended?** ✅ Run weekly minimum.

**Scardini's practice:** Daniel ties it to Friday afternoons. *"Like clearing the desk before the weekend."*

---

# 🌿 Phase 2 — Compounding

> Rungs 6–11. The OS starts to do work you wouldn't have done alone.

---

### 🪜 Rung 6 — Second domain activated

**What you'll have:** A second domain folder with its own entry agent. Routing config (`control-plane/config/spoke-owners.yaml`) updated.

**Why it matters:** Two domains let you see what cross-domain coordination looks like. The interface agent has to actually route — which exercises the hub-and-spoke pattern.

**Recommended?** 🟡 Optional. Only if your real life has two distinct areas that generate ≥ 1 decision/month each.

**Scardini's practice:** Daniel added `finance/` second, then `learning/` third, then `investments/` fourth. Each addition was triggered by **observable need**, never speculative.

---

### 🪜 Rung 7 — First entity guardian instantiated

**What you'll have:** A read-only guardian agent protecting something **structurally non-negotiable** (family time, a craft, a health protocol). Consulted by the interface agent before any proposal consuming that account.

**Why it matters:** Without a guardian, structural priorities silently lose to whatever is loudest in the moment. The guardian surfaces concrete observations, never abstractions.

**Recommended?** ✅ Strongly recommended for any operator with a primary commitment.

**Scardini's practice:** Daniel runs a `family-guardian` that knows his household by member, the recurring evening routine, and the boundaries he's declared. It surfaces concrete observations — *"this would be the 4th evening this week the principal hasn't seen the youngest dependent awake"* — never abstractions like "balance" or "self-care". He treats it as **the most load-bearing agent in the system**.

**Other operator shapes for Rung 7:**
- *An athlete in training* might run a `recovery-guardian` that knows the macro-cycle, the planned rest days, and the sleep floor — fires when a proposal compresses recovery below threshold.
- *A solo creative* might run a `deep-work-guardian` that protects a specific morning block — fires when meetings or context-switches try to fragment it.
- *A primary caregiver* might run a `caregiving-guardian* that surfaces concrete schedule conflicts ("this would be the second medical appointment you committed to this week — both before 9am").

The pattern is always the same: **concrete observations, not abstractions**.

---

### 🪜 Rung 8 — First canon ingested + self-audit paired

**What you'll have:** A pair of files in `learning/canon/`: `<topic>-canon.md` (the distilled source) + `<topic>-self-audit.md` (current OS state scored against the canon, with `Re-check: YYYY-MM-DD` per item).

**Why it matters:** Canon without audit decays into shelfware. Self-audit without canon drifts into vibes. The pair is what keeps absorbed knowledge **load-bearing rather than decorative**.

**Recommended?** ✅ Strongly recommended once you have 5+ rungs of operating experience.

**Scardini's practice:** Daniel's first canon was the **Pyramid Principle** (Minto). His current shelf includes:
- **Principles** — Dalio (decision rules, ingested as the `dalio-compact` concept card)
- **Power** — Pfeffer (visibility-as-deliverable; informs the `walter-pressure-test` lens 3)
- **Thinking, Fast and Slow** — Kahneman (System 1 / System 2; informs Walter lens 1)
- **The Black Swan + Fooled by Randomness + Antifragile + Skin in the Game** — Taleb (informs Walter lens 2 entirely)
- **Predictably Irrational** — Ariely (bias detection in Walter lens 1)
- **The 7 Habits of Highly Effective People** — Covey (Q2 priority in the operating core)

Every one of those has a self-audit. He re-checks on the dates the audit prescribes — *"I read the canon, never the prior audit, when re-scoring. Otherwise the loop becomes the OS following the OS."*

**Other operator shapes for Rung 8:**
- *A medical practitioner* might ingest *Atul Gawande's Checklist Manifesto* + a clinical-decision-making text + an institutional protocol → audit measures *"how many of my recent decisions used a written checklist?"*
- *A craftsperson* might ingest two books on their craft (one technical, one philosophical) → audit measures *"how often did I apply the deliberate-practice scaffolding this month?"*
- *A research scientist* might ingest a methods textbook + a philosophy-of-science work → audit measures *"how often did I pre-register hypotheses vs post-hoc rationalize?"*

The shelf is **always the operator's**. The pattern — canon paired with audit, re-checked on dated cadence — is what travels.

---

### 🪜 Rung 9 — Weekly governance ritual

**What you'll have:** A Friday (or whichever cadence) ritual where Darwin runs **deep mode**: reads observability + decision-log + state files, produces an OS Health Report with ≤ 5 prioritized proposals. Each rejected proposal gets explicit **reopening criteria**.

**Why it matters:** Without a deliberate ritual, the system never gets re-shaped. Two-rhythm governance (watchdog + reconciliation) is the canonical pattern; without the second rhythm, drift compounds invisibly.

**Recommended?** ✅ Required once the OS has > 7 days of accumulated signal.

**Scardini's practice:** Daniel invokes deep mode every Friday at 17:00. Walter pressure-tests each proposal before it reaches him. Proposals that arrive without explicit reopening criteria are returned. *"If you don't know how to know you were wrong, you don't get to be right."*

**Other operator shapes for Rung 9:**
- *A weekend operator* might run deep mode Sunday morning — when the prior week is closed and the next week hasn't started. Different cognitive state; same loop.
- *A monthly rhythm* works for operators with low-frequency, high-stakes decisions (board members, fund managers). Weekly is overkill; monthly deep mode + daily housekeeping is sufficient.
- *A milestone-driven operator* might invoke deep mode at sprint or quarter boundaries instead of on a clock. Calendar-agnostic; what matters is that deep mode actually runs with accumulated signal, not that it runs on a specific day.

---

### 🪜 Rung 10 — Auto-memory tier curated

**What you'll have:** `control-plane/memory/auto/MEMORY.md` curated by hand, with 5–15 real auto-memories spanning the four types: `user`, `feedback`, `project`, `reference`. The `memory-consolidate` skill running weekly.

**Why it matters:** Auto-memory is the OS's **persistent layer**. Without curation, it bloats into shelfware. The `memory-consolidate` skill proposes additions/updates/deletions with operator confirmation — never silent rewrites.

**Recommended?** ✅ Run `memory-consolidate` weekly alongside the governance ritual.

**Scardini's practice:** Daniel's `auto/` tier carries ~80 entries. Almost half are `feedback` type — corrections he made once that the model now persists across sessions. *"Every correction not persisted is a correction I'll have to make again."*

---

### 🪜 Rung 11 — Concept cards routed at SessionStart

**What you'll have:** 2–4 decision-framework cards in `control-plane/concepts/_cards/` with frontmatter `decision_types`. The `compile-concept-routing.py` compiler running at SessionStart, injecting the routing index into context. Up to 2 cards marked `embed: true` for inline embedding.

**Why it matters:** When a decision context matches a card's `decision_types`, the framework is surfaced **automatically** instead of you having to remember it. Pyramid Principle when the output is structured. Walter's 3 lenses when the proposal carries weight. Dalio's compact rules on every recurring decision.

**Recommended?** 🟡 Recommended once you've ingested 2+ canons.

**Scardini's practice:** Daniel runs four canonical cards (Dalio compact embedded, Walter pressure-test, Kowalski operating core, domain specialist routing). He's stricter than the template default about the embed slot — *"one inline card is more usable than two."* The default is 1/2 embed slots used.

---

# 🌳 Phase 3 — Mastery

> Rungs 12–17. The OS becomes a competitive advantage. Operators below this often plateau; passing through Phase 3 is what separates harness-shaped operators from harness-mature ones.

---

### 🪜 Rung 12 — Orchestrator agent instantiated

**What you'll have:** An orchestrator agent coordinating a committee of 3+ named specialists with an explicit integration rule (weighted average / veto power / majority + minority / tie → senior advisor). Instantiated from `templates/agents/orchestrator.template.md`.

**Why it matters:** Some domains demand multi-lens evaluation. A single specialist's answer carries one bias. An orchestrator forces the operator to **declare the integration rule** before disagreement happens — which makes the disagreement productive.

**Recommended?** 🟡 Optional. Only if a single domain in your life has 3+ stable lenses that should evaluate the same input independently.

**Scardini's practice:** Daniel runs an `investment-cio` orchestrator coordinating **10 voting schools** (Buffett · Graham · Damodaran · Markowitz · Fama-French · Black-Litterman · Bogle · Momentum · Fisher · Ensemble Quant) plus 4 consultative modules. Every allocation passes through the committee with explicit weights. *"Disagreement that's logged is disagreement that compounds."*

**Other operator shapes for Rung 12:**
- *A product manager* might orchestrate a `feature-decision` committee of 3-5 lenses (user research / engineering cost / business case / strategic fit / risk) for each major roadmap call.
- *A clinician* might orchestrate a `differential-diagnosis` committee with named specialist sub-agents (cardio / endocrine / neuro / etc.) — integration rule: any "rule out" carries veto until labs return.
- *An editor* might orchestrate a `manuscript-review` committee (substance / voice / pacing / hostile-reader) — integration rule: majority + minority report when at least one lens dissents.

---

### 🪜 Rung 13 — Custom canon authored

**What you'll have:** Beyond ingested canons (other people's books), an **operator-authored canon** — a body of knowledge distilled from your own work over months. Often starts as a long-form thought-leadership draft, ends as a `learning/canon/` file with a paired self-audit.

**Why it matters:** Reading + audit only takes you so far. The point at which you can write a canon is the point at which the discipline has moved from external rule to operator vocabulary.

**Recommended?** 🟡 Optional. Only the deepest operators reach this.

**Scardini's practice:** Daniel is mid-authorship of two canons — *Harness Engineering for Knowledge Workers* and *Operator OS as Compounding Asset*. Both started as observed patterns in his own work; both will ship as paired canon+audit.

---

### 🪜 Rung 14 — Quality gate enforced before delivery

**What you'll have:** Every formal artifact (deck, document, model, report) passes through the `artifact-reviewer` quality gate before it reaches the stakeholder. Verdict: conforms / partially conforms / does not conform + specific gaps + one-line recommendation.

**Why it matters:** The most common reputational failure is *"the artifact looks polished but doesn't answer the brief."* A read-only gate catches this every time, without slowing the producer.

**Recommended?** ✅ Required for any client-facing operator.

**Scardini's practice:** Daniel runs the gate on every deck that leaves his system. Including drafts he was *sure* were ready. *"The gate is cheap. The 'they didn't answer the question' email is not."*

---

### 🪜 Rung 15 — Cross-fork sanity (validate-harness in CI)

**What you'll have:** A CI workflow (GitHub Actions or equivalent) running `validate-harness.sh` plus fixture tests on every PR. Frontmatter integrity, state coverage, regex fixtures, routing compilers, YAML lint, link integrity — all six checks green or no merge.

**Why it matters:** Once the harness grows past ~10 agents and ~10 skills, you can no longer hold the whole system in your head. CI is the structural memory.

**Recommended?** ✅ Required for any public or multi-operator fork.

**Scardini's practice:** Daniel's CI catches frontmatter drift weekly. *"Every catch is a future regression I didn't have to debug at 11 pm."*

---

### 🪜 Rung 16 — Two-rhythm governance fully wired

**What you'll have:** Light mode (Stop hook → `darwin-accumulator.jsonl`) firing every session. Housekeeping mode running daily (or on-demand). Deep mode running weekly with the 7-day frequency lock enforced. **Three distinct rhythms, three distinct outputs, no rhythm doing another's job.**

**Why it matters:** Mixing the rhythms produces noise (continuous deliberation) or blindness (deliberation without signal). The structural separation is what keeps the governance loop honest.

**Recommended?** ✅ Required once weekly ritual runs.

**Scardini's practice:** Daniel calls this *"the most expensive lesson I learned about systems"* — early versions had Darwin generating proposals on every session, which collapsed into noise within two weeks. The 7-day frequency lock is non-negotiable now.

---

### 🪜 Rung 17 — Visibility-as-deliverable

**What you'll have:** For high-stakes external outputs (a client-facing deck, a senior-stakeholder memo, a published article), you plan **two layers**: execution + signaling. Calendar time blocked for the signaling layer with the same seriousness as the technical work. Walter checks for over-rotation if signaling exceeds ~25% of total deliverable time.

**Why it matters:** Per Pfeffer's *Power*, technical quality alone never translates into outcome. The signaling layer is what closes the gap. Most operators leave 50%+ of their actual impact on the table by neglecting it.

**Recommended?** ✅ Required for any operator whose work depends on stakeholder perception (which is most of them).

**Scardini's practice:** Daniel applies the rule strictly. Every client-facing deliverable gets a planned signaling layer. He calibrates the ratio per artifact — *"a routine internal weekly doesn't need it; a board-track update does."* The calibration is itself documented in his auto-memory.

**Other operator shapes for Rung 17:**
- *A solo creator* might invert the ratio entirely — signaling layer = 60%+ for any piece destined for public audience, because reach is the whole job.
- *An engineer in a flat org* might apply the rule only to twice-yearly performance moments — *"signaling overhead is a tax I pay for the calendar quarters that matter, not every PR."*
- *A non-profit director* might map signaling onto donor-facing materials specifically, with internal team comms running unstyled and fast.

---

# 🌲 Phase 4 — Authorship

> Rungs 18–22. You're not just operating the system — you're shaping what it becomes. Few operators reach this. It compounds at a different rate.

---

### 🪜 Rung 18 — Books → decisions pipeline

**What you'll have:** A repeatable pipeline from *I want to read this book* to *the principles from this book inform recurring decisions in my OS*. Specifically:

1. **Ingest** the book via `ingest-content` skill → Pyramid Principle analysis (TL;DR + abstract + argument map + key concepts) saved in `learning/canon/`.
2. **Distill** into a canon file with paired self-audit.
3. **If it has decision rules → concept card** with `decision_types` frontmatter so the SessionStart routing surfaces them automatically.
4. **Re-check** on the prescribed date.

**Why it matters:** Most reading produces fleeting impressions. A pipeline produces persistent operating change. The difference compounds: 10 books on a shelf vs 10 books that altered your decision-making for years.

**Recommended?** ✅ Strongly recommended once you have 3+ canon pairs.

**Scardini's practice:** Daniel reads ~20 books a year. Of those, ~6 enter the pipeline. Of those, ~2 promote to concept cards. Current concept cards he runs (all derived from this pipeline):
- **`dalio-compact`** (from *Principles* — embedded inline)
- **`walter-pressure-test`** (synthesizes Kahneman + Taleb + Ariely + Pfeffer)
- **`kowalski-operating-core`** (Minto + Covey + Dalio)
- **`domain-specialist-routing`** (per-domain book-to-agent mapping)

*"Every concept card is a year of operator behavior compressed into a routing rule."*

**Other operator shapes for Rung 18:**
- *A teacher* might ingest pedagogy texts → distill into a `lesson-planning` card with `decision_types: ["weekly plan", "unit design", "student-conference prep"]`. Same pipeline; entirely different output.
- *A trader* might ingest market-microstructure books → produce a card on `decision_types: ["entry sizing", "exit discipline", "risk-limit override"]`. The card never tells them WHAT to trade; it surfaces frameworks WHEN they're making the type of decision the framework was built for.
- *A startup operator* might compress *The Hard Thing About Hard Things* + *High Output Management* into a `people-decisions` card with triggers like *"someone disagrees with the strategy"* or *"first-time hire at this level."*

---

### 🪜 Rung 19 — Multi-school orchestrator (10+ voting members)

**What you'll have:** An orchestrator coordinating 10+ named voting specialists across distinct intellectual schools, with weighted integration and explicit dissent registration. Each school is its own sub-agent with its own state file. Disagreement is logged with verbatim votes.

**Why it matters:** This is the structural form of *"I want to think about this from every angle that matters."* Done right, it produces decisions that survive years of scrutiny because every plausible objection was logged before execution.

**Recommended?** 🟡 Optional. Only domains with genuine 10+ lenses justify this surface area.

**Scardini's practice:** Daniel's `investment-cio` is the canonical example (see Rung 12). He's mid-experiment with a second one — a `spiritual-cte` that coordinates 25 specialists across 8 layers for theological exegesis. Both required 6+ months of operating discipline before they paid off.

---

### 🪜 Rung 20 — Fallback agent + coverage-gap log feeding Darwin

**What you'll have:** An `interface-fallback` agent that catches tasks no specialist owns, executes them competently, and **logs the invocation as a coverage gap** in its own state.md. Darwin reads the log in deep-mode passes and proposes either a new specialist for the recurring category or scope extension to an existing one.

**Why it matters:** Without a fallback, the interface agent silently absorbs uncovered work and the gap never gets seen. With it, the gap becomes a Darwin proposal. The OS literally learns where it's incomplete.

**Recommended?** 🟡 Optional. Only when the OS has > 5 specialists and Darwin flags "interface agent did non-trivial work itself" ≥ 2 times in a governance pass.

**Scardini's practice:** Daniel ran without a fallback for the first year. Added it after Darwin's third consecutive pass flagged the same pattern. *"The fallback is a Darwin signal, not a victory."*

---

### 🪜 Rung 21 — Deliberate accretion as operating principle

**What you'll have:** Every retained component in your OS justifies its place by being invoked. Darwin flags components untouched for 30 days. Subtraction requires the same justification as addition (a decision log entry, a Walter pass).

**Why it matters:** Most operators add and never subtract. The OS bloats into shelfware. The accretion principle — *"the OS grows by addition, not by replacement; subtraction is permitted but requires justification"* — is what keeps the system alive over years rather than over months.

**Recommended?** ✅ Required from Rung 15 onward. Otherwise the harness collapses under its own weight.

**Scardini's practice:** Daniel calls this his **most important architectural commitment**. *"The OS is a guide rail, not a cage. It constrains direction, not motion. Every retained piece must keep earning its rail."* See `control-plane/best-practices/canon-self-audit-pair.md` for the canonical formulation.

---

### 🪜 Rung 22 — Operator-authored canon shipped publicly

**What you'll have:** A canon you wrote, drawn from your own operating discipline, published externally (book, paper, public Github canon, Medium series). Other operators ingest it via *their* `ingest-content` skill. The compounding flows outward.

**Why it matters:** This is the rare rung where the OS has produced enough operating clarity that you can give the discipline back to the field. It's no longer your private edge — it's the system inviting peers.

**Recommended?** 🟡 Optional. By definition, only operators authoring at this level reach it.

**Scardini's practice:** Daniel is mid-authorship. The *Harness Engineering* canon and the *Operator OS as Compounding Asset* canon are both targeting external publication. Estimated ship: 2027. *"If the discipline only lives in my head, it dies with me. If it lives in canon+audit pairs, other operators inherit it."*

---

# 🧬 How Darwin uses this ladder

The OS analyst (Darwin) reads `EVOLUTION_PATH.md` in deep-mode passes. For each rung, it does three checks:

1. **Done?** — Verifiable signal (file exists, agent invoked, ritual ran). If yes, rung is marked `[x]` in Darwin's report.
2. **Available?** — Prerequisites for the rung are satisfied. If yes, rung is "ready to take".
3. **Recommended now?** — Match between the operator's current state and the **importance**/**effort** profile of the rung.

Darwin's deep-mode output then surfaces:

- ✅ **Done** — rungs you've passed (silently, unless you ask)
- 🎯 **Next 2–3** — rungs ready and recommended, ordered by importance
- 🔮 **Visible but distant** — rungs available in the same phase, deferred
- 🚫 **Out of scope** — rungs that don't apply yet (prerequisites missing)

This is Darwin's **proactive mode** — distinct from the reactive housekeeping (watchdog) and weekly proposals (reconciliation). The operator never has to ask *"what should I do next?"* — Darwin's report answers it.

**Stop signal:** the operator says *"I'm settled at rung N for now"* in a decision-log entry. Darwin records the choice and stops surfacing the next rung until either (a) the operator invokes Darwin and explicitly asks for the next rung, or (b) ≥ 30 days pass and the operator's signal shows new appetite (more agents invoked, more decisions logged, more canon ingested).

---

# 📍 Where most operators stop (honestly)

A read of operating data from comparable harnesses suggests:

| Rung settled at | Operator profile |
|---|---|
| 1–4 | Tried it once, didn't stick |
| 5–7 | Personal productivity user — values the daily/decision-log loop |
| 8–11 | Serious operator — uses 2+ domains, has 1–2 canons, runs weekly ritual |
| 12–17 | Power operator — orchestrator pattern, custom canons, CI-enforced harness |
| 18–22 | Author-operator — books → decisions pipeline, authoring canons for others |

There is no shame in any rung. **Compounding starts at Rung 3 and continues at every higher rung.** The question is only how steep you want the slope.

---

# 🪞 Scardini's practice as a mirror

Throughout this document, when "Scardini's practice" is referenced, the intent is **not** to prescribe Daniel Scardini's specific choices. It's to show what one operator's compounding looks like at every rung — books he ingests, ratios he calibrates, rituals he runs, rules he's authored.

You will operate differently. The mirror exists so you can compare your trajectory to a real one, not so you copy a particular one. If you find yourself at Rung 10 and your habits look nothing like the Scardini reference at Rung 10 — that's information about your operating shape, not a failure.

The **pattern** is the canon. The **specific instances** are personal.

---

<div align="center">

🪜 *Every rung you climb is a rung your future self has already paid for.*

— this is the operating bet.

</div>
