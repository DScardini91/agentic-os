---
name: meeting-to-work-items
description: Convert a meeting note into structured work items — tasks (with owners), decisions (verbatim when literal), follow-ups, and participant list. Atomic skill; consumed by meeting-close orchestrator or invoked directly.
triggers:
  - "extract work items"
  - "process meeting notes"
  - "convert this meeting"
  - "what came out of this meeting"
---

# Skill: meeting-to-work-items

## Purpose
Convert a meeting note into operational work items — tasks, decisions, project updates.

## Steps
1. Read the meeting note
2. Extract decisions
3. Extract tasks with owner, due date, linked project
4. Extract follow-ups
5. Update project state if needed
6. Update note maturity → operationalized
7. Report back
