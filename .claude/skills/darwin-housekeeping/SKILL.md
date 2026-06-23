---
name: darwin-housekeeping
description: Lightweight housekeeping pass over the OS repo. Distinct from Darwin's deep mode — no full health report, no senior-advisor pass. Covers TTL compaction, state drift, agent coverage, git status, and pending-changes scan. Invokable manually or via daily scheduled run.
triggers:
  - "run housekeeping"
  - "tidy the repo"
  - "darwin housekeeping"
  - "/darwin-housekeeping"
---

# Skill: darwin-housekeeping

## When to use
- A light "tidy-up" of the repo is wanted without a full governance pass.
- Accumulated work in the repo may be stale (state files, scratchpads).
- Preparation before an intense work session.
- Triggered automatically via a daily scheduled run.

## Difference from other Darwin modes

| Mode | Frequency | Cost | Output | Senior advisor? |
|---|---|---|---|---|
| Light (Stop hook) | Every session | ~0.5 min | Append jsonl | No |
| **Housekeeping** | **Daily / on-demand** | **~3 min** | **Triage table** | **No** |
| Deep (weekly pass) | Weekly | ~15 min | Health Report + proposals | Yes |

## Architecture

```
/darwin-housekeeping
  ↓
Agent(darwin) — housekeeping mode
  ├── bash: memory-ttl-compaction.sh
  ├── bash: state-drift-check.sh
  ├── git status (Read-only audit)
  ├── agent coverage scan (.claude/agents/ × control-plane/memory/)
  ├── canon-recheck-due sweep
  └── triage report
  ↓
Interface agent → summary to principal (only if there are FLAGS — silent if all PASS)
```

## Protocol

When Darwin is invoked in this mode, follow this checklist in order:

### 1. TTL Compaction
```bash
bash control-plane/scripts/memory-ttl-compaction.sh
```
Output: count of scratchpads removed + state files reset.

### 2. State drift check
```bash
bash control-plane/scripts/state-drift-check.sh
```
Output: agents with stale `state.md` mtime but recent activity in commits / agent-calls.

### 3. Git status
```bash
git status --short
git log --oneline -5
```
Flag uncommitted changes. Do not commit — that is the responsibility of a separate daily-commit job, not housekeeping.

### 4. Agent coverage audit
List `.claude/agents/*.md` and cross-check with `control-plane/memory/*/state.md` or `control-plane/agent-state/*.md`:
- Agent present in `.claude/agents/` but no state.md → FLAG.
- Exception: read-only agents (typically the senior advisor and entity guardians) do not need their own state.md — the interface agent maintains theirs.

### 5. Canon re-check sweep
```bash
bash control-plane/scripts/canon-recheck-due.sh
```
Lists items in `learning/canon/*-self-audit.md` with `Re-check: YYYY-MM-DD` ≤ today + 7d. Each due item is a FLAG.

**Anti-anchor rule:** when re-checking, Darwin must read the canon (not the prior audit) and re-derive status from scratch.

## Output format

Darwin produces a short triage table:

```
## Darwin Housekeeping — YYYY-MM-DD

| Check | Status | Detail |
|---|---|---|
| TTL compaction  | ✅ / ⚠️ N items | [scratchpads removed / state files reset] |
| State drift     | ✅ / ⚠️ N drifted | [agents] |
| Git status      | ✅ clean / ⚠️ | [uncommitted files] |
| Agent coverage  | ✅ / ⚠️ N missing state | [agents lacking state.md] |
| Canon re-check  | ✅ / ⚠️ N due | [items] |

Flags to address: N
```

**Silence rule:** if all checks PASS (zero flags), Darwin updates `state.md` and produces no output. The interface agent does not forward anything.

**Escalation rule:** if ≥ 3 flags or 1 ALERT → Darwin notes it in `state.md` as an item for the next deep mode. Does not trigger deep mode automatically.

## Update darwin/state.md

At the end, Darwin replaces the "Handoff — last execution" block with:
```
**Date:** YYYY-MM-DD
**Mode:** housekeeping
**Flags found:** N
**Items compacted:** N scratchpads, N state resets
**Note:** [only if anything notable]
```

## Cost estimate
~3 min · ~2.5k tokens (script execution + triage without analytical synthesis)

## Do NOT do in this mode
- Do not produce a full health report — that is deep mode.
- Do not pass through the senior advisor — housekeeping is operational, not strategic.
- Do not commit changes — that is a different job.
- Do not open structural proposals — note them in `state.md` for the next deep mode.
- Do not escalate to the principal if all checks pass.
