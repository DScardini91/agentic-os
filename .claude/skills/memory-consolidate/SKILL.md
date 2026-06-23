---
name: memory-consolidate
description: Reflective pass over the auto-memory tier. Surveys daily logs, decision-log entries, and recent agent invocations from the last N days, identifies durable facts that should persist as auto-memories, and proposes additions, updates, or deletions to MEMORY.md. The mechanism that keeps the auto/ tier alive.
triggers:
  - "consolidate memory"
  - "memory pass"
  - "what should be remembered"
  - "review auto memory"
  - "memory weekly review"
---

# Skill: memory-consolidate

## Preconditions

- `control-plane/memory/auto/MEMORY.md` exists (created by os-bootstrap).
- The system has at least 7 days of activity (daily logs, decision-log entries, agent calls). Without accumulated signal, consolidation is speculation.
- The operator is available for confirmation — this skill proposes; it does not silently rewrite memory.

## When to use

- Weekly evolution ritual (alongside Darwin deep mode).
- After a milestone (project closure, sprint end) when patterns crystallized.
- When the operator notices "I've been correcting Claude on the same thing repeatedly" — that signal belongs in auto-memory.
- When `auto/` has been static for > 30 days and the system has been active.

NOT for:
- Adding a specific fact the operator wants saved right now → direct edit + decision-log if structural.
- Cleaning up stale memories without new signal → drift correction, different shape.
- Operating-state context (active threads, current sprint) → that's `state.md`, not auto-memory.

## Input contract

```yaml
window_days: int               # default 7 — how far back to scan
include_dailies: bool          # default true
include_decision_log: bool     # default true
include_agent_calls: bool      # default true — needs PostToolUse hook populated
include_fires: bool            # default false — too noisy unless a specific pattern is suspected
domain_focus: str | None       # default null = all domains
```

## Output contract

```yaml
proposals: list[Proposal]      # ≤ 5 additions / updates / deletions
  # each: {action, target, body, why, confidence}
unchanged_baseline: list[str]  # 3-5 things that did NOT need change — sanity check
review_summary: str            # one paragraph TL;DR
```

## Sequence

### Step 1 — Read the inputs
- `control-plane/memory/daily/*.md` — last `window_days` files
- `control-plane/memory/decisions/decision-log.md` — entries with date in window
- `control-plane/memory/observability/agent-calls.jsonl` — filter by `ts >= window_start`
- `control-plane/memory/auto/*.md` — current auto-memory inventory

### Step 2 — Detect patterns
For each candidate signal, check whether it should become or update an auto-memory:

| Signal | Memory type to consider |
|---|---|
| Recurring correction in dailies ("Claude opens with preamble") | `feedback` |
| Stable fact about the operator ("works at X, focus is Y") | `user` |
| Active project with multi-week duration + clear deadline | `project` |
| Repeated pointer to an external system (Notion DB, Slack channel) | `reference` |

### Step 3 — Apply the duplicate test
For each proposed addition:
- Is there already an auto-memory covering this? → update, don't duplicate.
- Is the signal observed only once in the window? → defer, not enough evidence.
- Is the signal structural ("I prefer X") or ephemeral ("today X was tricky")? → only structural earns persistence.

### Step 4 — Apply the staleness test
For each existing auto-memory:
- Last touched > 60 days ago? → flag for re-confirmation.
- Contradicted by recent signal? → flag for update.
- Project-type memory with past deadline? → flag for removal or archival.

### Step 5 — Generate proposals (≤ 5)
Each proposal:
- **Action:** `add` / `update` / `remove`
- **Target:** file path (existing or proposed)
- **Body:** the actual memory content (frontmatter + body, ready to paste)
- **Why:** what signal in the window triggered this
- **Confidence:** `high` (multiple signals) / `medium` (one strong signal) / `low` (defer if not high)

### Step 6 — Present + confirm
Show all proposals to the operator. Wait for confirmation per proposal:
- ✅ apply
- ✏️ apply with edit
- ❌ reject (don't repropose unless new signal)

### Step 7 — Apply
- Write or update files per confirmation
- Update `MEMORY.md` index — add a line for each new file, remove lines for deleted files
- Log a decision-log entry if any proposal is structural (`type: methodology` or `architecture`)

## Anti-patterns

- **Acting without operator confirmation** — auto-memory is the operator's voice persisted. Silent rewrites erode trust.
- **Proposing > 5 changes** — review fatigue degrades signal. If 5 doesn't cover it, do another pass next week.
- **Promoting one-time signals** — auto-memory is for stable facts. Run-of-the-mill observations belong in dailies.
- **Forgetting the staleness pass** — additions without subtractions bloat the tier into shelfware.

## Relationship to Darwin

Darwin deep mode reads the auto-memory tier when synthesizing OS health proposals. A healthy `memory-consolidate` cadence (weekly or biweekly) keeps Darwin's input fresh. If `memory-consolidate` hasn't run in > 30 days, Darwin will flag it as a coverage gap.
