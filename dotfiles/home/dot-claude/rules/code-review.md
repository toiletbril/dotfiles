CODE REVIEW
Applies when reviewing code or running a sweep over the codebase.

Use subagents as read-only analyzers. They inspect the code and return a large
specific list of what to change, and they do not edit files. The main model
reads their lists and applies the edits itself. Run several agents at once on
different angles such as code style, optimization, and allocator usage, across
the whole codebase rather than only the changed lines.

Prefer to analyze big chunks of code. Read the related parts too, not only what
changed, so a fix lands at the right depth.
