# state — <agent-name>
_Updated: YYYY-MM-DD_

Live state of the agent. Read by the agent at invocation; written at end of execution. Not the spec (that lives in `.claude/agents/<agent>.md`) and not static memory (that lives elsewhere under `control-plane/memory/<agent>/`). This file holds what is open **now**.

Three continuous-state fields + a per-execution Handoff section. Keep it tight — if it grows past one screen, consolidate and archive.

## Open decisions
_Decisions waiting on principal input or a future event. Each one with origin date and what unblocks it._
- ...

## Active threads
_Work in progress that spans sessions. Includes owner (who moves it) and the concrete next step._
- ...

## Last update
_Timestamp of who updated and why. Only the most recent entry — this is not a changelog._
- YYYY-MM-DD — <agent or interface-agent> — <one-line reason>

---

## Handoff — last execution
_Replaced wholesale at end of each invocation. The interface agent reads this block to know what happened without rebuilding full context._

**Completed:**
- ...

**Not completed:**
- ...

**Blockers:**
- ...

**Open questions:**
- ...
