# agentic-os — Architecture

> Visual reference for the system design. For operational setup, see `control-plane/CLAUDE.md` and `control-plane/session-start.md`.

---

## 1. Agent Hierarchy

```mermaid
flowchart TD
    P(["🧑 Principal · CEO"])

    subgraph Core ["Core Interface"]
        K["Interface Agent\nCOO — single point of contact"]
        W["Senior Advisor\n⟨internal — never speaks to principal⟩"]
    end

    subgraph Specialists ["Domain Specialists"]
        PCS["Professional\nChief of Staff"]
        PA["Personal\nAdvisor"]
        FA["Finance\nAdvisor"]
        INV["Investment\nAdvisor"]
        SPI["Spiritual\nGuide"]
        LRN["Learning\nCurator"]
    end

    subgraph Guardians ["Entity Guardians"]
        FG["Family\nGuardian\n⟨hard gate⟩"]
        M["Craft\nAgent"]
        TG["Travel\nAgent"]
    end

    subgraph Quality ["Quality · Governance"]
        AR["Artifact\nReviewer\n⟨read-only⟩"]
        DA["OS Analyst\n⟨governance · Darwin⟩"]
    end

    subgraph ClientProject ["Client · Project"]
        CA["Client\nAgent"]
        PJA["Project\nAgent"]
        PJA2["Codebase\nAgent\n⟨under Project⟩"]
    end

    subgraph Suites ["Multi-Agent Suites"]
        INVS["Investment CIO Suite\n⟨10 schools + 4 modules⟩"]
        SPIS["Spiritual CTE Suite\n⟨25 specialists · 8 layers⟩"]
        TLS["Thought-Leadership Pipeline\n⟨12 agents⟩"]
    end

    P -->|"request"| K
    K -.->|"internal pressure-test\n(when output has weight)"| W
    W -.->|"verdict"| K
    K --> PCS & PA & FA & INV & SPI & LRN
    K --> FG & M & TG
    K --> AR
    DA -.->|"OS proposals → Walter first"| W
    K --> CA & PJA
    PJA --- PJA2
    INV --> INVS
    SPI --> SPIS
    LRN --> TLS

    style P fill:#007A4D,stroke:#00C47A,color:#fff
    style K fill:#007A4D,stroke:#00C47A,color:#fff
    style W fill:#152030,stroke:#2A4460,color:#8CA8C0
    style AR fill:#152030,stroke:#2A4460,color:#8CA8C0
    style DA fill:#152030,stroke:#2A4460,color:#8CA8C0
    style FG fill:#3A1A00,stroke:#F5A623,color:#F5A623
```

---

## 2. Canonical Flow

```mermaid
sequenceDiagram
    actor P as Principal
    participant K as Interface Agent
    participant S as Specialist(s)
    participant W as Senior Advisor
    participant FG as Family Guardian

    P->>K: Request

    alt involves personal time outside work hours
        K->>FG: Checkpoint (mandatory)
        FG-->>K: Cleared / flagged
    end

    K->>S: Delegate work (parallel when independent)
    S-->>K: Result + B1 Handoff

    alt output carries strategic · exec · reputational weight
        K->>W: Pressure-test (3 lenses)
        W-->>K: approved / refine-and-return
    end

    K->>P: Final output (5-point format)
```

> **Rule:** Senior Advisor never delivers output to the Principal. Family Guardian runs before any output that consumes personal time. B1 Handoff is written after every agent invocation — no exceptions.

---

## 3. Quality Gates Pipeline

```mermaid
flowchart LR
    subgraph Plan ["Plan phase"]
        A1["A1\nPre-Sprint\nAssertion"]
    end

    subgraph Execute ["Execute phase"]
        SPRINT["Sprint\nExecution"]
        B1["B1\nHandoff\n⟨per invocation⟩"]
    end

    subgraph Deliver ["Deliver phase"]
        A2["A2\nArtifact\nReview"]
    end

    subgraph Review ["Review phase"]
        C1["C1\nMilestone\nReview\n⟨weekly⟩"]
    end

    subgraph Infra ["Infrastructure"]
        D1["D1\nModel\nAssignment"]
    end

    A1 -->|"Senior Advisor approved"| SPRINT
    SPRINT --> B1
    SPRINT --> A2
    A2 -->|"formal deliverable\nto client/stakeholder"| DELIVER(["Output\nDelivered"])
    B1 -.->|"state.md updated"| STATE[("state.md")]
    C1 -.->|"compares brief vs output"| A1
    D1 -.->|"targeted only\n(no global default)"| SPRINT

    style A1 fill:#007A4D,stroke:#00C47A,color:#fff
    style A2 fill:#1A3A5C,stroke:#4A9EFF,color:#fff
    style B1 fill:#3A2A00,stroke:#F5A623,color:#F5A623
    style C1 fill:#2A1A5C,stroke:#9B7EFF,color:#fff
    style D1 fill:#152030,stroke:#2A4460,color:#8CA8C0
```

| Gate | When | Who | Exception |
|------|------|-----|-----------|
| **A1** Pre-Sprint Assertion | Before any planned sprint | Chief of Staff drafts brief → Senior Advisor reviews | Reactive urgent execution skips A1; A2 covers output at end |
| **A2** Artifact Review | Before formal deliverable to client/stakeholder | Artifact Reviewer (read-only) | Drafts, code, internal notes excluded |
| **B1** Structured Handoff | End of every agent invocation | Each agent writes to `state.md` | None |
| **C1** Milestone Review | Weekly | Interface Agent | None |
| **D1** Model Assignment | Infrastructure setup | Interface Agent | Default: no global model override — targeted assignments only where measurable gain exists |

---

## 4. Memory Architecture

```mermaid
flowchart TB
    subgraph T1 ["Tier 1 — Structural · Identity (permanent)"]
        SELF["memory/self/\npersonality · decision-rules\ncommunication-style · boundaries"]
        IA["memory/&lt;interface-agent&gt;/\nmandate · delegation · execution\nreporting-rules"]
        SA["memory/&lt;senior-advisor&gt;/\nmandate · judgment-model\nescalation-rules · personality"]
    end

    subgraph T2 ["Tier 2 — Auto-Memory (cross-session persistent)"]
        IDX["memory/auto/MEMORY.md\n(index file ≤200 lines)"]
        TOPIC["memory/auto/&lt;topic&gt;.md\nuser profile · operating mode\nclient context · working patterns…"]
    end

    subgraph T3 ["Tier 3 — Operational (session-scoped)"]
        DAILY["memory/daily/YYYY-MM-DD.md"]
        DEC["memory/decisions/decision-log.md"]
        STATE["memory/&lt;agent&gt;/state.md\n(B1 handoff blocks)"]
        OBS["memory/observability/\nagent-calls.jsonl · pre-tool-fires.jsonl\ndarwin-accumulator.jsonl"]
    end

    HOOK_START(["SessionStart Hook\n(injects T2 + recent dailies)"])
    HOOK_STOP(["SessionStop Hook\n(commits memory files)"])
    K_AGENT["Interface Agent"]

    HOOK_START -->|"injects at session open"| T2
    T2 --> K_AGENT
    T1 -->|"read on demand"| K_AGENT
    T3 -->|"read by agents as needed"| K_AGENT
    K_AGENT -->|"writes on session close"| HOOK_STOP
    HOOK_STOP -->|"commits T2 + T3"| T2

    style HOOK_START fill:#1A3A5C,stroke:#4A9EFF,color:#fff
    style HOOK_STOP fill:#3A2A00,stroke:#F5A623,color:#F5A623
    style T1 fill:#0A1A0F,stroke:#007A4D
    style T2 fill:#0A1520,stroke:#1A3A5C
    style T3 fill:#1A1500,stroke:#3A2A00
```

### Source-of-truth split

| Category | Owner |
|----------|-------|
| Structural / Identity (rules, memory, agent specs) | This repo (Tier 1 + Tier 2) |
| Operational (projects, tasks, notes, reviews) | External system (Notion, Linear, etc.) |
| Code | Git repos |
| Raw evidence | Original files (SharePoint, email, etc.) |

---

## 5. Domain Structure

```mermaid
flowchart LR
    K["Interface\nAgent"]

    subgraph Active ["Active domains (all 6)"]
        PRO["Professional\n· Chief of Staff\n· Client Agents\n· Project Agents\n· Codebase Agents\n· Artifact Reviewer"]
        PER["Personal\n· Personal Advisor\n· Family Guardian ⟨hard gate⟩\n· Craft Agent\n· Travel Agent"]
        FIN["Finance\n· Finance Advisor\n· Investigative posture"]
        INV["Investments\n· Investment Advisor\n· CIO Suite\n· 10 school agents\n· 4 advisory modules"]
        SPI["Spiritual\n· Spiritual Guide\n· CTE Suite\n· 25 specialist agents"]
        LRN["Learning\n· Learning Curator\n· TL Pipeline\n· 12 writing agents"]
    end

    K --> PRO & PER & FIN & INV & SPI & LRN

    style PRO fill:#0A1A0F,stroke:#007A4D
    style PER fill:#0A1A0F,stroke:#007A4D
    style FIN fill:#0A1A0F,stroke:#007A4D
    style INV fill:#0A1A0F,stroke:#007A4D
    style SPI fill:#0A1A0F,stroke:#007A4D
    style LRN fill:#0A1A0F,stroke:#007A4D
```

> All 6 domains active in Controlled Scale-Up mode. Expansion governed by `control-plane/rules/post-mvp-expansion-directive.md` — sequential activation, one domain at a time after previous is stable.

---

## 6. Agent State Lifecycle (B1 Handoff)

```mermaid
stateDiagram-v2
    [*] --> Idle

    Idle --> Reading : Invoked by Interface Agent
    Reading --> Executing : state.md read (open decisions + active threads)
    Executing --> Writing : Work complete
    Writing --> Idle : state.md updated\n(Handoff block replaced in full)

    Writing --> Writing : Concurrent invocations\nwait for state.md lock

    note right of Writing
        Handoff block contains:
        • Completed
        • Not completed
        • Blockers
        • Open questions
    end note
```

---

## 7. OS Governance (Darwin Loop)

```mermaid
flowchart TD
    OBS["Observability Feed\nagent-calls.jsonl\npre-tool-fires.jsonl\ndarwin-accumulator.jsonl\n(1 entry/session · UTC timestamps)"]

    DA["OS Analyst\n⟨Darwin⟩\nread-only tools"]

    W["Senior Advisor\n⟨Walter⟩"]

    DEC["decision-log.md\nEvery Walter-approved\nstrategic decision logged\nDate · Domain · Decision · Implemented?"]

    P(["Principal"])
    K["Interface Agent"]

    OBS -->|"deep mode on demand\nor weekly governance pass"| DA
    DA -->|"OS health report\n+ proposals"| W
    W -->|"approved / refine"| K
    K -->|"refined proposals"| P
    P -->|"approved changes\n→ decision-log entry"| DEC
    DEC -.->|"next Darwin pass reads\ndrift vs decisions"| DA

    style DA fill:#152030,stroke:#2A4460,color:#8CA8C0
    style W fill:#152030,stroke:#2A4460,color:#8CA8C0
    style OBS fill:#1A1500,stroke:#3A2A00,color:#8CA8C0
    style DEC fill:#1A1500,stroke:#3A2A00,color:#8CA8C0
```

### Darwin accumulator schema (light mode — runs at SessionStop)

| Field | Description |
|-------|-------------|
| `session` | Session ID |
| `date` | YYYY-MM-DD |
| `ts` | UTC timestamp |
| `agents_invoked` | Unique agents called this session |
| `violations` | Pre-tool-use enforcement fire count |
| `violation_matchers` | Which matchers fired |
| `domains_touched` | Derived from agents invoked |
| `duration_min` | Minutes from first agent call to session end (UTC-corrected) |
| `notes` | Free text, populated in deep mode |

> `tasks_opened` / `tasks_closed` are deep-mode-only — require Notion query. Not in light-mode schema.

---

## Design principles

| Principle | Rationale |
|-----------|-----------|
| **Single interface** — one agent fronts all work | Prevents context fragmentation; principal never manages agent-to-agent routing |
| **Senior Advisor is internal** | Internal pressure-testing is a different cognitive act than delivering. Mixing both in one agent produces softer outputs |
| **Entity guardians as hard gates** | Some things are not resources to optimize — they are structural priorities. The guardian surfaces every proposal that quietly draws from that account |
| **Agentic-by-default** | Sub-agents are the default for non-trivial work. Simulated invocation (internal reasoning only) is the exception, enumerated explicitly |
| **Memory in tiers** | Identity (T1) never changes without instruction. Operating context (T2) persists automatically. Execution state (T3) is ephemeral and never authoritative for identity |
| **Quality gates before and after** | A1 gates execution (brief approved before work starts). A2 gates delivery (artifact conforms to brief before leaving the system). B1 ensures no invocation is lost |
| **Darwin governance loop** | OS Analyst observes the system over time. Proposals flow through Senior Advisor before reaching Principal. Decision-log closes the loop — Darwin reads past decisions to detect drift between what was decided and what was executed |
| **Decision log as structural memory** | Every Senior-Advisor-approved strategic decision is logged with date, domain, decision, and implementation status. Without it, governance is opaque and Darwin rebuilds context from scratch each cycle |
