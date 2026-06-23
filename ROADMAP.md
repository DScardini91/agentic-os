# 🗺️ Roadmap

> Forward-looking direction for `agentic-os`. Not commitments — directional bets on where the template grows next. Read with the [`OS evolution principle`](CLAUDE.md#opinionated-topology--and-how-to-opt-out) in mind: **deliberate accretion**, components earn their place by being used.

[← Back to README](README.md) · [CHANGELOG](CHANGELOG.md) · [Done Contract](DONE_CONTRACT.md)

---

## 🎯 Currently shipped

**Latest:** `v2.0.0` released **2026-06-23** — Evolution Path (22-rung ladder) + Darwin path mode.
Release history: `v1.0.0` → `v1.0.1` → `v1.1.0` → `v1.1.1` → `v1.1.2` → **`v2.0.0`**.

See [`CHANGELOG.md`](CHANGELOG.md) for the full inventory and [`EVOLUTION_PATH.md`](EVOLUTION_PATH.md) for the rung ladder itself.

---

## ✅ Completed since v1.0

| Item | Release |
|---|---|
| ROADMAP.md + visual polish across ARCHITECTURE + sub-READMEs | v1.0.1 |
| `bootstrap-progress.sh` real progress persistence + social preview PNG + CI smoke tests | v1.1.0 |
| Phantom-reinit fix + 6 CI fixture tests | v1.1.1 |
| Marker check for non-agentic-os repos + post-success-path canon | v1.1.2 |
| **Evolution Path** (22 rungs, 4 phases) + **Darwin path mode** + `darwin-path-mode` skill | **v2.0.0** |

---

## 🧪 Tentative (v2.1+)

| Item | Trigger | Effort |
|---|---|---|
| 🎬 **Asciinema demo cast** in README | Real bootstrap session to record (needs operator) | M |
| 🖼️ **Social preview image** upload to repo Settings | Manual step (gh CLI doesn't support OG upload) | S |
| 📚 **More canon + self-audit pairs** shipped as worked examples | Operator absorbs a second canon | M |
| 🧠 **Richer agent-state worked examples** with real Handoff blocks | Templates landed; live examples now valuable | S |
| 🔧 **`install.sh` Linux smoke test** in CI | Validate beyond macOS dev environment | M |
| 🪜 **Rung completion auto-detection** beyond Darwin manual evaluation | After 30+ days of path-mode usage data | L |
| 🎴 **Per-rung skill triggers** so the path is invokable by rung number | Path mode usage validates the rung naming | M |

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
