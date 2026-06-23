# 📋 Best practices

> Universal operating rules that ship as canonical with the template. **Each file is one rule** documented as `Rule → Why → How to apply → Anti-patterns`.

[← Back to README](../../README.md) · [Rules](../rules/) · [Concept cards](../concepts/_cards/) · [Agent patterns](../agent-patterns/README.md)

---

## 🎯 When the interface agent reads this directory

| Context | Rules that apply |
|---|---|
| 🖊️ Writing code or documentation | Engineering + Communication |
| 📤 Producing output for an external stakeholder | Communication + Review |
| 💾 Committing or merging | Engineering (git discipline) |
| 🧩 Building a new agent or skill | Architecture |

> 💡 After bootstrap, the operator can **add, remove, or override** any of these. The `Why` block explains the cost so the deletion is informed.

---

## 📑 Index

### 🗣️ Communication
- [`conclusion-first.md`](conclusion-first.md) — Lead every output with the conclusion, not the setup
- [`no-emoji-no-emdash.md`](no-emoji-no-emdash.md) — External / formal output: no emoji, no em-dash, no second-person pronouns by default
- [`no-half-finished.md`](no-half-finished.md) — Don't ship half-finished; explicit defer beats silent partial

### 🛠️ Engineering
- [`git-stage-surgical.md`](git-stage-surgical.md) — Never bulk-add (`git add .`, `-A`, `-u`, `<dir>/`); stage file by file
- [`no-direct-merge.md`](no-direct-merge.md) — Merges to main on shared / public repos require pressure-test + explicit approval
- [`atomic-commits.md`](atomic-commits.md) — One concern per commit; commit message answers "why", not "what"
- [`code-ownership-respect.md`](code-ownership-respect.md) — Do not edit another developer's open PR directly; surface the blocker

### 🏛️ Architecture
- [`agentic-by-default.md`](agentic-by-default.md) — Sub-agents are the default; simulated reasoning is the exception
- [`progressive-disclosure.md`](progressive-disclosure.md) — Agent spec has two tiers — fast path (state.md) and deep context (full spec)
- [`canon-self-audit-pair.md`](canon-self-audit-pair.md) — Every absorbed canon ships with a living self-audit; the pair is the unit

### 📝 Output discipline
- [`comments-explain-why.md`](comments-explain-why.md) — Comments document the non-obvious "why"; code shows the "what"

### 🧪 Testing
- [`post-success-path-testing.md`](post-success-path-testing.md) — The terminal state of a happy path is itself a state. Test what happens AFTER the happy path completes. Case study: PR #3 → dry-run → PR #4
