---
name: explain-why
description: "Trace code rationale, regressions, and postmortems to cited records. Use explain-how for current behavior."
license: MIT
compatibility: droid
---

# Explain why

Trace reasons through incomplete commits, PRs, tickets, docs, chat, and incident data. Separate records from inference. Read [references/epistemics.md](references/epistemics.md) before answering.

## 1. Pin the target and the question

Name the code, pattern, or decision and the question (rationale, tradeoff, edge case, external constraint, dead code, or history sweep). If vague, state your best reading and continue.

## 2. Own source control in the parent

Anchor the question to paths, lines, and symbols. Trace `git blame` and `git log --follow` to substantive commits and their PRs; collect cited reasons, linked records, and gaps. Do not assign this history to a second reader.

## 3. Route gaps to evidence sources

Go straight to synthesis for a narrow question answered by an author record if there is no unresolved contradiction, relevant lead, incident signal, or requested breadth. Otherwise route each gap to the source that can resolve it: issues, docs, chat, observability, errors, or analytics. For defensive code, investigate the incident rather than inferring a reason from the guard.

Check a single bounded lead inline. Parallelize independent sources with [the investigator brief](references/investigator-prompt.md). Give each only its gap, source, and relevant identifiers. Use read-only tools when they support the source; otherwise give the worker an explicit no-write brief. Follow new cross-source leads in the parent. Report why each category was searched or skipped.

## 4. Synthesize

Weigh reports, merge duplicate citations, expose contradictions, check doubtful citations, and assign every claim a confidence tier. Follow [references/answer-format.md](references/answer-format.md).

If the question precedes a change, end with a constraint set for the change: what to preserve, what to change, what to avoid, and the risk.

## Done when

- Every Direct or Supported claim has a citation (PR, ticket, URL, commit, or `file:line`).
- Inferred and speculative claims are hedged and show their chain.
- "What we don't know" names specific searches that came back empty.
- Sources consulted has one line per category, including skipped ones with the reason.
- No file or external state was changed.
