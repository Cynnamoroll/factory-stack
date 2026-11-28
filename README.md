# factory-stack

25 skills and a custom droid for Factory's Droid CLI. Use them to understand code, fix bugs, verify behavior in the real app, and prepare pull requests.

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

`e2e-qa` drives real apps with [e2e](https://github.com/e2e-inc/e2e) on web, iOS, Android, and native macOS. It uses Droid's built-in `tuistory` for terminal apps and `agent-browser` for the Factory browser pane and Electron renderers. Windows and Linux native desktop apps are out of scope.

Start Droid from the app project. The plugin registers `e2e` in `/mcp` and resolves the runner offline without installing it. If prerequisites are missing, Droid asks for approval, then installs and verifies them and continues the task. See [e2e setup](plugins/factory-stack/skills/e2e-qa/references/e2e-setup.md) for prerequisites.

### Project QA with install-qa

Droid's built-in `/install-qa` generates a `qa` skill, one `qa-<app>` skill per app, and an optional CI job. `e2e-qa` drives the flows those skills define, and `/qa` and `prove-it-works` route interactive flows through it.

Run `maintain-qa-skills` to map each app and flow to an e2e test in `.factory/skills/qa/e2e.yaml`, and again when features change. `/install-qa` never writes that file, so the mapping survives reruns.

## Update

```sh
droid plugin marketplace update factory-stack
droid plugin update factory-stack@factory-stack --scope user
```

Use the same marketplace name and scope you installed with. Start a new Droid session to load the update.

## Contribute

Follow [Factory's skills guide](https://docs.factory.com/harness/skills). Keep each skill's trigger distinct and its completion criteria checkable. Do not duplicate a skill Droid ships built in (see `/skills`, **Built-in** tab); call it from your skill and add a "use X for Y" boundary to the description instead. Update the [catalog](docs/skills.md) when a skill is added or its purpose changes.

[MIT License](LICENSE)
