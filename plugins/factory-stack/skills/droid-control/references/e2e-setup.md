# e2e setup in Factory

## Install

Use [agent-owned setup](setup.md) for approval. Include missing project dependencies, the `e2e` skill, and the selected host prerequisites in the request. After approval:

1. Install `e2e` and the needed engine with the project's package manager. Reuse its manifest and lockfile; use a private test package if the app has no JavaScript package. Copy the installed package's `skills/e2e/` with its references into `.factory/skills/` if missing. Use `e2e guide <topic>` in the current session if the skill is not loaded yet.
2. Follow [Suite](#suite) or [Live](#live). Prepare the selected runtime below. Build and install the intended app with the project recipe when required.
3. Run `e2e doctor --target <target>` for a configured target. Resolve setup findings and rerun the doctor, then resume the requested test or drive. For config-free live use, open the target to check readiness and reuse that session for the drive.

| Target | Engine and setup |
|---|---|
| Web | [`@e2e-dev/web`](https://e2e.com/docs/web). Use the app URL or project launch command. Install a missing browser with `e2e-web install <browser>` or let the first approved headless run fetch it. |
| iOS or Android | [`@e2e-dev/mobile`](https://e2e.com/docs/mobile). Prepare the selected simulator runtime or Android SDK/emulator, boot an owned device, and install the intended build if needed. |
| Native macOS | [`@e2e-dev/desktop`](https://e2e.com/docs/desktop). Use the built `.app` or bundle ID. The first run installs the engine's pinned driver; request any required Accessibility or Screen Recording grant from the user, then recheck. |

## Suite

Reuse an existing config. For an approved new web or mobile suite, run `e2e init --yes --engine <web|mobile> --gateway none --skills none --mcp none` (substitute `web` or `mobile`). Sync the lockfile if scaffolding changed dependencies. Point the generated target and test at the real app. For desktop, create the target from the engine docs.

## Live

From the test package, run `droid mcp list`, then rediscover `e2e` with `ToolSearch`. Use the plugin registration; it resolves offline without installing packages. Confirm the server version and config when opening the session. In a monorepo, pass the absolute config path and target. If discovery stays stale after install, start a fresh session with `droid exec --cwd <test-package>` and pass the drive and cleanup steps. Keep one registration.

Without a config, `open_session` can name the installed engine and real app directly. Use `engine: "@e2e-dev/web"` with `app.url`, `engine: {package: "@e2e-dev/mobile", options: {platform: "ios"}}` (`"android"` as needed) with `app.bundleId`, or `engine: "@e2e-dev/desktop/engine"` with `app.appPath` or `app.bundleId`. Check the live schema. A one-off drive does not need to scaffold a suite.

If live MCP is unavailable, use a configured suite only where it proves the same claim. Ask before changing machine permissions, installing device tooling, or adding model credentials.
