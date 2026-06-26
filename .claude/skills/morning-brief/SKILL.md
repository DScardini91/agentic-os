---
description: Start the day — reads the brain, pulls calendar and email digest, and delivers a single prioritized briefing with a development nudge tied to today's actual agenda.
triggers:
  - "bom dia"
  - "good morning"
  - "/morning"
  - "começa o dia"
  - "brief do dia"
  - "morning brief"
---

# Skill: morning-brief

## Purpose
One crisp briefing that replaces the "where do I even start?" moment at the top of the day.

## Steps

1. **Read the brain silently**
   - `control-plane/memory/self/` — who the principal is, working style, protected time
   - `control-plane/memory/tasks/backlog.md` — task list and priorities
   - Last 2 `control-plane/memory/daily/` logs — open threads, carried items
   - Active `control-plane/memory/projects/` files referenced in recent logs
   - `control-plane/memory/development/objectives.md` — active development objectives

2. **Delegate in parallel**
   - `briefing-analyst` — pull today's calendar + important email/inbox items. Pass brain context (active projects, key stakeholders). Note if external connectors are not authenticated and continue without.
   - `work-advisor` — ranked prioritization for today. Pass brain context + whatever briefing-analyst returns.

3. **Open today's daily log**
   - Delegate to `work-logger` to create `control-plane/memory/daily/YYYY-MM-DD.md` from `_template.md` if it doesn't exist. Pull "Carried to tomorrow" from yesterday's log.

4. **Synthesize ONE briefing** (structure below)

---

## Output structure

**Today's shape** — key meetings, hard deadlines, energy map for the day

**Top 3 priorities** — each with a one-line "why this first"

**Watch-outs** — anything slipping, anyone waiting on the principal, sensitivities to manage

**Development nudge** — ONE concrete moment today that is a practice rep for an active development objective. Tie it to a real calendar event or task, never generic. If no objective exists, skip.

**First move** — the single thing to start with right now

---

## Rules
- The entire output is one response. No back-and-forth before delivering it.
- Development nudge must be specific and observable. "Be more strategic" is not a nudge. "The 14:30 kickoff is your rep for 'drive the room' — open with your POV before opening the floor" is.
- If external connectors are unavailable, deliver the briefing from local memory only and note what is missing.
- Log the plan in today's daily log before closing.
