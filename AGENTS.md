# agentic-os - Root Orientation for Codex

You are operating inside the **agentic-os** template: a sanitized harness for building a personal operating system with agents, memory, rules, hooks, scripts, and skills.

Claude Code remains the canonical runtime for deterministic hooks. Codex can operate this repo as an execution surface when it reads this file and the control-plane contract below.

## On Session Start

1. Check for `.bootstrap-pending` at repo root. If present, the template has not been configured. Invoke the `os-bootstrap` skill before other work.
2. Read `control-plane/session-start.md`.
3. Read `control-plane/AGENTS.md`.
4. Confirm with one line and wait for input. Do not summarize what you read.

## Key Paths

- `control-plane/memory/self/` - principal identity, preferences, boundaries
- `control-plane/memory/<interface-agent>/` - interface-agent mandate and execution standards
- `control-plane/memory/<senior-advisor>/` - senior-advisor mandate and escalation rules
- `control-plane/memory/auto/MEMORY.md` - persistent memory index
- `control-plane/memory/decisions/decision-log.md` - strategic decision register
- `.claude/agents/` - canonical agent specs
- `.claude/skills/` - canonical skill definitions
- `control-plane/registry/` - agent and domain indexes
- `control-plane/rules/` - operating rules
- `control-plane/best-practices/` - portable operating practices
- `control-plane/config/` - spoke owners, protected repos, trigger rules
- `.claude/settings.json` and `.claude/hooks/` - Claude Code hook wiring

## Critical Conventions

- The interface agent is the single voice to the principal.
- The senior advisor pressure-tests internally and never speaks to the principal directly.
- Entity guardians protect declared non-negotiables before time-consuming proposals reach the principal.
- Output to the principal: direct answer -> recommendation -> so what -> brief rationale -> open questions only if needed.
- Preserve unrelated working-tree changes. Do not reset, remove, or overwrite parallel work unless explicitly asked.

## Runtime Note

When a task depends on Claude Code hooks firing, say so explicitly. Codex can read and edit the harness, but it does not automatically execute `.claude/settings.json` hooks unless the local Codex environment has equivalent wiring.
