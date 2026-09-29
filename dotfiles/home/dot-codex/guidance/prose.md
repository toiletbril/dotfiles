PROSE
-----
Applies whenever you write comments or any text file like arch docs, READMEs,
.txt, or .md.

Documentation is not your dumping ground. When writing any documentation, make
sure it contains only currently-relevant information. No historical data, no
unnecessarily details nits and no information for developer if the piece of
writing is meant for the end users.

Avoid stock internet banter, exaggerated enthusiasm, and self-aware asides.
Phrases such as "we did a thing," "plot twist," "because apparently," "what
could go wrong," "adulting," and "chaos goblin" turn a factual point into a
performance. Do not use a wink, emoji, meme, pun, or mock-dramatic pause as a
substitute for a clear sentence.

Do not make the reader, user, code, or tools the butt of a joke. Avoid fake
surprise, forced cuteness, and repeated callbacks to an earlier joke. When a
light remark fits, state it once and return to the subject.

Grammatical sentences with subject verb object. No unicode, ever, besides
cyrillic and language-specific character sets.

Prefer passive voice when talking about non-living objects. 'readme names the
cov mode' -> 'the cov mode is in the readme'.

STYLE
-----
Prose preserves full finite clauses. Keep is/are/was/were, has/have/had,
the/a/an, as/of/in/on/to. Natural English word order, no inversion (write
'partitioned ANALYZE', not 'ANALYZE partitioned'). No headlinese, no 'topic:
predicate', no colon-chains, no semicolons. Join with commas, dashes, or split
sentences.

Never write a comment in the "so, ..." shape that tacks a justification clause
onto a restatement of the code. State the one reason plainly and stop.

Do not justify by contrast. Drop 'rather than X', 'instead of X', and the
trailing 'not X'. Do not write every comment as an object doing an action ('the
alias swaps the name', 'a pointer reads as opaque'), the shape turns formulaic.
Keep it short and human. See @rules/prose.md.

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

State a fact and stop. Do not justify by contrast, drop 'rather than X',
'instead of X', and the trailing 'not X'. Do not write line after line as an
object doing an action, 'the alias swaps the name', 'a pointer reads as opaque'.
The shape turns formulaic. Keep it short and plain. Write 'void is ambiguous,
this is an alias for clarity', not 'an untyped pointer reads as opaque rather
than void'.
