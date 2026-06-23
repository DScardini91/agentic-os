<div align="center">

# 🔒 Data and Privacy

### Where your operating context actually lives.

[← README](../README.md) · [👤 Who is this for?](WHO_IS_THIS_FOR.md) · [🧭 Integration Map](INTEGRATION_MAP.md)

</div>

---

## TL;DR

Your data lives in **four places** when you use agentic-os:

1. **Your local machine** (the cloned repo on disk)
2. **Your GitHub fork** (if you committed and pushed)
3. **Anthropic** (whatever you send to Claude during a session — same as any other Claude Code use)
4. **Optional external systems** (Notion, Obsidian, etc. — only if you wire them in)

The system does **not** silently send anything to anywhere new. Every byte of "where it goes" is visible in the file system and the git remote you configured.

If you operate under confidentiality constraints (client data, regulated industries, public-company material non-public information), **read the rest of this doc before forking**.

---

## 📍 Where each kind of data lives

### Your identity, mandates, and decision rules
**Lives in:** `control-plane/memory/self/*` on your local machine + your GitHub fork.

These are markdown files like `personality.md`, `communication-style.md`, `boundaries.md`. They describe **how you want the system to operate**, not what your current projects look like.

- Local machine: yes
- GitHub fork: yes if you committed
- Anthropic: yes when injected into a session's context
- External: no (unless you explicitly copy these files elsewhere)

**Confidentiality posture:** these typically describe you in operator terms ("I prefer conclusion-first", "no emoji in external output"), not client-confidential material. Most operators are comfortable having this in a private GitHub fork. **Do not write client-confidential material into these files.**

### Your daily logs and decision history
**Lives in:** `control-plane/memory/daily/*.md` and `control-plane/memory/decisions/decision-log.md`.

These are the narrative log of what you actually worked on and decided.

- Local machine: yes
- GitHub fork: **yes if you committed and pushed**
- Anthropic: injected into context only for the last 2 daily logs and the decision log (~last 30 entries) per session
- External: no (unless you explicitly mirror)

**Confidentiality posture:** **this is where it gets sensitive.** If your daily log says *"discussed [Client X's] acquisition target with [Senior Partner Y]"*, that text lives wherever you push it. Three working postures:

| Posture | When it applies | What to do |
|---|---|---|
| **Private GitHub fork** | Solo operator, no regulatory constraint, comfort with GitHub holding work narrative | Default. Most operators land here. |
| **Local-only (no push)** | Client confidentiality requires no third-party storage | Configure git to push to an internal Git server you control, or never push at all. The OS works offline-friendly; daily logs and decisions are local files. |
| **Anonymized in commits** | You want the OS-evolution discipline visible publicly but not the operating content | Push the `control-plane/` skeleton and `learning/canon/` to a public fork; keep `memory/daily/` and `memory/decisions/` git-ignored locally. **The OS works fine like this.** Add to `.gitignore`: `control-plane/memory/daily/`, `control-plane/memory/decisions/`. |

### Your agent invocations, hook fires, and session metrics
**Lives in:** `control-plane/memory/observability/*.jsonl`.

These are append-only telemetry files: which agents got invoked, which hooks fired, session cost estimates. Used by Darwin and the enforcement layer.

- Local machine: yes
- GitHub fork: **default `.gitignore` excludes these.** They are local telemetry, not shared history.
- Anthropic: no (telemetry is post-hoc analysis of completed sessions)
- External: no

**Confidentiality posture:** low concern by default. The files are gitignored shipped. Verify your `.gitignore` after bootstrap to make sure that's still true.

### Your ingested canons
**Lives in:** `learning/canon/*.md`.

When you use `ingest-content` on a book or paper, the distilled analysis (TL;DR + abstract + argument map + key concepts + source notes) lands here.

- Local machine: yes
- GitHub fork: yes if you committed
- Anthropic: the original source (PDF, URL) was processed by Claude during ingestion. The committed analysis is what you write to disk.
- External: depends on your source (if the book is licensed material, **the committed analysis is a derivative work** — apply your judgment per the source's terms)

**Confidentiality posture:** the analysis is your synthesis. If the source was internal client material, the analysis derived from it carries the same confidentiality. **Do not commit canon files derived from client-confidential material to a public fork.**

### Your client-facing artifacts
**Lives in:** wherever you produced them (your local file system, your client's preferred share, etc.). agentic-os does not store artifacts; it stores the **discipline around producing them**.

- Local machine: yes (where you produced them)
- GitHub fork: no (unless you commit them — and you probably shouldn't)
- Anthropic: yes during the session that produced them
- External: wherever you delivered them

**Confidentiality posture:** unchanged from how you would handle these artifacts without agentic-os. The system adds no new attack surface here.

---

## 🌐 What Anthropic sees

Same as any other Claude Code use. Specifically:

- Every prompt you send during a session is sent to Anthropic for processing.
- Every file Claude reads during a session is sent to Anthropic as context.
- Anthropic's data usage policy (at the time of writing) treats these as input data, subject to their published terms.
- **agentic-os does not add any new data path to Anthropic** beyond standard Claude Code behavior.

If your organization has constraints on what you can send to Anthropic, those constraints apply unchanged. The OS will not magically make a regulated workflow compliant.

---

## 🔐 Three practical postures

### Posture A — "Public-ish operator"
You want the OS-evolution discipline visible publicly so others can learn from the pattern.

- Fork is public.
- `.gitignore` keeps `memory/daily/`, `memory/decisions/`, `memory/observability/`, and any `*-private-*` files local.
- Canon ingestions of *published material* (books you bought, papers you cite) are committed.
- Canon ingestions of *internal material* are gitignored.

### Posture B — "Private operator"
Your operating discipline is for you only.

- Fork is private (GitHub free tier supports this).
- Everything in `memory/` is committed to the private fork.
- No special restrictions.

### Posture C — "Regulated operator"
Your work has hard compliance constraints (legal, financial, medical, public-company MNPI).

- **Do not commit any client-derived content** to GitHub, public or private, without compliance approval.
- Push the `control-plane/` skeleton + your identity files; **gitignore all of `control-plane/memory/`** except the README files in each tier.
- Run the OS locally with no remote sync of operational memory.
- For shared/team installs, mirror to your organization's Git server, not GitHub.com.
- **Have your compliance team review this doc before forking.** If they need a more detailed posture statement, open an issue and we'll co-author one.

---

## 📋 Pre-fork compliance checklist

Run through this before you fork:

- [ ] I understand that committed files in `memory/daily/` and `memory/decisions/` will be in the git history of my fork.
- [ ] I have chosen Posture A, B, or C above.
- [ ] If Posture A: I have audited my `.gitignore` to confirm gitignored paths are correct.
- [ ] If Posture C: I have compliance approval, or I am working locally with no push to any remote.
- [ ] I understand Claude Code's data flow to Anthropic (this is unchanged by agentic-os).
- [ ] I have a backup of any local data before I start (the OS is not a backup; your laptop disk is your single source of truth for unpushed memory).

If you can check all six, you're cleared to fork.

---

## 🚪 Easy exit (privacy edition)

If you fork and later decide to leave:

1. Copy your `control-plane/memory/auto/`, `control-plane/memory/decisions/`, `control-plane/memory/daily/` to a personal location (Notion, Obsidian, plain folder).
2. Delete your fork (if it was on GitHub) — this removes the public/private history.
3. Delete the local clone.

**The OS leaves nothing behind on infrastructure you don't control.**

---

<div align="center">

*Confidentiality is a contract with yourself before it is a contract with anyone else.*

</div>
