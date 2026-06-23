# Daily logs

Files in this directory follow the naming pattern `YYYY-MM-DD.md` (or `YYYY-MM-DD-<suffix>.md` for ancillary same-day documents like `YYYY-MM-DD-meetings.md`).

The `inject-recent-dailies.sh` SessionStart hook injects the last 2 chronological daily logs into every session's context. Daily logs are narrative digests — operational state lives in your tracker (Notion, Linear, Jira), not here.

## What goes in a daily log

- What was actually worked on (not what was planned)
- Decisions made and why
- Surprises, friction, things learned about the principal or the work
- Pointers to commits, PRs, artifacts produced

## What does NOT go here

- Detailed task lists (use the tracker)
- Reproductions of meeting notes (those have their own format)
- Sensitive credentials, client-confidential material (this folder is committed)

## Lifecycle

Files older than ~6 months can be pruned manually or compressed into a monthly summary. There is no automated TTL for daily logs by default — they accumulate as narrative history.
