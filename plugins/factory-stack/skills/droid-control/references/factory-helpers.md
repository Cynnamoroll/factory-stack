# Factory capture helpers

Use the trusted `plugins/droid-control` root from the request, `DROID_CONTROL_HELPERS_ROOT`, or `~/factory-control-helpers/plugins/droid-control`, in that order. Report an invalid supplied path; validate only files the route needs. Substitute the absolute root for `DROID_PLUGIN_ROOT` in upstream files.

If the default checkout is missing, include it in [agent-owned setup](setup.md). Once approved, clone `https://github.com/Factory-AI/factory-plugins` into `~/factory-control-helpers` without registering it as a plugin. Install only the tools required by the selected atoms and check their versions before capture.

Read selected atoms at `skills/droid-control/atoms/<name>/ATOM.md` under that root:

- Terminal: `droid-cli` for Droid launch; `terminal-use` for `bin/tctl`, including scrollback. Add `true-input` for real emulator input or rendering and `pty-capture` for exact bytes.
- Scripted browser or terminal evidence: read that driver's section of `capture` before launch. Use the selected driver's own recorder and lifecycle.
- Edited artifact: `compose` and `verify`; add `showcase` only for showcase polish. Compose existing captures; do not switch drivers to render.

Before using `tctl` on macOS, read [timestamp compatibility](macos-tctl.md). Give independent capture or render workers exact commands, absolute paths, and expected outputs. Keep shared input and final verification in the parent.
