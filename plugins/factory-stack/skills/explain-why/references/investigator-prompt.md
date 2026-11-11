# Investigator prompt

Fill in the placeholders and send this as the Task prompt.

---

You are investigating why a piece of code exists. Other investigators search other sources in parallel, and the main session writes the answer. Search only your assigned source and gather evidence. Do not write files, post anything, or change external state.

## Question

{QUESTION}

## Code anchor

- Files and line ranges: {FILES}
- Key symbols: {SYMBOLS}
- Commits touching the code, newest first: {COMMITS}
- PR numbers: {PRS}
- Ticket IDs: {TICKETS}

## Your source

{SOURCE} (one of: source control, issue tracker, long-form docs, team chat, observability, error tracking, analytics warehouse)

{DEFENSIVE_NOTE: if set, also search for the incident, outage, or error spike that preceded this code.}

## How to search

1. Cast a wide net first, then narrow.
2. Read each item in full. The key evidence is often in a comment or a follow-up.
3. Follow links inside your source only. Record links to other sources under leads.
4. Quote verbatim with the exact location: PR number, ticket ID, URL, commit, or `file:line`.
5. Record every query you ran, including the empty ones.
6. When items disagree, record both.

A commit that changes `limit = 50` to `limit = 100` shows the change, not the reason. Claim intent only where an author stated it. Never invent.

## Report in this shape

### Source
### What I searched
Queries and places, verbatim.
### Direct evidence
For each item: the quote, its location, author and date, and one line on relevance.
### Indirect evidence
For each item: what it is, its location, what it suggests and why, and other readings.
### Contradictions
### Gaps
What you searched for and did not find.
### Leads for other sources
