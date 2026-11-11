# factory-stack

factory-stack is a set of agentic skills for Factory's Droid CLI. It packages 25 skills, and one custom droid named `principled-worker` as a single Droid plugin. The skills cover how a coding session runs, how to understand and change code, how to review and verify changes, and how to carry work through a pull request. Each skill does one job that Droid does not already do. Where Droid has a built-in feature for a job, factory-stack uses that feature and does not ship a replacement.

## Design principles

### Use Droid's own features first

factory-stack builds on Droid's native features: Spec mode, the `Task` tool with the built-in `explorer` and `worker` droids, `droid exec --worktree`, Missions, `AGENTS.md`, hooks, `/create-skill`, `/review`, `droid search`, `droid resume`, and Droid's built-in skills. A skill exists only for a method that Droid lacks.

### Pin no models

factory-stack sets no model anywhere. It has no per-role droids, no model tiers, no `subagentModelSettings`, and no model setup skill. Everything runs on the session's model, and the recommended session model is Factory Router (Auto Model), model ID `auto`. Subagents inherit the session's model, so a session on Auto Model runs its subagents on Auto Model too.

The one model string in the stack is `-m auto` on each `droid exec` that a skill starts. In Droid v1.8.0, `droid exec` defaults to `gpt-6.1-sol` when `-m` is absent, so `-m auto` selects the router. The flag is dropped if the signed-in run shows that `droid exec` reads the model from settings.

### Give each skill one job

Each skill has one trigger and one set of completion criteria, as Factory's [skills guide](https://docs.factory.com/harness/skills#best-practices) recommends. For example, creating a project verify skill and refreshing a drifted one are two skills, because the trigger and the finished state differ.

### Verify before calling work done

Verification has its own skills. `prove-it-works` checks a change in the running system before the work counts as done. `fix-bug`, `build-feature`, `ship-pr`, `unattended-run`, and `principled-worker` all end with it. Other skills build project verify skills, check formal models, find fallout outside a diff, and vet measurements.

### Do not duplicate built-ins

Every skill was compared against Droid's 45 built-in skills, 51 built-in slash commands, built-in droids, and Factory's official plugins. Each skill description names the nearest built-in and says when to use it instead. No skill name collides with a built-in name.

## Requirements

- The Droid CLI. The design was researched against Droid v1.8.0. Install it with one of these commands:
  - macOS or Linux: `curl -fsSL https://app.factory.ai/cli | sh`
  - Homebrew: `brew install --cask droid`
  - npm: `npm install -g droid`
- A Factory account signed in to Droid.
- `gh`, signed in, for `ship-pr` and `watch-pr`.
- A `FACTORY_API_KEY` environment variable may be required for skills that start `droid exec`, such as `race-worktrees`. Whether `droid exec` reuses the session's login is an open question.
- TLC, the TLA+ model checker, for the formal-methods skills. `tla-check/scripts/` holds the run and render tooling.

## Installation

The repository is a Droid marketplace that contains one plugin, `factory-stack`.

1. Add the marketplace:

	```sh
	droid plugin marketplace add https://github.com/Cynnamoroll/factory-stack
	```

2. Install the plugin for your user or for one project:

	```sh
	droid plugin install factory-stack@factory-stack --scope user
	```

	If Droid names the marketplace differently, `droid plugin marketplace list` shows the name to use after `@`.

3. Set the session model to Auto Model. In an interactive session, run `/model` and pick **Auto Model**. To make it the default, set `"model": "auto"` in `~/.factory/settings.json`. Whether Droid honors `auto` in settings is not yet confirmed.

To enable the plugin for a whole team, add the marketplace to `extraKnownMarketplaces` and the plugin to `enabledPlugins` in the project's `.factory/settings.json`.

A project skill with the same name as a factory-stack skill takes precedence over it. An organization plugin skill takes precedence over both.

## How to use the skills

### Invoke a skill yourself

Type `/` followed by the skill name, and add the target after it:

```text
/explain-how the auth flow
/fix-bug the login timeout
/vet-measurement this benchmark
/tighten-prose README.md
```

### Let Droid pick a skill

Droid reads each skill's description and loads the skill when a task matches. You do not need to name the skill. For example, if you ask Droid to fix a defect, it can load `fix-bug`. Most skills allow this.

### Slash-only skills

Six skills have side effects that are expensive or hard to undo. They set `disable-model-invocation: true`, so they run only when you type the slash command.

| Skill | Why it is slash-only |
|---|---|
| `race-worktrees` | It starts several paid `droid exec` runs in separate worktrees. |
| `add-guardrail` | It installs enforcement, such as a hook or a permission rule. |
| `create-verify-skill` | It writes a new, persistent skill into the project. |
| `ship-pr` | It opens a pull request. |
| `watch-pr` | It starts a long background watch on a pull request. |
| `unattended-run` | It starts a session that runs with nobody watching. |

### The hidden skill

`engineering-principles` sets `user-invocable: false`. It does not appear in the slash menu, but Droid and `principled-worker` can load it when a decision needs a named principle. It holds 24 principle files, such as `fix-root-causes.md` and `explain-the-number.md`. The files are not skills, and they do not appear in `/skills`.

## Skills reference

Each table lists the skill, what it does, when to use it, and when a Factory built-in or a sibling skill fits better. Skills marked "slash-only" run only when you type the command.

### Session and principles

| Skill | What it does | Use it when | Use instead |
|---|---|---|---|
| `dev-workflow` | Sets the autonomy, reply, comment, fan-out, and token rules for a coding session. | You start a coding task. | `AGENTS.md` for always-on repository conventions. The specific skill, such as `fix-bug` or `ship-pr`, for a specific workflow. |
| `engineering-principles` (hidden) | Applies the engineering principle that settles a coding or review decision, and reads only the principle files that apply. | A choice needs a named principle, such as fix root causes or explain the number. | `AGENTS.md` for always-on repository rules. `prove-it-works` or `vet-measurement` to run a verification procedure. |

### Understanding code

| Skill | What it does | Use it when | Use instead |
|---|---|---|---|
| `explain-how` | Explains how code works today in a walkthrough with file references, using `explorer` subagents. | You are about to change unfamiliar code, or you ask how something works. | `explain-why` for history or rationale. A bare `explorer` task for a quick lookup. |
| `explain-why` | Explains why code is the way it is from git history, pull requests, issues, and connected MCP sources, and cites each claim. | You need design rationale, the cause of a regression, or a postmortem. | `explain-how` for how code works now. `droid search` for local session history. |

### Building and fixing

| Skill | What it does | Use it when | Use instead |
|---|---|---|---|
| `fix-bug` | Reproduces the bug, finds the root cause, fixes it there, and verifies the fix against the reproduction with `prove-it-works`. | You have a defect report. | A direct fix in Normal mode when no repro-first loop is needed. `tune-perf` for a performance regression. |
| `build-feature` | Designs the feature in Spec mode, builds it, and verifies it in the running app with `prove-it-works`. | You build a new feature, a prototype, or a visual-parity change. | Spec mode alone for plan-only work. Factory's `refactoring-playbook` for large refactors, migrations, or dependency upgrades. |
| `test-first` | Writes a failing test that pins the behavior, makes it pass, then refactors. | You want TDD or a regression test, or a bug has an obvious reproduction. | `eval-runs` or `eval-hillclimb` for skill or prompt eval loops. |
| `race-worktrees` (slash-only) | Runs one task as several independent `droid exec` candidates in separate worktrees, picks the best result, and grafts the strongest parts of the others into it. | A change has several plausible designs. | Missions for multi-feature orchestration. Spec mode for a single plan. |

### Review

| Skill | What it does | Use it when | Use instead |
|---|---|---|---|
| `adversarial-review` | Attacks a diff with parallel read-only reviewers, one angle each, and verifies every finding before it reports the finding. | You are about to merge a risky change. | `/review` for a routine pass. `simplify` for a reuse, quality, and efficiency sweep. `check-blast-radius` for fallout outside the changed lines. |
| `check-blast-radius` | Finds what a change could break outside the changed lines and proves the one failure with a reproduction or a test. | The question is fallout beyond the diff. | `adversarial-review` for a multi-angle attack on the diff itself. `/review` for a routine review pass. |
| `add-guardrail` (slash-only) | Turns a repeated mistake into a blocking guardrail. It tries a type, then a lint or CI check, then a hook or a permission rule, and uses `AGENTS.md` last. | The same correction came up twice, or you want to mine a past session found with `droid search`. | `/hooks` or a manual edit of `permissionRules` when you only need to change a hook or rule yourself. |

### Verification

| Skill | What it does | Use it when | Use instead |
|---|---|---|---|
| `prove-it-works` | Verifies a change in the running system before the work counts as done. It uses the project's `verify-<app>` skill if one exists, otherwise `agent-browser` or `tuistory`, plus tests. | You are about to finish a bug fix, a feature, or a refactor. | `/review` or `adversarial-review` for a diff review. `simplify` for a reuse, quality, and efficiency sweep. |
| `create-verify-skill` (slash-only) | Creates a project `verify-<app>` skill that drives the running app the way a user does. It uses `agent-browser` for web apps and `tuistory` for terminal apps. | A project has no verify skill yet. | `maintain-verify-skill` to refresh a drifted one. `/create-skill` to draft a generic skill. `agent-browser` or `tuistory` for a one-time drive of the app. |
| `maintain-verify-skill` | Refreshes an existing project `verify-<app>` skill so that it still drives the running app the way a user does. | Features changed and the verify skill has drifted. | `create-verify-skill` to create the first verify skill. `agent-browser` or `tuistory` for a one-time drive. |

`create-verify-skill` writes the generated skill to the project's `.factory/skills/verify-<app>/`, not into the plugin.

### Formal methods

| Skill | What it does | Use it when | Use instead |
|---|---|---|---|
| `create-tla-model` | Writes TLA+ models of a system's stateful parts, such as flows, protocols, and state machines. | You start formal models for behavior that tests rarely cover. | `tla-check` to re-check existing models. `maintain-tla-model` to update models after code changes. |
| `maintain-tla-model` | Updates existing TLA+ models so that they match the code, then runs `tla-check`. | Commits touched code that a model covers. | `create-tla-model` to write the first model. `tla-check` to run the checker on unchanged models. |
| `tla-check` | Checks existing TLA+ models with TLC, renders the state diagram, and reports violations. | You want to verify a model or run the checker. | `create-tla-model` or `maintain-tla-model` to write or revise models. `eval-runs` or `eval-hillclimb` for skill or prompt evals. |

TLA+ models live in the project, not in the plugin.

### Performance

| Skill | What it does | Use it when | Use instead |
|---|---|---|---|
| `tune-perf` | Measures, vets the number with `vet-measurement`, changes one thing, and measures again. | You chase a slowdown, a performance regression, or a metric target. | `fix-bug` for correctness bugs. `vet-measurement` to vet a number on its own. |
| `vet-measurement` | Vets a measurement or a benchmark before anyone trusts, reports, or acts on it. It checks the limiter, tuning, limits, errors, repeatability, and relevance. | A number will drive a decision, including inside `tune-perf`. | `eval-runs` or `eval-hillclimb` for skill or prompt eval loops. `tune-perf` to make the performance change itself. |

### Pull requests and long runs

| Skill | What it does | Use it when | Use instead |
|---|---|---|---|
| `ship-pr` (slash-only) | Verifies each pull request in its own worktree with `prove-it-works`, runs `simplify` on the diff, and opens the pull request with `gh`. | Work is done and ready for review. | A bare `gh pr create` when no isolated verify and `simplify` pass is needed. `watch-pr` for a pull request that is already open. |
| `watch-pr` (slash-only) | Watches an open pull request in the background, triages comments from review bots and people, and fixes CI until the pull request can merge. | You opened a pull request that should be carried to green. | `/install-code-review` to set up automated review. Factory's `follow-up-on-pr` plugin for a single make-merge-ready pass. |
| `unattended-run` (slash-only) | Runs long work with nobody watching. It uses `Loop` to wake, keeps a decision log, and makes `wip:` commits with a resume note so that the run can stop safely. | You hand off a task and step away. | Missions for multi-feature orchestration. Automations for a scheduled job. |

### Writing and prompts

| Skill | What it does | Use it when | Use instead |
|---|---|---|---|
| `tighten-prose` | Edits prose to cut filler, hedging, and stock phrasing, and applies technical-writing rules to docs. | You edit text that people will read, such as READMEs, docs, pull request descriptions, commit messages, and comments. | `simplify` for a reuse, quality, and efficiency review of code. |
| `sharpen-prompt` | Restates what a task is for, then rewrites the prompt so that it goes deeper without growing in scope. | A request is vague or broad and has not reached Spec mode or a Mission yet. | Spec mode directly when the request is already sharp. |
| `session-recap` | Summarizes what changed since your last message, or across past sessions found with `droid search`. It lists the files touched, the decisions made, and what waits on you. | You come back to a session or pick up earlier work. | `droid search`, `droid resume`, or the `session-navigation` skill to search, list, or resume sessions. |

### Features Droid already covers

factory-stack ships no skill for these jobs:

| Job | Droid feature |
|---|---|
| List and route skills | `/skills` |
| Plan and approve before code | Spec mode |
| Run read-only work in parallel | Several `explorer` tasks in one message |
| Run parallel work that writes files | `droid exec --worktree` |
| Orchestrate multi-feature work | Missions |
| Review a diff for reuse, quality, and efficiency | The built-in `simplify` skill |
| Run skill and prompt eval loops | The built-in `eval-runs` and `eval-hillclimb` skills |
| Draft a generic skill | `/create-skill` |
| Search or resume past sessions | `droid search`, `droid resume`, and `session-navigation` |

## The principled-worker droid

`principled-worker` is the one custom droid. Use it for delegated tasks that change code or make a judgment call. Its prompt holds the principles index and the session's autonomy, reply, and comment rules. A delegate therefore does not reload `dev-workflow`. The droid loads `engineering-principles` for any principle it applies, and it runs `prove-it-works` before it treats a delegated edit as done.

The droid sets no `model`, so it inherits the session's model, and no `tools` list, so it has all tools. Use it in place of the built-in `worker` when the delegate must follow these principles and comment rules. Send read-only lookups to the built-in `explorer`, which Droid keeps read-only.

Subagents in Droid cannot start their own subagents. Skills that fan out, such as `race-worktrees` and `adversarial-review`, run from the main session.

## Repository layout

The repository contains only skills, this README, and the license:

```text
factory-stack/
	.factory-plugin/marketplace.json        # one plugin, source ./plugins/factory-stack
	plugins/factory-stack/
		.factory-plugin/plugin.json
		skills/
			<skill-name>/SKILL.md               # one directory per skill, 25 in total
			engineering-principles/             # SKILL.md plus 24 principle files
			tla-check/scripts/                  # TLC runner and Mermaid renderer
			watch-pr/scripts/pr-status.sh       # pull request status check
			...
		droids/
			principled-worker.md              # no model, no tools list
	LICENSE
	README.md
```

## Documentation

Factory's [skills guide](https://docs.factory.com/harness/skills) and [subagents guide](https://docs.factory.com/harness/subagents) set the rules that the skills and the droid follow.

## Contributing

Open a pull request only for completed work. Keep unfinished work on its branch. A completed skill has a `SKILL.md` that follows Factory's skills guide, matches its description in this README, and states its success criteria.

## License

factory-stack is released under the MIT License. Copyright Lauren Tan and Cynthia Toporowski. See [LICENSE](LICENSE).
