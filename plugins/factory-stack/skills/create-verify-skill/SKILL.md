---
name: create-verify-skill
description: "Create a project verify-<app> skill that drives the running app the way a user does, with agent-browser for web apps and tuistory for terminal apps. Use when a project has no verify skill yet; not to refresh a drifted one (use maintain-verify-skill), not to draft a generic skill (use /create-skill), and not for a one-shot drive of the app (use agent-browser or tuistory)."
license: MIT
compatibility: droid
disable-model-invocation: true
---

# Create verify skill

Generate `.factory/skills/verify-<app>/` in the project: a scripted way to launch the real app, drive a feature the way a user would, and capture evidence. Write it for the next agent, who will read it cold in the middle of a task and has never seen the app.

## 1. Interview the repo

Answer these from the code. Ask the user only what you cannot observe.

- **Surface.** What does a user touch: a web UI, a CLI or TUI, a desktop app, an API, a library? Pick the primary one and note the rest.
- **Run.** The repo's own dev command (package scripts, Makefile, README), ports, env vars, seed data, auth.
- **Drive.** Existing harnesses first (Playwright or Cypress specs, PTY helpers, curl-able endpoints). Otherwise use Droid's built-in `agent-browser` skill for web and Electron apps, `tuistory` for terminal apps, and plain HTTP for services.
- **Observe.** Screenshots, terminal transcripts, response bodies, logs, exit codes, stored state.
- **Isolate.** Can two instances run side by side (ports, data dirs, profiles)? If not, the generated skill says so and refuses to drive a shared instance.

If the checkout does not build or start, fix that or report it precisely before generating.

## 2. Write the skill

Write `.factory/skills/verify-<app>/SKILL.md` with `name: verify-<app>` and a description that names the app, the surface, and when to use it. Fill these sections from what the interview found, with no placeholders left:

- **Launch.** The exact command, how to tell it is ready to use (not just that a port answers), and teardown. Launch works from an empty data dir, including migrations and seed data. A short-lived CLI builds once, then runs each drive in its own PTY session.
- **Doctor.** One read-only check: process up, right build, port owned by this run, auth valid. Run it first whenever anything looks off.
- **Drive.** The harness recipe with real selectors and commands from this repo. Prefer stable handles (ARIA names, data attributes, prompt strings, routes) over coordinates.
- **Evidence.** What to capture and where. Drive the real user path, not internal setters or test-only endpoints. Capture the action and the resulting state. Check side effects (files, rows, messages) as well as the screen. Verify what a dry-run mode really skips by watching it.
- **Cleanup.** Kill only what this run started, never by process name. Remove instances and scratch state. Keep the evidence at the path the skill names.
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
