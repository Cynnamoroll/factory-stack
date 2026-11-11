---
name: engineering-principles
description: "Apply the engineering principle that settles a coding or review decision, reading only the files that apply. Use when a choice needs a named principle such as fix root causes or explain the number; not for always-on repository rules (use AGENTS.md) and not to run a verification procedure (use prove-it-works or vet-measurement)."
license: MIT
compatibility: droid
user-invocable: false
allowed-tools:
  - Read
  - Grep
  - Glob
---

# Engineering principles

Each principle is one file beside this one. Read the whole file for any principle you apply, then name it in your reply with the choice it changed. Cite only principles you read this session. Do not load all of them.

## Core

- [laziness-protocol.md](laziness-protocol.md). Refactoring, sizing a diff, or tempted to add a layer. Bias to deletion and the smallest change.
- [foundational-thinking.md](foundational-thinking.md). Before writing logic. Core types and data structures first, scaffold before features.
- [redesign-from-first-principles.md](redesign-from-first-principles.md). A new requirement meets an existing design. Redesign as if it had been there from the start.
- [attack-the-premise.md](attack-the-premise.md). Two fixes that share one premise failed the same gate. Test the premise before a third fix.
- [subtract-before-you-add.md](subtract-before-you-add.md). Sequencing an addition or rewrite. Remove dead weight first.
- [minimize-reader-load.md](minimize-reader-load.md). Code is hard to trace. Count layers and hidden state, then cut them.
- [outcome-oriented-execution.md](outcome-oriented-execution.md). A planned rewrite or migration with phase boundaries. Converge on the target, skip throwaway compatibility code.
- [experience-first.md](experience-first.md). Product, UX, or scope tradeoffs. Choose the user's experience over implementation convenience.
- [exhaust-the-design-space.md](exhaust-the-design-space.md). A novel interaction or architecture with no precedent. Compare 2 or 3 prototypes before committing.
- [build-the-lever.md](build-the-lever.md). Any non-trivial work. Build the script, codemod, or check that does or proves it.

## Architecture

- [model-the-domain.md](model-the-domain.md). Stateful logic, heavy branching, or a shape assumption repeated across files. Encode the domain in a structure.
- [boundary-discipline.md](boundary-discipline.md). Validation, error handling, or framework adapters. Guard at boundaries, trust internal types.
- [type-system-discipline.md](type-system-discipline.md). Designing types or a signature. Make illegal states unrepresentable.
- [make-operations-idempotent.md](make-operations-idempotent.md). Commands or loops that run amid crashes and retries. Converge to one end state.
- [migrate-callers-then-delete-legacy-apis.md](migrate-callers-then-delete-legacy-apis.md). A new internal API while old callers exist. Migrate and delete in one wave.
- [separate-before-serializing-shared-state.md](separate-before-serializing-shared-state.md). Concurrent writers might share a file, branch, or key. Remove the sharing first.

## Verification

- [prove-it-works.md](prove-it-works.md). Before declaring done. Check the real artifact, not a proxy. The procedure is the [prove-it-works](../prove-it-works/SKILL.md) skill.
- [fix-root-causes.md](fix-root-causes.md). Debugging. Fix the first place the system went wrong.
- [sequence-verifiable-units.md](sequence-verifiable-units.md). Multi-step work and commit order. Each unit ends in a check.
- [test-behavior-not-implementation.md](test-behavior-not-implementation.md). Writing or keeping a test. Assert what users of the code can observe.
- [explain-the-number.md](explain-the-number.md). Before trusting or reporting a measured number. Name the limiter. The procedure is the [vet-measurement](../vet-measurement/SKILL.md) skill.

## Delegation

- [guard-the-context-window.md](guard-the-context-window.md). Context is filling up. Send bulk reads to `explorer` Tasks and keep summaries.
- [never-block-on-the-human.md](never-block-on-the-human.md). Tempted to ask "should I do X?" on reversible work. Do it and report.

## Meta

- [encode-lessons-in-structure.md](encode-lessons-in-structure.md). The same instruction comes up a second time. Make it a check, not more text. The procedure is `/add-guardrail`.

## Done when

Every principle named in the reply was read in full this session, and each one is tied to a specific decision it changed.
