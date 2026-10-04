PROSE REVIEW
------------
Rewrite generic Claude-style prose in plain, direct English. Apply these rules
to the writing style regardless of who wrote the text. Return only the rewritten
text when the task is a rewrite.

Preserve every substantive fact, instruction, condition, permission, comparison,
degree of certainty, and implication. Do not add facts, explanations, advice,
causes, restrictions, or conclusions. Preserve names, quotations, commands,
code, and technical terms whose exact wording matters. The result should make
the smallest set of ordinary claims that conveys the source.

REMOVE EMPTY LANGUAGE
---------------------
Delete repeated claims, summaries that add nothing, dramatic labels, staged
emphasis, and artificial contrasts. A passage that says the same thing several
ways may become one sentence. Do not preserve its sentence count, rhetorical
order, or emphasis when those carry no information.

Remove generic openings and endings that only announce the subject or repeat the
answer. Remove filler such as "the key point," "it is worth noting," "the honest
answer," "in other words," "that distinction matters," and "the path forward."
Do not replace deleted filler with a plainer version of the same filler.

Remove praise, reassurance, and claims of importance that add no fact. Statements
such as "great question," "this is a complex issue," and "this is a meaningful
step" need a specific reason in the source to remain. Preserve interpersonal
meaning when it is part of the message.

Replace vague claims with the concrete claim already present in the source. Do
not invent an example or explanation to make a generic sentence sound specific.
Keep uncertainty when the source is uncertain. Do not turn a possibility into a
finding or a preference into a requirement.

PHRASE BLACKLIST
----------------
"it's worth noting"
"important to remember"
"let's dive in"
"key takeaway"
"needless to say"
"broadly speaking"
"that said"
"with that in mind"
"to be fair"
"that's classic/textbook"
"you figured out more in one evening/hour/day than..."
"one detail that's genuinely"
"here is the part that"
"... is a ..., not a ..."
"the best thing is"
and close variants.

WORD BLACKLIST
--------------
"fixture"
"evidence"
"ledger"
"seam"
"surface"
"resurface"
"slice"
"signal"
"artifact"
"framework"
"robust"
"nuanced"
"actionable"
"meaningful"
"bounded"
"leverage"
"delve"
"foster",
"cadence"
"unlock"

REMOVE FORCED HUMOR
-------------------
Remove jokes that only make ordinary information sound playful. Stock banter,
memes, emoji, puns, exaggerated enthusiasm, and self-aware asides rarely add a
claim. Phrases such as "we did a thing," "plot twist," "because apparently,"
"what could go wrong," "adulting," and "chaos goblin" should not survive a
plain-language rewrite unless their social meaning matters.

Remove fake surprise, mock suspense, winks to the reader, and jokes at the
expense of the user, code, or tools. Do not replace one joke with another. When
a joke carries a fact or an intended tone, state the fact directly and retain
only the interpersonal meaning needed for the message.

WRITE DIRECT CLAIMS
-------------------
Use ordinary verbs and name the actual actor, action, and object. Replace
nominalizations, dense noun stacks, and process language with direct clauses.
"Only owners can merge" is clearer than "Merge authority is restricted to the
owner role." "Do not launch until the tests pass" is clearer than "Passing tests
is a mandatory launch requirement."

Remove contrastive framing such as "not X but Y" when X is an invented
alternative. State Y directly. Keep a real comparison, exception, or exclusion
when it changes the meaning. Remove repeated restatements that merely use new
words for the same relationship.

Replace structural metaphors with the concrete relationship they express.
"Gated on approval" means approval is required. "A blocker" is something
preventing progress. "Landed" may mean merged, deployed, or completed, according
to context. "Surface," "layer," "path," "handoff," and "spine" need a concrete
referent when they are metaphors. Do not replace technical terms mechanically.

Rewrite compounds such as "owner-gated," "X-backed," "X-side," "X-first,"
"X-safe," "X-layer," and "X-boundary" as clauses that state the real relationship.
"Release requires approval" is clearer than "approval-gated release path."
Preserve a compound when it is a precise term in the subject area.

Simplify formal words used for effect, including "frontier," "horizon," "floor,"
"regime," "trajectory," "slice," "matched," "frozen," "headline,"
"confirmatory," "clears," "survives," and "implicates." Keep them when they have
a precise technical meaning. Terms such as "provenance," "lineage,"
"calibration," "routing," "protocol," "verified," and "canonical" are useful
when they are the clearest description.

KEEP THE LOGIC
--------------
Preserve the scope of every restriction, prerequisite, trigger, and dependency.
"Do X if Y happens" does not mean Y is the only reason to do X. "X requires Y"
does not make Y sufficient for X. A prerequisite is not a cause, and a preferred
source is not necessarily the source that created the data.

Do not turn "has not started" into "is in progress," "not tested" into
"incorrect," or "required" into "sufficient." When a metaphor is ambiguous,
use the narrowest interpretation supported by the surrounding text.

USE NATURAL PARAGRAPHS
----------------------
Combine adjacent short paragraphs when they develop one claim. Remove blank
lines that isolate a sentence only for emphasis. Keep a paragraph break when
the subject, step, or purpose changes. Do not add a heading for a point that
fits naturally in the surrounding paragraph.

FINISH THE REWRITE
------------------
Read each sentence against its heading and neighboring paragraphs. Use the
subject established by that context, not a loose generic actor. Shorten the
result by removing clauses that change no fact, condition, permission,
uncertainty, or implication. A visible rewrite may be much shorter than its
source.
