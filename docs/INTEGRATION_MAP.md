<div align="center">

# 🧭 Integration Map

### How agentic-os fits with the tools you already use.

[← README](../README.md) · [👤 Who is this for?](WHO_IS_THIS_FOR.md) · [🔒 Data and Privacy](DATA_AND_PRIVACY.md)

</div>

---

## TL;DR

agentic-os does **not replace** Notion, Linear, Outlook, ChatGPT, or whatever else you're using. It **complements** them by holding the layer they all leave empty: **your operating discipline across sessions**.

The split is consistent:

- **External systems** (Notion, Linear, Jira) hold **operational state** — active projects, tasks, meeting notes, statuses
- **agentic-os** holds **structural state** — identity, decisions, frameworks, governance
- **Claude Code** holds **execution** — the actual session where work gets done

---

## 🗺️ The big picture

```
┌─────────────────────────────────────────────────────────────┐
│                    Where YOU live                            │
│                                                              │
│  ┌──────────────────────┐    ┌─────────────────────────┐    │
│  │   External tracker    │    │      agentic-os         │    │
│  │  (Notion · Linear ·   │    │  (this repo on your     │    │
│  │   Jira · Asana)       │    │   local disk + fork)    │    │
│  │                       │    │                          │    │
│  │  • Active projects    │    │  • Identity + boundaries │    │
│  │  • Tasks + statuses   │    │  • Decision log          │    │
│  │  • Meeting notes      │    │  • Frameworks (canons)   │    │
│  │  • Stakeholder map    │    │  • Daily narrative logs  │    │
│  └──────────────────────┘    └─────────────────────────┘    │
│            │                            │                    │
│            └──────────────┬─────────────┘                    │
│                           ▼                                  │
│              ┌─────────────────────────┐                    │
│              │      Claude Code         │                    │
│              │  (the execution layer    │                    │
│              │   — where work happens)  │                    │
│              └─────────────────────────┘                    │
└─────────────────────────────────────────────────────────────┘
```

The OS reads from external trackers when needed (via MCP servers or by you pasting context). It writes back to your local files. **It never silently sends your tracker data to a third party.**

---

## 🔀 Surface-by-surface comparison

### Tasks and projects

| Tool | What it does | When to use |
|---|---|---|
| **Notion / Linear / Jira** | Active task lists, status tracking, calendars, kanbans | Day-to-day operational state — what's open, what's blocked, who owns what |
| **agentic-os** | Captures *decisions* about projects (scope changes, prioritization, allocation), not the tasks themselves | When a project-level decision happens that you'll need to remember in 3 months |

**Together:** Notion holds the kanban of your engagement; agentic-os holds the decision-log of strategic moves that shaped it.

### Notes and writing

| Tool | What it does | When to use |
|---|---|---|
| **Notion / Obsidian / plain markdown** | Long-form notes, knowledge base, drafts | Anything you'd want to search later by content — meeting notes, drafts, references |
| **agentic-os** | Captures *the discipline around writing* (conclusion-first rule, no-emdash for external, signaling layer for high-stakes) — not the notes themselves | When you're producing the artifact, the system shapes how |

**Together:** Your notes live in Notion; the system that shapes how you produce client-facing output lives in agentic-os.

### AI / chat assistants

| Tool | What it does | When to use |
|---|---|---|
| **ChatGPT Plus / Claude.ai web** | General-purpose conversation, quick lookups, one-off tasks | Anything that doesn't need persistent context — research, brainstorming, throwaway analysis |
| **agentic-os (via Claude Code)** | Persistent operator context across sessions — your voice, decisions, frameworks all auto-loaded | Anything that benefits from the system knowing who you are and what you've decided |

**Together:** ChatGPT for the throwaway question; Claude Code + agentic-os for the work that compounds.

> 💡 Most agentic-os operators **keep both**. Not every interaction with an LLM needs persistent context.

### Calendar and meetings

| Tool | What it does | When to use |
|---|---|---|
| **Outlook / Google Calendar** | Events, availability, scheduling | All scheduling — agentic-os does not replace this |
| **agentic-os** | Entity guardians fire when proposed meetings violate declared structural priorities; meeting-close skill extracts work items after the fact | Pre-meeting (guardian check) and post-meeting (extract decisions to log) |

**Together:** Outlook holds the calendar; entity guardians veto silently when a proposed slot would compress protected time; post-meeting, the OS extracts the decisions you made.

### Email

| Tool | What it does | When to use |
|---|---|---|
| **Outlook / Gmail** | Inbox, threading, filters | All email — agentic-os does not replace this |
| **agentic-os** | `email-intake` skill processes captures arriving via email; decisions extracted from threads can be logged via `decision-log-entry` | Triage of forwarded content, capture of decisions made in email threads |

**Together:** Email lives in your client; the OS provides intake patterns for the captures that matter.

### Code repositories

| Tool | What it does | When to use |
|---|---|---|
| **GitHub / GitLab / etc.** | Your actual code, PRs, issues, CI | All your engineering work |
| **agentic-os** | Captures decisions ABOUT code (architectural calls, design trade-offs, deferred items) in the decision-log; `pr-review` skill runs structured reviews; hook layer enforces no-direct-merges to main on protected repos | Decision capture, code review discipline, governance |

**Together:** Code lives in GitHub; the discipline of how you make decisions about it lives in agentic-os.

### Document storage

| Tool | What it does | When to use |
|---|---|---|
| **OneDrive / Drive / Dropbox** | File storage, sharing, sync | All file storage |
| **agentic-os** | Markdown-only, lives in your local repo. No file storage layer. | Never — agentic-os is not a file storage |

**Together:** Files live in OneDrive; the operating context about them lives in agentic-os.

---

## 🧩 Common operator setups

### Setup A — The minimalist

- **Operational:** Notion (tasks, projects, notes) + Outlook (calendar/email)
- **Structural:** agentic-os (decisions, frameworks, identity)
- **Execution:** Claude Code

**Result:** One tracker, one calendar, one OS. Everything else is layered on top.

### Setup B — The engineer-leaning operator

- **Operational:** Linear (tasks) + GitHub (code) + Obsidian (notes)
- **Structural:** agentic-os + GitHub fork for the OS itself
- **Execution:** Claude Code + occasional ChatGPT Plus for throwaway research

**Result:** Engineering workflow integrated; OS lives next to code.

### Setup C — The senior consultant

- **Operational:** OneDrive (docs) + Outlook (calendar/email) + Notion (personal)
- **Structural:** agentic-os in a private GitHub fork
- **Execution:** Claude Code with regulated-sector posture (memory/daily and memory/decisions gitignored, local only)

**Result:** Confidentiality preserved; system runs locally; operator gets compounding benefit without compliance risk.

### Setup D — The founder / executive

- **Operational:** Linear (team tasks) + Notion (personal) + Slack (team)
- **Structural:** agentic-os with multiple custom canons + orchestrator agents
- **Execution:** Claude Code (deep) + ChatGPT Plus (light)

**Result:** Strategic discipline scales with the role; orchestrator handles recurring high-stakes decisions.

---

## 🚫 What agentic-os explicitly does NOT do

These are not gaps to be filled. They are deliberate non-features:

- **No file sync.** Use OneDrive / Drive / iCloud / git for files.
- **No team task management.** Use Linear / Jira / Asana.
- **No calendar/scheduling.** Use Outlook / Google Calendar.
- **No email client.** Use Outlook / Gmail.
- **No Slack/Teams.** Use those.
- **No mobile app.** This lives on your dev machine. Mobile is on the v3+ horizon, no commitment.
- **No general AI chat.** Use ChatGPT / Claude.ai web for that.

When you see something agentic-os doesn't do that your existing tool does — keep using your existing tool. The OS is for the layer they all leave empty.

---

## 🔌 Optional integrations (if you want them)

These work via MCP servers (Model Context Protocol — Claude Code's plugin system):

- **Notion MCP** — read/write your Notion workspace from sessions
- **GitHub MCP** — read PRs, issues, repos
- **Outlook MCP** — read calendar and email
- **Filesystem MCP** — read/write your local files outside the repo

These are not bundled with agentic-os. You install them separately into Claude Code. The OS provides skill patterns (`email-intake`, `meeting-close`) that work well with these MCPs once they're connected.

---

<div align="center">

*The OS doesn't replace your stack. It holds the layer your stack leaves empty.*

</div>
