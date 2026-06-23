# agentic-os

[![validate](https://github.com/DScardini91/agentic-os/actions/workflows/validate.yml/badge.svg)](https://github.com/DScardini91/agentic-os/actions/workflows/validate.yml)
[![license](https://img.shields.io/github/license/DScardini91/agentic-os)](LICENSE)
[![latest tag](https://img.shields.io/github/v/tag/DScardini91/agentic-os?sort=semver)](https://github.com/DScardini91/agentic-os/releases)
[![last commit](https://img.shields.io/github/last-commit/DScardini91/agentic-os)](https://github.com/DScardini91/agentic-os/commits/main)

> A personal operating system on top of Claude Code. Agents, memory, hooks, skills, and conventions that turn an LLM from a generic assistant into a chief of staff for your work and life.

**v1.0** · MIT license · 12-line quickstart · [Architecture](ARCHITECTURE.md) · [Done Contract](DONE_CONTRACT.md) · [Changelog](CHANGELOG.md)

---

## The 90-second version

You start Claude Code in this repo. It detects you're new, interviews you for 10 minutes about your identity, voice, decision rules, and active domains, and then configures a multi-agent system around your answers. From that point on:

- **One interface agent** (the COO) is the only voice that talks to you. It routes work, coordinates specialists, and never dumps raw model output without filtering it.
- **A senior advisor** pressure-tests anything strategic before it reaches you. Three lenses: behavioral bias, tail risk, accountability alignment. It never speaks to you directly.
- **Domain entry agents** own recurring areas of your life: professional work, finance, learning, anything you define. Each has its own state file, vocabulary, and decision shapes.
- **Entity guardians** protect structural priorities you've decided do not enter the trade-off space: family time, a craft, a health protocol. They surface concrete observations, never abstractions.
- **An OS analyst** (Darwin) observes the system over weeks, surfaces drift, and proposes structural change in a weekly governance pass.
- **Hooks** enforce the rules deterministically before any tool fires: no direct merges to main, no edits to control-plane files without senior-advisor invocation, no work on protected repos without owner-agent invocation.

The system is opinionated and the opinions are documented. You can opt out of any of them with a one-line config edit — see [the opt-out section](#opinionated-topology--how-to-opt-out).

## Is this for you?

**You'll like this if you:**
- Operate Claude Code daily and notice it drifts without structure.
- Think of your own work like a small operating organization: priorities, decisions, signals, governance.
- Want deterministic enforcement (hooks blocking bad commands) rather than polite reminders the model ignores under pressure.
- Are comfortable reading a few markdown files before running a setup interview.

**This is NOT for you if you:**
- Want a chat companion. This is a workbench, not a relationship.
- Need an out-of-the-box product. The whole point is that you instantiate it for yourself.
- Are looking for general AI advice. The OS structures *how* Claude operates on *your* work; the work is still yours.

## Quickstart

```bash
# 1. Clone
git clone https://github.com/DScardini91/agentic-os.git
cd agentic-os

# 2. Install — single command, idempotent
bash scripts/install.sh
```

`install.sh` verifies prerequisites (jq, python3, gh, git), makes hooks and scripts executable, primes the routing caches, validates the harness, and confirms the bootstrap sentinel is in place. Run with `--check` to verify prerequisites without changing anything.

```bash
# 3. Open Claude Code
claude
```

The SessionStart hook detects `.bootstrap-pending` and prompts you to invoke the **os-bootstrap** skill — a 4-block interview (identity · naming · domains · technical wiring) that resolves placeholders, populates memory tiers, and removes the sentinel.

The interview takes 10-15 minutes. You can pause and resume in any session.

```bash
# 4. Confirm at any time
bash scripts/validate-all.sh
```

`validate-all.sh` runs the full check suite (frontmatter, state coverage, regex fixtures, routing compilers, YAML lint, markdown link integrity) — the same suite CI runs on every PR.

## What ships in this repo

| Surface | Count | Read first |
|---|---|---|
| Hooks (`.claude/hooks/` + `.claude/settings.json`) | 5 hooks across SessionStart / PreToolUse / Stop | [`.claude/settings.json`](.claude/settings.json) |
| Scripts (`control-plane/scripts/`) | 14 bash + 2 Python (compilers, validators, Darwin signal) | [`scripts/validate-harness.sh`](control-plane/scripts/validate-harness.sh) |
| Configs (`control-plane/config/`) | 3 YAML: spoke-owners, protected-repos, triggers | [`config/triggers.yaml`](control-plane/config/triggers.yaml) |
| Memory tiers | 11 (self / interface-agent / senior-advisor / auto / decisions / daily / observability / darwin / scratchpads / skills / concepts / agent-state) | [`memory/auto/MEMORY.md`](control-plane/memory/auto/MEMORY.md) |
| Rules (`control-plane/rules/`) | 3 (engineering-standards, parallel-session-reconciliation, post-mvp-expansion) | [`rules/engineering-standards.md`](control-plane/rules/engineering-standards.md) |
| Concept cards (`control-plane/concepts/_cards/`) | 3 decision frameworks (Dalio, senior-advisor pressure-test, interface operating core) | [`concepts/_cards/walter-pressure-test.md`](control-plane/concepts/_cards/walter-pressure-test.md) |
| Best practices (`control-plane/best-practices/`) | 11 universal operating rules | [`best-practices/README.md`](control-plane/best-practices/README.md) |
| Agent patterns (`control-plane/agent-patterns/`) | 8 canonical roles documented as replicable patterns | [`agent-patterns/README.md`](control-plane/agent-patterns/README.md) |
| Agent templates (`control-plane/templates/agents/`) | 2 instantiable templates (domain-entry, entity-guardian) | [`templates/agents/README.md`](control-plane/templates/agents/README.md) |
| Agents (`.claude/agents/`) | 10 shipped (kowalski, walter, darwin, artifact-reviewer, 3 domain entries, 3 entity-guardian examples) | [`agents/darwin.md`](.claude/agents/darwin.md) |
| Skills (`.claude/skills/`) | 9 (os-bootstrap, decision-log-entry, pr-review, harness-onboarding, branch-cleanup, darwin-housekeeping, spec-cross-check, capture-triage, meeting-to-work-items) | [`skills/os-bootstrap/SKILL.md`](.claude/skills/os-bootstrap/SKILL.md) |

## How it works

![Agent hierarchy](docs/diagrams/agent-hierarchy.svg)

Single interface agent fronts everything. Domain entries own recurring work. Entity guardians protect what you've declared non-negotiable. Senior advisor pressure-tests internally. Quality gate verifies artifacts before delivery. OS analyst observes the system over time and proposes structural change.

### The harness enforcement layer

![Harness enforcement](docs/diagrams/harness-enforcement.svg)

Hooks fire deterministically at SessionStart, PreToolUse, PostToolUse, and Stop. The rules you set don't drift across sessions because they're enforced at tool dispatch time, not relied on the model to remember.

Read [`ARCHITECTURE.md`](ARCHITECTURE.md) for the full canonical flow, design principles, and the 10 Mermaid diagrams describing each layer.

## Opinionated topology + how to opt out

The default topology is **single interface + internal senior advisor + domain spokes + entity guardians + governance analyst**. The enforcement layer (hooks, configs) assumes this shape. It is a guide rail, not a cage.

If you want a different topology (flat agents, multi-interface, no senior advisor):
1. Clear or rewrite `control-plane/config/spoke-owners.yaml`.
2. Remove `enforce-hub.sh` from `PreToolUse` in `.claude/settings.json`.
3. Skip Blocks 3-4 of `os-bootstrap` and delete `.bootstrap-pending` manually.

The harness silent-passes on missing config and keeps running.

## Why I built this

After a year of using Claude Code on consulting work, I noticed a pattern: the model is brilliant at any single turn, but it drifts across turns and sessions. The drift compounds in three places: (1) it forgets what I value, (2) it forgets what we decided, (3) it bypasses rules I told it to follow because I told them in plain English and the next session never read that conversation.

The solution wasn't a better prompt. It was a harness: structured files the model reads at every session start, hooks that enforce rules before tools fire, and explicit roles that separate execution from pressure-testing. Once that infrastructure existed, every session inherited the discipline of every previous session.

I'm a Senior Forward Deployed AI Scientist at BCG. The discipline this repo encodes — single-interface coordination, internal pressure-test before delivery, governance loops, deterministic enforcement — is the same shape I see in well-run client organizations. That isn't accidental. The repo is one way to make an LLM operate that way for you.

## Customization

Everything in this repo is meant to be edited:
- **Best practices** (`control-plane/best-practices/`) — delete any rule you don't agree with. The `Why` block explains the cost so the deletion is informed.
- **Agents** (`.claude/agents/`) — rename, repurpose, or delete. The `os-bootstrap` interview offers default names; the patterns library shows how to instantiate new ones for your domains.
- **Hooks** (`.claude/settings.json`) — remove a hook by deleting its entry. Override per-invocation via documented env vars (`HARNESS_MERGE_OVERRIDE`, `HARNESS_HUB_OVERRIDE`, `HARNESS_PROTECTED_WRITE_OVERRIDE`).
- **Domains** (`professional/`, `personal/`, `finance/`, ...) — six example folders ship with the repo. The bootstrap interview asks you which to keep and which to delete; the patterns library shows how to add your own.

## Contributing

See [`CONTRIBUTING.md`](CONTRIBUTING.md) for how to propose changes, run the validation suite, and the weekly evolution ritual.

## License

MIT. See [`LICENSE`](LICENSE).

---

Built by [Daniel Scardini](https://github.com/DScardini91). Issues, PRs, and forks welcome.
