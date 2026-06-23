---
name: expert-interview-guide
description: Generates structured interview guides for primary research — customer DD, competitor benchmark, industry expert, channel partner, supplier. Produces TWO documents — (1) a clean external-safe guide, (2) an internal prep brief with benchmarks / contradictions / anchoring. Priority tags [MUST-HAVE] / [IMPORTANT] / [OPTIONAL] + [Quantify] markers on all metrics.
triggers:
  - "interview guide for"
  - "discussion guide with"
  - "prepare questions for interview"
  - "guide to talk to"
---

# Skill: expert-interview-guide

## Preconditions

- Input mode chosen: `document_attached` (proposal / scope doc supplied) or `manual` (Q&A captures the inputs below).
- `docx` skill available if generating .docx (or markdown fallback if not).
- For `document_attached` mode: PDF / DOCX / PPTX readable.
- Operator can answer or has documented: engagement type, interviewee type, sector, top 2-3 priority topic areas.

## When to use

Operator is preparing an interview — primary research, customer due diligence, competitor benchmark, expert call, stakeholder mapping. The skill is generic across sectors and engagement types.

NOT for:
- Internal meeting prep → use `prep-my-week` or `meeting-close`.
- Journalistic interview → out of scope.
- Survey / questionnaire at scale → not 1:1, different shape.

## Configuration (edit before first use)

```yaml
default_project_template: ""             # e.g. "DD", "MarketStudy", "GrowthStrategy"
default_language: "en"
internal_disclaimer: "INTERNAL USE ONLY — DO NOT DISTRIBUTE EXTERNALLY"
default_duration_min: 60
default_priority_split:
  must_have: 12
  important: 6
  optional: 4
```

## Input contract

```yaml
input_mode: document_attached | manual

# if input_mode=document_attached
proposal_path: str | None      # PDF / DOCX / PPTX with scope or proposal
                               # extract: project, target, scope topics, hypotheses

# if input_mode=manual
engagement_type: commercial_dd | vendor_dd | market_study | growth_strategy | operational_dd | other
interviewee_type: customer | competitor | industry_expert | channel_partner | supplier
duration_min: 30 | 45 | 60 | 90
project_name: str
target_company: str | None     # [Company] placeholder if absent
sector: str
geography: str | None

topic_areas: list[str]         # e.g. ["market_sizing", "competitive", "pricing", "tech"]
priority_areas: list[str]      # 2-3 highest priority — drive MUST-HAVE tagging
hypotheses: list[str] | None   # specific hypotheses to test

output_dir: str | auto
language: str                  # default: configured
generate_prep_brief: bool      # default: true
```

## Output contract

```yaml
guide_path: str                # clean .docx (or .md fallback)
prep_brief_path: str | None    # internal-only prep brief, null if disabled
question_count: int
must_have_count: int
important_count: int
optional_count: int
```

## Sequence

### Step 1 — Resolve inputs
- `document_attached`: read the proposal, extract project / target / topics / hypotheses. Confirm extracted fields with the operator before generating.
- `manual`: Q&A walks the operator through the input contract.

### Step 2 — Calibrate question count by duration
| Duration | Total questions | Must-have | Important | Optional |
|---|---|---|---|---|
| 30 min | 12 | 7 | 3 | 2 |
| 45 min | 16 | 10 | 4 | 2 |
| 60 min | 22 | 12 | 6 | 4 |
| 90 min | 30 | 16 | 9 | 5 |

### Step 3 — Generate the clean guide

Structure:
1. **Header** — interview metadata (date placeholder, project, interviewee role, duration). No internal disclaimer.
2. **Warm-up** (2-3 min) — role, tenure, scope. Non-threatening, gets the interviewee talking.
3. **Topic sections** — one per `topic_area`. Within each: questions in priority order.
4. **Closing** (3-5 min) — "what else?", referrals, follow-up permission.

Each question:
- Carries a priority tag: `[MUST-HAVE]` / `[IMPORTANT]` / `[OPTIONAL]`.
- Carries `[Quantify]` on every metric question so the interviewer knows to push for numbers.
- Open-ended by default (avoid yes/no unless the goal is confirmation).
- One concept per question (no compound).

### Step 4 — Generate the prep brief (internal-only)

Mirror the guide's structure, but for each topic section add:

- **Hypothesis under test** (from `hypotheses` input or inferred from priority_areas)
- **Benchmark data** — known industry numbers / prior interview findings, with source
- **Anchoring** — what the interviewer should already believe, and what would change it
- **Contradiction watch** — claims to expect from this interviewee that contradict known data; how to probe without antagonizing
- **Internal disclaimer** at top — INTERNAL USE ONLY — DO NOT DISTRIBUTE

If `generate_prep_brief: false`, skip Step 4.

### Step 5 — Output

- Save guide to `output_dir/<project>-<interviewee>-guide-YYYY-MM-DD.docx`
- Save prep brief to `output_dir/<project>-<interviewee>-prep-internal-YYYY-MM-DD.docx`
- Return file paths + question count breakdown

## Anti-patterns

- **Confusing the two outputs** — never paste prep-brief content into the clean guide; the internal disclaimer is the only safeguard against accidental external distribution.
- **Closed questions on quantifiable topics** — "do you use X?" wastes a turn vs "how much X do you use, and how has that changed?".
- **One section per priority instead of per topic** — fragments the interview flow. Topics are the unit; priorities are tags within topics.
- **Forgetting the `[Quantify]` marker on metric questions** — the interviewer drifts to qualitative comfort if not prompted.
- **Skipping the prep brief for short interviews** — even 30-min interviews benefit from explicit hypotheses + benchmarks. The brief is short for short interviews, not absent.
