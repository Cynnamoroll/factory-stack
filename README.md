# factory-stack

26 skills and a custom droid for Factory's Droid CLI. Use them to understand code, fix bugs, verify behavior in the real app, and prepare pull requests.

## Install

Install the [Droid CLI](https://docs.factory.com/droid-cli/quickstart) and sign in, then run:

```sh
droid plugin marketplace add https://github.com/Cynnamoroll/factory-stack
droid plugin install factory-stack@factory-stack --scope user
```

Start a new Droid session and run `/skills`. Use `--scope project` to install for one project instead. If the marketplace has a different name, check `droid plugin marketplace list` and use that name after `@`.

## Start with a task

| I want to… | Try |
| --- | --- |
| Understand unfamiliar code | `/explain-how the auth flow` |
| Find out why a decision was made | `/explain-why login retries were added` |
| Reproduce, fix, and verify a bug | `/fix-bug the login timeout` |
| Verify a change on the real user path | `/prove-it-works saving a draft survives reload` |
| Run standalone QA with screenshots | `/e2e-qa save a draft and capture before and after screenshots` |
| Open a verified pull request | `/ship-pr` |

Droid can also pick most skills from a natural-language request. See the [full skill catalog](docs/skills.md) for every skill, optional tools, and which commands require explicit invocation.

## Set up e2e QA

`/e2e-qa` reuses your project's `verify-<app>` recipe or tests. It uses [e2e](https://github.com/e2e-inc/e2e) for web, iOS, Android, and native macOS testing. Windows and Linux native desktop apps are out of scope. It hands the Factory browser pane and Electron renderer to Droid's built-in `agent-browser`, and unrecorded terminal flows to the built-in `tuistory`.

Start Droid from the app project. The plugin registers `e2e` in `/mcp` and resolves the runner offline without installing it. If prerequisites are missing, Droid asks for approval, then installs and verifies them and continues the task. See [e2e setup](plugins/factory-stack/skills/e2e-qa/references/e2e-setup.md) for prerequisites.

For terminal recordings, byte capture, real emulator setup, or produced video, `/e2e-qa` hands off to Factory's official [droid-control plugin](https://docs.factory.com/automations/droid-control). Install it alongside factory-stack:

```sh
droid plugin marketplace add https://github.com/Factory-AI/factory-plugins
droid plugin install droid-control@factory-plugins --scope user
```

Without that plugin, Droid can set up a separate checkout of [its helpers](https://github.com/Factory-AI/factory-plugins/tree/master/plugins/droid-control) after approval. For a different location, set `DROID_CONTROL_HELPERS_ROOT` to the absolute `plugins/droid-control` directory, or pass that path in the request. See the [macOS `tctl` compatibility note](plugins/factory-stack/skills/e2e-qa/references/macos-tctl.md) before using older terminal helpers on macOS.
## Update

```sh
droid plugin marketplace update factory-stack
droid plugin update factory-stack@factory-stack --scope user
```

Use the same marketplace name and scope you installed with. Start a new Droid session to load the update.

## Contribute

Follow [Factory's skills guide](https://docs.factory.com/harness/skills). Keep each skill's trigger distinct and its completion criteria checkable. Do not duplicate a skill Droid ships built in (see `/skills`, **Built-in** tab); call it from your skill and add a "use X for Y" boundary to the description instead. Update the [catalog](docs/skills.md) when a skill is added or its purpose changes.

[MIT License](LICENSE)
