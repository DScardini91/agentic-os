# Context Budget

## Rule

Treat context as an operating budget. Load the smallest set of files that can support a correct decision, and keep long evidence behind file paths, scratchpads, or generated indexes.

## Why

Agentic systems fail quietly when every session starts by loading every possible memory, agent spec, skill body, transcript, and generated artifact. The model becomes expensive, slower to steer, and more likely to follow stale detail instead of current evidence.

## How To Apply

- Start with the root orientation, current state files, routing indexes, and the narrow rule for the path being edited.
- Read full agent specs, skill bodies, and historical logs only when the task actually needs them.
- Prefer `rg` over broad manual browsing, and exclude generated files, archives, large bundles, and stale worktrees unless they are the target.
- Put bulky evidence in a scratchpad or artifact file, then keep the main response to the decision, path, command, or diff that matters.
- When working across runtimes, state whether a behavior was validated in the current runtime or inferred from the reference runtime.

## Anti-Patterns

- Preloading every memory folder "just in case."
- Searching generated bundles when the source files are available.
- Treating old session transcripts as fresher than current repo state.
- Claiming hook/runtime parity without running a runtime-specific validation.
