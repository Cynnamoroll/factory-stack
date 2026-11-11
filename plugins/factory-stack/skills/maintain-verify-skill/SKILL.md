---
name: maintain-verify-skill
description: "Refresh an existing project verify-<app> skill so it still drives the running app the way a user does. Use when features changed and the verify skill has drifted; not to create the first verify skill (use create-verify-skill) and not for a one-shot drive (use agent-browser or tuistory)."
license: MIT
compatibility: droid
---

# Maintain verify skill

A feature map rots when the app changes. This is the upkeep pass. The unit of rigor is the feature: cover every feature file from source and drive every feature live.

## Edit scope

Edit only the verify skill's own directory: its `SKILL.md`, `features/`, and the scripts it owns. Never edit product code. Behavior the map describes that the app no longer has is either doc drift (fix the map) or a product regression (report it).

## Pass

1. **Find the target.** The project skill under `.factory/skills/verify-*/` with launch and drive sections and a feature map. Several candidates: ask which. None: stop and point at `/create-verify-skill`.
2. **Index hygiene.** Read `features/README.md` and list its sibling files. Fix missing, extra, duplicate, or dead entries.
3. **Source wave.** Issue one `explorer` Task per feature file, all in one message. Each explains how the feature works from source, flags likely drift with `file:line` citations, and returns one live-verification recipe. Explorers never drive the app.
4. **Reconcile.** Every feature file has a returned summary. Merge recipes into as few app states as practical. Spot-check cited drift. Check recent commits (`git log --since=<last sync>`) for user-facing surfaces missing from the map, and require a source path before calling one missing.
5. **Live pass.** Required even when source looks clean. You drive, serially, following the skill's own Launch section. Drive every feature at least once and hold three rules throughout:
   - Run the doctor before the first drive, on each fresh session, and after any failed or surprising drive. If the doctor cannot see the problem, reset or relaunch.
   - Evidence survives every cleanup. Check it at its named path.
   - Nothing a drive started outlives it. Clean up failed attempts too.

   A doctor failure caused by drift in the skill is drift. Fix it and retry once. A feature you cannot reach is `verified-unreachable` only with the concrete prerequisite and the route you tried.
6. **Triage.** Wrong or missing user-facing description: fix the doc. Working behavior the harness cannot drive: fix the harness and drive it again. App behavior that is broken: record it for the user and keep it out of this change.

## Done when

The reply names one outcome:

- **clean.** Every feature got source and live coverage. Nothing changed.
- **changed.** One commit of corrections, each re-driven live, with every changed file re-read.
- **blocked.** Coverage or a fix could not finish. Say exactly what blocked it.

It also lists features covered, unreachable prerequisites, confirmed drift, and product regressions found.
