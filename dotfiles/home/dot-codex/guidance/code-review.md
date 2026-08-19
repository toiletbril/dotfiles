CODE REVIEW
-----------
Applies when reviewing code or running a sweep over the codebase.

Use subagents as read-only analyzers. They inspect the code and return a large
specific list of what to change, and they do not edit files. The main model
reads their lists and applies the edits itself. Run several agents at once on
different angles such as code style, optimization, and allocator usage across
the changed lines.

Prefer to analyze big chunks of code. Read the related parts too, not only what
changed, so a fix lands at the right depth.

First pass is style adherence. You should read the docs, existing AGENTS.md or
related files, then search for style inconsistencies and fix them.

You should search for code that is duplicated across modules and which can be
hoisted into single helper functions. Ask yourself "can this be made
simpler?"--and if yes, simplify the code.

Optimize reviewed code. Prefer switch cases or static tables before if-else
chains. Make sure you understand hot paths and check for low-hanging fruits in
it.

Last wave should always be correctess, after all. Make sure the software passes
all tests and is otherwise fool-proof and right.

If the user asks you to do the review on the whole codebase, ask what he needs
from review, and begin in parallel.

Each agent should always reread project-specific AGENTS.md before starting
work.
