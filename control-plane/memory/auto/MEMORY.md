# Memory Index

_This file is the index for the auto-memory tier. The interface agent reads it on every session start to load persistent context about the principal — who they are, how they want to collaborate, current project state, and external references._

_Each entry below is a one-line pointer to a memory file in this directory. The interface agent loads the full file on demand when the entry's hook matches the active task._

## Foundational
_(populated by os-bootstrap interview and ongoing operation)_

## User & relationships
- [User profile](user_profile.md) — _filled by os-bootstrap_

## Communication & working style
_(filled by os-bootstrap based on interview answers)_

## System & operating
_(filled by os-bootstrap)_

## Project context
_(populated organically as the principal works through projects)_

## References
_(external systems: trackers, dashboards, notion workspaces, slack channels — populated on first mention)_

---

## Memory tier conventions

**Memory types** (lead with one of these in each file's frontmatter):

| Type | When to write |
|------|---------------|
| `user` | New facts about the principal's role, preferences, knowledge |
| `feedback` | Corrections OR validated approaches (always record the **why**) |
| `project` | Who is doing what, by when, with what motivation (absolute dates) |
| `reference` | Pointers to external systems and what lives there |

**What NOT to save:** code patterns (read the code), git history (use `git log`), debugging recipes (the commit message has context), CLAUDE.md content, ephemeral task state.

**File format:**

```markdown
---
name: <memory name>
description: <one-line description used for relevance matching>
type: <user | feedback | project | reference>
---

<body — for feedback/project, structure as: rule/fact + **Why:** line + **How to apply:** line>
```

**Index discipline:** entries here are one-liners under ~150 chars. Lines past 200 may be truncated when the index is auto-injected into context, so keep this file concise.
