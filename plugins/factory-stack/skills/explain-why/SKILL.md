---
name: explain-why
description: "Explain code rationale from git, PRs, issues, and connected MCP sources with citations. Use for design rationale, regressions, and postmortems; use explain-how for current behavior or droid search for session history."
license: MIT
compatibility: droid
---

# Explain why

Trace reasons through incomplete commits, PRs, tickets, docs, chat, and incident data. Separate records from inference. Read [references/epistemics.md](references/epistemics.md) before answering.

## 1. Pin the target and the question

Name the code, pattern, or decision and the question (rationale, tradeoff, edge case, external constraint, dead code, or history sweep). If vague, state your best reading and continue.

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

Weigh reports, merge duplicate citations, expose contradictions, check doubtful citations, and assign every claim a confidence tier. Follow [references/answer-format.md](references/answer-format.md).

If the question precedes a change, end with a constraint set for the change: what to preserve, what to change, what to avoid, and the risk.

## Done when

- Every Direct or Supported claim has a citation (PR, ticket, URL, commit, or `file:line`).
- Inferred and speculative claims are hedged and show their chain.
- "What we don't know" names specific searches that came back empty.
- Sources consulted has one line per category, including skipped ones with the reason.
- No file or external state was changed.
