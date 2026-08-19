CODE
----
NULL check via != NULL not !, nullptr, or nil where applicable.

Do not write new abstractions without approval. Do not split or merge files,
upgrade deps.

Prefer writing optimized code. For legacy-full languages, ask to reimplement or
adjust datastructures if that'll help with cache locality or memory footprint.

Names are verbose and semantic.
- A boolean should start with `is_`, `should_`, `was_`, `did_`, or `has_`.
- Add `_count` suffixes or a measure suffix such as `_length`, `_depth`, or
  `_position` to numbers.
- A variable-bound lambda should always start with `do_`.
- An accessor reads `get_` or `set_`, with no shorthand.

An if whose condition has `&&` or `||` is braced. Logical blocks are separated
by a blank line, before and after a loop, before a return, and after a group of
declarations.

NEW
---
Before implementing anything at all, ask whether the codebase already
implements it. Search for an existing function, parser, or helper that does the
work and reuse it rather than writing a second copy.

COMMENTS
--------
See ~/.codex/guidance/prose.md.

Do not write comments unless user explicitly asks. Ever.

BUILD
-----
Prefer a make target over a raw build or other direct compiler call, so the
artifacts are put in the build folder as te project expects. When planning, ask
whether to build to test before you add a build step.

LOGS
----
Log helper behavior and what the function does as it runs to trace the runtime,
not return results.

Prefer verbose logging, and use ~/.codex/guidance/prose.md.
