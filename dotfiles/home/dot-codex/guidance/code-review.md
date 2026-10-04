CODE REVIEW
-----------
Applies when reviewing code, reviewing a diff, or sweeping a codebase.

Use subagents as read-only analyzers. They inspect the code and return specific
findings; they never edit files. The main model reads their findings, rejects
weak ones, and applies justified changes itself.

Run review in waves. Each wave has a narrow purpose. Do not ask one agent to
perform a generic "senior code review"; broad review prompts produce
speculative findings, stylistic noise, and unnecessary rewrites.

Every agent must reread the project-specific `AGENTS.md`, relevant
documentation, build configuration, and nearby code before analyzing anything.

ANTI-SLOP RULES
---------------
A finding is valid only when it identifies:

1. the exact code involved;
2. the concrete problem;
3. the condition under which the problem matters;
4. the observable consequence;
5. the smallest justified change.

Do not report:

- hypothetical problems without a plausible execution path;
- generic "could be cleaner" observations;
- stylistic preferences not established by project conventions;
- abstractions proposed only for possible future use;
- rewrites whose only argument is elegance;
- micro-optimizations without evidence that the code is relevant;
- defensive checks for states already made impossible by invariants;
- duplicate code whose extraction would make the call sites harder to understand;
- comments that merely restate the code;
- renames without a concrete ambiguity;
- pre-existing unrelated problems during a diff review.

Prefer deletion and simplification over adding machinery.

Do not introduce a helper, abstraction, wrapper, class, template, configuration
option, compatibility layer, cache, or new state unless the reviewed code
demonstrates a present need for it.

When uncertain whether a finding is real, investigate further. If it cannot be
demonstrated from the repository, discard it.

Read enough surrounding code to understand ownership, invariants, callers,
callees, tests, error handling, and architectural boundaries. Do not review
changed lines in isolation.

WAVE 1: PROJECT CONVENTIONS
---------------------------
Read `AGENTS.md`, project documentation, nearby implementations, and existing
tests.

Find violations of conventions that are actually established by the repository:
naming, control flow, error handling, ownership, API shape, file organization,
comments, formatting not already handled mechanically, and recurring local
idioms.

Do not invent a preferred style.

Fix inconsistencies only when there is a clear project precedent.

WAVE 2: SIMPLIFICATION
----------------------
Ask of every non-trivial piece of reviewed code:

"Can the same behavior and invariants be expressed with less code, less state,
fewer branches, or fewer concepts?"

Look for:

- unnecessary indirection;
- redundant state;
- values stored when they can be derived;
- wrappers that add no semantics;
- branches representing the same operation;
- needless temporary objects;
- duplicated validation;
- duplicated conversions;
- dead compatibility paths;
- helpers used only once that obscure local logic;
- abstractions whose interface is larger than their actual use;
- convoluted control flow that can become direct control flow.

Simplification must preserve semantics.

Do not collapse code merely to reduce line count. A shorter implementation that
hides invariants, ownership, or failure handling is not simpler.

WAVE 3: DUPLICATION AND BOUNDARIES
----------------------------------
Search beyond the immediate diff for genuinely duplicated logic.

Extract shared code only when the duplicated pieces have the same semantics,
invariants, ownership model, and expected future direction.

Do not deduplicate code merely because two fragments currently look similar.

Look for misplaced responsibilities: parsing done in execution code, policy
embedded in mechanism, repeated transformations at several layers, state
mirrored across modules, or APIs exposing implementation details.

Prefer moving behavior to the layer that already owns the relevant invariant.

Do not create new architectural layers unless an existing concrete problem
requires them.

WAVE 4: DATA FLOW, OWNERSHIP, AND LIFETIMES
-------------------------------------------
Trace values through the reviewed code.

Check:

- who creates each resource;
- who owns it;
- who may mutate it;
- how long it remains valid;
- how failure changes ownership;
- whether aliases can outlive their source;
- whether state can become inconsistent;
- whether cleanup occurs on every exit path.

For C and C++, explicitly inspect object lifetimes, pointer validity,
iterator/reference invalidation, RAII boundaries, move semantics, allocation
ownership, integer conversions, overflow assumptions, undefined behavior, and
error-path cleanup.

Do not report theoretical lifetime issues when the surrounding invariant proves them impossible.

WAVE 5: PERFORMANCE
-------------------
First identify whether the reviewed code is plausibly performance-sensitive.

Trace loops, allocation frequency, syscalls, parsing paths, repeated lookups,
copying, memory layout, and work performed per input element.

Prefer structural low-cost improvements such as:

- removing repeated work;
- avoiding unnecessary allocation or copying;
- moving invariant work out of loops;
- replacing repeated dynamic lookup with static data when appropriate;
- batching operations when repeated direct syscalls dominate the work;
- avoiding accidental quadratic behavior;
- using a `switch` or a hash lookup for long conditional chains when the
  dispatch cost is demonstrated;
- replacing `ArrayList` with `SortedArrayList` when repeated ordered lookups
  justify the cost of maintaining sorted order.

Do not optimize based on folklore.

Do not replace readable code with a clever implementation unless the cost being
removed is concrete.

Do not assume `switch`, hashes, batching, `SortedArrayList`, tables, branchless
code, custom allocators, caching, or manual memory management are faster.
Inspect the actual use first.

Allocator-related findings must identify the allocation site, frequency,
lifetime, and reason the allocation matters.

WAVE 6: API AND ERROR SEMANTICS
-------------------------------
Inspect public and internal interfaces touched by the change.

Check that:

- callers cannot easily violate required invariants;
- error states are represented consistently;
- errors are neither silently discarded nor redundantly wrapped;
- return values carry useful semantics;
- ownership is apparent from the interface;
- functions do not expose more state than callers need;
- parsing, validation, and execution boundaries remain coherent.

Do not enlarge an API merely to make one implementation easier.

Do not add error handling for impossible states unless the invariant itself is
weak or externally controllable.

WAVE 7: ADVERSARIAL CORRECTNESS
-------------------------------
This wave runs after all edits from earlier waves.

Treat the resulting code as suspect and attempt to disprove its correctness.

Trace normal paths and failure paths from real entry points. Inspect boundary
conditions, empty input, malformed input, partial operations, cleanup, retries,
state transitions, integer limits, ownership transfer, concurrency where
applicable, and interactions between the modified code and existing callers.

Every correctness finding must provide a concrete failing scenario or a
violated invariant.

Do not report "potential" bugs merely because a construct is traditionally
dangerous.

Pay special attention to regressions introduced by simplification or
optimization in earlier waves.

WAVE 8: TESTS AND VERIFICATION
------------------------------
Run the narrowest relevant tests first, then the broader project test suite
where practical.

For every behavioral change, determine whether an existing test proves it. Add
or modify regression tests for defects and risky changes when the task includes
implementation.

Build with the project's normal warnings and sanitizers when they are already
supported by the repository.

Do not add tests that merely duplicate implementation details. Tests should
establish observable behavior, invariants, or previously failing cases.

WAVE 9: C++ STANDARD LIBRARY REMOVAL
------------------------------------
Remove C++ standard library headers, types, functions, and linker dependencies
from project-owned code. C library functions and operating system APIs remain
in scope for use. Inventory direct includes, names, transitive dependencies,
and link symbols before changing the central headers.

Preserve container relocation, allocation failure, exception propagation,
object lifetime, and editor and no-editor behavior. Replace each facility at
its existing owner. Check every supported build mode and target before removing
a linker dependency. Run waves 7 and 8 again after this wave changes code.

FINAL SKEPTICAL PASS
--------------------
Run one final read-only agent whose only job is to challenge the completed review.

It must inspect the final diff and answer:

- Which edits are not justified by an actual problem?
- Which edits add more concepts than they remove?
- Which abstractions have only one real use?
- Which optimizations lack a demonstrated cost?
- Which defensive checks guard impossible states?
- Which comments or names became more verbose without becoming more precise?
- Which changes accidentally broaden the scope of the original task?
- Which earlier findings were technically true but not worth changing?

Revert changes that fail this pass.

A clean review is allowed to produce no findings.

OUTPUT DISCIPLINE
-----------------
Subagents should return findings.

Each finding should contain:

- location;
- concrete issue;
- evidence or execution path;
- consequence;
- minimal proposed change;
- confidence.

Do not repeat the same issue from several agents. The main model must merge
duplicates and independently verify findings before editing.

For a diff review, keep the review centered on regressions or problems
materially exposed by the change.

For a whole-codebase review, divide the repository into coherent subsystems and
run the same waves on each subsystem in parallel. If the user's desired review
focus is already known, do not ask again. If it is not known, begin with
correctness, simplification, and project-convention sweeps while determining
the remaining emphasis from the repository itself.

The goal is not to maximize findings or edits. The goal is to leave the code
with fewer defects, fewer unnecessary concepts, and no speculative cleanup.
