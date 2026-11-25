# e2e setup in Factory

## Install

If e2e, the target engine, or the `e2e` skill is missing, use `AskUser`: “May I install [missing items] in this project?” Wait for approval. Use the project's package manager for dependencies. For the skill, copy the installed package's `skills/e2e/` into `.factory/skills/` without replacing an existing skill. Without the skill, use `e2e guide <topic>` when available.

| Target | Engine and setup |
|---|---|
| Web | [`@e2e-dev/web`](https://e2e.com/docs/web), Playwright browser and app URL or launch command |
| iOS or Android | [`@e2e-dev/mobile`](https://e2e.com/docs/mobile), Xcode simulator runtime or Android SDK/emulator, device plus app identity/build |
| Native desktop | [`@e2e-dev/desktop`](https://e2e.com/docs/desktop), macOS prototype, built `.app` or installed bundle ID; Electron web content is not supported |

## Suite

For a new web or mobile suite, run installed `e2e init --yes --engine <web|mobile> --gateway none --skills none --mcp none` (substitute `web` or `mobile`). Point the generated target and test at the real app. For desktop, follow the engine docs. Run the selected target's doctor before the first test.

## Live

Start Droid from the test project and check `/mcp` for `e2e`. The plugin uses offline npm resolution without installing packages. Check that the server reports the expected version and opens the expected config; npm may find an existing binary outside the project. In a monorepo, start from the test package and pass its absolute config and target. Keep one registration. Reconnect or restart after installing dependencies.

Without a config, `open_session` can name the installed engine and real app directly. Use `engine: "@e2e-dev/web"` with `app.url`, `engine: {package: "@e2e-dev/mobile", options: {platform: "ios"}}` (`"android"` as needed) with `app.bundleId`, or `engine: "@e2e-dev/desktop/engine"` with `app.appPath` or `app.bundleId`. Check the live schema. A one-off drive does not need to scaffold a suite.

If live MCP is unavailable, use a configured suite only where it proves the same claim. Ask before changing machine permissions, installing device tooling, or adding model credentials.
