---
name: maintain-verify-skill
description: "Refresh a project's verify-<app> recipe after feature changes. Use droid-control for a one-off QA flow."
license: MIT
compatibility: droid
---

# Maintain verify skill

Sync the feature map with source and live results.

## Edit scope

Edit only the verify skill's directory (`SKILL.md`, `features/`, and owned scripts). Report product regressions without editing product code. Fix map descriptions that drifted from intended behavior.

## Pass

1. **Find the target.** The project skill under `.factory/skills/verify-*/` with launch and drive sections and a feature map. Several candidates: ask which. None: stop and point at `/create-verify-skill`.
2. **Index hygiene.** Read `features/README.md` and list its sibling files. Fix missing, extra, duplicate, or dead entries.
3. **Source pass.** Group features by shared code. Read small groups inline; give each independent `explorer` only its paths and feature list. Require one row per feature: behavior, cited drift, live recipe. Explorers do not drive the app.
4. **Reconcile.** Account for every feature. Combine recipes that share app state and check cited drift. Check `git log --since=<last sync>` for missing user-facing surfaces; require a source path for each.
5. **Live pass.** Follow the recipe serially, even when source looks clean. Check coverage by journey and target. Require each mapped e2e test to pass on its intended target; drive every unmapped journey:
   - Run the doctor before the first drive, on each fresh session, and after any failed or surprising drive. If the doctor cannot see the problem, reset or relaunch.
   - Follow [QA cleanup](../droid-control/references/qa-cleanup.md) after each attempt. Add missing app-specific teardown to the recipe.

   Use [agent-owned setup](../droid-control/references/setup.md) for missing prerequisites. Fix doctor failures caused by recipe drift and retry once. A feature is `verified-unreachable` only with the concrete prerequisite and the route you tried.
6. **Triage.** Wrong or missing user-facing description: fix the doc. Working behavior the harness cannot drive: fix the harness and drive it again. App behavior that is broken: record it for the user and keep it out of this change.

## Done when

The reply names one outcome:

- **clean.** Every feature got source coverage and every journey got live coverage. Nothing changed.
- **changed.** One commit of corrections, each re-driven live, with every changed file re-read.
- **blocked.** Coverage or a fix could not finish. Say exactly what blocked it.

It also lists features covered, unreachable prerequisites, confirmed drift, and product regressions found.
