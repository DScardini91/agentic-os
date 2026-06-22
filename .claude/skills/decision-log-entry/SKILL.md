---
name: decision-log-entry
description: Transcribe a free-form decision from the principal into a structured entry in the project's decision-log, preserving verbatim rationale, inferring type/decider/linked specs, and proposing a review date. Atomic skill — works on any project that has a decision-log.md.
triggers:
  - "record this decision"
  - "log this decision"
  - "this becomes D-"
  - "decision-log:"
  - "this is a decision"
---

# Skill: decision-log-entry

## When to use

The principal just made a decision (methodological, architectural, stakeholder, override) and wants it recorded in the decision-log before it slips. They usually speak free-form; this skill formats.

NOT for:
- Substantive spec amendment → escalate to `pr-review` + spec edit.
- Open premise → goes in `OPEN_QUESTIONS.md`, not the decision-log.
- Generic note capture → use `parse-capture`.

---

## Inputs

- **`raw`** (required) — free-form text of the decision, ideally verbatim from the principal.
- **`project`** (optional) — defaults to the OS root. Determines the path of the decision-log.
- **`type`** (optional) — if not stated, infer from the canonical categories:
  - `spec-approved` · spec approved for execution
  - `spec-amended` · mid-sprint spec change
  - `override-proposed` / `override-approved` · change to decisions-locked
  - `methodology` · methodological decision
  - `architecture` · architecture / contract decision
  - `stakeholder` · decision about a person / relationship
  - `pending` · still open, will be locked when resolved

---

## Sequence

### Step 1 — Locate the decision-log

Default path: `control-plane/memory/decisions/decision-log.md` (this template's canonical location).
For project-specific decision-logs: `<project>/docs/harness/decision-log.md` or wherever the project's harness defines.

If the path does not exist, ask the principal where to create it before proceeding.

### Step 2 — Determine next D-NNN

```bash
grep -E "^## D-[0-9]+|^\| D-[0-9]+" <decision-log.md> | tail -1
```

Take the highest number used and add 1. Format: `D-NNN`, zero-padded to 3 digits.

### Step 3 — Parse raw into entry fields

**Required fields:**

| Field | How to infer |
|-------|--------------|
| `id` | Next D-NNN |
| `date` | Today in `YYYY-MM-DD` (unless the principal cites another date explicitly) |
| `type` | From the canonical list. Infer if not stated. |
| `short title` | < 50 chars, imperative. Do not invent — extract from raw. |
| `Decider` | The principal by default. Others if cited (team lead, stakeholder, committee). |
| `Context` | Why the decision had to be made. Verbatim when possible. |
| `Decision` | WHAT was decided. **Verbatim** when there is a literal quote — do not paraphrase. |
| `Rationale` | Why this decision. Verbatim or minimal synthesis of raw. |
| `Linked` | Cited spec, decisions-locked entry, PR. List refs found in raw. |

**Optional but recommended:**

| Field | How to infer |
|-------|--------------|
| `Review (target N days)` | Default 7 business days. Type `methodology` or `architecture` → 14d. Type `stakeholder` → 30d. |

### Step 4 — Preserve verbatim (paraphrase antidote)

If the raw contains quotes or a characteristic expression from the principal or stakeholder:
- Keep literal with `> "phrase"` or `**"phrase"**` in the `Decision` or `Canonical quote` field.
- **Do not paraphrase.** Paraphrasing is the #1 failure mode of harness execution — "polished nonsense".

### Step 5 — Canonical format

```markdown
## D-NNN · YYYY-MM-DD · <type> · <short title>
- **Decider:** <who>
- **Context:** <why the decision was needed>
- **Decision:** <what was decided — verbatim when possible>
- **Rationale:** <why this decision>
- **Linked:** <refs: spec / decisions-locked / PR>
- **Review (target YYYY-MM-DD):** pending
```

If there is a canonical quote:
```markdown
- **Canonical quote:** > "<literal phrase>"
```

### Step 6 — Append + confirm

1. Append the entry to the end of `decision-log.md`.
2. Show the principal the formatted entry before saving:
   ```
   Adding this entry to the decision-log:
   <entry>

   OK?
   ```
3. If OK, write to the file. Otherwise adjust based on feedback.

### Step 7 — Suggest the next action

Always close with 1-2 concrete questions:
- If `type == spec-approved`: "Also update decisions-locked?"
- If `type == architecture` + impacts team: "Worth communicating to the team via a doc PR?"
- If `type == override-proposed`: "Who needs to approve before this becomes locked?"
- If `type == stakeholder`: "Update the stakeholder map too?"

---

## Anti-patterns

- **Paraphrase when there's a literal quote** — verbatim or nothing.
- **Invent a field** — if raw has no explicit rationale, leave `Rationale: <pending>` and ask the principal.
- **Infer decider without evidence** — do not assume the principal if context suggests a committee or specific stakeholder.
- **Skip review date** — entries without a review get forgotten. Always propose a target.
- **Save without confirming** — always show the principal before writing to the file.

---

## Example

Principal (free-form):
> *"Record this — we decided in the steering committee that the X module stays separate from the Y module. Mixing them in schema or UI kills adoption."*

Output:
```
Adding this entry to the decision-log:

## D-NNN · YYYY-MM-DD · architecture · X and Y modules stay separate
- **Decider:** Steering committee
- **Context:** Risk of label confusion between X and Y modules — adoption killer.
- **Decision:** Modules separated with isolated namespaces. Schema and UI must
  explicitly distinguish `module_x` ≠ `module_y`.
- **Rationale:** > "Label confusion kills adoption" — different iteration cycle,
  different risk profile, different tooling.
- **Linked:** specs/module-x.md, specs/module-y.md
- **Review (target YYYY-MM-DD):** pending

OK to save?
```
