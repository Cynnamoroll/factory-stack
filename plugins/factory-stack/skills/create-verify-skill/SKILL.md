---
name: create-verify-skill
description: "Create a project verify-<app> recipe that prove-it-works follows to check changes live. For a QA suite with CI integration, use install-qa."
license: MIT
compatibility: droid
disable-model-invocation: true
---

# Create verify skill

Generate `.factory/skills/verify-<app>/` to launch the real app, drive a user's feature path, and capture evidence. Assume the next agent has never seen the app.

## 1. Interview the repo

Answer from code. Ask only what you cannot observe.

- **Existing QA skill.** If Droid's built-in `install-qa` already generated a QA skill under `.factory/skills/`, reuse its launch, auth, and drive steps. Point the recipe's sections at it instead of copying them, and add only what it lacks.
- **Surface.** Pick the primary user surface: web, mobile, native macOS, CLI/TUI, API, or library. Note secondary surfaces.
- **Run.** The repo's own dev command (package scripts, Makefile, README), ports, env vars, seed data, auth.
- **Drive.** Reuse the project's harness. For new UI routes use `e2e-qa`, which selects e2e for supported targets. Use plain HTTP for services.
- **Observe.** Screenshots, terminal transcripts, response bodies, logs, exit codes, stored state.
- **Isolate.** Can two instances run side by side (ports, data dirs, profiles)? If not, the generated skill says so and refuses to drive a shared instance.

For missing prerequisites, follow [agent-owned setup](../e2e-qa/references/setup.md). If the checkout still does not build or start, fix that or report the blocker before generating.

## 2. Write the skill

Write `.factory/skills/verify-<app>/SKILL.md` with `name: verify-<app>` and a description naming the app, surface, and trigger. Fill all sections from the interview, without placeholders:

- **Launch.** The exact command, how to tell it is ready to use (not just that a port answers), and teardown. Launch works from an empty data dir, including migrations and seed data. A short-lived CLI builds once, then runs each drive in its own PTY session.
- **Doctor.** One read-only check: process up, right build, port owned by this run, auth valid. Run it first whenever anything looks off.
- **Drive.** Name the driver and prerequisites. Point to existing e2e config, target, and test selectors or commands rather than copying test steps. For unmapped journeys, give stable locators and exact assertions. Link to the driver for mechanics.
- **Evidence.** Name the artifact type and path for each proof point, including any screenshots and recordings. Capture the real user action and result rather than using test endpoints or internal setters. Check side effects (files, rows, messages) as well as the screen. Verify what dry-run actually skips.
- **Cleanup.** Follow [QA cleanup](../e2e-qa/references/qa-cleanup.md) and document app-specific teardown, including owned session, device, or process IDs to capture and verify.
- **Helpers.** Every script the skill ships is executable, and its invocation is shown in the body.

## 3. Seed the feature map

Create `.factory/skills/verify-<app>/features/README.md` and one file per user-facing feature, starting with the top 3 to 5 from routes, commands, menus, or docs. Follow the shape in [references/feature-map-example.md](references/feature-map-example.md). If seed data lacks a precondition a journey needs, the journey reports a failure and the reason goes in that feature's Gotchas. Never weaken a journey so it passes.

## 4. Prove it

Follow the generated skill end to end once: launch, doctor, drive one mapped feature, capture evidence, clean up. Then confirm the evidence still exists at its named path. Fix whatever fails, and run the generated cleanup after every failed attempt. If you proved it in a stand-in (a container instead of the real target), list the setup steps the stand-in did that the target will not.

## Done when

- `.factory/skills/verify-<app>/SKILL.md` exists with valid frontmatter and all six sections filled.
- The feature map has a README and at least three feature files.
- One full run passed, its evidence survived cleanup, and the reply links the evidence path.
- The reply points the user at `maintain-verify-skill` for upkeep.
