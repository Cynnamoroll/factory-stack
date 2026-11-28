# e2e

Use the project's installed e2e and engine. Check the live build, account, and device before input.

## Suite

1. From the test project's root, run `npx --no e2e doctor --target <target>` or your package manager's equivalent. For a missing config, engine, or runtime asset, complete [approved setup](e2e-setup.md), then continue. Also run the project's build and readiness checks.
2. Run the project script or `npx --no e2e run <test-file> --target <target>`. For independent or repeated runs, reserve a unique `--output` directory inside the project. Check the exit code and report for the named test and target; skipped, empty, or unselected tests do not prove a claim. Read only the relevant failure, trace, and evidence.
3. Prefer exact locators and `expect` over model steps. For existing replay suites, use `--strict-cache` in CI to reject stale recordings; cache misses can still call a model. Keep release gates model-free with deterministic tests or independently verified complete replay and no live model credentials.

## Live drive and authoring

1. Discover the plugin's `e2e` MCP tools via `ToolSearch`. For a missing runtime, config, or connection, use [e2e setup](e2e-setup.md). `open_session` takes the configured `target` and, in a nested project, the absolute `config` path. Use `test: "<file>:<line>"` when debugging a matching failure. Record the session ID; always pass it explicitly.
2. Use `call` with the session ID. Discover only needed tool schemas through `tools`. Prefer fresh refs or checked locators; use `run_code` for a short, known sequence of exact actions and assertions when supported. Inspect fresh state after an uncertain action.
3. For authoring, read `e2e guide writing-tests`. Take the checked `test_lines`, add exact postconditions, and run the saved test. Reuse the config, fixtures, and project script. For a one-off drive, leave no test files unless requested.
4. Use the live catalog for screenshots and recording; check support before committing either. Use the project's secret binding, not literal credentials. Recordings can expose secrets. Stop recording, verify its output, and call `close_session` on the owned ID even on failure. Close before a suite that would share the same fixed port, device, or desktop.

On mobile, use a dedicated simulator/emulator or approved device with the intended build installed. If cold boot times out, boot the owned device and wait for OS readiness before retrying. Installing or resetting the app is an explicit recipe step. On macOS, serialize native runs on an unlocked desktop with approved Accessibility and Screen Recording grants. Get approval for foreground input. Check physical input and capture separately; report native video as blocked if the engine has no recorder.
