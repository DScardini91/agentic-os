---
name: eod
description: End of day — finalizes today's log, updates the task backlog, reconciles external trackers, and previews tomorrow's first priority.
triggers:
  - "/eod"
  - "fim do dia"
  - "fechando o dia"
  - "end of day"
  - "wrapping up"
  - "done for today"
---

# Skill: eod

## Purpose
Close the day cleanly so tomorrow starts with context, not archaeology.

## Steps

1. **Collect what happened**
   - Ask the principal (if not already told): what got done, what didn't, any decisions made, anything that changed.
   - Read today's `control-plane/memory/daily/YYYY-MM-DD.md` for what was logged through the day.

2. **Delegate to `work-logger`**
   - Finalize today's daily log: fill "Done today", "Decisions made", "Carried to tomorrow" sections.
   - Update `control-plane/memory/tasks/backlog.md`: check off completed tasks, re-rank, add new ones, move stale P0s.
   - Update status on any affected project files.

3. **Development evidence capture**
   - If anything today was clear evidence on a development objective (good or missed), note it in the daily log "Reflections" section and add to the evidence log in `control-plane/memory/development/objectives.md`. Keep it factual and specific.

4. **Friday trigger**
   - If today is Friday and the weekly retro has not happened, offer to run it now: "Quer rodar o retro semanal antes de fechar?"

5. **Deliver EOD recap** (3-4 lines max)
   - What got done
   - What moved or changed
   - Tomorrow's first priority

---

## Rules
- Keep the recap short. The principal is done for the day.
- Do not re-explain everything in the log — just the highlights.
- Evidence capture for development objectives should be concrete: a specific moment, not a generalization.
