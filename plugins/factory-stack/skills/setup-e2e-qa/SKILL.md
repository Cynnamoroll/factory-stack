---
name: setup-e2e-qa
description: "Generate the project's QA skills (the qa orchestrator, qa-<app> flow menus, config, e2e mapping, and an optional CI job) with e2e-qa as the only driver. Use instead of Droid's built-in /install-qa. Rerun to refresh."
license: MIT
compatibility: droid
disable-model-invocation: true
---

# Set up e2e QA

Generate project QA in which every interactive flow runs through `e2e-qa`. Rerun this skill whenever apps, personas, environments, or CI change. `/qa` then runs the generated orchestrator, and `maintain-qa-skills` keeps flows and mappings current.

```text
.factory/skills/qa/SKILL.md              orchestrator, invoked as /qa
.factory/skills/qa/config.yaml           environments, personas, apps, evidence, cleanup
.factory/skills/qa/e2e.yaml              driver and flow-to-test mapping per app
.factory/skills/qa/REPORT-TEMPLATE.md    report shape
.factory/skills/qa/.setup-progress.yaml  saved answers for resume
.factory/skills/qa-<app>/SKILL.md        one flow menu per app
.github/workflows/qa.yml or a qa job in .gitlab-ci.yml   only if approved
```

Shapes: [generated skills](references/templates.md), [config.yaml](references/config.md), [CI](references/ci.md), and the [e2e.yaml example](../e2e-qa/references/e2e-yaml-example.md).

Rules for every generated file:

- The only drivers are `e2e`, `tuistory`, `agent-browser`, and `curl`, always reached through `e2e-qa`. Never name another driver, plugin, or recorder.
- Describe what to test and its success criteria. Leave driving, evidence capture, and cleanup to `e2e-qa`; never copy driver commands.
- Never write a secret. Record only where it lives: an env var name, secret manager path, or `manual`.
- Add no entries to `.factory/settings.json`.

## 1. Locate and resume

Work from `git rev-parse --show-toplevel`. Outside a repository, ask which repository to use. This skill needs a human for its questions; in CI or `droid exec` without one, stop and say so. Create a todo list from these steps.

If `.factory/skills/qa/` already exists, read `config.yaml`, `e2e.yaml`, `.setup-progress.yaml`, and each `qa-<app>` flow menu and Known Failure Modes. Ask whether to keep them as defaults or start fresh. Defaults carry forward flows, Known Failure Modes, and `e2e.yaml` entries that still resolve. If existing QA files, CI jobs, or settings route QA through anything other than `e2e-qa`, list them now. Step 5 replaces the QA files; ask before changing a settings entry or CI job.

## 2. Analyze

Detect these yourself and present a summary before asking anything:

- **Apps:** workspaces in a monorepo, each app's kind (web, iOS, Android, native macOS, Electron, CLI or TUI, HTTP API), its path patterns, and its build and dev-server commands.
- **Tests:** existing e2e configs and targets (run `npx --no e2e doctor --target <target>` for each), and other suites that drive the app.
- **Auth:** login method and provider.
- **Environments:** URLs from env examples, config, CI, and deploy manifests; preview deployments (Vercel, Netlify) and how their URLs are published.
- **Flags and integrations:** feature-flag provider; payment, email, SMS, and other SaaS SDKs.
- **CI:** provider and existing QA or e2e jobs. Platform: `origin` on github.com is `github`; a GitLab host is `gitlab`; otherwise `.gitlab-ci.yml` means `gitlab`, `.github/workflows/` means `github`, and with no signal default to `github` and confirm.
- **Flows:** critical user flows from routes, screens, commands, and endpoints.

## 3. Ask

Ask only for what you could not detect, framed around what you found. Use `AskUser` in these groups and save answers to `.setup-progress.yaml` after each one.

1. **Target:** default environment and restrictions per environment, such as "never create users in production".
2. **Personas:** for each role, its name, what it can do, what it must not do (each becomes a negative check), its test account, and where its credentials live. Ask whether QA signs up missing accounts or the user provides them.
3. **Flows:** confirm and extend each app's list, with success criteria, personas, and data each flow leaves behind.
4. **Integrations:** sandbox mode and test credentials for each one detected, and how QA receives email.
5. **Cleanup:** delete through an API, an admin panel, a reset command, manual, or none.
6. **Evidence:** whether to record video. On GitHub, inline video needs a classic PAT with `repo` scope stored as the `QA_EVIDENCE_TOKEN` secret, and the upload endpoint is undocumented; default no. On GitLab, the project uploads API keeps files on the instance; default yes. Edited or composed video is never offered.
7. **CI:** whether to generate a job; required or informational; whether to wait for preview deployments. On GitLab, this answer approves the job posting and updating one MR note.

## 4. Map drivers and tests

Pick each app's driver: `e2e` for web, iOS, Android, and native macOS; `tuistory` for CLI and TUI; `agent-browser` for an Electron renderer; `curl` for an HTTP API. For each `e2e` app, reuse its config and target or create them through [agent-owned setup](../e2e-qa/references/setup.md), then run the doctor until it is clean.

Map a flow label to a test (`file` or `file:line`) only when that test drives the flow with the configured target and persona and asserts its success criteria. Map every other flow to `null`, which means `e2e-qa` drives it live. Never map a test because its name looks similar. Write `e2e.yaml`.

## 5. Generate

Write every file from the references and the answers, overwriting earlier output. Keep carried-forward flows and Known Failure Modes unless the user chose to start fresh. Write CI only when approved, following [CI](references/ci.md). Replace existing QA jobs only after listing them and getting a yes. Never touch unrelated jobs.

## 6. Validate

1. Parse `config.yaml`, `e2e.yaml`, and any CI file with a YAML parser the project already has, such as PyYAML or the `yaml` npm package. If none is installed, use one in a temporary environment rather than adding it to the project. On GitLab, run `glab ci lint` when available.
2. Check that every app in `config.yaml` has a `qa-<app>` skill and an `e2e.yaml` entry, every flow label is mapped or `null`, and every mapped test exists.
3. Search the generated files for driver, plugin, or recorder names outside the rules above, and confirm `.factory/settings.json` is unchanged.
4. Run the built-in `review` skill on the generated files, passing the file list. Fix P0 and P1 findings; list the rest as review notes.
5. Load `e2e-qa` and run one mapped flow for one persona with `RUN_ID=setup-<date>`, plus one `null` flow if any exist. Verify cleanup after each attempt.

## Done when

- All checks in step 6 pass, and the proof flows passed with their evidence paths linked.
- The reply lists the generated files, mapped and unmapped flow counts per app, and review notes.
- If CI was generated, the reply gives a checklist of every secret or CI/CD variable it reads, what each is for, where to get it, and the settings URL to add it. On GitLab, it reminds the user to enable merge request pipelines.
- The reply lists remaining manual setup (test accounts, allowlists), and points at `/qa` and `maintain-qa-skills`.
