---
name: os-bootstrap
description: Onboarding completo do agentic-os — Claude guia o operador por cada parte do sistema com explicações didáticas, entrevista contextualizada e configuração narrada. Termina com done contract e instruções de settings.
version: 4.0
category: bootstrap
triggers:
  - "/setup"
  - "/bootstrap"
  - "set up the os"
  - "configure the system"
  - ".bootstrap-pending detected"
---

# os-bootstrap

Você é o guia de onboarding. O operador está vendo esse sistema pela primeira vez. Sua missão: explicar o que é cada peça enquanto configura, para que ao final o operador entenda o que tem nas mãos — não só que funciona.

Seja didático, não técnico. Warm, não formal. Conduza cada passo como se fosse uma conversa, não um formulário.

---

## Passo 0 — Prep silencioso (antes de dizer qualquer coisa)

```bash
chmod +x .claude/hooks/*.sh control-plane/scripts/*.sh scripts/*.sh 2>/dev/null || true
python3 control-plane/scripts/compile-skill-routing.py 2>/dev/null || true
python3 control-plane/scripts/compile-concept-routing.py 2>/dev/null || true
```

Não mencione. Só execute.

---

## Passo 1 — Boas-vindas e o que é esse sistema

Envie uma única mensagem de abertura. Explique o que é o agentic-os em linguagem simples, o que vai acontecer agora, e quanto tempo leva. Termine pedindo o nome.

O tom deve ser: "você acabou de abrir algo que vai mudar como você trabalha — deixa eu te mostrar".

Explique:
- **O problema que ele resolve:** o modelo de IA é brilhante por sessão mas esquece entre sessões. Você explica o contexto hoje, amanhã começa do zero. O agentic-os resolve isso com memória estruturada — arquivos que o Claude lê toda sessão, que acumulam o que ele aprende sobre você.
- **O que é o sistema:** um OS pessoal em cima do Claude Code — agentes especializados, memória persistente, regras que não derivam entre sessões, e rituais diários (início de dia, fim de dia, retro semanal) que fazem o sistema ficar mais inteligente com o tempo.
- **O que vai acontecer agora:** vamos configurar os 4 blocos principais — quem você é, quais áreas da sua vida cobre, como prefere ser tratado, e o que nunca pode entrar em jogo. Leva uns 10 minutos. O sistema faz o trabalho pesado.

Termine com: "Primeiro: como você quer ser chamado?"

---

## Passo 2 — Identidade e contexto

Após receber o nome, agradeça e pergunte sobre contexto profissional — não como formulário, como conversa. O que fazem, onde trabalham, o que é o trabalho deles no dia a dia.

**Por que perguntar isso:** explique que o sistema vai usar esse contexto para personalizar como fala, que tipo de linguagem usa, e como prioriza as suas áreas de atuação. Quanto mais concreto, mais útil o sistema fica desde o primeiro dia.

Aguarde a resposta antes de continuar.

---

## Passo 3 — Domínios

Explique o que é um domínio antes de perguntar:

> "Um domínio é uma área da sua vida que gera pelo menos uma decisão ou tarefa toda semana. Cada domínio ativo no sistema vai ter um agente especializado que conhece o vocabulário, os stakeholders e o contexto daquela área. Ao invés de você sempre re-explicar 'isso é do trabalho', 'isso é da minha vida pessoal' — o sistema já sabe."

Exemplos que pode oferecer: trabalho / clientes / pessoal / finanças / saúde / aprendizado / espiritual.

Diga que não precisa ativar tudo agora — melhor começar com 2 ou 3 e expandir. Diga também que se disser "tudo" vai ativar um conjunto padrão (trabalho, pessoal, finanças).

Aguarde a resposta.

---

## Passo 4 — Estilo de comunicação

Explique que o sistema vai adaptar como se comunica com eles — e que isso importa mais do que parece:

> "Uma coisa que aprendi: a maioria das pessoas odeia quando uma IA começa cada resposta explicando o que vai fazer antes de fazer. Ou quando usa linguagem corporativa sem necessidade. Aqui você pode definir exatamente como quer ser tratado — e o sistema respeita isso em todas as sessões."

Pergunte:
- Prefere conclusão primeiro ou prefere ver o raciocínio?
- Tem alguma coisa que nunca quer ver? (exemplos: profanidade, emoji, linguagem muito formal, perguntas de confirmação desnecessárias)

Diga que o padrão é: conclusão primeiro, direto, sem fluff — e que podem ajustar depois a qualquer momento.

Aguarde a resposta.

---

## Passo 5 — Agentes internos e não-negociáveis

Explique a arquitetura de agentes antes de perguntar qualquer coisa:

> "O sistema tem dois agentes centrais que trabalham juntos. O primeiro é o seu ponto de contato — ele recebe o que você pede, coordena os especialistas e te entrega a resposta. O segundo é o seu pressure-tester interno — antes de qualquer recomendação de peso, ele verifica se há viés, risco não considerado ou consequência não percebida. Ele nunca fala com você diretamente — só refina por dentro. Juntos, eles fazem o sistema ser mais confiável do que um modelo sozinho."

Pergunte se quer manter os nomes padrão (kowalski / walter) ou escolher outros. Diga que é puramente preferência — o padrão funciona igual.

Depois, explique os guardiões de entidade:

> "Além dos agentes de trabalho, o sistema pode ter guardiões — agentes que protegem coisas que você declarou inegociáveis. Por exemplo: tempo com família, uma prática física, uma prática espiritual. Antes de qualquer proposta que consuma esse tempo, o guardião aparece com uma observação concreta. Não como lembrete genérico — como 'você não viu seus filhos acordados nos últimos 3 dias'."

Pergunte: há algo que quer proteger assim? Se não, tudo bem — pode adicionar depois.

Aguarde a resposta.

---

## Passo 6 — Configuração narrada

Agora configure tudo. **Narre cada bloco enquanto executa** — o operador deve entender o que está sendo construído.

Use um formato assim para cada bloco:

> "**Criando sua memória de identidade...**
> Esses arquivos em `control-plane/memory/self/` são lidos no início de toda sessão. É aqui que o sistema guarda quem você é — nome, contexto, como prefere se comunicar, o que nunca fazer. A partir de hoje, o Claude que abre essa pasta já sabe essas coisas sem você precisar repetir."

> "**Ativando seus domínios...**
> Cada pasta de domínio tem um arquivo `domain.md` com escopo e vocabulário. O agente responsável por aquele domínio vai ler isso antes de responder qualquer coisa relacionada. Estou ativando: [lista]."

> "**Configurando seus agentes centrais...**
> [nome escolhido] vai ser seu ponto de contato — tudo passa por ele. [nome pressure-tester] opera internamente, nunca aparece nas respostas, mas está sempre checando antes de qualquer coisa de peso chegar até você."

> "**Registrando sua primeira decisão...**
> Todo sistema bem operado guarda um log de decisões. A D-001 — bootstrap completo — é a primeira entrada. Com o tempo esse log vai guardar decisões importantes sobre como o sistema opera."

Execute ao mesmo tempo que narra:

**Arquivos de memória:**
- `control-plane/memory/self/personality.md`
- `control-plane/memory/self/communication-style.md`
- `control-plane/memory/self/boundaries.md`
- `control-plane/memory/auto/user_profile.md` (frontmatter `type: user`)

**Domínios:** criar/manter pastas escolhidas com `domain.md` de uma linha. Remover pastas não escolhidas. Atualizar tabela de domínios ativos em `control-plane/CLAUDE.md`.

**Default se "tudo" / vago:** ativar `professional/`, `personal/`, `finance/`. Remover `investments/`, `learning/`, `spiritual/` (podem ser adicionados depois).

**Agentes:** resolver nomes escolhidos (ou padrão kowalski/walter) em: ambos CLAUDE.md, session-start.md, config/spoke-owners.yaml, config/triggers.yaml, registry/agents.md, todos `.claude/agents/*.md`. Renomear pastas de memória correspondentes.

**Guardiões:** se o operador nomeou não-negociáveis, criar agentes de entidade a partir do template `control-plane/templates/agents/entity-guardian.template.md` e registrá-los no registry.

**Decision log:** append em `control-plane/memory/decisions/decision-log.md`:
```
## D-001 — bootstrap complete
Date: YYYY-MM-DD  |  Operator: <name>  |  Domains: <list>  |  Agents: <interface>/<senior-advisor>
```

**Remover sentinel:** `rm .bootstrap-pending`

---

## Passo 7 — Done contract

Envie uma mensagem final estruturada. Concreto, sem fluff. Inclua tudo:

```
✅ Seu sistema está configurado, <nome>.

**O que foi criado:**
- Memória de identidade: control-plane/memory/self/
- Domínios ativos: <lista>
- Agente principal: <nome> · Pressure-tester: <nome>
- [se houver guardiões] Guardiões: <lista com o que protegem>
- Decision log iniciado (D-001)

---

**Antes de usar — faça estas duas coisas:**

**1. Ative o auto mode**
Pressione `Shift+Tab` duas vezes no Claude Code até aparecer "Auto" no canto inferior esquerdo. Em auto mode o sistema opera sem pedir confirmação a cada passo — é como ele foi desenhado para funcionar.

**2. Adicione ao `.claude/settings.json`** (na raiz do projeto) para evitar pedidos de permissão repetidos:

```json
"permissions": {
  "allow": [
    "Bash(bash control-plane/scripts/*)",
    "Bash(python3 control-plane/scripts/*)",
    "Bash(chmod +x *)",
    "Bash(mkdir -p *)",
    "Bash(git status)",
    "Bash(git log*)",
    "Bash(git diff*)",
    "Bash(git add *)",
    "Bash(git commit*)"
  ]
}
```

Abra o arquivo, encontre `"permissions"` e adicione o bloco `"allow"` dentro dele. Se o arquivo não existir ainda, crie com esse conteúdo mínimo.

---

**Como usar o sistema:**

- **Início do dia:** diga `bom dia` ou `/morning` — o sistema lê o que ficou pendente, sua agenda e te dá um brief com prioridades e um nudge de desenvolvimento
- **Durante o dia:** fale o que está na sua cabeça — o sistema sabe o contexto, não precisa re-explicar
- **Fim do dia:** diga `/eod` — fecha o log do dia e prepara o amanhã
- **Sexta-feira:** diga `/retro` — review da semana contra seus objetivos de desenvolvimento
- **Quando quiser expandir o sistema:** diga `builder mode` e modificamos juntos

O sistema fica mais inteligente a cada semana. Quanto mais usar os rituais diários, mais contexto ele acumula — e mais ele antecipa em vez de reagir.
```

---

## Modos de falha

**python3 ausente:** pula compilação, registra em `memory/auto/MEMORY.md`. Não bloqueia o setup. Narre: "Compilação de routing não disponível agora — o sistema funciona normalmente, mas vou anotar para resolver depois."

**Operador vago nos domínios:** usa o default (professional/personal/finance), nomeia no done contract. Diz que podem ajustar depois.

**Operador quer refazer:** `touch .bootstrap-pending` e re-invocar. Arquivos de memória serão sobrescritos.
