---
name: os-bootstrap
description: Configure agentic-os on a fresh clone — one-shot interview (5 questions, ~5 min), then automatic setup. Triggers on .bootstrap-pending detection or any "set up / bootstrap" request.
version: 2.0
category: bootstrap
triggers:
  - "set up the os"
  - "bootstrap the agentic-os"
  - "configure the system"
  - "fresh fork"
  - ".bootstrap-pending detected"
  - "/setup"
  - "/bootstrap"
---

# os-bootstrap

One-shot setup skill. Five questions, one response from the operator, then automatic configuration. Total time: ~5 minutes.

No blocks. No progress tracking. No shell scripts to run first — this skill handles prerequisites inline.

---

## Step 1 — Prepare the environment (silent, automatic)

Before asking anything, do this silently:

```bash
# make hooks and scripts executable
chmod +x .claude/hooks/*.sh 2>/dev/null || true
chmod +x control-plane/scripts/*.sh 2>/dev/null || true
chmod +x control-plane/scripts/*.py 2>/dev/null || true
chmod +x scripts/*.sh 2>/dev/null || true

# prime routing caches (non-blocking on failure)
python3 control-plane/scripts/compile-skill-routing.py 2>/dev/null || true
python3 control-plane/scripts/compile-concept-routing.py 2>/dev/null || true
```

If chmod or python3 are unavailable, note it but continue — the harness degrades gracefully.

---

## Step 2 — Ask five questions in ONE message

Send a single message with all five questions. Do not split into multiple turns.

```
Welcome. Five quick questions and the system configures itself.

1. Your name (and how you want to be addressed)
2. Your role / context — e.g. "consultant at BCG", "indie founder", "engineering lead at startup"
3. Communication style — pick one or describe your own:
   A) Conclusion first, terse, no preamble
   B) Walk through the reasoning, then the answer
   C) Match the situation
   And: anything I should never do? (e.g. no profanity, no em-dash, no second-person "você")
4. Agent names — keep the defaults (kowalski / walter) or choose your own?
   If custom: what should I call your main agent and your internal pressure-tester?
5. Active domains — which areas do you want this OS to cover?
   Examples: work / personal / finances / learning / health / spiritual
   You can say "all the examples" or list your own.

Answer however feels natural — one line per question is enough.
```

---

## Step 3 — Parse and execute (all automatic, no further Q&A)

With the operator's answers, do the following in order:

### 3a. Populate memory/self/

Write these files from the answers (use the template shapes already in the repo):

- `control-plane/memory/self/personality.md` — name, role, context, cognitive style
- `control-plane/memory/self/communication-style.md` — conclusion-first preference, length, tone
- `control-plane/memory/self/boundaries.md` — never-dos, hard limits
- `control-plane/memory/self/decision-rules.md` — any rules volunteered ("I always X before Y")

Also write `control-plane/memory/auto/user_profile.md`:
```yaml
---
type: user
description: Operator profile — name, role, context
---
```
With a short paragraph summarizing who the operator is.

### 3b. Resolve agent names

Default: `kowalski` (interface) and `walter` (senior advisor). If the operator chose different names, replace across:

- `CLAUDE.md` (root)
- `control-plane/CLAUDE.md`
- `control-plane/session-start.md`
- `control-plane/config/spoke-owners.yaml`
- `control-plane/config/triggers.yaml`
- `control-plane/registry/agents.md`
- All `.claude/agents/*.md` files that reference the old names

Rename memory folders if names changed:
- `control-plane/memory/kowalski/` → `control-plane/memory/<interface-agent>/`
- `control-plane/memory/walter/` → `control-plane/memory/<senior-advisor>/`

### 3c. Activate domains

For each domain the operator wants active:

1. If it's one of the six example folders (`professional/`, `personal/`, `finance/`, `investments/`, `learning/`, `spiritual/`) — keep it, update `domain.md` with a one-line scope description.
2. If the operator named a custom domain not in the examples — create `<slug>/domain.md` with scope and vocabulary.
3. Remove example folders the operator does NOT want: `rm -rf <folder>`. Remove their rows from `control-plane/CLAUDE.md` and `spoke-owners.yaml`.

Do NOT ask permission for each domain. Do the right thing from the answers, then confirm in Step 4.

### 3d. Write the first decision-log entry

Append to `control-plane/memory/decisions/decision-log.md`:
```
## D-001 — os-bootstrap complete
Date: YYYY-MM-DD
Operator: <name>
Active domains: <list>
Agent names: <interface>/<senior-advisor>
```

### 3e. Remove the sentinel

```bash
rm .bootstrap-pending
```

---

## Step 4 — Confirm in one message

One response to the operator:

```
Done. Here's what was configured:

- Name: <name>
- Domains: <list>
- Main agent: <interface-agent> | Pressure-tester: <senior-advisor>
- Communication: <one-line style summary>

You're live. Try: "what should I work on today?" or just tell me what's on your mind.
```

No listing of every file written. No explaining what placeholders were resolved. Just the outcome.

---

## Failure modes

**python3 not found:** skip routing compilation, note it in `memory/auto/MEMORY.md` ("routing compilers not available — install python3 to enable skill/concept routing"). Bootstrap continues.

**Operator answers ambiguously:** make the sensible default call, state what you chose in Step 4, and move on. Do not loop back to ask again.

**Operator wants to restart:** `touch .bootstrap-pending` and re-invoke. Existing memory files will be overwritten.

---

## What NOT to do

- Do not run `install.sh` — this skill replaces that step for standard setup.
- Do not split into multiple Q&A turns before configuring. One question batch, one answer, then execute.
- Do not ask the operator to confirm each file write. Confirm the outcome, not the process.
- Do not push to remote during bootstrap — that is the operator's call.
