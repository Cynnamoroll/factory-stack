---
name: maintain-verify-skill
description: "Refresh a project's verify-<app> recipe after feature changes. Use droid-control for a one-off QA flow."
license: MIT
compatibility: droid
---

# Maintain verify skill

Check every feature file against source and drive every feature live.

## Edit scope

Edit only the verify skill's directory (`SKILL.md`, `features/`, and owned scripts). Report product regressions without editing product code. Fix map descriptions that drifted from intended behavior.

## Pass

1. **Find the target.** The project skill under `.factory/skills/verify-*/` with launch and drive sections and a feature map. Several candidates: ask which. None: stop and point at `/create-verify-skill`.
2. **Index hygiene.** Read `features/README.md` and list its sibling files. Fix missing, extra, duplicate, or dead entries.
3. **Source pass.** Group features by shared code. Read small groups inline; give each independent `explorer` only its paths and feature list. Require one row per feature: behavior, cited drift, live recipe. Explorers do not drive the app.
4. **Reconcile.** Account for every feature. Combine recipes that share app state and check cited drift. Check `git log --since=<last sync>` for missing user-facing surfaces; require a source path for each.
5. **Live pass.** Required even when source looks clean. You drive, serially, following the skill's own Launch section. Drive every feature at least once and hold three rules throughout:
   - Run the doctor before the first drive, on each fresh session, and after any failed or surprising drive. If the doctor cannot see the problem, reset or relaunch.
   - Verify teardown and state restoration after each attempt, including failures. Follow `droid-control`'s QA cleanup checklist and add missing app-specific teardown to the recipe.
   - Verify the promised evidence still opens at its delivery path. Remove failed captures and scratch, not linked evidence.

   A doctor failure caused by drift in the skill is drift. Fix it and retry once. A feature you cannot reach is `verified-unreachable` only with the concrete prerequisite and the route you tried.
6. **Triage.** Wrong or missing user-facing description: fix the doc. Working behavior the harness cannot drive: fix the harness and drive it again. App behavior that is broken: record it for the user and keep it out of this change.

## Done when

The reply names one outcome:

- **clean.** Every feature got source and live coverage. Nothing changed.
- **changed.** One commit of corrections, each re-driven live, with every changed file re-read.
- **blocked.** Coverage or a fix could not finish. Say exactly what blocked it.

It also lists features covered, unreachable prerequisites, confirmed drift, and product regressions found.
