# 📜 Changelog

All notable changes to this template are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); the project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- _(track in-flight changes here before they land in a release)_

---

## 🔧 [2.2.1] — 2026-06-28

> **Hook performance & reliability patch.** Session startup was slow (full-file jq scan on every start) and sessions could freeze indefinitely due to missing timeouts. This patch fixes both.

### Fixed

- **`session-start-violations.sh` — single-pass rewrite**: replaced N-session loop (2N+1 file reads) with a single jq slurp pass over `tail -2000` of each log file. Session startup time drops from ~20s to under 1s. Uses `any(. == $t)` for reliable jq 1.5/1.6/1.7 membership test (per Walter review).
- **`settings.json` — timeouts on all hooks**: all 19 hooks now have explicit timeouts (5–20s). Previously `timeout=none` meant any hanging hook froze the session indefinitely.
- **`settings.json` — deduplicate PreToolUse matchers**: `Write`, `Edit`, and `MultiEdit` matchers consolidated into a single `Write|Edit|MultiEdit` matcher. Reduces hook count from 26 to 19 with no behavioral loss; MultiEdit gains `pre-tool-use-trigger-check` coverage it was missing.
- **`settings.json` — remove `state-drift-check` and `memory-ttl-compaction` from SessionStart**: both scripts were registered in SessionStart and Stop, running twice per session. Now Stop-only.

---

## 🎯 [2.2.0] — 2026-06-23

> **Non-technical onboarding release.** A BCG-director persona review (no code context, 10 minutes on the repo) surfaced 5 material gaps between what the README sells and what a non-engineer leigo technical can actually evaluate. v2.2 closes them — and goes further to enrich the operator-shape variety, audience qualifier, data residency, integration story, and time/cost budget.

### ✨ Added — five new docs in `docs/`

- **`docs/A_MONDAY.md`** — the missing narrative vignette. Three Mondays at three rungs (4, 8, 12), each showing concrete inputs/outputs of a real Monday morning at that depth. Replaces the *"system sells what it IS, not what your Monday looks like"* gap.
- **`docs/WHO_IS_THIS_FOR.md`** — explicit audience qualifier with positive (*you'll like this if*), negative (*not for you if*), maybe band, and career-stage fit table. *"The hardest part of selling a system is honest disqualification."*
- **`docs/DATA_AND_PRIVACY.md`** — where each kind of data lives (local · GitHub · Anthropic · external), three working postures (public-ish, private, regulated), pre-fork compliance checklist, easy-exit instructions. Resolves the *"where does my client data go?"* unknown.
- **`docs/INTEGRATION_MAP.md`** — agentic-os vs / + Notion / Linear / Jira / Outlook / ChatGPT / Obsidian. Surface-by-surface comparison; what the OS does NOT do (deliberate non-features); four operator setup recipes.
- **`docs/COST_AND_MAINTENANCE.md`** — honest time + dollar budget per rung. One-time setup, recurring time costs, token cost estimates, signals that the system is over-engineered for you, when to stop climbing.
- **`docs/GLOSSARY.md`** — 12 top terms (agent · bootstrap · canon · concept card · decision log · domain · entity guardian · fork · harness · hook · skill · Walter / senior advisor) + 11 secondary terms, all in plain language. For non-engineer readers.

### 🪞 Changed

- **README** rewritten to lead with *output* instead of *architecture*:
  - New **30-second pitch** at the top (5 bullets of what changes after 3 months of use)
  - Direct callout *"What does Monday look like?"* pointing to A_MONDAY.md
  - "Is this for you?" hardened with senior-knowledge-worker / persistent-context / regulated-environment criteria
  - New **"Where does my data live?"** section with 3-posture table
  - New **"How does this fit with my existing tools?"** section
  - New **"What does this cost me?"** section with rung-by-rung budget
  - Nav bar at top now leads with the 6 new operator-facing docs (A_MONDAY, WHO_IS_THIS_FOR, DATA, INTEGRATION, COST, GLOSSARY) before the architecture docs

### 🎬 Why this release

The BCG-director persona review concluded: *"Não forkaria hoje. Não porque o sistema parece ruim — ao contrário, ele me parece sério. Mas falta a vinheta concreta da semana 1."* This release lands that vinheta + the surrounding scaffolding so a senior knowledge worker who is **not a full-time engineer** can:

1. Read 1 page (30-second pitch) and decide if they're curious
2. Read 1 doc (A Monday) and decide if the output is worth their time
3. Read 1 doc (Who is this for) and self-qualify honestly
4. Read 1 doc (Data and Privacy) and clear it with compliance if needed
5. Read 1 doc (Cost and Maintenance) and know the realistic budget
6. *Then* fork

Each document deliberately under 15-minute reads. Each one removable without breaking the others.

### 🔄 Migration from v2.1.0

No code or schema changes. All additive documentation.

---

## 🪞 [2.1.0] — 2026-06-23

> Honesty release. A cold-eyes external review of v2.0.0 surfaced five legitimate critiques about the gap between what the repo *says* and what it *delivers*. v2.1 closes them without re-shipping the architecture.

### 🔧 Fixed

- **Hook enforcement language** in README clarified. Previous text claimed *"hooks enforce the rules deterministically before any tool fires"* — true only for `block-pr-merge` and `block-protected-repo-writes` (hard deny). `enforce-hub.sh` is warn-loud, not deny. New phrasing distinguishes deny vs warn per hook, notes the warn-loud default, and points to `settings.json` for the per-hook contract.
- **Hook count math** in README. Previous text said "5 hooks across SessionStart × 6 …" — actual count is 6 hook scripts in `.claude/hooks/`, with the SessionStart × 6 invocations being control-plane scripts, not hooks. The "what ships" table and the status row now reflect that accurately.
- **Empty `bootstrap/` directory** removed. Was shipped accidentally; carried no content; cost honesty.

### 🪞 Changed

- **EVOLUTION_PATH self-positioning calibrated.** Previous text said *"Scardini lives around Rung 18–20."* Honest read: he aims for 18–20 but settles around **14–16 most weeks** (Mastery, not Authorship-on-tap). The new phrasing makes the gap visible and removes unverifiable self-positioning.
- **22 inline "Mirror, not prescription" footers removed.** Reviewer flagged that 22 repetitions read defensive, not calibrating. Single opening blockquote now carries the disclaimer ("applies to every Scardini's practice block below; we don't repeat it"). The reflection section at the end of the document is preserved as a reinforcement, not a third repetition.
- **"Other operator shapes" alternative vignettes added** to 7 rungs (4, 7, 8, 9, 12, 17, 18). Each gives 3 different operator archetypes taking the same rung in different directions (founder vs grad student vs creative; athlete vs caregiver vs solo creator; medical vs craft vs research; weekend vs monthly vs milestone; PM vs clinician vs editor; solo creator vs IC engineer vs nonprofit director; teacher vs trader vs startup operator). The pattern is the canon; the operator-shape examples now travel without locking the reader into Scardini's specific choices.

### 🔄 Migration from v2.0.0

No code or schema changes. Documentation correction only. Forks pull and continue.

### 📝 Honesty signal

The cold-eyes review was invited (the operator asked for a critical no-context reviewer), the verdict landed approved-with-conditions, and the conditions landed in the next release. The pattern matters more than the patch itself — *"a repo whose author wrote 7 regression tests for one shell script is a repo whose claims I can trust to be tested next month too"* (reviewer's deciding factor for forking). v2.1 is the same compounding logic applied to documentation honesty.

---

## 🌲 [2.0.0] — 2026-06-23

> Minor-major release: introduces the **Evolution Path** — a 22-rung ladder that guides operators from fresh install all the way to authoring their own canons. Darwin gains a third invocation mode (**path mode**) that proactively surfaces the next 2-3 rungs without ever pushing.

### ✨ Added

- **`EVOLUTION_PATH.md`** — the canonical 22-rung ladder organized in 4 phases:
  - 🌱 Foundations (1-5): bootstrap, first domain, first decision, daily log, first housekeeping pass
  - 🌿 Compounding (6-11): second domain, entity guardian, first canon+audit pair, weekly ritual, auto-memory curation, concept cards routing
  - 🌳 Mastery (12-17): orchestrator pattern, custom canon, quality gate enforcement, CI-enforced harness, two-rhythm governance, visibility-as-deliverable
  - 🌲 Authorship (18-22): books → decisions pipeline, multi-school orchestrator (10+), fallback agent + coverage-gap log, deliberate accretion as operating principle, operator-authored canon shipped publicly

  Every rung documents **what you'll have**, **why it matters**, **recommended? optional? already done?**, and **Scardini's practice** as a mirror. The operator can settle at any rung; the ladder never pushes.

- **Darwin path mode** — new invocation mode on the `darwin` agent, distinct from light mode (Stop hook), housekeeping mode (daily), and deep mode (weekly). Path mode reads `EVOLUTION_PATH.md`, evaluates which rungs the operator has completed, and surfaces the next 2-3 ready + recommended rungs with importance/effort/benefit framing.

- **`darwin-path-mode` skill** — the canonical wrapper for invoking Darwin in path mode. Triggers include *"where am I on the ladder?"*, *"what's next?"*, *"path mode"*, *"/darwin-path-mode"*. Skill ends with the never-push line: *"You can settle anywhere on this ladder. Tell me the rung you want to stop at and I'll stop surfacing the next ones."*

- **Operator settlement contract** — when the operator says *"I'm settled at rung N for now"*, a meta-type decision-log entry records the choice and Darwin stops surfacing next-rung proposals for 30 days (or until explicit re-invocation).

### 🔄 Updated

- **README** gains a 🪜 evolution-path section with the four-phase summary and a pointer to `darwin-path-mode`.
- **Darwin agent spec** (`.claude/agents/darwin.md`) documents path mode alongside the existing three modes, with explicit cognitive-act separation (deep mode = drift detection; path mode = direction proposal).

### 🔄 Why minor-major (2.0.0) and not a 1.x minor

Path mode is a **new cognitive surface** for the OS analyst, not just an additive feature. The Darwin contract grows from three modes to four; the operator's mental model of *"how do I know what to do next?"* has a structural answer for the first time. SemVer minor would understate this.

No breaking changes to the existing harness — v1.1.2 forks upgrade by pulling the new files; no scripts, configs, or memory schemas were modified.

### 🔄 Migration from v1.1.2

- Pull the new files (`EVOLUTION_PATH.md`, `.claude/skills/darwin-path-mode/SKILL.md`).
- The Darwin agent gains path mode automatically — its spec is updated in-place; no agent restart required.
- Optional: invoke `darwin-path-mode` once to see where you currently sit on the ladder. Most v1.x operators will land between Rungs 5-11.

---

## 🩹 [1.1.2] — 2026-06-23

> Patch release closing the two remaining Walter conditions from PR #4: marker check for non-agentic-os repos, and the canon entry for post-success-path testing.

### 🐛 Fixed

- **`status` / `next` no longer fabricate `bootstrapped` answer outside an agentic-os repo.** If `$CLAUDE_PROJECT_DIR` (or `$PWD`) does not contain any of the canonical markers (`control-plane/CLAUDE.md`, `control-plane/scripts/bootstrap-progress.sh`, `.claude/settings.json`), both commands now exit code 4 with `{"state":"not-an-agentic-os-repo"}` instead of silently claiming the system is bootstrapped. Closes Walter LB#2 from PR #4 pressure-test.

### 🧪 Added

- **Test 7** in CI fixture: status + next in a non-agentic-os directory must exit 4 with the correct state JSON. CI fixture coverage: 6 → 7 tests.

- **`best-practices/post-success-path-testing.md`** — canon entry promoting the lesson from PR #3 → dry-run → PR #4. The terminal state of a happy path is itself a state; test what happens after the happy path completes. Three required post-success tests per terminal-state surface: query, mutation, re-entry. Listed in `best-practices/README.md` under a new `🧪 Testing` category.

### 📋 Exit code convention documented

Header of `bootstrap-progress.sh` now enumerates:
- 0 — success
- 1 — missing prerequisite (jq)
- 2 — usage error
- 3 — wrong-state error (sentinel absent when start/complete called)
- 4 — not-an-agentic-os-repo (no markers detected)

### 🔄 Migration from v1.1.1

No action required.

---

## 🩹 [1.1.1] — 2026-06-23

> Patch release fixing a phantom-reinit bug in `bootstrap-progress.sh` discovered during the v1.1.0 dry-run.

### 🐛 Fixed

- **Phantom progress-file reinit after ALL_COMPLETE.** `bootstrap-progress.sh next` was calling `_init_if_missing` unconditionally, which re-created the progress file with all-pending blocks on a freshly bootstrapped system. Any downstream check that ran `next` post-bootstrap would falsely report "1_identity next", producing infinite directive loops or re-execution of completed work.

  Fix: `_init_if_missing` is now sentinel-aware — it does not create a progress file when `.bootstrap-pending` is absent. `status` and `next` short-circuit to `{"state":"bootstrapped"}` and `done` respectively in that case. `start` and `complete` refuse with a clear message when the system is already bootstrapped, exit code 3.

### 🧪 Added

- **Six CI fixture tests** for `bootstrap-progress.sh` (was one end-to-end test). New coverage:
  - Test 3: post-bootstrap `next` returns `done` without phantom re-init
  - Test 4: `status` reports `{"state":"bootstrapped"}` without side-effects
  - Test 5: `start` refused with helpful message when sentinel absent
  - Test 6: mid-bootstrap interruption + resume returns the in-progress block

### 🔄 Migration from v1.1.0

- No action required. The fix only changes behavior when the system is already bootstrapped (where the old behavior was broken).
- **If you are upgrading from v1.0 with a partial bootstrap** (sentinel `.bootstrap-pending` still present): the sentinel must exist before you run `bootstrap-progress.sh complete <block>` — that is the normal state for mid-bootstrap. If you accidentally removed the sentinel, run `bootstrap-progress.sh reset` first, then `touch .bootstrap-pending`, then resume the migration steps documented in v1.1.0.

---

## 🚀 [1.1.0] — 2026-06-23

> Feature release closing three known limitations from v1.0.

### ✨ Added

- **`bootstrap-progress.sh`** — concrete implementation of the `.bootstrap-progress.json` contract documented in v1.0. Five subcommands (`status` · `next` · `start` · `complete` · `reset`). Atomic JSON writes via `jq`; auto-cleans both sentinel and progress file when all 4 blocks complete (emits `ALL_COMPLETE`). Closes Done Contract dimension #2 — bootstrap interview resumability.

- **Social preview image** — `docs/diagrams/social-preview.png` (1280×640) rendered from SVG. Inline at the top of the README so GitHub link cards and LinkedIn previews carry the visual brand. Upload to repo Settings → General → Social preview for the explicit OG card.

- **CI smoke tests for setup flow** — `validate.yml` now exercises:
  - `bash scripts/install.sh --check` (prerequisite verification path)
  - `bash scripts/install.sh --quiet` (full install on fresh CI checkout)
  - `bootstrap-progress.sh` end-to-end contract (start → complete × 4 → ALL_COMPLETE + cleanup)
  Catches drift between documented setup flow and actual behavior before merge.

### 🔄 Updated

- **`os-bootstrap` SKILL.md** — Resumability section now references the `bootstrap-progress.sh` helper directly with the canonical 5-command flow. The interview reads `next` to find the resume point and calls `start` / `complete` per block. Interruption mid-block leaves the block in `in_progress`; next invocation resumes from there.

### 🔄 Migration from v1.0.x

- No breaking changes. Forks that bootstrapped in v1.0 are already configured (sentinel removed); the new script does nothing on a configured system.
- **Mid-bootstrap forks** (sentinel still present, but some blocks were already completed manually under v1.0): run `bootstrap-progress.sh status` to initialize the progress file, **then run `bootstrap-progress.sh complete <block-name>` for each block you already finished** (`1_identity`, `2_harness_naming`, `3_domains`, `4_technical_wiring` in canonical order). Without this, the next `os-bootstrap` invocation will resume from block 1 and re-execute work you already did.

---

## 🚀 [1.0.0] — 2026-06-22

> **First public release** of `agentic-os` — a complete template for building personal operating systems on top of Claude Code.

### ✨ What ships

<details>
<summary><b>🪝 Harness machinery — deterministic enforcement layer</b></summary>

- **5 hooks** across the four lifecycle events:
  - `SessionStart`: `bootstrap-check` · `placeholder-check` · `violations` · `inject-skill-routing` · `inject-concept-routing` · `inject-recent-dailies`
  - `PreToolUse`: `auto-gh-auth` · `block-pr-merge` · `block-protected-repo-writes` · `enforce-hub` · `pre-tool-use-trigger-check`
  - `PostToolUse`: `log-agent-call` (populates `agent-calls.jsonl`)
  - `Stop`: `session-cost-report` · `darwin-accumulate`
- **14 control-plane scripts** including: declarative trigger engine, freshness-cached skill + concept routing compilers, Darwin signal accumulator, TTL compaction, drift detection, harness validation, decision-log trailing review, canon re-check sweep
- **3 YAML configs** (`spoke-owners`, `protected-repos`, `triggers`) — declarative, operator-edited
- **`.bootstrap-pending` sentinel** + SessionStart routing to the `os-bootstrap` skill
- **Cross-fork escalation namespace** — `~/.config/agentic-os/<project-hash>/` so two clones don't contaminate each other

</details>

<details>
<summary><b>🧠 Memory tier scaffolding (11 tiers)</b></summary>

- `self/` · `interface-agent/` · `senior-advisor/` for static identity + mandates
- `auto/` with 4 worked-example memories (one per type: user / feedback / project / reference)
- `decisions/` with seeded `decision-log.md` + anti-anchor rule + trailing review
- `daily/` · `observability/` · `darwin/` · `scratchpads/` · `skills/` · `concepts/` · `agent-state/`
- TTL compaction for state.md (30d) and scratchpads (48h)

</details>

<details>
<summary><b>📋 Rules + best practices (14 documents)</b></summary>

- **3 rules**: engineering standards · parallel-session reconciliation · post-MVP expansion
- **11 universal best practices** across:
  - **Communication**: conclusion-first · no-emoji-no-emdash · no-half-finished
  - **Engineering**: git-stage-surgical · no-direct-merge · atomic-commits · code-ownership-respect
  - **Architecture**: agentic-by-default · progressive-disclosure · canon-self-audit-pair
  - **Output discipline**: comments-explain-why

</details>

<details>
<summary><b>🧩 Agent patterns + templates (8 patterns)</b></summary>

- 8 canonical agent roles documented as **replicable patterns**: interface agent · senior advisor · domain entry · entity guardian · quality gate · OS analyst · orchestrator · fallback
- **4 instantiable templates** in `templates/agents/`: domain-entry · entity-guardian · orchestrator · fallback
- Pattern-to-shipped-agent crosswalk table
- Explicit anti-pattern guidance per pattern

</details>

<details>
<summary><b>🎴 Concept cards (3)</b></summary>

- Dalio's compact decision rules (inline-embedded in routing index)
- Senior-advisor 3-lens pressure-test (behavioral / randomness / systems)
- Interface operating core (Pyramid + Covey + Dalio)

</details>

<details>
<summary><b>🤖 Agents (10 shipped, all with YAML frontmatter)</b></summary>

- `kowalski` (interface) · `walter` (senior advisor) · `darwin` (OS analyst) · `artifact-reviewer` (quality gate)
- `professional-chief-of-staff` · `personal-advisor` · `finance-advisor` (domain entries)
- `family-guardian` · `maestro` · `terra-guide` (entity guardian examples)
- All with `state.md` files (10/10 state coverage)

</details>

<details>
<summary><b>⚡ Skills (13 shipped)</b></summary>

**Bootstrap & governance** (5):
- `os-bootstrap` — first-fork interview (4 blocks, resumable via `.bootstrap-progress.json`)
- `os-bootstrap-extend` — add a new domain / agent / guardian post-bootstrap
- `darwin-housekeeping` — daily fixed checklist
- `memory-consolidate` — weekly reflective pass over auto-memories
- `decision-log-entry` — transcribe free-form decisions into structured entries

**Engineering ops** (4):
- `pr-review` · `branch-cleanup` · `spec-cross-check` · `harness-onboarding`

**Intake & triage** (2):
- `capture-triage` · `meeting-to-work-items`

**Research & review** (3):
- `ingest-content` (Pyramid Principle ingestion) · `ux-critique` · `expert-interview-guide`

</details>

<details>
<summary><b>📚 Worked examples</b></summary>

- **4 seed auto-memories** (one per memory type) — example user profile, communication feedback, project, reference
- **1 canon + self-audit pair** (harness engineering) demonstrating the canon-shipped-with-audit pattern
- **D-000 decision-log entry** seeded for the v1.0 launch

</details>

<details>
<summary><b>⚡ Setup automation</b></summary>

- **`scripts/install.sh`** — single-command fork setup (prereq check, chmod, prime caches, validate, sentinel check). Flags `--check` and `--quiet`
- **`scripts/validate-all.sh`** — mirrors CI locally; run before pushing
- **`Justfile`** — 13 common operator commands (`install` · `validate` · `tidy` · `drift-check` · `canon-due` · `decision-review` · `reset-bootstrap` · etc.)
- **`os-bootstrap` resumability** via `.bootstrap-progress.json` contract

</details>

<details>
<summary><b>📖 Documentation</b></summary>

- **README** designed for 90-second comprehension with emoji-as-iconography, comparison tables, callout boxes, status table
- **`ARCHITECTURE.md`** with 10 Mermaid diagrams + design principles
- **`ARCHITECTURE-VISUAL.html`** interactive 5-panel reference
- **`CONTRIBUTING.md`** · **`EVOLUTION.md`** · **`DONE_CONTRACT.md`** · **`CHANGELOG.md`**
- **Pattern**, **best-practices**, **rules**, **templates** each have their own README index
- **2 rendered SVG architecture diagrams** inline in README: `agent-hierarchy.svg` · `harness-enforcement.svg`

</details>

<details>
<summary><b>🧪 Quality gates</b></summary>

- **GitHub Actions `validate.yml`** workflow on every PR + push to main:
  - `validate-harness.sh` (frontmatter integrity, state coverage)
  - 15-case fixture suite for `block-pr-merge` regex
  - Skill routing compiler (`compile-skill-routing.py`)
  - Concept routing compiler (`compile-concept-routing.py`)
  - YAML config parse validation
  - Markdown link integrity (control-plane + root)
- **All 15 fixture tests pass** for the no-direct-merge regex (catches `HEAD:main`, `refs/heads/main`, `+main`, `--force` variants)
- **PR template** + 3 issue templates (`bug` · `feature` · `question`) in `.github/`

</details>

### ⚠️ Known limitations

- **Asciinema demo cast** of the bootstrap interview not yet recorded
- **Social preview image** for GitHub repo card not yet uploaded
- **`os-bootstrap` actual progress persistence** — contract documented in SKILL.md; implementation exercised on first real fork bootstrap
- **`learning/canon/` real-world entries** — only the worked-example pair ships; forks add their own

### 🔄 Migration

First release. No migration needed.

---

<div align="center">

🧬 **One release = one coherent evolution step.**

</div>
