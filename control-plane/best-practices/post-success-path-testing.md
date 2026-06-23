# Post-success-path testing

**Rule:** the terminal state of a happy path is itself a state. Test what happens when the system is asked to do something **after** the happy path completed. Tests that stop at "success emitted" miss an entire class of state-transition bugs.

## Why

A test that runs `start → step → step → SUCCESS` and stops at the success signal does not exercise:

- What `next` returns when there is no more work.
- What `status` reports when the system is finished.
- What happens if the caller re-invokes the same step on a terminated state.
- Whether terminal-state side-effects (file removal, lock release, channel close) are properly defended against re-entry.

Bugs in these transitions are common because the developer writing the happy path is mentally already done — the terminal state feels like "off the map" rather than "still on the map, just at the edge".

## The case study (PR #3 → dry-run → PR #4)

`bootstrap-progress.sh` shipped in v1.1.0 (PR #3) with the contract `start → complete × 4 → ALL_COMPLETE + cleanup`. CI fixture covered this exact happy path: 1 test, passed, merged.

The Walter pressure-test on PR #3 returned approved-with-conditions, deferring "real dry-run in throwaway fork" to a post-merge open item. The dry-run was 10 minutes of work; it ran the full happy path successfully, then ran one more command — `next` — to see what the system reported when there was nothing left to do.

**The dry-run found a phantom-reinit bug on the first invocation past success.** `next` was calling `_init_if_missing` unconditionally, which recreated the progress file with all-pending blocks on a freshly bootstrapped system. The system silently said "start over from block 1" when it should have said "done".

The fix (PR #4) made `_init_if_missing` sentinel-aware and added 5 new fixture tests, including:

- post-bootstrap `next` returns `done` without phantom re-init
- `status` reports bootstrapped without side-effects
- `start` refused with helpful message when sentinel absent
- `complete` refused when system is already terminated
- mid-bootstrap interruption + resume

## How to apply

- For every script, skill, or workflow that has a "done" / "completed" / "all-finished" terminal state, write at least **three** post-success tests:
  1. The query operation (`next`, `status`, `which`) returns the terminal indicator without side effects.
  2. The mutation operation (`start`, `complete`, `apply`) refuses with a useful error.
  3. Re-running the entire happy path on the terminal state behaves as `noop` or `error`, not as `restart`.
- When you write the happy-path test, write the post-success test in the same PR. They are the same surface.
- If the system has cleanup-on-success (file removal, lock release), the post-success test must verify the cleanup persisted, not just that the cleanup ran.

## Anti-patterns

- **"The happy path passes, ship it."** The terminal state is not the happy path; it is the state the happy path leaves behind.
- **Unit-testing only in isolation directories** (`/tmp/foo-test`) that get destroyed between runs. Real users invoke operations on real persistent state; the persistent state is the bug surface.
- **Treating the deferred dry-run as ceremony.** If Walter (or any pressure-tester) says "run this end-to-end before declaring done", the cost is 10 minutes and the alternative is shipping silent regressions.

## Operational hint

If you are about to mark a PR as ready and you have not run the system through one full happy-path cycle in a real environment (not the unit test rig), do that now. The mental cost is small; the bug it catches is the one that wakes you up.
