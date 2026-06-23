---
name: ingest-content
description: Ingest a document (PDF, article, white paper, book chapter, URL) and produce a Pyramid Principle analysis at multiple granularities — TL;DR, abstract, structural pillars, deep dive per section, key concepts. Optionally save to the operator's external knowledge tracker.
triggers:
  - "ingest this document"
  - "absorb this PDF"
  - "analyze this article"
  - "pyramid this content"
  - "synthesize this paper"
---

# Skill: ingest-content

## Preconditions

- The input is a local PDF, a URL, or raw text — supplied via `source` input.
- `pdfplumber` is available if the source is a PDF (`pip install pdfplumber` once).
- `WebFetch` is available for URL sources.
- An external knowledge tracker (Notion, Obsidian, plain markdown) is configured if `save_to_external=true` — otherwise output stays in the response and optionally in `learning/`.

## When to use

Operator hands you a document and wants it understood at depth, not just summarized. The output is structured so the principal can read the TL;DR in 5 seconds and the deep dive in 15 minutes, depending on need.

NOT for:
- A quick Q&A about a single fact in a document — just answer.
- Generating new content from research — that's a thought-leadership pipeline, not ingestion.
- Translating documents — different skill.

## Input contract

```yaml
source: str                   # local path (PDF) or URL or raw text
source_type: pdf | url | text
title: str | None             # extracted from document if None
author: str | None
domain: str | None            # which knowledge area (learning / professional / etc)
save_to_external: bool        # default true if external tracker configured
context_hint: str | None      # additional context (e.g. "relevant to X engagement")
```

## Output contract

```yaml
tl_dr: str                    # 1-2 sentences — complete answer in minimum words
abstract: str                 # single ~150-200 word paragraph
argument_map: str             # tree structure of the argument (markdown)
deep_dive: list[Section]      # one per chapter/section
key_concepts: list[str]       # 5-10 extracted concepts
source_notes: str             # provenance, editorial bias, limitations
external_url: str | None      # link to created note if saved externally
```

## Sequence

### Step 1 — Content extraction
- **PDF local:** `pdfplumber` via `python3 -c "..."` extracting page by page
- **URL:** `WebFetch` for the content
- **Raw text:** use directly
- Record: title, author / org, page or section count, chapter structure

### Step 2 — TL;DR
1-2 sentences answering "what is the central thesis and why does it matter?". Must be intelligible without further context.

### Step 3 — Abstract
~150-200 word paragraph structured as:
1. Problem / context the document addresses
2. Central thesis
3. 2-3 supporting pillars
4. Practical implication or call to action

### Step 4 — Argument map
Tree structure of the argument:
```
THESIS: <central claim>
├── PILLAR 1: <support 1>
│     ├── Evidence A
│     └── Evidence B
├── PILLAR 2: <support 2>
└── PILLAR 3: <support 3>
```

### Step 5 — Deep dive per section
For each chapter / section, a ~100-150 word block that captures:
- What the section argues
- How it supports the central thesis
- Key data, examples, or definitions
- Friction or weakness if present (do not over-flatter)

### Step 6 — Key concepts
5-10 named concepts the document introduces or relies on. These are vocabulary the principal will use when referencing the document later. Each concept gets a one-sentence definition.

### Step 7 — Source notes
- Provenance (publisher, date, edition)
- Editorial bias (advocacy / academic / commercial / personal)
- Limitations (sample size, scope, time)
- Other documents this engages with or contradicts

### Step 8 — Persist
- If `save_to_external=true` and a tracker is configured: create a structured note in the operator's external knowledge system (Notion / Obsidian / plain markdown in `learning/canon/`).
- Otherwise: return all sections inline.

## Anti-patterns

- **Summarizing without structure** — defeats the Pyramid Principle. A summary is not the same as TL;DR + abstract + argument map.
- **Skipping the source notes** — provenance is what lets the operator weight the document's claims later.
- **Treating every section as equally important** — deep-dive blocks for trivial sections waste attention. Triage by load-bearing-ness.
- **Hiding weaknesses** — the operator wants the document understood honestly, including where it's thin.
