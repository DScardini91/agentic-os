---
name: os-bootstrap
description: Set up agentic-os for a new operator — Claude leads every step, operator decides the minimum, ends with a done contract and settings instructions. Triggers on .bootstrap-pending or any setup request.
version: 3.0
category: bootstrap
triggers:
  - "/setup"
  - "/bootstrap"
  - "set up the os"
  - "configure the system"
  - ".bootstrap-pending detected"
---

# os-bootstrap

You are the guide. The operator follows. Keep decisions on your side — only ask what you genuinely cannot infer or default.

---

## Step 0 — Silent prep (before saying anything)

```bash
chmod +x .claude/hooks/*.sh control-plane/scripts/*.sh scripts/*.sh 2>/dev/null || true
python3 control-plane/scripts/compile-skill-routing.py 2>/dev/null || true
python3 control-plane/scripts/compile-concept-routing.py 2>/dev/null || true
```

Don't mention this. Just do it.

---

## Step 1 — Ask exactly two things

Send ONE message. Two questions only. No preamble about architecture or what you're about to do.

```
Ótimo — vamos configurar tudo agora. Preciso de duas coisas:

1. Como você quer ser chamado? (nome ou apelido)
2. Quais áreas da sua vida quer cobrir aqui? Exemplos: trabalho, pessoal, finanças, saúde, aprendizado — ou diga "tudo" e eu ativo um conjunto padrão.
```

Use the operator's language (PT or EN) based on how they triggered the skill.

Everything else — agent names, communication style, non-negotiables — gets a sensible default and can be adjusted later. Don't ask.

**Defaults applied silently:**
- Agent names: `kowalski` (interface) and `walter` (internal pressure-tester)
- Communication: conclusion-first, terse, no profanity
- Non-negotiables: none (operator adds later via `/capture`)

---

## Step 2 — Configure everything silently

After the operator answers, execute without narrating. Don't say "now I'm writing the file" — just write it.

**Memory files** (write from the two answers):
- `control-plane/memory/self/personality.md` — name, context inferred from domains
- `control-plane/memory/self/communication-style.md` — conclusion-first default
- `control-plane/memory/self/boundaries.md` — empty placeholder, ready to fill
- `control-plane/memory/auto/user_profile.md` (frontmatter `type: user`, one short paragraph)

**Domains:** for each domain the operator named (or the default set if they said "tudo"):
- Keep or create `<slug>/` folder with a one-line `domain.md` describing scope
- Remove example folders not in their list
- Update active domains table in `control-plane/CLAUDE.md`

**Default domain set** (if operator says "all" / "tudo" / is unsure):
`professional/`, `personal/`, `finance/` — keep these three. Remove `investments/`, `learning/`, `spiritual/` unless named.

**Agent names:** apply defaults (kowalski / walter) or operator's choice across:
- Both CLAUDE.md files, `control-plane/session-start.md`
- `control-plane/config/spoke-owners.yaml`, `config/triggers.yaml`
- `control-plane/registry/agents.md`
- All `.claude/agents/*.md` files

Rename memory folders: `control-plane/memory/kowalski/` and `control-plane/memory/walter/` if custom names were chosen.

**Decision log:** append to `control-plane/memory/decisions/decision-log.md`:
```
## D-001 — bootstrap complete
Date: YYYY-MM-DD  |  Operator: <name>  |  Domains: <list>  |  Agents: kowalski / walter
```

**Remove sentinel:** `rm .bootstrap-pending`

---

## Step 3 — Done contract

Send ONE final message. This is the handoff. Be concrete, directive, zero fluff.

Structure:

```
✅ Pronto, <nome>. Aqui está o que foi configurado:

**Sistema**
- Domínios ativos: <lista>
- Agente principal: kowalski · Pressão interna: walter
- Memória iniciada · Decision log: D-001

**Agora faça isto (leva 2 minutos):**

**1 — Ative o auto mode**
No Claude Code, pressione `Shift+Tab` duas vezes até aparecer "Auto" no canto. Ou abra a paleta de comandos e selecione "Enable auto mode". Em auto mode o sistema opera sem pedir confirmação a cada passo.

**2 — Cole no `.claude/settings.json`** para evitar pedidos de permissão repetidos:

```json
"permissions": {
  "allow": [
    "Bash(bash control-plane/scripts/*)",
    "Bash(python3 control-plane/scripts/*)",
    "Bash(chmod +x *)",
    "Bash(mkdir -p *)",
    "Bash(rm .bootstrap-pending)",
    "Bash(git status)",
    "Bash(git log*)",
    "Bash(git diff*)"
  ]
}
```

Abra `.claude/settings.json` na raiz do projeto e adicione esse bloco dentro do objeto principal.

**3 — Próxima sessão**
Abra Claude Code nesta pasta e diga `bom dia` ou `/morning` para o brief do dia. Ou simplesmente diga o que está na sua cabeça — o sistema já sabe quem você é.

Qualquer dúvida ou ajuste: diga `builder mode` e modificamos o que precisar.
```

Adjust PT/EN and the exact names to match what was configured.

---

## Failure modes

**python3 not found:** skip compilation, note in `memory/auto/MEMORY.md`. Don't block setup.

**Operator is vague on domains:** use the default set (professional / personal / finance), name it in the done contract. They can change later.

**Operator wants to redo:** `touch .bootstrap-pending` and re-invoke. Existing memory is overwritten.
