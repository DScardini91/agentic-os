# 📜 Changelog

All notable changes to this template are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); the project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- _(track in-flight changes here before they land in a release)_

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
