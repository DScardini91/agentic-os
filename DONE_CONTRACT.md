# 📋 agentic-os — Done Contract

[← Back to README](README.md) · [Architecture](ARCHITECTURE.md) · [Roadmap](ROADMAP.md) · [Changelog](CHANGELOG.md)

---

> 🎯 **Audience:** BCG peers, ex-MBB / consulting operators, builders evaluating Claude Code at scale, recruiters / hiring partners using this GitHub as a seriousness signal.
>
> 🏆 **Intent:** anyone landing here from a LinkedIn post, BCG conversation, or referral should be able to:
> 1. Understand what the system is in under **90 seconds**
> 2. Clone-and-run the bootstrap in under **10 minutes**
> 3. Leave with the impression of a thoughtful engineer who ships **impeccable work**

The contract below is the explicit, testable definition of "impeccable" for v1.0 launch. ✅ **Done = every box below passes.** Items grouped by surface; each has an objective verifier.

---

## 🎬 1. First impression (README + landing)

| Criterion | Verifier |
|---|---|
| Landing reader understands the system in ≤ 90 seconds | Stranger reads README top, names back the value prop in their own words |
| README has a one-screen "what is this" section before any architecture detail | First 40 lines = value prop, audience, getting-started link, demo asciinema/GIF |
| Concrete demo of the bootstrap interview is shown in README | Asciinema cast or 3-frame screenshot sequence inline |
| Visual diagram of the architecture is inline or one-click away | Mermaid embed in README + link to ARCHITECTURE-VISUAL.html |
| README answers "is this for me?" explicitly | Section with 3 bullet-list "you'll like this if..." + 3 bullets "this is NOT for you if..." |
| Quickstart works on a fresh Mac and Linux machine | Tested on a clean container; copy-paste commands work end-to-end |
| Repo has badges (license, last-commit, stars) and a clear `v1.0` tag | Badges on README, tag pushed |
| `CONTRIBUTING.md`, `LICENSE`, `CODE_OF_CONDUCT.md` present | Files exist with non-trivial content |
| Repo description and topics set on GitHub | `gh repo edit` with description + topics: `claude-code`, `agentic-os`, `personal-os`, `harness` |

## ⚡ 2. Setup automation (unzip-and-go)

| Criterion | Verifier |
|---|---|
| Single command bootstraps the system from a fresh clone | `bash scripts/install.sh` (or similar) creates sentinel, marks scripts executable, verifies prerequisites, instructs to open Claude Code |
| Prerequisites are checked before bootstrap interview fires | jq, python3, gh, git presence verified; missing → clear install instructions per OS |
| Bootstrap interview is resumable | `.bootstrap-progress.json` saves state per block; reinvoke continues from last completed block |
| Bootstrap interview can roll back | Each block is reversible until commit step at end of Block 4 |
| Bootstrap removes its own sentinel only on full success | Partial completion → sentinel persists, clear "X of 4 blocks complete" header |
| `setup` skill complements `os-bootstrap` for non-interactive forks | `os-bootstrap --non-interactive --config=path.yaml` for CI / scripted forks |

## 🧠 3. Memory layer

| Criterion | Verifier |
|---|---|
| All 11 memory tiers have populated README or example content | No empty directory; every tier has a `README.md` or seed file documenting purpose and write-rules |
| `auto/` memory tier ships with 3-5 seed example memories | User profile template, communication-style example, feedback example, project example, reference example |
| Memory format is enforced consistently | Each file with frontmatter `type:` is one of {user, feedback, project, reference}; `validate-memory.sh` script verifies |
| TTL rules are documented and tested | `memory-ttl-compaction.sh` runs without errors; documented in `best-practices/` |
| Memory tier separation is visible and intuitive | A new operator can answer "where should I save X?" in under 30s by reading the memory README index |

## 🪝 4. Hooks (deterministic enforcement)

| Criterion | Verifier |
|---|---|
| Every hook in settings.json has a corresponding script that exists | `validate-harness.sh` checks all paths in settings.json resolve; passes |
| Every hook is documented inline with header comment explaining what / when / why | Comments at top of every `.sh`; format: name, trigger, what it does, override env var if any |
| Hooks degrade gracefully when prerequisites missing | jq/python3 absent → silent skip with note; never breaks SessionStart |
| Hooks have fixture tests for governance gates | `scripts/tests/test-block-pr-merge.sh` and similar for trigger-check, enforce-hub |
| Hooks namespace state by project to avoid cross-fork contamination | `~/.config/agentic-os/<project-hash>/` |
| Loud warning when placeholders remain in active config | `session-start-placeholder-check.sh` fires when `<placeholder>` present and sentinel absent |
| `block-pr-merge.sh` catches all common refspec variants | 15/15 fixture tests pass |

## ⚡ 5. Skills

| Criterion | Verifier |
|---|---|
| Every skill has YAML frontmatter with name, description, triggers | `validate-harness.sh` skill check passes 100% |
| Every skill has a "Preconditions" block in body | First section after frontmatter is Preconditions; format consistent |
| Every skill cites the best-practice rule(s) it embodies | If applicable, body references `control-plane/best-practices/<rule>.md` |
| `os-bootstrap` is robust (resumable, idempotent, rollback) | Manual run + interrupt + resume passes; second run on bootstrapped system does nothing destructive |
| Skill list covers the canonical operator workflows | Bootstrap, decision-log entry, PR review, branch cleanup, harness-onboarding, spec cross-check, darwin housekeeping, capture triage, meeting → work items, os-bootstrap |
| Each skill has a one-line usage example | At the top or bottom; copy-paste runnable |

## 🤖 6. Agents (specs + patterns)

| Criterion | Verifier |
|---|---|
| Every shipped agent has YAML frontmatter | `validate-harness.sh` agent check passes 100% (currently 2/10 — must reach 10/10) |
| Every agent has a corresponding `state.md` (or is documented as read-only) | `validate-harness.sh` state-file coverage check passes |
| Pattern-to-shipped-agent crosswalk table exists | `agent-patterns/README.md` has table mapping each of 8 patterns to worked example or "no example, instantiate via template" |
| Agent patterns each have 1 page max, with template inline OR linked | No pattern doc exceeds 200 lines; templates separated cleanly |
| 8 pattern docs cover every shipped agent's role | Every shipped agent is the worked example of exactly one pattern |

## ⚙️ 7. Configs (YAML)

| Criterion | Verifier |
|---|---|
| Every YAML config has inline comments explaining each field | Reader can edit the file without external docs |
| Every YAML config has an explicit "after bootstrap, edit X" guidance | Inline comment block at top |
| Every placeholder in a YAML config uses consistent `<kebab-case>` notation | grep finds zero deviations |
| YAML files are validated for parse-correctness | `scripts/tests/validate-yaml.sh` runs `yq` or `python3 -c "import yaml"` over every config |

## 📝 8. Markdowns (cross-referencing)

| Criterion | Verifier |
|---|---|
| Every markdown file in `control-plane/` has at least one link to another | No orphan docs |
| Every "see also" link resolves | `scripts/tests/validate-links.sh` checks every markdown link in `control-plane/` and `README.md` resolves to an existing file or section |
| Hierarchical reading order is explicit | Root CLAUDE.md → control-plane/CLAUDE.md → session-start.md → patterns / best-practices on demand |
| Architecture, patterns, best-practices, rules, concepts each have a README index | All 5 surfaces have a `README.md` indexing their contents with one-line summaries |
| No dead Portuguese strings (template is English) | grep for common Portuguese words (Daniel, ainda, está, são, etc.) returns zero hits outside LICENSE and decision-log examples |

## 🔬 9. Capacity for evolution (continuous improvement)

| Criterion | Verifier |
|---|---|
| Darwin agent is wired and producing signal on first session | `agent-calls.jsonl` records darwin invocation in first 5 sessions of a real fork |
| `darwin-housekeeping` skill produces a triage table when invoked manually | Test run on a populated repo emits PASS/FLAG/ALERT triage |
| Weekly sync ritual documented in `CONTRIBUTING.md` or `EVOLUTION.md` | A new operator can run a weekly sync ritual without asking |
| Canon + self-audit pairing is honored in `learning/canon/` examples | At least one shipped canon + self-audit pair in `learning/canon/` as a worked example |
| `os-bootstrap-extend` skill exists for adding new agents post-bootstrap | When operator adds a new domain after initial bootstrap, a skill instantiates the agent from template with the same Q&A flow |

## 🎨 10. Customization (operator vocabulary, not template)

| Criterion | Verifier |
|---|---|
| Bootstrap interview never assigns names without operator confirmation | Code review of `os-bootstrap` Block 2 + Block 3 |
| Six shipped domain folders are explicitly framed as examples, removable | README + os-bootstrap explicit; tested by running bootstrap with operator who keeps 0 of the shipped 6 |
| All template-shipped agent names (kowalski, walter, family-guardian, maestro, terra-guide, etc.) are renamable in one place | Single command or interview step renames across all references; tested on `kowalski` → some-other-name |
| Best-practices are opt-out, not mandatory | README states clearly that operators can delete any best-practice file they don't agree with, and explains the consequence per file |

## 🧪 11. Quality gates (CI / pre-merge)

| Criterion | Verifier |
|---|---|
| GitHub Actions workflow runs on every PR | `.github/workflows/validate.yml` runs validate-harness, validate-yaml, validate-links, fixture tests |
| All CI checks must pass for merge | Branch protection on main requires CI green |
| Failed checks produce actionable error messages | Reader of a failing PR knows what to fix in under 1 minute |
| Releases are tagged with `vX.Y.Z` and have release notes | First release `v1.0.0` includes changelog, migration notes (none for first release), known limitations |

## ✨ 12. Public-facing polish

| Criterion | Verifier |
|---|---|
| Repo's GitHub social preview image is set | Custom image (or Mermaid render) uploaded |
| README has a "Why I built this" section signaling intent | 2-3 paragraphs; references the BCG-style operating discipline angle without name-dropping |
| Architecture diagram has a high-resolution rendered version | SVG or PNG export from the Vue dashboard, embedded in README |
| Repo description on GitHub mentions Claude Code + agentic OS + harness | `gh repo edit --description "..."` |
| At least one BCG-style 4-quadrant or 2x2 framework slide rendered as a one-pager | Visual hook for the BCG audience; demonstrates Daniel's slide-craft alongside the repo |

---

## 📅 Sequence (work plan)

**Phase 1 — Stability of what exists** (1-2 sessions)
- Frontmatter retrofit on 8 legacy agents (Walter + 4-agent critique consensus)
- Placeholder warning hook + block-pr-merge regex (already applied; commit)
- Validate-harness err→warn for legacy agents during transition
- Fixture tests for governance gates

**Phase 2 — UX polish** (1-2 sessions)
- README rewrite for the 90-second test
- Asciinema cast of os-bootstrap
- Quickstart on a clean machine
- README sections: "why I built this", "is this for me?", "this is NOT for you if..."

**Phase 3 — Wholeness** (2 sessions)
- CONTRIBUTING.md, CODE_OF_CONDUCT.md, EVOLUTION.md
- Memory README per tier + 3-5 seed memories in auto/
- Pattern-to-shipped-agent crosswalk table
- Best-practices link from every skill that embodies one

**Phase 4 — Continuous evolution** (1 session)
- `os-bootstrap-extend` skill for adding agents post-bootstrap
- One worked canon + self-audit pair in learning/canon/
- Weekly sync ritual doc

**Phase 5 — Public launch** (1 session)
- GitHub social preview image + repo description + topics
- `v1.0.0` tag + release notes
- `.github/workflows/validate.yml` CI
- Branch protection on main

---

## ✅ Definition of done overall

`v1.0.0` is published when every checkbox above is verified. The verifier method is named for each row. If a verifier is "tested on a clean container" or "code review", the result is recorded in `EVOLUTION.md` with a date.

This contract is itself part of the repo. Future revisions update it explicitly via decision-log entry.
