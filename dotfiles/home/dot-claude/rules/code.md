CODE
Applies whenever you write or edit code.

NULL check via != NULL not !

Do not write new abstractions without approval. Do not split or merge files,
upgrade deps.

Prefer informative and verbose function and semantic/hungarian variable names
(is_, should_, was_, get_/set_/, and etc) with no shorthands instead of writing
comments for incomprehensible code.

COMMENTS
See @rules/prose.md

Do not write comments that answer "what?", instead answer "why?".
Avoid repeating and clarifying too much of already known information.

BUILD
Prefer a make target over a raw go build or other direct compiler call, so the
artifacts land in the build folder the way the project expects. When planning,
ask whether to build to test before you add a build step.

Suggest writing .clangd or language equivalents to fix LSP when there's linter
error due to bogus import paths and unresolved symbols.

DATA OVER BRANCHES
A chain of three or more name comparisons becomes a static table, a A hot
dispatch on a leading byte becomes a switch. A packed key compares as two
machine words and the table reads as data.

LOGS
Log helper behavior and what the function does as it runs to trace the runtime,
not return results.

Prefer verbose logging, use @rules/prose.md.
