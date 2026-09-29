TEST REVIEW
-----------
A campaign reviews all tests owned by one component or subsystem and removes
low-value tests in one coherent change. Apply the criteria and checks in
[test.md](test.md) throughout. Complete each step before starting the next.

RECORD THE BASELINE
-------------------
At a recorded revision, count the subsystem's test and support lines and record
whether each test file passes. List baseline failures separately. Investigate
those failures before treating the tests as obsolete.

This step is complete when every relevant test file has a recorded result.

ASSIGN EACH TEST
----------------
Group tests by the production code that owns the behavior. Do not group them by
filename prefix. Include tests in shared components and any integration,
system, manual, or live checks owned by the subsystem.

This step is complete when each relevant test and scenario belongs to exactly
one group.

RECORD
------
Review each group without editing it. Read every assigned test in full,
including parameter tables. Read the production code, entry points, callers,
history, and test runner configuration. Record each test case in a written list
with one of these marks. Treat a parameterized test as one case unless its rows
need different marks.

- `R` means keep the test. Name the contract and the regression it could catch.
  A retained test that only moves to a better-named file remains `R`, with the
  move noted.
- `F` means keep the contract and fix the assertion. For example, a negative
  assertion can pass when only one of several expected items is missing.
- `C` means combine the test with another. Name the test that will receive its
  assertion first. It may be a sibling table case, a stronger boundary test, or
  a shared owner in another package.
- `D` means delete the test. Name the test that still proves the contract, or
  explain why no contract exists.

Judge the assertions and exercised behavior. A test's name may claim behavior
that its assertions do not check.

This step is complete when every test case has a mark and an evidence line.

PLAN
----
Use the list from the previous step for a second read-only review. Find groups
of tests that repeat the same behavior. Check whether tests using mocked
collaborators duplicate tests at an observable boundary.

Name the test to keep for each contract. Prefer a test at an observable boundary
with controlled external dependencies when it checks the contract. Correct any
errors in the list.

This step is complete when each group has a plan naming the files to remove,
the test to keep for each contract, the assertions to move, and the production
hooks used only by tests that can be removed.

CHANGES
-------
Edit one group at a time. Give one person responsibility for shared test
harnesses and support files. Remove injection parameters, getters, reset
exports, and indirection code used only by the removed tests. Update test
runner configuration and inventories when tests move. Update any line limits
that may only decrease. Add lasting test ownership rules to the project's
instructions when the campaign reveals a recurring mistake.

This step is complete when every group plan is applied and its retained tests
pass.

COVERAGE
--------
Have independent reviewers compare removed tests with retained tests, with one
reviewer per group of boundaries. They look for contracts that lost their only
test and new assertions that cannot fail. One example is a rejection test that
production code never reaches.

For each restored contract, deliberately change the owning production code
once and confirm that the retained test fails. Restore the source byte for
byte afterward.

This step is complete when every reported gap is restored or rejected using
source evidence, and every restored contract has failed under a deliberate
change.

BUGS
----
Treat a baseline failure that remains in a retained test as a possible product
bug. Confirm the cause and fix the owning code separately from the test removal
change. Check the behavior through its real entry point. Run the same test
without the fix to show the old behavior, then with the fix to show the repair.
Record unrelated product discrepancies as follow-ups.

This step is complete when each repaired defect fails without the fix and
passes with it on the same test harness.

REPORT
------
Report everything required by [test.md](test.md), plus the baseline and final
test and support line counts. Count production lines separately. Name the
groups, removed sets of duplicate tests, and retained tests. Record coverage
gaps and the deliberate changes that exposed them. Include product bugs with
results from runs with and without their fixes.
