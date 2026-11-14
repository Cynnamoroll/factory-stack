---
name: explain-how
description: "Explain current code with file references and explorer subagents. Use for unfamiliar code or how-it-works questions; use explain-why for history or rationale, or a bare explorer Task for quick lookups."
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

Give a senior engineer a working mental model, not annotated source. Stay read-only.

## 1. Size the question

If scope is unclear, state your reading and continue.

- **Simple** (one module, one function, a narrow question). Read the code yourself and go to step 3.
- **Complex** (a subsystem across files or services, a cross-cutting feature, an architecture overview). Go to step 2.

When in doubt, take the simple path.

## 2. Explore in parallel

Split the question into 2 to 4 angles, each a distinct slice of the subsystem. Issue one `explorer` Task per angle, all in one message. Build each prompt from [references/explorer-prompt.md](references/explorer-prompt.md) with the question and the angle filled in.

## 3. Write the walkthrough

Merge explorer reports and settle contradictions from code without re-exploring. Follow [references/walkthrough-format.md](references/walkthrough-format.md), omitting inapplicable sections.

## Done when

- Every claim about behavior cites a real `file:line` or symbol you or an explorer read.
- Open questions the explorers could not trace are listed, not hidden.
- No file was changed.
