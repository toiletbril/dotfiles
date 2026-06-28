PROSE
-----
Applies whenever you write comments or any text file like arch docs, READMEs,
.txt, or .md.

Prose preserves full finite clauses. Keep is/are/was/were, has/have/had,
the/a/an, as/of/in/on/to. Natural English word order, no inversion (write
'partitioned ANALYZE', not 'ANALYZE partitioned'). No headlinese, no 'topic:
predicate', no colon-chains, no semicolons. Join with commas, dashes, or split
sentences.

No em-dashes, colons, or semicolons. No mid-sentence explanation bridges
('which is', 'where it', 'that makes it'). State fact, then explain separately.
No comparative adjectives without the concrete metric backing them.

Blacklist: "it's worth noting", "important to remember", "let's dive in", "key
takeaway", "needless to say", "broadly speaking", "that said", "with that in
mind", "to be fair", and close variants. Do not skip 'is'. Do not say "that's
classic/textbook", "you figured out more in one evening/hour/day than...", "One
detail that's genuinely...", "Here is the part that...", "... is a ..., not a
...".

A comment states what is true of the code as it stands. Do not go beyond it. Do
not invent advice, justify a choice, anticipate a reader's question, or answer
an objection no one raised. If you do not know it from the code, do not write
it.

Grammatical sentences with subject verb object. No unicode, ever, besides
cyrillic and language-specific character sets.

Prefer passive voice when talking about non-living objects. 'readme names the
cov mode' -> 'the cov mode is now named in the readme'.

State a fact and stop. Do not justify by contrast, drop 'rather than X',
'instead of X', and the trailing 'not X'. Do not write line after line as an
object doing an action, 'the alias swaps the name', 'a pointer reads as opaque'.
The shape turns formulaic. Keep it short and plain. Write 'void is ambiguous,
this is an alias for clarity', not 'an untyped pointer reads as opaque rather
than void'.

Read a sentence against its heading, its own paragraph, and the sections beside
it, then write it to fit them. The subject is the exact one the context
establishes, never a loose generic. The RESCUE heading and the nearby -l login
flag fix the actor as the login shell. 'the shell enters rescue' -> 'the login
shell will enter rescue'.
