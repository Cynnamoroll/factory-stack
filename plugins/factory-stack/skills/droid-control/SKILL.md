---
name: droid-control
description: "Drive real terminal, browser, Electron, or desktop apps for QA, behavior proof, or recorded demos."
license: MIT
compatibility: droid
version: 0.1.0
---

# Droid Control

1. **Commit.** Reuse the caller's target, build, method, postconditions, and artifacts. Fill gaps before driving. Screenshots and video are separate commitments. Get approval before recording a demo. Default to one clip; compare only real baselines with identical actions.
2. **Route.** A matching `verify-<app>` owns Launch, Doctor, relevant feature steps, and Cleanup if it supports the required method. If it called you for mechanics, stay on that step. Select the union of target, stage, and polish routes below.
3. **Run.** Use the real app. Give each attempt unique session and scratch paths. Read [QA cleanup](references/qa-cleanup.md) before starting resources or mutating state. Observe, act, wait, verify; reobserve before retrying uncertain input. The parent owns the plan, shared desktop, permissions, and verdict. Independent capture or render workers get only commands, absolute paths, and expected outputs; return observations, artifact paths, and blockers.
4. **Report.** Verify the evidence, run cleanup even on partial or failed attempts, and check both teardown and evidence survival. Return build, method, results, reviewed artifact paths, and any cleanup or proof blockers.

## Routes

Read the full selected driver atom to plan the drive; load each stage atom when you reach that stage. Upstream files live at `skills/droid-control/atoms/<name>/ATOM.md`. Follow only the relevant platform pointers. Keep driver lifecycles separate.

| Target | Atoms |
|---|---|
| Native GUI input, including Electron when required | `desktop-use` |
| Web or Electron otherwise | `browser-use` |
| Terminal TUI | `terminal-use` |
| Droid CLI | `terminal-use`, `droid-cli` |
| Actual emulator rendering or physical key handling | `terminal-use`, `true-input` |
| Exact terminal bytes | `terminal-use`, `true-input`, `pty-capture` |

| Stage or artifact | Atoms |
|---|---|
| Screenshots, recording, scripted evidence | `capture` |
| Produced artifact, annotated set, or comparison image | `compose` |
| Showcase polish | `compose`, `showcase` |
| Formal proof, QA, or demo | `verify` |

Read upstream `commands/{verify,qa-test,demo}.md` only when the full playbook is needed. Use it as a reference, not a registered command.

## Helpers

Use the trusted absolute `plugins/droid-control` root from the request, `DROID_CONTROL_HELPERS_ROOT`, or `~/factory-control-helpers/plugins/droid-control`, in that order. Validate only selected files. Report an invalid supplied path instead of switching checkouts. Substitute this root for `DROID_PLUGIN_ROOT` in upstream files. Use `tctl`, platform helpers, and the renderer with that checkout's atoms.

Before using `tctl` on macOS, read [timestamp compatibility](references/macos-tctl.md).

Without a usable upstream route, read only the relevant local fallback: [browser](references/browser-use.md), [desktop](references/desktop-use.md), [unrecorded TUI](references/terminal-use.md), or [evidence verification](references/verify.md). Use it only if it meets the original commitment. Mark the rest `BLOCKED` and continue independent checks.
