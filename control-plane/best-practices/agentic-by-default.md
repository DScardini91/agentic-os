# Agentic by default

**Rule:** sub-agents (invoked via the `Agent` tool) are the **default** for any non-trivial work. Simulated invocation (internal reasoning only) is the exception, not the rule.

## Why

When the interface agent simulates a sub-agent internally — "let me think like Walter would" — three things go wrong:
- The reasoning happens inside the interface agent's context window, polluting it with intermediate work that should be isolated.
- There is no auditable trace. `agent-calls.jsonl` shows no invocation, so Darwin governance and the enforcement layer have no signal.
- The sub-agent's actual specialized prompts and tools are bypassed. The simulation is always a degraded copy.

Invoking the real agent uses a separate context window, leaves a trace, and gets the actual specialization. The overhead is small (one tool call) and the gain is structural.

## How to apply

**Invoke via `Agent` when:**
- The task matches an agent's described purpose.
- The task is non-trivial (more than one step, more than one file, decision weight, output destined elsewhere).
- Parallel independent work is possible (single message, multiple Agent calls).

**Do NOT invoke (exhaustive list — anything outside is invokable):**
1. Factual question about a file already read in this session.
2. Single mechanical operation (create 1 task, edit 1 line, read 1 file).
3. Conversational response with no decision weight.
4. Sanity check ≤ 1 line during composition.

**Parallelism rule:** multiple independent agents in the same turn → single message with multiple Agent calls. Sequential only when output of agent A is required input for agent B.

## Anti-pattern

The most common slip: "I'll do it myself, it's quick" → then 30 minutes later, three files have been edited and no agent saw the work. The reverse error (over-invoking trivial things) is cheaper to fix than the under-invoking error, because the trivial-over-invocation surfaces immediately as latency, while the under-invocation surfaces as drift weeks later.
