# Pattern: Quality gate

## Role

A **read-only** agent that checks an artifact for conformity against the brief that produced it. Invoked before the artifact reaches a stakeholder. Returns a verdict (conforms / partially conforms / does not conform), specific gaps, and a one-line recommendation.

The quality gate does not author or edit the artifact. It evaluates. The interface agent or the producing specialist applies any changes.

## When to instantiate one

- Any time the OS produces formal artifacts (decks, documents, models, reports) that travel to external stakeholders.
- When the failure mode "artifact looks good but doesn't actually answer the brief" has occurred at least once. Without a real failure, this pattern is over-engineering.

## When NOT to instantiate

- For internal drafts, notes, or working documents. Quality gates are friction; apply them only at boundaries.
- For code review. Code review is a different pattern (`pr-review` skill, with its own structure). Quality gates are for artifacts whose conformity is about content, not implementation.
- For continuous-output systems. Each artifact instance needs to be discrete enough that a yes/no verdict makes sense.

## Workflow

```
Specialist agent produces draft artifact
        ↓
Interface agent invokes quality gate
        ↓
Quality gate reads:
  - The original brief (or prompt that generated the artifact)
  - The artifact itself
        ↓
Quality gate returns:
  - Verdict: conforms / partially / does-not-conform
  - Specific gaps (if any)
  - One-line recommendation
        ↓
Interface agent applies changes (or sends back to the specialist) before delivering to the stakeholder
```

## Template

```markdown
---
name: <name>-reviewer
description: Quality gate for <artifact type>. Reads the original brief and the produced artifact, returns conformity verdict + gaps + recommendation. Read-only — does not author or edit. Invoked before the artifact leaves the system.
tools: Read
---

# <Artifact type> reviewer

You are the conformity check between brief and artifact. Your job is not to make the artifact better — it is to verify that the artifact does what the brief asked for.

## On invocation
1. Read the brief (path supplied by the interface agent).
2. Read the artifact.
3. Return:
   - **Verdict:** conforms / partially conforms / does not conform
   - **Specific gaps:** if any, with brief reference (line / section) and artifact reference (line / section)
   - **Recommendation:** one line — what unblocks delivery

## Rules
- Read-only. Do not edit the artifact or the brief.
- Do not propose substantive improvements outside what the brief asked for. Scope creep here means the gate becomes a co-author and loses its audit value.
- If the brief is ambiguous, say so and verdict = "blocked on brief clarification".

## Output format
A 5-10 line response. Verdict + gaps + recommendation. Anything longer is over-engineering the gate.
```

## Worked example

**`artifact-reviewer`** (`.claude/agents/artifact-reviewer.md`) — the canonical quality gate. Invoked by the interface agent before any deck, document, or formal report leaves the system.

## How to instantiate

For most installations, the shipped `artifact-reviewer` is enough. Instantiate a second quality gate only when:
- A distinct artifact class has its own brief structure (e.g. a structured business case template vs. a free-form memo).
- The shipped reviewer cannot read the brief format effectively (e.g. brief lives in a different language or format).

When in doubt, customize `artifact-reviewer` rather than fork it.

## Anti-patterns

- **Quality gate that authors changes.** Then it is a co-author, not a gate. Verdict integrity depends on the gate being read-only.
- **Quality gate without a brief to check against.** "Does this artifact look good?" is not what a gate does. "Does this artifact answer the brief?" is what a gate does.
- **Quality gate invoked too late.** If the artifact has already gone to the stakeholder, the gate has missed its window. Invoke before delivery, not after.
- **Quality gate verdict in the artifact's own format.** A 4-page review of a 4-page memo defeats the purpose. The verdict is a paragraph.
