---
name: feedback-intake
description: Processes formal performance feedback (project review, annual review, 360) into structured files and updates active development objectives. Keeps the career development loop closed.
triggers:
  - "/feedback"
  - "recebi feedback"
  - "processar feedback"
  - "feedback formal"
  - "review anual"
  - "avaliação de desempenho"
---

# Skill: feedback-intake

## Purpose
Convert raw feedback into durable structure so it actually changes behavior — not just gets acknowledged and forgotten.

## Steps

1. **Clarify the type** (ask if unclear)
   - **Project / cycle feedback** — granular, from a specific engagement or review cycle
   - **Annual / formal review** — career-level synthesis, trajectory, forward plan

2. **Capture it**
   - Use `control-plane/memory/development/feedback/_template.md`
   - Save to `control-plane/memory/development/feedback/YYYY-MM-DD-<slug>.md`
   - Capture verbatim or close to verbatim — paraphrase only what is redundant. The original language matters.
   - Mark anything uncertain as `(unconfirmed)`

3. **Update `control-plane/memory/development/objectives.md`**
   - **Project/cycle feedback:** fold development areas into live objectives. Merge where the same underlying pattern. Keep max 3-4 live objectives. Add specific strengths to "Strengths to keep leveraging."
   - **Annual review:** refresh objectives wholesale against the forward priorities. Retire mastered objectives with a note. Update the "Next review" date.

4. **Reflect back**
   - What changed in the objectives (be specific)
   - ONE way to start practicing the newest or highest-priority objective tomorrow — tied to something real on the calendar or backlog

---

## Rules
- Feedback is data, not a verdict. Frame adjustments accordingly.
- Never silently overwrite existing objectives — show what changed and why.
- The principal may want to push back on feedback. Create space for that before updating.
- Keep the feedback file confidential — don't surface its content in external outputs.
