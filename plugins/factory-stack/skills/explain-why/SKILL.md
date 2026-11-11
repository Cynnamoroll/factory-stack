---
name: explain-why
description: "Explain why code is the way it is from git history, PRs, issues, and connected MCP sources, citing each claim. Use for design rationale, regressions, and postmortems; not for how code works now (use explain-how) or local session history (use droid search)."
license: MIT
compatibility: droid
---

# Explain why

Code shows what it does, not why it exists. The reasons live in commits, PRs, tickets, docs, chat, and incident data, all incomplete. Investigate like a careful historian. Separate what the record says from what you infer. Read [references/epistemics.md](references/epistemics.md) before writing the answer.

## 1. Pin the target and the question

The target is code, a pattern, or a named decision. The question is a rationale, a tradeoff, an edge case, an external constraint, dead code, or a history sweep. If the target is vague, state your best reading from the conversation and continue.

## 2. Build the code anchor yourself

Before any fan-out, collect the seed every investigator gets:

- file paths, line ranges, and key symbols
- `git blame -L <start>,<end> <file>` for last-touch commits
- `git log --follow --oneline -- <file>` and `git log -1 --format=%B <sha>` for history and PR numbers
- `gh pr view <n> --json title,body,author,mergedAt,closingIssuesReferences,comments,reviews` for each substantive PR
- ticket IDs mentioned in commits or PR bodies

## 3. Fan out one investigator per evidence source

List the MCP servers this session has. Map each to one category: issue tracker, long-form docs, team chat, observability, error tracking, or analytics warehouse. Source control (`git`, `gh`) is always a category.

Issue one Task per category, all in one message. Each owns exactly one source and never chases another source's leads. Use a `worker` Task and state in the prompt that it must not write files or change external state. `explorer` is read-only but may not carry shell or MCP tools, which these investigators need. Build each prompt from [references/investigator-prompt.md](references/investigator-prompt.md). If the target looks defensive (retries, timeouts, null guards, rate limits, feature flags), tell the investigator to search for the incident behind it.

Skip a category only with a written reason that goes in the answer: no MCP server for it, or the source is provably irrelevant (for example, error tracking for a build-time script).

## 4. Synthesize

Weigh the reports yourself. Merge duplicate citations, keep contradictions visible, spot-check any citation you doubt, and place every claim in one confidence tier. Write the answer in the shape of [references/answer-format.md](references/answer-format.md).

If the question precedes a change, end with a constraint set for the change: what to preserve, what to change, what to avoid, and the risk.

## Done when

- Every Direct or Supported claim has a citation (PR, ticket, URL, commit, or `file:line`).
- Inferred and speculative claims are hedged and show their chain.
- "What we don't know" names specific searches that came back empty.
- Sources consulted has one line per category, including skipped ones with the reason.
- No file or external state was changed.
