---
name: maintain-qa-skills
description: "Reconcile the qa-<app> flow menus from install-qa and the e2e mapping with source and live behavior after features change. For one QA run, use /qa; for first-time wiring, use /adopt-e2e-qa."
license: MIT
compatibility: droid
---

# Maintain QA skills

Keep the generated `qa-<app>` flow menus and `.factory/skills/qa/e2e.yaml` true to the source and the running app.

## Edit scope

Edit only `.factory/skills/qa-*/SKILL.md` (flow menus and Known Failure Modes) and `.factory/skills/qa/e2e.yaml`. A rerun of `/install-qa` regenerates the `qa-*` files, so say which edits it would overwrite. `e2e.yaml` survives it. Changes to personas, environments, or CI belong to `/install-qa`; report them instead. Report product regressions without editing product code.

## Pass

1. **Find the target.** `.factory/skills/qa/config.yaml` with its `qa-<app>` skills. None: stop and point at `/adopt-e2e-qa`. Run `python3 "${DROID_PLUGIN_ROOT}/skills/adopt-e2e-qa/scripts/rewire.py" --check`. If it exits nonzero, stop and point at `/adopt-e2e-qa`.
2. **Index hygiene.** Every app in `config.yaml` has a `qa-<app>` skill and an `e2e.yaml` entry. Every flow label in a `qa-<app>` menu appears in `e2e.yaml`, and every `e2e.yaml` label exists in its menu. Every mapped test file and test still exists. Fix missing, extra, duplicate, or dead entries.
3. **Source pass.** Group flows by the app's `path_patterns`. Read small groups inline; give each independent `explorer` only its paths and flow list. Require one row per flow: current behavior, cited drift, and whether its mapped test still asserts the success criteria. Check `git log --since=<last sync>` for user-facing surfaces no flow covers; require a source path for each. Explorers do not drive the app.
4. **Pending suggestions.** Read the Suggested Skill Updates in the latest `qa-results/report.md` or QA PR comment, if any. Apply each one the source or a live run confirms.
5. **Live pass.** Through `e2e-qa`, serially: every mapped test must pass on its target, and every `null` flow gets a live drive.
   - Run `npx --no e2e doctor --target <target>` and the app's pre-flight before the first drive, on each fresh session, and after any failed or surprising drive.
   - Follow [QA cleanup](../e2e-qa/references/qa-cleanup.md) after each attempt. Add missing app-specific teardown to Known Failure Modes.

   Use [agent-owned setup](../e2e-qa/references/setup.md) for missing prerequisites. A flow is `verified-unreachable` only with the concrete prerequisite and the route you tried.
6. **Triage.** Wrong or missing flow description: fix the menu. A test that no longer asserts its flow: remap it or set it to `null`. Working behavior the harness cannot drive: fix the mapping and drive it again. Broken app behavior: record it for the user and keep it out of this change.

## Done when

The reply names one outcome:

- **clean.** Every flow got source and live coverage. Nothing changed.
- **changed.** One commit of corrections, each re-driven live, with every changed file re-read, and the edits a `/install-qa` rerun would overwrite listed.
- **blocked.** Coverage or a fix could not finish. Say exactly what blocked it.

It also lists flows covered, mapped and unmapped counts, unreachable prerequisites, confirmed drift, and product regressions found.
