TESTS
-----
Use this guidance when writing tests, reviewing existing tests, or removing
tests across a subsystem. New or changed tests must meet the criteria below.
For a subsystem review, also read [test-review.md](test-review.md).

BEFORE WRITING A TEST
---------------------
Answer these questions before adding a test. If an answer is missing, do not
add the test yet.

1. What observable behavior, invariant, or independent contract does it check?
2. What credible regression would make it fail?
3. Why would the existing tests miss that regression? Give each contract one
   primary test at the strongest boundary. Another layer needs a distinct risk,
   such as a transport or lifecycle failure the primary test cannot reach.
   Extend a table case or shared fixture when possible. Consolidate duplicated
   setup in the same change.
4. Does the test require an export, flag, wrapper, or injection hook that no
   production caller needs? If so, test through the real boundary.

Check the [junk patterns](#junk-patterns). A new test matching one needs an
independent contract named in the [retention criteria](#retention-criteria).
Rewrite a test at its owning boundary if a refactor that preserves behavior
would break it.

A bug regression test must fail for the intended reason before the fix and pass
after the owning code is repaired. Without a demonstrated failure, it does not
prove the fix. Keep one regression test at the owning boundary for the bug.

JUNK PATTERNS
-------------
Reject new tests with these patterns unless they independently check a contract
in the retention criteria. Look for the same patterns when reviewing existing
tests.

- The test has no assertions or only probes coverage.
- The test compares a value with itself or copies a value without checking it.
- The test copies fixtures, inventories, manifests, or export lists.
- The test checks exact source text, imports, or strings without an independent
  contract.
- The test checks a private predicate or call shape already covered at a real
  boundary.
- The test repeats another check of the same contract.
- A component test repeats a shared helper's behavior.
- The test exists only to preserve a test-only export, global, or wrapper.
- Production code has no callers outside tests.
- The expected value comes from the helper or renderer under test.
- A mock supplies the behavior being asserted, or the same mock represents
  different APIs.
- A fixture supplies a result or callback order that production code should
  produce, or the test checks persistence in a store the path never writes.
- A capability test repeats a declared flag without checking the delivery or
  acknowledgement it promises.
- A negative control passes for another reason, such as a different guard
  denying access or a rejection that production code never reaches.
- A test name or fixture promises behavior its input does not exercise. For
  example, a test named for retiring a window asserts that the window was not
  cleared.

DECIDE WHETHER TO KEEP AN EXISTING TEST
---------------------------------------
A test should protect behavior, a credible regression, or an independent
contract that justifies its maintenance cost. A test that breaks after a
refactor preserving behavior deserves review. That alone does not justify
deletion.

Before judging a test, read it in full. Read the production code, entry point,
callers, callees, related implementations, overlapping tests, test runner
configuration, and relevant history. Read the project's instructions first. If
a test claims behavior supplied by a dependency, inspect the dependency source
or types.

FIND CANDIDATES
---------------
Read and report the evidence before editing. For a broad review, inspect each
relevant area separately.

- Core components and libraries.
- Integrations and extensions.
- User interfaces, applications, scripts, and tooling.
- Repeated patterns across those areas.

Outside a subsystem campaign, choose a few candidates with strong evidence.
Continue broad reviews in separate, coherent changes. Aim to keep useful
coverage rather than maximize deletion counts.

RETENTION CRITERIA
------------------
Keep a test that independently checks a public interface, protocol,
configuration, migration, storage, security, platform, default, exact output,
generated artifact, package, release, or architecture contract. Also keep
these tests.

- A test checks call order that users can observe.
- A regression test has a credible failure mode.
- Source inspection is the cheapest independent check of a contract. It must
  fail when the user-facing key, byte, or path changes and survive a refactor
  that only renames identifiers.
- A retained test fails at baseline. Reproduce the failure and check whether it
  is a product bug. Repair the owning code if it is.

Being static or slow is not a reason to delete a test. A test resembling its
implementation may still check an independent contract. Establish what other
test covers the contract before removing it.

CANDIDATES
----------
For each candidate, record all of the following before editing. A candidate is
not ready for deletion while any item is missing.

- The exact test name and location.
- The failure it can actually detect.
- The production or support code it covers and any callers outside tests.
- The stronger test that will remain at the owning boundary, or the reason no
  test is needed.
- The relevant history and the reason the test or support code exists.
- The production or test support code that deletion would make unnecessary.
- The risk and the focused command that will check the change.

EDIT AND CHECK
--------------
Make one coherent change at the owning boundary. Remove obsolete exports,
globals, wrappers, and dead production code used only by tests. Move retained
regression tests to the code that owns the behavior. Combine repeated package
or dependency checks into one general contract.

Prefer a net reduction in production lines. Do not replace a removed test with
another test of the same implementation. Leave uncertain candidates alone.

1. Run the smallest tests for the owner and its siblings.
2. If a removed test checked source text or a plan, run the executable script
   or dry run that owns the real contract.
3. Run applicable formatting checks and check the diff for whitespace errors.
4. Report production and tooling changes separately from test and test support
   changes.
5. Complete any review required by the project.

REPORT
------
Report the cause of the low-value tests, the categories removed, and any
simplification to production code. Name valuable tests that looked like
candidates and explain why they remain. Report the focused and full checks that
ran, production and test line counts, integration state, and named follow-ups.
