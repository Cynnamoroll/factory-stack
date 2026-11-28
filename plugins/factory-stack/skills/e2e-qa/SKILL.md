---
name: e2e-qa
description: "Drive real apps for QA and verification: e2e on web, iOS, Android, and native macOS, built-in tuistory for terminals, and built-in agent-browser for browser panes and Electron. Serves as the interaction layer for install-qa's qa skills in place of droid-control."
license: MIT
compatibility: droid
version: 0.2.0
---

# e2e QA

This skill's directory is `${DROID_PLUGIN_ROOT}/skills/e2e-qa`. The QA wiring check is `python3 "${DROID_PLUGIN_ROOT}/skills/adopt-e2e-qa/scripts/rewire.py" --check`, run from the repository root.

1. **Commit.** Pin the build, target, persona, method, postconditions, and artifacts. Compare only real builds with identical actions.
2. **Route.** Honor the requested method. When `.factory/skills/qa/config.yaml` exists, follow [QA integration](references/qa-integration.md): the generated `qa` and `qa-<app>` skills own scope, personas, environments, and the report, and this skill owns driving, evidence, and cleanup. Without them, reuse a matching project test or select a driver below. If called for mechanics, stay on that step.
3. **Setup.** Check the selected route's prerequisites. If any are missing, follow [agent-owned setup](references/setup.md) before driving or choosing a fallback.
4. **Drive.** Read [QA cleanup](references/qa-cleanup.md) before launch or mutation. Isolate each attempt. Observe, act, wait, verify; reobserve before retrying. Keep shared-desktop input in the parent.
5. **Report.** Apply [proof checks](references/verify.md). Verify teardown even on failure and confirm delivered evidence still opens. Report build, method, observations, artifacts, and blockers.

| Target | Driver |
|---|---|
| Web, iOS, Android, native macOS | [e2e](references/e2e.md) |
| Factory browser pane, Electron renderer, or one-off web drive without e2e | Built-in `agent-browser` via `Skill`, with [browser notes](references/browser-use.md) |
| Terminal or TUI app | Built-in `tuistory` via `Skill`; record with `asciinema` when a recording is required |
| HTTP API | `curl` with the real request |

Record with the selected driver's own recorder. Edited or composed video is out of scope. Native desktop testing is macOS-only and uses e2e. Use a fallback only if it meets the same platform, input, and evidence requirements. Report unsupported capabilities as `BLOCKED`; continue independent checks.
