# Technical writing

Write so a tired engineer understands on the first read. Three rules sit above the rest:

- Cut every word that does no work.
- Use the short, everyday word.
- When a rule makes a sentence worse, fix the sentence another way or leave it alone.

Write the real symbol, file, flag, or command, not a synonym for it. Do not invent jargon.

## Pick one mode per document

- **Tutorial** (doing, learning). Say what the reader will build. Each step shows a visible result and what they should see. Explanation is one clause and a link.
- **How-to** (doing, working). Solve one problem a competent reader has. Steps only. Allow forks: "If you want X, do Y." Title it by the task.
- **Reference** (knowing, working). Describe only. Dry, complete, no opinion. Mirror the structure of the thing described.
- **Explanation** (knowing, learning). One bounded topic and its why: decisions, history, constraints, alternatives. Opinion belongs here and nowhere else.

Do not mix modes in one document. Split and link.

## Sentences

- Address the reader as "you", in the present tense.
- Name who does what. Passive only when the actor is unknown or beside the point.
- Write instructions as commands. Put the condition first: "To delete the file, run X."
- Common case first, exceptions after.
- Never "simply", "easy", or "quickly" in a procedure.
- Link text says where the link goes. Never "click here".
- Headings carry the point, in sentence case. One H1 per page.
- Numbered lists for sequences, bullets otherwise. Introduce a list with a full sentence. Keep items parallel.
- Code in code font. Serial commas. No "etc."

## One reading only

- One instruction per sentence. Split instructions over about 20 words.
- Put a warning before the step it guards.
- Keep "the" and "a".
- One word per action, one meaning per word, one name per thing.
- Keep "only" and "not" next to the word they change.
- Break up long noun strings.
- Make every "it", "this", and "they" point at one obvious noun.
- No semicolons, slashes, "(s)" plurals, idioms, or Latin abbreviations.

## Rhythm

Mix sentence lengths. Short sentences land a point. Longer ones carry a fact with its condition. Be specific: "a column rename fails the build", not "schema changes can cause issues."

## PRs and commits

A PR body is a briefing a reviewer reads in under a minute: why, what changed, what it leaves out, what it could break, how you proved it. Link logs and tables instead of pasting them. Make every count or tree claim true at the commit that lands it.

## Example

Before:

> Configuration of the import budget script parameters is performed via budget.json. Note that it's important to remember that running with --write should only be done when lowering it. If exceeded, CI fails.

After:

> `budget.mjs` reads the budget from `budget.json` and counts the files that import protos. If the count exceeds the budget, CI fails. Run `budget.mjs --write` only to lower the budget.
