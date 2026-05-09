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
    end

    subgraph Guardians ["Entity Guardians"]
        FG["Family\nGuardian"]
        M["Craft\nAgent"]
        TG["Travel\nAgent"]
    end

    subgraph Quality ["Quality"]
        AR["Artifact\nReviewer\n⟨read-only⟩"]
    end

    subgraph ClientProject ["Client · Project"]
        CA["Client\nAgent"]
        PJA["Project\nAgent"]
    end

    P -->|"request"| K
    K -.->|"internal pressure-test\n(when output has weight)"| W
    W -.->|"verdict"| K
    K --> PCS & PA & FA
    K --> FG & M & TG
    K --> AR
    K --> CA & PJA

    style P fill:#007A4D,stroke:#00C47A,color:#fff
    style K fill:#007A4D,stroke:#00C47A,color:#fff
    style W fill:#152030,stroke:#2A4460,color:#8CA8C0
    style AR fill:#152030,stroke:#2A4460,color:#8CA8C0
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

    K->>S: Delegate work
    S-->>K: Result + B1 Handoff

    alt output carries strategic · exec · reputational weight
        K->>W: Pressure-test (3 lenses)
        W-->>K: approved / refine-and-return
    end

    K->>P: Final output
```

> **Rule:** Senior Advisor never delivers output to the Principal. Family Guardian runs before any output that consumes personal time.

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

    A1 -->|"Walter approved"| SPRINT
    SPRINT --> B1
    SPRINT --> A2
    A2 -->|"formal deliverable\nto client/stakeholder"| DELIVER(["Output\nDelivered"])
    B1 -.->|"state.md updated"| STATE[("state.md")]
    C1 -.->|"compares brief vs output"| A1

    style A1 fill:#007A4D,stroke:#00C47A,color:#fff
    style A2 fill:#1A3A5C,stroke:#4A9EFF,color:#fff
    style B1 fill:#3A2A00,stroke:#F5A623,color:#F5A623
    style C1 fill:#2A1A5C,stroke:#9B7EFF,color:#fff
```

| Gate | When | Who | Exception |
|------|------|-----|-----------|
| **A1** Pre-Sprint Assertion | Before any planned sprint | Chief of Staff drafts brief → Walter reviews | Reactive urgent execution skips A1; A2 covers output at end |
| **A2** Artifact Review | Before formal deliverable to client/stakeholder | Artifact Reviewer (read-only) | Drafts, code, internal notes excluded |
| **B1** Structured Handoff | End of every agent invocation | Each agent writes to `state.md` | None |
| **C1** Milestone Review | Weekly | Interface Agent | None |

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
        IDX["memory/auto/MEMORY.md\n(index file)"]
        TOPIC["memory/auto/&lt;topic&gt;.md\nuser profile · operating mode\nclient context · working patterns…"]
    end

    subgraph T3 ["Tier 3 — Operational (session-scoped)"]
        DAILY["memory/daily/YYYY-MM-DD.md"]
        DEC["memory/decisions/decision-log.md"]
        STATE["memory/&lt;agent&gt;/state.md\n(B1 handoff blocks)"]
    end

    HOOK(["SessionStart Hook"])
    K_AGENT["Interface Agent"]

    HOOK -->|"injects at session open"| T2
    T2 --> K_AGENT
    T1 -->|"read on demand"| K_AGENT
    T3 -->|"read by agents as needed"| K_AGENT

    style HOOK fill:#1A3A5C,stroke:#4A9EFF,color:#fff
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

    subgraph Active ["Active domains"]
        PRO["Professional\n· Chief of Staff\n· Client Agents\n· Project Agents\n· Artifact Reviewer"]
        PER["Personal\n· Personal Advisor\n· Family Guardian\n· Craft Agent\n· Travel Agent"]
        FIN["Finance\n· Finance Advisor"]
    end

    subgraph Planned ["Expandable domains"]
        INV["Investments\n· CIO\n· 10 school agents\n· 4 advisory modules"]
        SPI["Spiritual\n· CTE\n· 25 specialist agents"]
        LRN["Learning\n· Learning Curator"]
    end

    K --> PRO & PER & FIN
    K -.->|"expansion\nsequence"| INV & SPI & LRN

    style PRO fill:#0A1A0F,stroke:#007A4D
    style PER fill:#0A1A0F,stroke:#007A4D
    style FIN fill:#0A1A0F,stroke:#007A4D
    style INV fill:#152030,stroke:#2A4460
    style SPI fill:#152030,stroke:#2A4460
    style LRN fill:#152030,stroke:#2A4460
```

> Expansion is governed by `control-plane/rules/post-mvp-expansion-directive.md`. New domains are added one at a time after the previous one is stable.

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

## Design principles

| Principle | Rationale |
|-----------|-----------|
| **Single interface** — one agent fronts all work | Prevents context fragmentation; principal never manages agent-to-agent routing |
| **Senior Advisor is internal** | Internal pressure-testing is a different cognitive act than delivering. Mixing both in one agent produces softer outputs |
| **Entity guardians as hard gates** | Some things are not resources to optimize — they are structural priorities. The guardian surfaces every proposal that quietly draws from that account |
| **Agentic-by-default** | Sub-agents are the default for non-trivial work. Simulated invocation (internal reasoning only) is the exception |
| **Memory in tiers** | Identity (T1) never changes without instruction. Operating context (T2) persists automatically. Execution state (T3) is ephemeral and never authoritative for identity |
| **Quality gates before and after** | A1 gates execution (brief must be approved before work starts). A2 gates delivery (artifact must conform to brief before leaving the system) |
