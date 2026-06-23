---
name: reference_notion_workspace
description: Example reference memory — pointer to where operational state lives outside the repo. Notion / Linear / Jira / Asana / wherever the operator tracks tasks.
type: reference
---

# Example reference — Notion workspace

**Where to look:** Operational state (active projects, tasks, meeting notes, decisions in flight) lives in the principal's Notion workspace at `notion.so/<workspace>` (the operator fills in the real URL during bootstrap or after).

**What lives there vs here:**

| Category | Owner |
|---|---|
| Active projects, tasks, weekly reviews, notes | Notion (operational, time-sensitive) |
| Identity, decision rules, agent specs, memory, hooks | This repo (structural, slow-changing) |
| Code | Git repos |
| Raw evidence | Original files / attachments |

**When to query Notion:**
- Looking up the current state of a project ("what's blocking ACME?").
- Finding meeting notes from a past week.
- Checking task ownership and status.

**When NOT to query Notion:**
- Anything about *how* the principal operates (that lives in `control-plane/memory/`).
- Architectural decisions (those live in `decision-log.md`).
- Daily narrative (`memory/daily/*.md`).

The interface agent uses the Notion MCP server (when authenticated) to read/write. The `professional-chief-of-staff` agent is the primary consumer.

> Replace this example with your own tracker reference (Linear, Jira, Asana, GitHub Projects, plain markdown). The shape is the same — point at the external system, declare what lives there vs here.
