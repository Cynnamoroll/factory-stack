---
name: droid-control
description: "Run e2e, drive live QA, or capture screenshots and demos. Covers web, iOS, Android, native macOS, Electron, terminals, and the Factory browser pane."
license: MIT
compatibility: droid
version: 0.1.0
---

# Droid Control

1. **Commit.** Pin the build, target, method, postconditions, and artifacts. Get approval before recording a demo. Compare only real builds with identical actions; otherwise use one clip.
2. **Route.** Honor the requested method. A compatible `verify-<app>` owns the lifecycle; use its mapped test when it covers the claim. Without a recipe, reuse a matching project test or select a driver below. If called for mechanics, stay on that step. Add the evidence route before launch when needed.
3. **Drive.** Read [QA cleanup](references/qa-cleanup.md) before launch or mutation. Isolate each attempt. Observe, act, wait, verify; reobserve before retrying. Keep shared-desktop input in the parent.
4. **Report.** Apply [proof checks](references/verify.md) for QA, claims, or video. Verify teardown even on failure and confirm delivered evidence still opens. Report build, method, observations, artifacts, and blockers.

| Target or required capability | Read or load |
|---|---|
| Web, iOS, Android, native macOS | [e2e](references/e2e.md) |
| Factory browser pane, Electron renderer, or one-off web drive without e2e | [Browser](references/browser-use.md) |
| Unrecorded virtual terminal | `tuistory` via `Skill` |
| Droid CLI launch, `tctl`, terminal scrollback, real emulator, or exact bytes | [Factory capture helpers](references/factory-helpers.md) |
| Terminal recording, scripted browser/terminal capture, or edited artifacts | [Factory capture helpers](references/factory-helpers.md) |

Native desktop testing is macOS-only and uses e2e. Use a fallback only if it meets the same platform, input, and evidence requirements. Report unsupported capabilities as `BLOCKED`; continue independent checks.
