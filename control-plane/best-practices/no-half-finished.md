# No half-finished implementations

**Rule:** don't ship code, configs, or documents that work in some cases but silently fail in others. An explicit "deferred — see issue X" is always better than a silent partial implementation.

## Why

Half-finished work is the most expensive class of artifact. It costs:
- The original implementation time (already spent).
- The user-time hitting the cases that don't work (recurring).
- The debugging time when someone investigates the silent failure (typically 3-10× the cost of the original).
- The reputation cost when the user concludes "this system doesn't work" instead of "this case isn't covered".

A clear deferral ("only handles case A; case B will be PR #N") preserves the working part and tells the next person where the boundary is.

## How to apply

- Before submitting code or merging a PR: enumerate the cases. For each, the answer is **works**, **explicitly deferred**, or **explicitly out of scope**.
- "Works in the case I tested" is not in the list. Either it works in the documented cases or it is deferred.
- Deferrals get an issue number, a TODO with context, or a comment in the relevant doc — not silence.
- Don't add error handling, fallbacks, or validation for scenarios that can't happen — that's a different anti-pattern (over-defensive code). Validate at system boundaries (user input, external APIs), trust internal code.

## Anti-patterns

- A function that handles the happy path but silently no-ops on edge cases without a comment.
- A skill that works in English but silently mis-parses in another language without flagging.
- A migration that backfills 80% of rows and leaves 20% to "figure out later" without an issue.
- An agent spec that lists capabilities that aren't actually wired.

## Forward-compatible alternative

If shipping the full implementation isn't feasible, ship the **detection** of the unsupported case first, with a clear error message pointing to the deferral. The next user gets a fast, informative failure instead of a slow, mysterious one.
