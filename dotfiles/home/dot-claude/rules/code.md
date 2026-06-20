CODE
----

NULL check via != NULL not !, nullptr, or nil where applicable.

Do not write new abstractions without approval. Do not split or merge files,
upgrade deps.

Names are verbose and semantic, never terse. A boolean reads `is_`, `should_`,
`was_`, `did_`, or `has_`. A number carries a `_count` suffix or a measure
suffix such as `_length`, `_depth`, or `_position`, and never a bare `n_`
prefix, because a name like `line_length` already reads as a number. A
variable-bound lambda is named `do_`. An accessor reads `get_` or `set_`, with
no shorthand. A clear name replaces a comment that would explain an unclear one.
A comment states why the code is the way it is, not what it does.

An if whose condition has `&&` or `||` is braced, while a trivial
single-condition if stays unbraced. Logical blocks are separated by a blank
line, before and after a loop, before a return, and after a group of
declarations.

A chain of three or more name comparisons becomes a static table rather than an
if ladder. The completion and the parser dispatch hot paths pack a key and read
the table as data. A hot dispatch on a leading byte becomes a switch, or a static
dispatch table.

NEW
---

Before implementing anything new, ask whether the codebase already implements
it. Search for an existing function, parser, or helper that does the work and
reuse it rather than writing a second copy.

COMMENTS
--------

See @rules/prose.md

Do not write comments that answer "what?", instead answer "why?".
Avoid repeating and clarifying too much of already known information.

Keep comments short. Do not overuse them for all ocassions. Only comment if the
reason for written code can't be understood from the code itself.

Never write a comment in the "so, ..." shape that tacks a justification clause
onto a restatement of the code. State the one reason plainly and stop.

BUILD
-----

Prefer a make target over a raw go build or other direct compiler call, so the
artifacts land in the build folder the way the project expects. When planning,
ask whether to build to test before you add a build step.

Suggest writing .clangd or language equivalents to fix LSP when there's linter
error due to bogus import paths and unresolved symbols.

LOGS
----

Log helper behavior and what the function does as it runs to trace the runtime,
not return results.

Prefer verbose logging, use @rules/prose.md.
