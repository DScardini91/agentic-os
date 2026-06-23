# Changelog

All notable changes to this template are documented in this file. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and the project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- (track in-flight changes here before they land in a release)

---

## [1.0.0] — 2026-06-22

First public release of `agentic-os` as a complete template for building personal operating systems on top of Claude Code.

### What's in v1.0

**Harness machinery**
- 5 hooks across SessionStart / PreToolUse / Stop:
  `auto-gh-auth` · `block-pr-merge` · `block-protected-repo-writes` · `enforce-hub` · `session-cost-report`
- 14 control-plane scripts: declarative trigger engine, freshness-cached skill + concept routing compilers, Darwin signal accumulator, TTL compaction, drift detection, harness validation, decision-log trailing, canon re-check sweep
- 3 YAML configs (spoke-owners, protected-repos, triggers) — declarative, operator-edited
- `.bootstrap-pending` sentinel + SessionStart bootstrap-check + placeholder-check hooks

**Memory tier scaffolding** (11 tiers)
- `self/` `interface-agent/` `senior-advisor/` for static identity + mandates
- `auto/` with 4 worked-example memories (one per type: user / feedback / project / reference)
- `decisions/` with seeded `decision-log.md` + anti-anchor rule + trailing review
- `daily/` `observability/` `darwin/` `scratchpads/` `skills/` `concepts/` `agent-state/`

**Rules + best practices** (14 documents)
- Engineering standards, parallel-session reconciliation, post-MVP expansion (3 rules)
- 11 universal operating rules (Communication / Engineering / Architecture / Output discipline)

**Agent patterns + templates** (8 patterns)
- Interface agent · senior advisor · domain entry · entity guardian · quality gate · OS analyst · orchestrator · fallback
- 2 instantiable templates (domain-entry, entity-guardian)
- Pattern-to-shipped-agent crosswalk table

**Concept cards** (3)
- Dalio's compact decision rules (inline-embedded)
- Senior-advisor 3-lens pressure-test (behavioral / randomness / systems)
- Interface operating core (Pyramid + Covey + Dalio)

**Agents** (10 shipped)
- `kowalski` (interface) · `walter` (senior advisor) · `darwin` (OS analyst)
- `artifact-reviewer` (quality gate)
- `professional-chief-of-staff` · `personal-advisor` · `finance-advisor` (domain entries)
- `family-guardian` · `maestro` · `terra-guide` (entity guardian examples)
- All with YAML frontmatter (name / description / tools)

**Skills** (10 shipped)
- `os-bootstrap` — first-fork interview (4 blocks)
- `os-bootstrap-extend` — add a new domain / agent / guardian post-bootstrap
- `decision-log-entry` · `pr-review` · `harness-onboarding` · `branch-cleanup` · `darwin-housekeeping` · `spec-cross-check`
- `capture-triage` · `meeting-to-work-items` (from the original template)

**Worked examples**
- 4 seed auto-memories
- 1 canon + self-audit pair (harness engineering) demonstrating the canon-shipped-with-audit pattern

**Documentation**
- README rewritten for 90-second comprehension
- `ARCHITECTURE.md` with 10 Mermaid diagrams + design principles
- `ARCHITECTURE-VISUAL.html` interactive 5-panel reference
- `CONTRIBUTING.md` · `EVOLUTION.md` · `DONE_CONTRACT.md`
- Pattern, best-practices, rules, templates each have their own README index

**Quality gates**
- GitHub Actions workflow runs `validate-harness`, `block-pr-merge` fixture tests, both Python compilers, YAML linting, markdown link integrity on every PR
- 15/15 fixture tests pass for the no-direct-merge regex

### Known limitations

- The 8 legacy agent specs were retrofitted with frontmatter in this release; their `state.md` files use the English template, but downstream skill bodies referring to them may still have minor inconsistencies. The `validate-harness.sh` warnings are advisory, not blocking.
- `os-bootstrap` is not yet resumable via a persisted progress file. Interrupting mid-interview means re-answering from Block 1; future versions will add `.bootstrap-progress.json`.
- Orchestrator and fallback patterns ship as docs only — no concrete template files. Operators copy the inline template from the pattern doc.
- No asciinema demo cast or screen recording in the README yet. The Quickstart section uses text only.
- No fork-time installer script (`scripts/install.sh`). Bootstrap is invoked from inside Claude Code.

These limitations are tracked as issues for v1.1+.

### Migration

This is the first release. No migration needed.
