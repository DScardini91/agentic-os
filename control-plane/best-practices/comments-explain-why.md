# Comments explain "why", not "what"

**Rule:** default to writing no comments. Only add one when the **why** is non-obvious. Never explain what the code does — well-named identifiers do that.

## Why

Code shows the **what**. The next reader can see `counter += 1` is incrementing a counter. The comment that says `# increment counter` adds zero information and one more thing that can rot when the code changes.

Comments earn their cost only when they carry information the code cannot:
- A hidden constraint (`# must run before X because X assumes Y is set`).
- A subtle invariant (`# this list is intentionally ordered by Z — sorting elsewhere breaks the loop below`).
- A workaround for a specific bug or platform quirk (`# bug: lib version 3.4.2 misparses floats with > 6 decimals`).
- A non-obvious choice the reader would otherwise question and possibly "fix" wrong.

## How to apply

**Default:** no comment.
**Comment when:**
- The why is non-obvious from the code, name, and immediate context.
- A hidden constraint or invariant exists.
- A workaround needs documenting so it isn't naively removed.
- A decision was made that the reader will want to challenge.

**Don't comment:**
- The what — let the names carry it.
- The history of changes — `git log` and `git blame` do that, and stay current.
- The author — same, via `git blame`.
- Code that was removed — git already remembers; "// removed because X" is clutter.
- The current task or PR — that belongs in the PR description, not in the code.

## Docstrings

Public-API docstrings are real value and are not "what" comments — they document the contract (inputs, outputs, side effects, error modes). Keep them tight (one line for trivial signatures; a paragraph for non-trivial ones). Never write multi-paragraph docstrings unless the API genuinely requires it.

## Test for "is this comment earning its space?"

If removing the comment would not confuse a future reader who is also reading the code around it, the comment is decoration. Delete it.
