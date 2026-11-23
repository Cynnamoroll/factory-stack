---
name: build-feature
description: "Design, build, and verify features, prototypes, or visual-parity changes. Use Spec mode alone for plans and refactoring-playbook for large migrations."
license: MIT
compatibility: droid
---

# Build feature

Own the design and review. Delegate implementation.

## 1. Ground and design

1. Run `explain-how` on the affected subsystem.
2. Enter Spec mode. Write the caller's view first (the call sites or user steps), then the data shape and its organizing structure (`engineering-principles`, model-the-domain), then the plan. Screen the shape against [references/design-red-flags.md](references/design-red-flags.md). For a contested or cross-cutting design, write the rationale with [references/rationale-template.md](references/rationale-template.md). Exit Spec mode for approval.
3. If the shape has several valid forms and the choice matters, run `/race-worktrees` instead of picking one by feel.

## 2. Plan the work

Write four todo items, marking any inapplicable item `n/a: <reason>`.

- **Blocking first steps.** What must land before anything else.
- **Independent workstreams.** Disjoint files or layers that can run in parallel.
- **Shared state.** Split shared write targets. Serialize only real invariants.
- **Smallest decomposition.** If one worker is best, say why.

## 3. Build

Give each workstream to one `principled-worker` Task with file paths, data shape, and success criteria. Parallel writers on separate files use `droid exec -m auto --auto medium --worktree <name>`. Review every diff. Verify each small, ordered commit before the next.

## 4. Verify

Run `prove-it-works` on the running app. If the design was contested, run `adversarial-review` before shipping.

## Variants

- **Prototype.** Build throwaway variants behind one switcher in a scratch directory outside the source tree. Use the lightest stack that shows the idea. Capture screenshots or timings for each variant using the surface picked by `prove-it-works`. Present the evidence and recommendation; label the prototype throwaway.
- **Visual parity.** Capture a screenshot baseline of every component state before any change. Never edit the baseline or the harness to pass. Migrate one component at a time, shared pieces first. A component passes only at zero image diff against its baseline.

## When validation fails

Fix the cause and rerun `prove-it-works`. If the design itself is wrong, go back to Spec mode rather than patching around it.

## Done when

The reply covers what was built, the design choices and why, the four planning items, the `prove-it-works` evidence, and open decisions. A prototype reply has the variants, evidence, recommendation, and scratch path. A visual-parity reply has each component's diff result.
