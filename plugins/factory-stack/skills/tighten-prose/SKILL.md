---
name: tighten-prose
description: "Edit prose to cut filler, hedging, and stock phrasing, and apply technical-writing rules to docs. Use on text people will read (READMEs, docs, PR descriptions, commit messages, comments); not for a reuse, quality, and efficiency code review (use simplify)."
license: MIT
compatibility: droid
---

# Tighten prose

Scan the text for the patterns below and rewrite. Keep the meaning and the intended tone. For docs, READMEs, RFCs, PR descriptions, and commit messages, also apply [references/technical-writing.md](references/technical-writing.md).

## Patterns

**Content**
- Trailing "-ing" phrases that add a vague effect ("highlighting...", "ensuring..."). Delete, or state the effect.
- Vague attributions ("experts believe"). Name the source or delete.

**Words**
- Stock vocabulary: additionally, crucial, delve, enhance, foster, garner, intricate, landscape, pivotal, showcase, tapestry, testament, underscore, vibrant. Use the plain word.
- "Serves as", "stands as", "boasts", "features". Say "is" or "has".
- "Not just X, but Y." State the point.
- Forced groups of three. Use the real number.
- Synonym cycling. Pick one name and repeat it.
- Abstract metaphor nouns: substrate, wedge, vector, nexus, primitive (as a noun), harness (as a metaphor), surface (as in "API surface"), north star, flywheel, paradigm. Use the concrete word.
- Fancy words: utilize, leverage, facilitate, numerous, in the event that. Use use, help, many, if.

**Style**
- No em dashes. Use a period or a comma.
- A colon only before a list or an example, not as a connector.
- Bold only where a reader scans for it.
- No bold label that restates its line ("**Performance:** Performance improved"). A bold lead-in that names the item and ends in a period is fine.
- Sentence-case headings. No decorative emoji. Straight quotes.

**Chat residue**
- "I hope this helps", "Let me know if", "Certainly", "Great question". Delete.

**Filler**
- "In order to" is "to". "Due to the fact that" is "because". Delete "it is important to note that".
- Stacked hedges ("could potentially possibly"). Use one, or none.
- Generic closers ("the future looks bright"). State a fact or a plan.

**Plain speech**
- Say what it does, not how it feels. Replace "SQL you can read" with "`.toSQL()` returns the exact query string." If a sentence could appear unchanged in another project's docs, cut it.
- One idea per sentence. Split a sentence the reader must parse twice.
- Active voice. Name the actor.
- Cut adverbs, or use a stronger verb or the number.
- No mannered prose: aphorisms, personified code, figurative verbs.
- No over-compression: keep articles and verbs, spell out arrows and abbreviations.

## Done when

Every pattern above is absent from the edited text, the meaning is unchanged, and code identifiers, commands, and quoted output are untouched. Report what you changed in one or two lines, not a diff recital.
