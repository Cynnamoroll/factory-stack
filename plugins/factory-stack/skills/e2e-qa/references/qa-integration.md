# QA integration

`/setup-e2e-qa` generates a `qa` orchestrator skill, `.factory/skills/qa/config.yaml`, `.factory/skills/qa/e2e.yaml`, `REPORT-TEMPLATE.md`, and one `qa-<app>` skill per app. Those skills define what to test; this skill drives every interactive flow they select. If a QA skill or config names any other driver or plugin, ignore it, drive through this skill, and add an Action Required line telling the user to rerun `/setup-e2e-qa`.

## Who owns what

- **`qa` and `qa-<app>`:** diff scope, flow choice, personas, target environment, pre-flight, report format, evidence upload and embedding, and failure learning.
- **This skill:** driver choice, launch or attach, actions, evidence capture, verification, and cleanup.

Never change the report format or upload rules. Return results and evidence to the orchestrator in its terms.

## Inputs

Read both files on every run; never reuse values from an earlier run.

- `config.yaml`: `default_target`, `environments` and their `restrictions`, `personas` with `credentials_source` and `secret_name`, `apps.<app>` (`kind`, `path_patterns`, `build_command`, `dev_command`), `cleanup`, `video_evidence`, and `platform`. Resolve secrets at run time; never print them or put them in evidence.
- `e2e.yaml`: per app, `driver` (`e2e`, `tuistory`, `agent-browser`, or `curl`), the e2e `config` path and `target`, and `flows`, which maps each flow label in `qa-<app>` to a test (`file` or `file:line`) or `null`.

If an app has no `e2e.yaml` entry, pick its driver from `kind` with the table in `SKILL.md`, drive its flows live, and report the missing entry for `maintain-qa-skills`.

## Run a flow

1. **Target.** Use the URL or build the orchestrator chose. Respect environment restrictions. Never fall back to a shared remote environment to test branch code; report `BLOCKED` instead.
2. **Mapped flow.** Run the mapped test with the [e2e Suite](e2e.md#suite) steps, scoped to that test, with `--output ./qa-results/$RUN_ID/<flow-slug>`. Confirm the test uses the orchestrator's URL or build and persona, not a hardcoded default. If those cannot be supplied, drive the flow live instead. Check that the report names the test and target and that it passed; a skipped or unselected test is not a pass.
3. **Unmapped or diff-specific flow.** Honor the app's selected driver: use the [e2e MCP](e2e.md#live-drive-and-authoring) for `e2e`, load the built-in `agent-browser` for browser panes and Electron, use the terminal steps below for `tuistory`, or send real requests with `curl` for APIs. Use the orchestrator's target and persona. If the drive proves a flow worth keeping, note it for `maintain-qa-skills` to map; do not write test files during a QA run.
4. **Persona.** Sign in through the real UI or the project's secret binding. A persona's `cannot_do` items are negative checks: the action must be refused, not merely hidden.
5. **Terminal app.** Load `tuistory`, start one session named `qa-$RUN_ID-<app>` with `--cols 110 --rows 36`, and in CI prefix the launch with `env -u CI`. Capture text snapshots that each show a different state.

## Evidence

Text first, as the orchestrator requires. Write files under `./qa-results/$RUN_ID/`.

- **e2e:** the assertion output and the relevant accessibility snapshot excerpt; screenshots from the e2e report or live catalog.
- **tuistory:** labeled snapshots as fenced code blocks.
- **agent-browser:** accessibility tree excerpts and screenshots.

When `video_evidence` is true, record each interactive flow with the driver's own recorder: the e2e live catalog's recorder or the engine's report video, `agent-browser` recording for browser panes, and `asciinema` for terminals. Check each playable video with `ffprobe` and a full decode before handing it over. A terminal `.cast` stays an artifact; verify it can be replayed instead of running video checks, and never pass it to a video upload. API flows use request and response evidence, not recordings. Leave the upload and embedding to the orchestrator.

## Results

Use the orchestrator's values:

- **PASS:** every postcondition observed true.
- **FAIL:** a postcondition observed false.
- **BLOCKED:** the flow could not run; give what was tried and how to fix it.
- **FLAKY:** a failure that passed on one retry with no change; attach both runs.
- **INCONCLUSIVE:** the claim could not be pinned, or the evidence does not decide it.

Never report setup steps (build, launch, sign-in) as test rows.

## Failure learning

When a `BLOCKED` or `FAIL` comes from the test environment (an auth wall, a missing variable, a slow iframe), give the orchestrator the insight for its Suggested Skill Updates. A moved or renamed e2e test is mapping drift: report it for `maintain-qa-skills`, not as a skill update.

## Cleanup

Follow [QA cleanup](qa-cleanup.md) and the `cleanup` strategy in `config.yaml` after every flow, including failed ones. Close e2e sessions and `tuistory` sessions by their exact IDs.

## CI

There is no human in CI. [Agent-owned setup](setup.md) cannot ask, so report a missing prerequisite as `BLOCKED` with the exact install command. The CI job must provide:

- Node.js and the project's package install, so `npx --no e2e` resolves the project's e2e and engine
- engine assets for each e2e target, such as `e2e-web install <browser>` or a booted simulator
- `tuistory` for terminal apps, plus `asciinema` when `video_evidence` is true
- `ffmpeg` when `video_evidence` is true, for recording checks

It never needs `agg` or Remotion.
