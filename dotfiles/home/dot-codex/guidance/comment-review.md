COMMENT REVIEW
--------------
Applies when reviewing code, reviewing a diff, or sweeping a codebase for
comments.

A comment exists to help the reader hold a model of the data in their head.
A comment that does not do this is deleted. The review runs in two waves,
prune then write. It edits only comments.

Use subagents as read-only analyzers. Each agent inspects a file or a
function and returns findings; it never edits. The main model reads the
findings, rejects weak ones, and applies the justified changes itself.

Every agent must reread the project-specific `AGENTS.md`, nearby code, and
the callers of the function it analyzes before reporting anything.

WAVE 1: PRUNE
-------------
Delete a comment when a reader with the code open loses nothing without it.
This removes:

1. restatements of the code ("increment i", "return the result");
2. commented-out code;
3. author tags, dates, changelog lines, section banners;
4. TODO/FIXME without a tracker reference;
5. remarks addressed to the reader ("note that", "be careful", "tricky")
   that carry no fact.

A "why" comment is kept only after its reason has been checked against the
current code. If the reason holds, keep the comment and name the constraint.
If the reason no longer holds, report it as a finding, because the code may
now be wrong.

WAVE 2: WRITE
-------------
Add a comment only where one of the four kinds below is missing. Write every
comment in present tense, as a statement about the data, before the block it
describes. Do not write comments about the reader's feelings.

FORM
----
1. a function named in a comment carries `()` after its name
   (`heap_getnext()`), which distinguishes a call from a variable or type of
   the same word;
2. comments are lowercase, including the first word of a sentence;
3. identifiers keep their exact spelling so a search for the name finds the
   comment.

STATE CHECKPOINT. In a function with early returns or guards, one comment
after the last check states what is now true: what is locked, what is
non-null, who else can see the data, which memory context owns allocations.
Put it next to an `Assert` where one can be written.

    /*
     * at this point: rel is locked AccessShareLock, tupdesc is valid for the
     * whole call, and no other backend can see this entry.
     */

WORKED EXAMPLE. In a function whose steps transform data in a way the reader
cannot simulate, choose one concrete input that exercises the hard branch and
carry it through every step with its real values. One example per function.
The step annotation trails the line whose result it shows.

    /* e.g. chunks = [16, 8, 32], want = 24 */
    qsort(chunks, n, sizeof(*chunks), cmp_size);
    /* -> [8, 16, 32]; first fit at index 2, leftover 8 returns to free list */

COST HEADER. Required on a function that allocates, is superlinear in any
input, does I/O or syscalls, takes a lock, or is called from a loop. Name the
input the cost depends on and who frees the memory. A function without a cost
header is trivial.

    /*
     * memory: palloc() 2*nkeys pointers in CurrentMemoryContext; caller frees
     *         by resetting the context.
     * time:   O(nkeys log nkeys) for qsort(), one hash probe per key. no locks.
     */

WHY. On a non-obvious choice, state the constraint that forced it, with a
pointer: bug id, lock order, ABI document, measurement. A "why" that cannot
name its constraint is not written.

ANTI-SLOP RULES
---------------
A finding is valid only when it identifies:

1. the exact comment or the exact undocumented block;
2. which of the four kinds applies, or which prune rule applies;
3. the fact the comment states, checked against the code;
4. for a worked example, the input values and the value after each step;
5. compliance with FORM.

A finding is rejected when:

1. the proposed comment restates the code;
2. the cost header names a complexity that was neither measured nor derived
   from the loop structure;
3. the example values do not survive a step;
4. the "why" names no constraint.

STALENESS
---------
A change to a loop, allocation, or lock inside a function reopens its cost
header and its checkpoints; confirm or update them in the same commit. A
comment that no longer matches the code is a bug of the same severity as the
code being wrong, because the reader will debug the wrong hypothesis first.

CI MODE
-------
Applies when the review runs unattended.

Write only worked examples. Do not prune and do not add cost headers,
checkpoints, or "why" comments. Do not touch existing comments.

Target functions in the diff that have no example and whose steps transform
data: sort, partition, merge, rewrite, encode, parse. Everything else this
rule would produce goes into the review output as a finding.
