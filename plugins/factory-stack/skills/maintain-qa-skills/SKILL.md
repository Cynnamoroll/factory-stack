---
name: maintain-qa-skills
description: "Reconcile the qa-<app> flow menus and the e2e mapping from /setup-e2e-qa with source and live behavior after features change. For one QA run, use /qa; for first-time setup, use /setup-e2e-qa."
license: MIT
compatibility: droid
---

# Maintain QA skills

Keep the generated `qa-<app>` flow menus and `.factory/skills/qa/e2e.yaml` true to the source and the running app.

## Edit scope

Edit only `.factory/skills/qa-*/SKILL.md` (flow menus and Known Failure Modes) and `.factory/skills/qa/e2e.yaml`. A rerun of `/setup-e2e-qa` carries flow menus, Known Failure Modes, and `e2e.yaml` forward unless the user starts fresh. Changes to personas, environments, or CI belong to `/setup-e2e-qa`; report them instead. Report product regressions without editing product code.

## Pass

1. **Find the target.** `.factory/skills/qa/config.yaml` with its `qa-<app>` skills. None: stop and point at `/setup-e2e-qa`.
2. **Mapping.** If `e2e.yaml` is missing or names a driver outside the list below, rebuild it in the shape of [the e2e.yaml example](../e2e-qa/references/e2e-yaml-example.md). Pick each app's driver: `e2e` for web, iOS, Android, and native macOS; `tuistory` for CLI and TUI; `agent-browser` for an Electron renderer or the Factory browser pane; `curl` for an API. For each `e2e` app, find or [set up](../e2e-qa/references/setup.md) its config and target. Map a flow label to a test (`file` or `file:line`) only when that test drives the flow and asserts its success criteria; otherwise map it to `null`. Never map a test because its name looks similar.
3. **Index hygiene.** Every app in `config.yaml` has a `qa-<app>` skill and an `e2e.yaml` entry. Every flow label in a `qa-<app>` menu appears in `e2e.yaml`, and every `e2e.yaml` label exists in its menu. Every mapped test file and test still exists. Fix missing, extra, duplicate, or dead entries.
4. **Source pass.** Group flows by the app's `path_patterns`. Read small groups inline; give each independent `explorer` only its paths and flow list. Require one row per flow: current behavior, cited drift, and whether its mapped test still asserts the success criteria. Check `git log --since=<last sync>` for user-facing surfaces no flow covers; require a source path for each. Explorers do not drive the app.
5. **Pending suggestions.** Read the Suggested Skill Updates in the latest `qa-results/report.md` or QA PR comment, if any. Apply each one the source or a live run confirms.
6. **Live pass.** Through `e2e-qa`, serially: every mapped test must pass on its target, and every `null` flow gets a live drive.
   - Run `npx --no e2e doctor --target <target>` and the app's pre-flight before the first drive, on each fresh session, and after any failed or surprising drive.
   - Follow [QA cleanup](../e2e-qa/references/qa-cleanup.md) after each attempt. Add missing app-specific teardown to Known Failure Modes.

   Use [agent-owned setup](../e2e-qa/references/setup.md) for missing prerequisites. A flow is `verified-unreachable` only with the concrete prerequisite and the route you tried.
7. **Triage.** Wrong or missing flow description: fix the menu. A test that no longer asserts its flow: remap it or set it to `null`. Working behavior the harness cannot drive: fix the mapping and drive it again. Broken app behavior: record it for the user and keep it out of this change.

## Done when

The reply names one outcome:

- **clean.** Every flow got source and live coverage. Nothing changed.
- **changed.** One commit of corrections, each re-driven live, with every changed file re-read.
- **blocked.** Coverage or a fix could not finish. Say exactly what blocked it.

It also lists flows covered, mapped and unmapped counts, unreachable prerequisites, confirmed drift, and product regressions found.
