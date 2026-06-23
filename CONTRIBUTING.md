# 🤝 Contributing to agentic-os

Thanks for considering a contribution. This repo is a **template** — most "contributions" are forks where you adapt the template to your own operating discipline. But upstream improvements that **generalize** are welcome.

---

## ✅ What belongs upstream

- 🐛 **Bug fixes** in hooks, scripts, validators, or compilers
- 🧩 **New agent patterns** that are genuinely canonical (you've used the pattern in 2+ different domains and the abstraction held)
- 📋 **New best practices** that are universal (not "I prefer X" — but "X compounds over time and not doing X has a documented cost")
- ⚡ **Better setup automation** — anything that reduces the gap between `git clone` and a running, bootstrapped system
- 📖 **Documentation clarifications** for any place a fresh reader gets stuck

## ❌ What does NOT belong upstream

- 🔒 Your own **operator-specific agents**, domain folders, or memories. Those go in your fork.
- 🏢 **Domain-specific skills** unless they're genuinely generic.
- 📊 **N=1 evidence** for new canonical principles. The template prefers underclaiming.

---

## 🚀 How to propose a change

### 1️⃣ Open an issue first
For non-trivial changes. State the problem, your proposed fix, and which surfaces of the [Done Contract](DONE_CONTRACT.md) it affects.

### 2️⃣ Fork + branch
Create a descriptive branch: `feat/`, `fix/`, `docs/`.

### 3️⃣ Atomic commits
- One concern per commit
- Each commit message answers **"why"**, not "what" — see [`best-practices/atomic-commits.md`](control-plane/best-practices/atomic-commits.md)
- Stage **surgically** — `git add <path>`, not `git add .` — see [`best-practices/git-stage-surgical.md`](control-plane/best-practices/git-stage-surgical.md)

### 4️⃣ Run the validation suite before pushing

```bash
bash scripts/validate-all.sh
```

Or use `just validate` if you have [`just`](https://github.com/casey/just) installed.

### 5️⃣ Push + open PR
Push your branch and open a PR against `main`.

---

## 📋 PR expectations

| Field | Expectation |
|---|---|
| **Title** | Short, imperative. Under 70 characters |
| **Description** | What changed, why, what it affects. Reference any issue |
| **Test plan** | Bullet list reviewers will check. Be specific |
| **Scope** | One concern per PR. Multi-surface changes → split |

The maintainer reviews via the [`pr-review`](.claude/skills/pr-review/SKILL.md) skill: **APPROVE / REFINE & RETURN / REJECT** verdict with concrete reasoning. The senior-advisor pressure-test fires automatically on cross-cutting or governance-class PRs (anything touching `control-plane/`, `.claude/`, root `CLAUDE.md`, hooks, or rules).

---

## 🚫 Hooks and the no-direct-merge rule

This repo has **external visibility**, so all merges to main require a PR. The [`block-pr-merge.sh`](.claude/hooks/block-pr-merge.sh) hook enforces this at the tool level.

> ⚠️ Override env var `HARNESS_MERGE_OVERRIDE=1` exists for vacation or emergency, **not for routine work**.

Every override leaves a fire in `pre-tool-fires.jsonl` for Darwin to surface in the next governance pass.

---

## 🔬 Weekly evolution ritual

A weekly governance pass keeps the template from drifting. See [`EVOLUTION.md`](EVOLUTION.md) for the cadence, the Darwin deep-mode protocol, and how rejected proposals get reopening criteria.

---

## 💬 Code of Conduct

Be **direct, specific, and respectful**:
- 🎯 Surface issues concretely
- 🤲 Assume good intent in others
- 🚪 If a contribution is rejected, the maintainer states why and what would make it acceptable
- 🗣️ If a maintainer rejects your work badly, raise it explicitly

---

## ❓ Questions

- 💭 Open a [GitHub Discussion](https://github.com/DScardini91/agentic-os/discussions) or an [issue](https://github.com/DScardini91/agentic-os/issues)
- 📵 No Slack or Discord by design — **async, durable text leaves an audit trail** that ephemeral channels don't

---

<div align="center">

🧬 Built on the principle that **the harness > the model**.

</div>
