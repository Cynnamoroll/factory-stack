---
name: maintain-tla-model
description: "Update existing TLA+ models so they stay in step with the code, then run tla-check. Use after commits touch code a model covers; not to write the first model (use create-tla-model) or only to run the checker on unchanged models (use tla-check)."
license: MIT
compatibility: droid
---

# Maintain TLA model

When code changes and its model does not, the check keeps passing on code that no longer exists. That pass is the dangerous case, because it looks like proof. This skill brings models back in step.

## Edit scope

Edit only models, configs, and `COVERAGE.md`. Never edit product code unless the user asks. When a rule fails on the current code, report it. Do not weaken the rule or the model to make it pass.

## Pass

1. **Find the models.** Look for `*.tla` files with a `COVERAGE.md` (or the model the user named). From each, collect the rules, the covered code, the bounds, the run command, and the sync commit. With no coverage record, use the last commit that touched the model and say so. With no model at all, stop and point at `create-tla-model`.
2. **Run it as it is.** Run `tla-check` once before changing anything and record the result. A pass only means the old description still holds.
3. **Read every change to covered code.** `git log -p <sync>..HEAD -- <covered files>`, plus renamed or moved functions and new code that writes the same state. Classify each change:
   - **No effect.** Formatting, comments, or paths the model does not cover. Check against the model, not the commit message.
   - **Model drift.** An atomic step became two, a branch appeared, a check moved, or a value range changed. The model must change.
   - **Intended promise change.** The docs, tests, or commit message say the promise changed. The rule changes, and you cite the evidence.
   - **Possible break.** The code changed and nothing says the promise did. A failure that follows is a bug candidate.
4. **Update from the code.** Rewrite the changed parts so each again points to real code, before rerunning. Do not shape the model by what makes it pass. Keep bounds unless the change makes them wrong, and report any bound you reduce.
5. **Rerun and judge.** Run `tla-check`.
   - On a pass, break the new code's guard in the model and confirm the check catches it, then revert.
   - On a violation, replay the trace against the real code step by step. A step that cannot happen means the model is wrong, so fix it. If every step can happen, it is a bug. Name the commit that introduced it and state the harm in one sentence.
6. **Update `COVERAGE.md`.** Covered code, commands, bounds, and the sync commit. Do not move the sync commit for a blocked model.

## Done when

The reply gives each model one outcome: **in sync**, **updated**, **bug** (can combine with updated), or **blocked** with the reason. For each, it lists the commits read, each model change with its reason, the rerun result and the break that proved the check can still fail, and each bug as numbered steps with its harm and introducing commit. Model updates are committed separately from any product fix.
