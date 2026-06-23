# 📜 Changelog

All notable changes to this template are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/); the project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- _(track in-flight changes here before they land in a release)_

---

## 🚀 [1.0.0] — 2026-06-22

> **First public release** of `agentic-os` as a complete template for building personal operating systems on top of Claude Code.

### ✨ What's in v1.0

<details>
<summary><b>🪝 Harness machinery</b></summary>

- 5 hooks across SessionStart / PreToolUse / PostToolUse / Stop:
  - `auto-gh-auth` · `block-pr-merge` · `block-protected-repo-writes` · `enforce-hub` · `session-cost-report` · `log-agent-call`
- 14 control-plane scripts: declarative trigger engine, freshness-cached skill + concept routing compilers, Darwin signal accumulator, TTL compaction, drift detection, harness validation, decision-log trailing, canon re-check sweep
- 3 YAML configs (`spoke-owners`, `protected-repos`, `triggers`) — declarative, operator-edited
- `.bootstrap-pending` sentinel + SessionStart bootstrap-check + placeholder-check hooks

</details>

<details>
<summary><b>🧠 Memory tier scaffolding (11 tiers)</b></summary>

- `self/` · `interface-agent/` · `senior-advisor/` for static identity + mandates
- `auto/` with 4 worked-example memories (one per type: user / feedback / project / reference)
- `decisions/` with seeded `decision-log.md` + anti-anchor rule + trailing review
- `daily/` · `observability/` · `darwin/` · `scratchpads/` · `skills/` · `concepts/` · `agent-state/`

</details>

<details>
<summary><b>📋 Rules + best practices (14 documents)</b></summary>

- Engineering standards · parallel-session reconciliation · post-MVP expansion (3 rules)
- 11 universal operating rules across Communication / Engineering / Architecture / Output discipline

</details>

<details>
<summary><b>🧩 Agent patterns + templates (8 patterns)</b></summary>

- Interface agent · senior advisor · domain entry · entity guardian · quality gate · OS analyst · orchestrator · fallback
- 2 instantiable templates (domain-entry, entity-guardian)
- Pattern-to-shipped-agent crosswalk table

</details>

<details>
<summary><b>🎴 Concept cards (3)</b></summary>

- Dalio's compact decision rules (inline-embedded)
- Senior-advisor 3-lens pressure-test (behavioral / randomness / systems)
- Interface operating core (Pyramid + Covey + Dalio)

</details>

<details>
<summary><b>🤖 Agents (10 shipped)</b></summary>

- `kowalski` (interface) · `walter` (senior advisor) · `darwin` (OS analyst)
- `artifact-reviewer` (quality gate)
- `professional-chief-of-staff` · `personal-advisor` · `finance-advisor` (domain entries)
- `family-guardian` · `maestro` · `terra-guide` (entity guardian examples)
- All with YAML frontmatter (name / description / tools)

</details>

<details>
<summary><b>⚡ Skills (10 shipped)</b></summary>

- `os-bootstrap` — first-fork interview (4 blocks)
- `os-bootstrap-extend` — add a new domain / agent / guardian post-bootstrap
- `decision-log-entry` · `pr-review` · `harness-onboarding` · `branch-cleanup` · `darwin-housekeeping` · `spec-cross-check`
- `capture-triage` · `meeting-to-work-items` (from the original template)

</details>

<details>
<summary><b>📚 Worked examples</b></summary>

- 4 seed auto-memories
- 1 canon + self-audit pair (harness engineering) demonstrating the canon-shipped-with-audit pattern

</details>

<details>
<summary><b>📖 Documentation</b></summary>

- README rewritten for 90-second comprehension
- `ARCHITECTURE.md` with 10 Mermaid diagrams + design principles
- `ARCHITECTURE-VISUAL.html` interactive 5-panel reference
- `CONTRIBUTING.md` · `EVOLUTION.md` · `DONE_CONTRACT.md`
- Pattern, best-practices, rules, templates each have their own README index

</details>

<details>
<summary><b>🧪 Quality gates</b></summary>

- GitHub Actions workflow runs `validate-harness`, `block-pr-merge` fixture tests, both Python compilers, YAML linting, markdown link integrity on every PR
- 15/15 fixture tests pass for the no-direct-merge regex

</details>

### ⚠️ Known limitations

- Some legacy agent specs were retrofitted with frontmatter in this release; downstream skill bodies referring to them may still have minor inconsistencies
- `os-bootstrap` is not yet resumable via a persisted progress file (spec exists; implementation in v1.1)
- Orchestrator and fallback patterns ship as docs only — no concrete template files in v1.0
- No asciinema demo cast or screen recording in the README yet
- No fork-time installer script (`scripts/install.sh`) in v1.0

### 🔄 Migration

First release. No migration needed.

---

## 🚀 [1.1.0] — _(pending merge — additions on `feat/maximalist-port-w26`)_

### ✨ Added

#### 🎬 Setup automation (closes v1.0 limitation)
- **`scripts/install.sh`** — single-command fork setup (prereq check, chmod, prime caches, validate, sentinel check). Flags `--check` and `--quiet`
- **`scripts/validate-all.sh`** — mirrors CI locally; run before pushing
- **`Justfile`** — 13 common operator commands (install · validate · tidy · drift-check · canon-due · decision-review · reset-bootstrap · etc.)
- **`os-bootstrap` resumability spec** — `.bootstrap-progress.json` contract documented in SKILL.md

#### ⚡ Skills batch 2 (3 universal)
- **`ingest-content`** — Pyramid Principle ingestion of PDF / URL / raw text
- **`ux-critique`** — adversarial UI/UX critique; refuses without concrete user fact
- **`expert-interview-guide`** — structured interview guides (.docx) with internal-only prep brief

#### 🧠 Memory tier living mechanism
- **`memory-consolidate`** skill — reflective pass over `auto/`, proposes ≤ 5 additions / updates / deletions with operator confirmation

#### 🧩 Template parity completed
- **`orchestrator.template.md`** — committee orchestrator with integration-rule slot
- **`fallback.template.md`** — catch-all with coverage-gap logging

#### 🪝 Hooks
- **`log-agent-call.sh` (PostToolUse)** — closes observability loop; `agent-calls.jsonl` now auto-populated
- **`session-start-placeholder-check.sh`** — loud warning when bootstrap is incomplete but sentinel was deleted
- **Cross-fork escalation namespace** — `~/.config/agentic-os/<project-hash>/`; two clones no longer contaminate each other

#### 🧪 CI hardening
- **`block-pr-merge.sh` regex** hardened to catch `HEAD:main`, `refs/heads/main`, `+main`, `--force` variants. 15/15 fixture tests pass
- **All 10 agents** retrofitted with YAML frontmatter (was 2/10)
- **All 10 skills** retrofitted with YAML frontmatter (was 8/10)
- **All 9 agents** with state.md files (was 1/10)

#### 🎨 Visual polish
- **2 SVG architecture diagrams** rendered inline in README (`agent-hierarchy.svg`, `harness-enforcement.svg`)
- **README hyped** — emojis as iconography, comparison tables, callout boxes, collapsible sections, status table
- **`CONTRIBUTING.md`, `EVOLUTION.md`, `CHANGELOG.md`** restructured with same visual treatment

#### 🐛 Bug fixes
- Markdown link integrity (broken `user_profile.md` reference → `_example_user_profile.md`)
- File mode fixes on placeholder check script
- `compile-skill-routing.py` attribution comment generalized

### 🔄 Migration from v1.0

No breaking changes. New scripts are additive. Frontmatter retrofits don't affect existing forks; they only fix `validate-harness.sh` warnings.

---

<div align="center">

🧬 **One release = one coherent evolution step.** Read the dimension headings; expand details on demand.

</div>
