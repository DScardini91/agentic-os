# agentic-os

A template for building a personal operating system on top of Claude — agents, memory, rules, and conventions that turn an LLM into a real chief of staff rather than a generic assistant.

This repo is the **generic, sanitized version** of the architecture. Fork it and fill in the placeholders to instantiate your own.

## What this is

`agentic-os` is not an app. It's an architecture:

- **Agents** — specialized roles (COO, advisors, domain specialists, entity guardians, client/project agents) that route work
- **Memory** — structured files describing identity, decision rules, mandates, escalation paths
- **Rules** — non-negotiables, expansion sequences, output standards
- **Convention** — a single interface agent fronts everything; specialists never speak to the principal directly

## Architecture

```
Principal (CEO)
  └── Interface agent (COO — single point of contact)
        ├── Senior Advisor (refines internally, doesn't speak to principal)
        ├── Domain specialists (professional, personal, finance, ...)
        ├── Entity guardians (household, craft, travel)
        └── Client/Project agents
```

**Canonical flow:** Principal → Interface → specialists → Interface → Senior Advisor (when output carries weight) → Interface → Principal.

**Why a senior advisor that doesn't talk to the principal?** Because internal pressure-testing of recommendations is a different cognitive act than delivering them. Mixing those roles in one agent produces softer outputs.

**Why entity guardians (family-guardian, etc.)?** Some things are not resources to optimize — they are structural priorities. The guardian flags every proposal that quietly draws from that account.

## Repo layout

```
control-plane/
├── CLAUDE.md                    Primary orientation for any Claude instance
├── session-start.md             Bootstrap script for a fresh session
├── .claude/
│   ├── agents/                  Agent specifications
│   └── skills/                  Reusable workflows (capture-triage, meeting-to-work-items)
├── memory/
│   ├── self/                    Principal: personality, decision rules, boundaries, communication style
│   ├── <interface-agent>/       Interface agent: mandate, delegation, execution standards, reporting
│   └── <senior-advisor>/        Senior advisor: mandate, judgment model, escalation rules, personality
├── concepts/                    Reference frameworks (e.g., autoresearch)
├── meta/                        Meta-programs the system runs on itself
├── registry/                    Index files: agents, domains, clients
├── rules/                       Operating rules (e.g., post-mvp-expansion-directive)
└── templates/                   Project brief, weekly review, etc.

professional/  personal/  spiritual/  learning/  finance/  investments/
```

## Getting started

1. Fork or clone this repo
2. Read `control-plane/CLAUDE.md` and `control-plane/session-start.md`
3. Fill in `control-plane/memory/self/personality.md` with the principal's profile
4. Pick an interface-agent name and senior-advisor name; replace `<interface-agent>` / `<senior-advisor>` placeholders throughout
5. Stand up the first domain (recommended: Professional). Add one client and one project using `templates/project-brief-template.md`
6. Validate the loop end-to-end before adding more domains. The expansion sequence in `rules/post-mvp-expansion-directive.md` is the default order

## Source-of-truth split

| Category | Owner |
|---|---|
| Operational (projects, tasks, notes, reviews) | External system (Notion, Linear, etc.) |
| Structural / identity (rules, memory, agent specs) | This repo |
| Code | Git repos |
| Raw evidence | Original files |

## License

MIT (see `LICENSE`).
