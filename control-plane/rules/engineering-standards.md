# Engineering Standards (Universal)

_Universal floor for engineering discipline applied to any code the principal or the interface agent writes within this OS. Principles + anti-patterns + over-rotation guardrails. Derived from Clean Code (Martin, 2008) adapted to Python + data + LLM stacks._

## Scope

Applies to:
- OS internals (Python, scripts, hooks, MCPs, agents)
- Personal repos
- Future client repos without their own canon

Does **not** apply directly to:
- Domain-specific repos that have their own engineering canon — the domain canon inherits this base but adds specifics; on explicit conflict, the domain canon wins inside its scope.
- Exploratory notebooks — discipline is relaxed by design (see E2).
- Throwaway research / prototype code (≤ 2 weeks lifespan) — apply P1, P3 and nothing else.

---

## Principles

### P1 — Names reveal intent
Variables, functions, classes, modules carry names that make the purpose obvious without reading the implementation. No cryptic abbreviation, no type encoding (`strName`, `lstUsers`), no names that lie about content.

**Apply:** every time you name something.
**Why:** code is read a hundred times for every time it is written. Bad-name cost is paid on every future read.
**Good:** `days_since_last_renewal` instead of `d`. `is_eligible_for_upsell` instead of `flag2`.
**Bad:** `data`, `info`, `tmp`, `process()`, `handle()` without qualifier.

### P2 — Function / module does one thing at one level of abstraction
A function that mixes "read file + parse line + validate + apply business rule" is four functions disguised as one. SRP at function level; same logic at module and class level.

**Apply:** whenever you write or review a function/module with more than one visible responsibility.
**Why:** one reason to change = one place to change.
**Pattern:** `read_input → validate → transform → write_output` as separate functions; a pipeline composes them.
**⚠️ Not to confuse with:** dogma "function ≤ 4 lines". A 12-line function that keeps one level of abstraction is better than 4 two-line functions that force the reader to jump around. **Stepdown rule > numeric rule.**

### P3 — Comments are the exception; the "why" is the justification
Well-named code dispenses with most comments. Legitimate cases:
- **Non-obvious "why"** — documented workaround, non-evident architectural decision, domain invariant
- **External reference** — regulatory citation, actuarial formula, paper, ticket
- **Warning** — "do not call in a loop" + reason
- **TODO with context** — link to issue, deadline

**Rotten (remove):**
- Redundant (`# increment counter` before `counter += 1`)
- Historical (use git)
- Attribution (use blame)
- Commented-out code (use git)
- Empty templates (`# function` before `def function`)

**⚠️ Not to confuse with:** "zero comments always". Public-API docstrings, regulatory annotations and hyperparameter justifications are real value.

### P4 — Errors are typed exceptions, never a silent return
A function that can fail raises an exception with an informative message. It does not return `None`, `False`, or `-1` expecting the caller to check.

**Apply:** every time you write a function that can fail (I/O, validation, parsing, network).
**Why:** silent return spreads defensive checks across every caller, and one caller always forgets. Exceptions are fail-fast and visible.
**Pattern:** domain exceptions (`InvalidPolicyError`, `MissingPremiumError`) wrapping boundary exceptions (`requests.HTTPError`).

### P5 — Third-party boundaries are wrapped
External lib (HTTP client, ORM, cloud SDK, LLM provider) never leaks into the domain layer. Define a domain interface + adapter for the concrete impl.

**Apply:** when integrating any external dependency with an unstable API, possible multi-provider, or hard to mock.
**Why:** provider switch, lib version bump, no-network testing — all become changes in the adapter, not in the domain.
**Pattern:** `class LLMClient(Protocol): def complete(prompt: str) -> str` with `OpenAIAdapter`, `AzureAdapter`, `MockAdapter`. The domain depends on the Protocol.
**Learning tests:** before adopting a new lib, write 2-3 tests of the intended usage against the real API. Documents expectation and catches version regression.

### P6 — Tests are F.I.R.S.T., with an escape hatch for probabilistic code
**Deterministic (parsers, validators, business logic, dispatchers):**
- **Fast** — < 100ms per test; suite runs in seconds
- **Independent** — order doesn't matter, no shared state
- **Repeatable** — any environment, no net/clock/external state
- **Self-Validating** — pass/fail, no visual inspection
- **Timely** — written alongside (or before) production code
- **One concept per test**

**Probabilistic (LLM output, ML models, stochastic simulations):**
- **Golden / snapshot tests** — fix seed when possible; otherwise snapshot of N runs
- **Rubric-based eval** — LLM-as-judge against explicit criteria; documented tolerance
- **Distributional** — % of runs above a quality threshold
- **Deterministic unit tests still mandatory** — prompt parser, dispatcher, fallback path

**⚠️ Anti-pattern:** forcing literal F.I.R.S.T. on LLM code. Result: flaky tests, ignored suite, real regression slips through.

### P7 — SRP per class / module: one reason to change
`OrderProcessor` that validates, computes tax, persists and notifies = 4 classes in disguise. When the description uses "and", there is more than one responsibility.

**Apply:** designing a new class/module, or reviewing one that has grown.
**Heuristic:** if the name contains `Manager`, `Processor`, `Handler` without a specific qualifier, it is probably a god class.

### P8 — Dependencies flow toward abstraction; `main` composes, modules don't know `main`
The domain layer doesn't know concrete impls. Concrete depends on abstraction. `main` (or a container) builds the object graph and injects dependencies.

**Apply:** structuring a new project, or refactoring detected coupling.
**Why:** testability comes for free (inject fake); impl swap doesn't touch the domain; import cycles disappear.

### P9 — Boy Scout Rule
Every PR leaves the touched code a little cleaner than it was. Rename a confusing variable, extract an obvious function, delete a dead comment, remove an unused import.

**Apply:** any change to existing code.
**⚠️ Limit:** do not turn the PR into a side refactor. Keep the main change's scope clear; cleanup is a minimal side-effect, not the central theme.

---

## Anti-patterns

### E1 — Function/class that does "this AND that"
Description uses "and" two or more times → almost certainly violates P2. **Break** into functions of one abstraction level.

### E2 — Applying production rules to exploratory notebooks
Notebooks are scratchpads. Applying SRP / F.I.R.S.T. / tests to notebooks is the wrong category. **Flag** when notebook code is ready to become a module — then the rules apply.

### E3 — Comment that explains what code does
`# loop through users` before `for user in users` is noise. **Delete** or replace with a better variable/function name.

### E4 — Silent `None` / silent value on the error path
`def get_user(id): if not found: return None`. Caller forgets to check; bug in production. **Raise a typed exception** or return `Optional[User]` with explicit type hint that forces the caller's check.

### E5 — Third-party leaks (Pandas, requests, SDK) in the domain layer
`def compute_premium(df: pd.DataFrame, response: requests.Response)`. Domain coupled to 2 external libs. **Wrap** in domain types (`Policy`, `PremiumQuote`); adapters convert at the boundary.

### E6 — God class / god function
Class > 300 lines or function > 80 lines is a smell. **Not an absolute rule** — pipeline code may justify a longer function if it maintains one level of abstraction. But it is a review trigger.

### E7 — Hardcoded dependencies inside a domain class/module
`class OrderService: def __init__(self): self.db = SQLAlchemyClient(...)`. Untestable without spinning up a DB; provider switch touches the domain. **Inject** via constructor or Protocol.

### E8 — TDD / F.I.R.S.T. forced on probabilistic code
A suite that fails 30% of the time is ignored. Migrate to golden tests + rubric eval; keep deterministic unit tests only on deterministic layers.

---

## When to over-rotate and when to ignore

**Signals of over-rotation:**
1. PR critique uses "function too big" without evidence of actual legibility loss
2. Refactor-for-refactor's-sake consumes time that should go to feature/client work
3. Pandas / functional pipeline being OO-ified with no gain
4. Public-API docstrings removed in the name of "the code speaks for itself"
5. `Protocol` + adapter + factory applied to a < 100-line script without a second real impl (DI ceremony without payoff)

**When to ignore the rule:**
- Throwaway research / prototype code (≤ 2 weeks)
- Exploratory notebooks (until they become a production module)
- Explicit conflict with a project-specific canon already validated (domain canon wins inside its scope)

---

## Relationship with domain canons

```
engineering-standards.md  (universal, this file)
        │
        ├── inherited by: <client-A>/engineering-canon.md (when introduced)
        │       adds: domain specifics
        │       may override: specific rules where domain evidence justifies (N≥2 or regulatory)
        │
        ├── inherited by: <client-B>/engineering-canon.md
        │
        └── applied directly: this OS's internals, personal repos
```

**Principle:** the universal base defines the floor. Domain canons add a domain ceiling and may override when justified by evidence.

---

## Minimal PR / commit checklist

Before opening a PR (self-review), confirm:

- [ ] Function/variable names reveal intent (P1)
- [ ] Each function does one thing at one level of abstraction (P2)
- [ ] No redundant comment; present comments justify "why" (P3)
- [ ] Errors are typed exceptions; no silent return (P4)
- [ ] Third-party dependencies wrapped in adapters (P5) — when applicable
- [ ] Tests for deterministic logic; golden/rubric for probabilistic (P6)
- [ ] Class/module has one reason to change (P7)
- [ ] No hardcoded dependency in the domain (P8)
- [ ] Touched code left slightly cleaner (P9)
