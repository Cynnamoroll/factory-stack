---
name: e2e-qa
description: "Run e2e tests or drive live QA on web, iOS, Android, or native macOS through the e2e runner. Not for terminal flows (tuistory), browser panes or Electron (agent-browser), or demo videos (Factory's droid-control plugin)."
license: MIT
compatibility: droid
version: 0.1.0
---

# e2e QA

This skill's directory is `${DROID_PLUGIN_ROOT}/skills/e2e-qa`.

1. **Commit.** Pin the build, target, method, postconditions, and artifacts. Get approval before recording. Compare only real builds with identical actions; otherwise use one clip.
2. **Route.** Honor the requested method. A compatible `verify-<app>` owns the lifecycle; use its mapped test when it covers the claim. Without a recipe, reuse a matching project test or select a driver below. If called for mechanics, stay on that step. Add the evidence route before launch when needed.
3. **Setup.** Check the selected route's prerequisites. If any are missing, follow [agent-owned setup](references/setup.md) before driving or choosing a fallback.
4. **Drive.** Read [QA cleanup](references/qa-cleanup.md) before launch or mutation. Isolate each attempt. Observe, act, wait, verify; reobserve before retrying. Keep shared-desktop input in the parent.
5. **Report.** Apply [proof checks](references/verify.md) for QA, claims, or video. Verify teardown even on failure and confirm delivered evidence still opens. Report build, method, observations, artifacts, and blockers.

| Target or required capability | Read or load |
|---|---|
| Web, iOS, Android, native macOS | [e2e](references/e2e.md) |
| Factory browser pane, Electron renderer, or one-off web drive without e2e | Built-in `agent-browser` via `Skill`, with [browser notes](references/browser-use.md) |
| Unrecorded virtual terminal | Built-in `tuistory` via `Skill` |
| Terminal recording, Droid CLI launch, real emulator, exact bytes, demo video, or edited artifacts | Factory's `droid-control` plugin, or its [capture helpers](references/factory-helpers.md) when the plugin is not installed |

Native desktop testing is macOS-only and uses e2e. Use a fallback only if it meets the same platform, input, and evidence requirements. Report unsupported capabilities as `BLOCKED`; continue independent checks.
