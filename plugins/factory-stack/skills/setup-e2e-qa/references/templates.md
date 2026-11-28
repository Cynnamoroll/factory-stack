# Generated skills

Fill the angle-bracket fields from the analysis and answers. Keep the orchestrator short; flow detail belongs in each `qa-<app>` skill. Never write resolved config values, such as whether video is on, into a skill; skills read `config.yaml` on every run.

## Orchestrator: `.factory/skills/qa/SKILL.md`

````markdown
---
name: qa
description: >
  Run QA for <Project>: map the git diff to affected apps, run their relevant flows
  as each persona through e2e-qa, and write a report. Use for PRs, releases, and smoke tests.
---

# QA

Functional QA only: use the app as a real user would. Never run or report unit tests, lint, typecheck, or other CI checks.

1. **Load.** Read `.factory/skills/qa/config.yaml` and `.factory/skills/qa/e2e.yaml`. Load `e2e-qa` and follow its QA integration guide for every interactive flow. It owns driving, evidence capture, and cleanup.
2. **Target.** Use `default_target` unless the user names another environment, and honor its restrictions. A preview deployment is the development environment: same backend, data, and keys, so use development flows against it.
3. **Scope.** Diff against the base branch and map changed files to apps by `path_patterns`. Files no app claims (docs, CI, `.factory/`) select nothing. If no app is affected, report INCONCLUSIVE: "No app code changed; QA does not apply to this diff." Never load, pre-flight, or run an unaffected app.
4. **Pre-flight.** For affected apps only: build, start or locate the target, and run `npx --no e2e doctor --target <target>` for `e2e` apps. A failed pre-flight makes that app's flows BLOCKED with the error and the fix; continue with other apps.
5. **Run.** Read each affected `qa-<app>` skill. Run the flows the diff touches plus adjacent flows that prove the change integrates; skip unrelated flows. If no flow covers a change, drive an ad-hoc flow that verifies it directly. Run each flow as the personas it lists, including `cannot_do` negative checks.
6. **Evidence.** Text first: assertion output, accessibility excerpts, terminal snapshots, and request and response bodies, inline in the report. Files go to `./qa-results/$RUN_ID/`. When `video_evidence` is true, upload each playable video (never a `.cast`) and embed only the URL the upload returned:
   - GitHub: `POST https://uploads.github.com/user-attachments/assets` with `QA_EVIDENCE_TOKEN`; put the URL alone on its own line.
   - GitLab: `POST $CI_API_V4_URL/projects/$CI_PROJECT_ID/uploads` with `GITLAB_TOKEN`; embed the returned Markdown.
   - If an upload fails, keep the file as a CI artifact and say so.
7. **Report.** Write `qa-results/report.md` from `REPORT-TEMPLATE.md`. Results: PASS, FAIL, BLOCKED, FLAKY, INCONCLUSIVE. Setup steps are not test rows. Never silently skip a flow; a flow that cannot finish is BLOCKED with what was tried and how to fix it.
8. **Learn.** When a BLOCKED or FAIL reveals something new about the test environment (an auth wall, a required flag, slow loading), add a "Suggested Skill Updates (N)" table: severity (Breaking, Degraded, Info), target file, issue, and a collapsed, self-contained fix prompt. Skip failures already in Known Failure Modes, bad selectors, and behavior changes the diff intended. Moved or renamed e2e tests are mapping drift for `maintain-qa-skills`.
````

## App skill: `.factory/skills/qa-<app>/SKILL.md`

````markdown
---
name: qa-<app>
description: >
  QA flows for the <app> app (<kind>): <one line on what it covers>. Loaded by the qa orchestrator.
---

# QA: <app>

Drive every flow through `e2e-qa`. This file says what to test and what success looks like.

## Testing target

<Preview deployments: use the preview URL the workflow passes in <ENV_VAR>; apply the bypass secret on the first request if one is needed. Without a preview URL, every flow is BLOCKED.>
<No previews: start `<dev command>`, wait until `<readiness URL or prompt>` responds, and test that.>
Never fall back to a shared remote environment for branch code; it runs different code.

## Authentication

<Env vars or secret paths per persona, how the app reads them, and that CI provides them so no interactive login is needed.>

## Flows

The orchestrator picks flows by the diff; this is a menu, not a checklist. Keep each heading identical to its `e2e.yaml` label.

### <Flow label>

- **Covers:** <paths or features that select this flow>
- **Personas:** <names; mark negative checks>
- **Steps:** <user-level actions>
- **Success:** <observable postconditions>
- **Cleanup:** <data to remove, or none>

## App notes

<UI quirks, slow screens, terminal size, CI launch notes such as `env -u CI` for Ink-based TUIs.>

## Known Failure Modes

1. <quirk found during analysis and how to handle it>
````

## Report template: `.factory/skills/qa/REPORT-TEMPLATE.md`

```markdown
## QA Report

| # | Test case | App | Persona | Result | Notes |
| --- | --- | --- | --- | --- | --- |
{{TEST_ROWS}}

Results: :white_check_mark: PASS, :x: FAIL, :no_entry: BLOCKED, :warning: FLAKY, :grey_question: INCONCLUSIVE

{{#if ACTIONABLE_ITEMS}}
### Action Required

{{ACTIONABLE_ITEMS}}
{{/if}}

<details>
<summary>Evidence</summary>

{{EVIDENCE}}

</details>
```
