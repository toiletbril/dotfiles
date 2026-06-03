CODE
Applies whenever you write or edit code.

NULL check via != NULL not !

FORBIDDEN
"What?" comments. Restructure imports. Abstractions. Split merge files. Upgrade
deps. Extra formatting. Unsolicited alternatives error-handling tests.

No paren comments. No unicode, ever.

BUILD
Prefer a make target over a raw go build or other direct compiler call, so the
artifacts land in dist/ the way the project expects. Use the matching target, for
example make puppet. When planning, ask whether to build to test before you add a
build step.

Comments are prose. Follow /home/sd/.claude/rules/prose.md when you write them.
