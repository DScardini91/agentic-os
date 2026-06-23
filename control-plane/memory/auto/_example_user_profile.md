---
name: user_profile
description: Example user memory — what the principal does, what they're focused on, what level of expertise they expect Claude to assume. Replace with your own during or after os-bootstrap.
type: user
---

# Example user profile

> This is a worked example, not your real profile. The `os-bootstrap` skill creates a real one from your interview answers. Once that exists, this file can be deleted (it has a leading underscore so it sorts to the top of the directory).

Sample shape an operator might write after the interview:

- **Role:** Senior consultant at a strategy firm, focused on AI-enabled transformations for large enterprises.
- **Current focus:** Three active client engagements; one personal thought-leadership series; one open-source side project.
- **Expected expertise:** Treat me as a senior practitioner. Don't explain what a Pyramid Principle is. Do explain why a specific recommendation deviates from a canonical framework.
- **Tools I touch daily:** Claude Code, GitHub, Notion (operational tracker), VS Code, terminal.
- **Communication languages:** English (work), Portuguese (personal, family).

**Why this file matters:** the interface agent reads this every session. Without it, every response is calibrated for a generic user, which is wrong by default for any operator who's serious about their work.

## How to update

- After a real signal (you correct Claude on something, or you state a preference explicitly), the interface agent updates this file directly.
- Periodic review during the weekly evolution ritual catches drift.
