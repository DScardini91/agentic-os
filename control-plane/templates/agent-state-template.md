# state — <agent-name>
_Atualizado: YYYY-MM-DD_

State vivo do agent. Lido pelo agent ao ser invocado, escrito pelo agent ao final da execução. Não é spec (isso vive em `.claude/agents/<agent>.md`) e não é memória estática (isso vive em outros arquivos sob `control-plane/memory/<agent>/`). É o que está aberto **agora**.

Três campos de estado contínuo + seção Handoff por execução. Manter enxuto — se cresceu além de uma tela, consolidar e arquivar.

## Decisões em aberto
_Decisões que dependem de input do principal ou de um próximo evento. Cada uma com data de origem e o que destrava._
- ...

## Threads ativas
_Trabalho em curso que cruza sessões. Inclui owner (quem move) e próximo passo concreto._
- ...

## Último update
_Carimbo de quem atualizou e por quê. Apenas a última entrada — não vira changelog._
- YYYY-MM-DD — <agent ou kowalski> — <razão em uma linha>

---

## Handoff — última execução
_Substituído integralmente ao final de cada invocação. Kowalski lê este bloco para saber o que aconteceu sem reconstruir o contexto completo._

**Concluído:**
- ...

**Não concluído:**
- ...

**Blockers:**
- ...

**Perguntas abertas:**
- ...
