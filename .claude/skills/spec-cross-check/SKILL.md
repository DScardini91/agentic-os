---
name: spec-cross-check
description: Diff between implemented code and the canonical spec — identifies drift (code does more/less/differently than spec), categorizes by severity, suggests spec amendments or code corrections. Antidote to "implementation creep" — code growing past what the spec actually licenses.
triggers:
  - "spec cross-check"
  - "is the code matching the spec?"
  - "look at implementation vs spec"
  - "spec drift?"
---

# Skill: spec-cross-check

## When to use

Before merging a PR for a substantive feature, or when drift is suspected between the canonical spec (e.g. `docs/harness/specs/<module>.md`) and the implementation (e.g. `src/<module>/`).

NOT for:
- Purely technical code review → use `pr-review`.
- Validating business logic with data → notebook in the repo.
- New methodological decision → `decision-log-entry`.

---

## Inputs

- **`spec_path`** (required) — path to the canonical spec.
- **`code_path`** (required) — directory of the implementation.
- **`mode`** (optional) — `"quick"` (5 high-level dimensions) or `"deep"` (each acceptance criterion checked individually).

---

## Sequence

### Step 1 — Read the canonical spec

Identify and extract:
- **Goal** — what the module / feature must produce.
- **Acceptance criteria** — verifiable tests (verbatim when stated).
- **Output schema** — expected fields, types.
- **Locked premises** — things the code MUST respect (filters, distinctions, etc.).
- **Negative space ("is not")** — things the code MUST NOT do.

If the spec lacks these sections, list the gap as finding #0: "spec missing minimum structure".

### Step 2 — Read the implementation

For each `.py` (or equivalent) file under `code_path`:
- Module docstring.
- Public functions and their docstrings.
- Output schema (if applicable, often in a config file).

### Step 3 — Cross-check across 5 dimensions

| Dimension | Question | Typical severity |
|---|---|---|
| **D1. Goal alignment** | Does what the code produces match the spec's goal? | High |
| **D2. Schema match** | Declared output schema == spec's output schema? | High |
| **D3. Locked premises** | Are spec-mandated filters / distinctions enforced in code? | Critical |
| **D4. Acceptance criteria** | Does each testable AC have evidence (test, notebook)? | Medium |
| **D5. Negative space** | Does the code do something the spec explicitly forbids? | High |

Severity ladder:
- **🔴 Critical** — violates a locked premise / does something the spec forbids.
- **🟠 High** — substantive goal or schema misalignment.
- **🟡 Medium** — AC without evidence / outdated docstring / minor technical drift.
- **🟢 Info** — observation without immediate action.

### Step 4 — Decide direction of fix

For each finding:
- **Spec amendment** — code is correct, spec is outdated → escalate to `decision-log-entry` + edit the spec.
- **Code fix** — spec is correct, code drifted → open an issue or fix PR.
- **Discuss** — ambiguous, requires methodological decision (escalate to `decision-log-entry` with `type: methodology`).

### Step 5 — Structured output

```
## Spec cross-check — <module/feature>

**Spec:** <path>
**Code:** <path>
**Mode:** quick | deep

### Findings

#### 🔴 Critical — N
- <finding> · spec: <line/section> · code: <file:line> · direction: <spec-amend / code-fix / discuss>

#### 🟠 High — N
- ...

#### 🟡 Medium — N
- ...

#### 🟢 Info — N
- ...

### Recommended action queue
1. <highest severity> · <direction> · owner: <who>
2. ...

### Drift summary
- Code does <X> that spec doesn't license: ...
- Spec mandates <Y> that code doesn't implement: ...
- Both diverge on <Z>: ...
```

---

## Anti-patterns

- **Mass-categorizing every difference as 🔴** — severity exists to focus attention. Use the ladder honestly.
- **Failing to choose a direction** — every finding gets one of {spec-amend, code-fix, discuss}. "Both could be right" is not a direction.
- **Skipping the negative space check (D5)** — implementation creep usually surfaces here, not in the positive-space dimensions.
- **Reading code without reading the spec first** — the order matters: spec defines the question, code is the answer being graded. Reading code first biases what is seen.
