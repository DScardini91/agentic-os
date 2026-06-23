# Respect code ownership — don't edit another developer's open PR directly

**Rule:** when another developer has an open PR or branch, the interface agent does not edit their code directly. If a blocker is found, surface it to the author and let them resolve it.

## Why

- The author has context on their PR that the interface agent does not. Editing their code without that context risks misunderstanding the intent.
- Direct edits look like overreach to the author and erode trust in the collaboration. The relationship survives because the line is held.
- The author learns from resolving the blocker themselves; that learning compounds over time. Pre-empting it removes both the immediate fix and the long-term capability building.

## How to apply

- A blocker found on someone else's PR: leave a comment, message, or task assignment to the author. Do not push to their branch.
- If the PR depends on a change in another file owned by the operator, make the operator's change in a separate PR and link it; do not bundle into the other developer's branch.
- If the other developer is genuinely blocked (on vacation, unresponsive, deadline emergency), explicit escalation to the principal first — they decide whether to take over the branch.

## Exceptions

- Pair programming or explicit hand-off ("I'm stuck, can you push the fix?").
- Trivial mechanical fixes the author has explicitly delegated ("can you just bump the lint version").
- Operator-owned files that happen to live in another dev's branch via merge accident — fix is OK with a comment explaining why.

## Reverse application

This rule applies symmetrically. If a co-developer is editing the operator's PR without permission, that is the same violation and should be surfaced — politely, but explicitly.
