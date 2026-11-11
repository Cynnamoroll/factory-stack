---
name: explain-how
description: "Explain how code works today in a walkthrough with file references, using explorer subagents. Use before changing unfamiliar code or for how-does-X-work questions; not for history or rationale (use explain-why) and not for a quick lookup (use a bare explorer Task)."
license: MIT
compatibility: droid
allowed-tools:
  - Read
  - Grep
  - Glob
  - LS
  - Task
---

# Explain how

Write the explanation a senior engineer needs to start working in a subsystem: enough for a working mental model, not annotated source. This skill is read-only.

## 1. Size the question

If the scope is unclear, state your reading and continue. The user can redirect.

- **Simple** (one module, one function, a narrow question). Read the code yourself and go to step 3.
- **Complex** (a subsystem across files or services, a cross-cutting feature, an architecture overview). Go to step 2.

When in doubt, take the simple path.

## 2. Explore in parallel

Split the question into 2 to 4 angles, each a distinct slice of the subsystem. Issue one `explorer` Task per angle, all in one message. Build each prompt from [references/explorer-prompt.md](references/explorer-prompt.md) with the question and the angle filled in.

## 3. Write the walkthrough

Reconcile the explorer reports yourself. Merge overlaps, and settle contradictions by reading the code. Do not re-explore from scratch. Write the result in the shape of [references/walkthrough-format.md](references/walkthrough-format.md), dropping sections that do not apply.

## Done when

- Every claim about behavior cites a real `file:line` or symbol you or an explorer read.
- Open questions the explorers could not trace are listed, not hidden.
- No file was changed.
