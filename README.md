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
| Run standalone QA or capture a demo | `/droid-control save a draft and capture before and after screenshots` |
| Open a verified pull request | `/ship-pr` |

Droid can also pick most skills from a natural-language request. See the [full skill catalog](docs/skills.md) for every skill, optional tools, and which commands require explicit invocation.

## Set up Droid Control

`/droid-control` reuses your project's `verify-<app>` recipe or tests. It uses [e2e](https://github.com/e2e-inc/e2e) for web, iOS, Android, and native macOS testing. Windows and Linux native desktop apps are out of scope. Use `agent-browser` for the Factory browser pane or Electron renderer, and `tuistory` for unrecorded terminal flows.

Start Droid from the app project. The plugin registers `e2e` in `/mcp` and resolves the runner offline without installing it. Droid asks before installing missing e2e dependencies or the optional upstream skill. See [e2e setup](plugins/factory-stack/skills/droid-control/references/e2e-setup.md) for prerequisites.

For terminal recordings, byte capture, real emulator setup, or produced video, keep a separate checkout of the [original Factory helpers](https://github.com/Factory-AI/factory-plugins/tree/master/plugins/droid-control). Do not register this checkout as a Droid plugin:

```sh
git clone https://github.com/Factory-AI/factory-plugins "$HOME/factory-control-helpers"
```

For a different location, set `DROID_CONTROL_HELPERS_ROOT` to the absolute `plugins/droid-control` directory, or pass that path in the request. See the [macOS `tctl` compatibility note](plugins/factory-stack/skills/droid-control/references/macos-tctl.md) before using older terminal helpers on macOS.

If another installed plugin exposes `/droid-control`, disable that plugin in its configured scope and restart Droid. See [Factory's plugin settings guide](https://docs.factory.com/harness/plugins) for team setup and plugin enablement.

## Update

```sh
droid plugin marketplace update factory-stack
droid plugin update factory-stack@factory-stack --scope user
```

Use the same marketplace name and scope you installed with. Start a new Droid session to load the update.

## Contribute

Follow [Factory's skills guide](https://docs.factory.com/harness/skills). Keep each skill's trigger distinct and its completion criteria checkable. Update the [catalog](docs/skills.md) when a skill is added or its purpose changes.

[MIT License](LICENSE)
