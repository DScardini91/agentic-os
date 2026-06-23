# 🗺️ Roadmap

> Forward-looking direction for `agentic-os`. Not commitments — directional bets on where the template grows next. Read with the [`OS evolution principle`](CLAUDE.md#opinionated-topology--and-how-to-opt-out) in mind: **deliberate accretion**, components earn their place by being used.

[← Back to README](README.md) · [CHANGELOG](CHANGELOG.md) · [Done Contract](DONE_CONTRACT.md)

---

## 🎯 Currently shipped

`v1.0.0` released **2026-06-22**. See [`CHANGELOG.md`](CHANGELOG.md) for the full inventory.

---

## 🚧 In flight (v1.0.x patches)

| Priority | Item | Why now |
|---|---|---|
| 🟢 High | **Visual polish** of architecture + sub-READMEs | First-impression for BCG / external readers |
| 🟢 High | **ROADMAP.md** + TOC on README | Reader navigation on a 300-line README |
| 🟡 Medium | **Architecture-VISUAL.html** refresh | Currently last-rebuilt before v1.0 polish pass |
| 🟡 Medium | **Migration script** for orphaned legacy `~/.config/agentic-os/escalation-state.json` | Old installs not yet on the namespaced path |

---

## 🧪 Tentative (v1.1)

| Item | Trigger | Effort |
|---|---|---|
| 🎬 **Asciinema demo cast** in README | Real bootstrap session to record | M |
| 🖼️ **Social preview image** | Design + upload via `gh repo edit` | S |
| 💾 **`os-bootstrap` actual progress persistence** | First real fork exercises the contract | M |
| 📚 **More canon + self-audit pairs** shipped as worked examples | Operator absorbs a second canon | M |
| 🧠 **`agent-state/` per-agent state files** with richer worked examples | Templates landed; live examples now valuable | S |
| 🔧 **`install.sh` Linux smoke test** in CI | Validate beyond macOS dev environment | M |

---

## 🔮 Aspirational (v1.2+)

| Item | When it would make sense |
|---|---|
| **Headless `os-bootstrap`** (`--non-interactive --config=path.yaml`) | CI / scripted forks |
| **Web-based bootstrap UI** | Non-CLI operators |
| **Multi-language docs** (English + Portuguese minimum) | International forks reach critical mass |
| **`memory-consolidate` automation** beyond Darwin manual invocation | After 6 months of operator use validates the cadence |
| **Generative test fixtures** for hook regex changes | Hook surface grows past 10 |
| **Stripped-down "core only" preset** | Operators want < 50% of the shipped surface |
| **Plugin marketplace** for domain-specific skill packs | Multiple operators publishing shared kits |

---

## 🚫 Not on the roadmap

- ❌ **Slack / Discord integration** — by design. Async, durable text > ephemeral channels.
- ❌ **Web app version** — Claude Code is the substrate; replacing it defeats the point.
- ❌ **Provider-agnostic abstraction** (OpenAI / Gemini / Claude) — the template is Claude-Code-specific because Claude Code's hook architecture is what makes deterministic enforcement possible.
- ❌ **"Better defaults" preset packs** — opinionation belongs in the operator's fork, not in upstream variants.

---

## 💬 Propose a roadmap item

Open a [GitHub Discussion](https://github.com/DScardini91/agentic-os/discussions) or a [feature issue](https://github.com/DScardini91/agentic-os/issues/new?template=feature.md). The promotion bar is documented in [`CONTRIBUTING.md`](CONTRIBUTING.md):

> N≥2 evidence of the pattern's value across distinct domains, before it becomes part of the canonical template.

---

<div align="center">

🧬 **The roadmap is a hypothesis, not a contract. Reality shifts it as the system learns.**

</div>
