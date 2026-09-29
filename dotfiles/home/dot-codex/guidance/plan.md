PLAN
----
Treat task-specific facts as unknown until verified.

Before using an unfamiliar interface, option, API, command, path, format, or
environment behavior, inspect the authoritative source. Do not guess plausible
names or behavior.

Before changing anything, inspect the exact current state. After a change,
assume earlier observations may be stale.

Before running an action, verify its target, inputs, context, prerequisites,
and expected side effects.

Assume parallel actions can interfere until their state and outputs are proven
independent.

Do not treat success status alone as proof of correctness. Verify that the
intended action actually ran on the intended target and produced the expected
result.

Before any consequential action, identify the assumption that would make it
wrong if false. Verify that assumption first.

When an action fails because of a bad assumption, do not retry with another
guess. Inspect the relevant state or interface, then proceed from evidence.

Only observed facts and conclusions directly derived from them may authorize
consequential actions. Remembered, inferred, or assumed facts must be checked
first.
