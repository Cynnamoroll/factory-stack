# Skill catalog

[Back to install and quick start](../README.md)

Most skills can be selected by Droid or invoked directly. **Slash only** means the skill runs only when explicitly invoked. **Hidden** means the skill is available to Droid but not shown in the slash menu.

## Understand and change code

| Skill | Use it to… |
| --- | --- |
| [`explain-how`](../plugins/factory-stack/skills/explain-how/SKILL.md) | Trace how code works today. |
| [`explain-why`](../plugins/factory-stack/skills/explain-why/SKILL.md) | Find cited rationale, regression history, or postmortem evidence. |
| [`build-feature`](../plugins/factory-stack/skills/build-feature/SKILL.md) | Plan, build, and verify a feature, prototype, or visual-parity change. |
| [`fix-bug`](../plugins/factory-stack/skills/fix-bug/SKILL.md) | Reproduce a defect and verify the fix against the same repro. |
| [`test-first`](../plugins/factory-stack/skills/test-first/SKILL.md) | Pin behavior with a failing test before fixing or refactoring. |
| [`race-worktrees`](../plugins/factory-stack/skills/race-worktrees/SKILL.md) · Slash only | Compare competing designs in isolated worktrees and combine the strongest verified changes. |

## Verify and review

| Skill | Use it to… |
| --- | --- |
| [`e2e-qa`](../plugins/factory-stack/skills/e2e-qa/SKILL.md) | Run e2e on web, iOS, Android, or native macOS. Hands browser panes, terminals, and demo video to `agent-browser`, `tuistory`, and Factory's `droid-control` plugin. |
| [`prove-it-works`](../plugins/factory-stack/skills/prove-it-works/SKILL.md) | Verify a change on the real user path before declaring it done. |
| [`create-verify-skill`](../plugins/factory-stack/skills/create-verify-skill/SKILL.md) · Slash only | Create a project `verify-<app>` recipe for `prove-it-works`, reusing any `install-qa` skill. |
| [`maintain-verify-skill`](../plugins/factory-stack/skills/maintain-verify-skill/SKILL.md) | Reconcile a project verification recipe with source and live behavior. |
| [`adversarial-review`](../plugins/factory-stack/skills/adversarial-review/SKILL.md) | Stress-test a risky diff from independent angles and keep only reproduced findings. |
| [`check-blast-radius`](../plugins/factory-stack/skills/check-blast-radius/SKILL.md) | Reproduce fallout outside the changed code. |
| [`add-guardrail`](../plugins/factory-stack/skills/add-guardrail/SKILL.md) · Slash only | Turn a recurring mistake into an enforced check or rule. |

Project verification recipes live in `.factory/skills/verify-<app>/`, not in the plugin. Use Droid's `/review` for a routine diff review, `simplify` for code quality and reuse, and `install-qa` for a QA suite with CI.

## Measure and model

| Skill | Use it to… |
| --- | --- |
| [`tune-perf`](../plugins/factory-stack/skills/tune-perf/SKILL.md) | Measure and fix a performance regression or meet a target. |
| [`vet-measurement`](../plugins/factory-stack/skills/vet-measurement/SKILL.md) | Check whether a measurement supports a decision. |
| [`create-tla-model`](../plugins/factory-stack/skills/create-tla-model/SKILL.md) | Model a new state machine, flow, or protocol in TLA+. |
| [`maintain-tla-model`](../plugins/factory-stack/skills/maintain-tla-model/SKILL.md) | Update an existing TLA+ model after behavior changes. |
| [`tla-check`](../plugins/factory-stack/skills/tla-check/SKILL.md) | Run TLC, render states, and report violations. |

The TLA+ skills need the TLC model checker. Models belong in the project.

## Run and ship work

| Skill | Use it to… |
| --- | --- |
| [`dev-workflow`](../plugins/factory-stack/skills/dev-workflow/SKILL.md) | Set autonomy, communication, and delegation rules for a coding session. |
| [`engineering-principles`](../plugins/factory-stack/skills/engineering-principles/SKILL.md) · Hidden | Load the principle that informs a coding or review decision. |
| [`ship-pr`](../plugins/factory-stack/skills/ship-pr/SKILL.md) · Slash only | Verify an isolated PR branch, simplify the diff, and open a PR. |
| [`watch-pr`](../plugins/factory-stack/skills/watch-pr/SKILL.md) · Slash only | Watch an open PR or stack until it is merge-ready, running `fix-pull-request` on each fixable wake. |
| [`unattended-run`](../plugins/factory-stack/skills/unattended-run/SKILL.md) · Slash only | Run a defined task unattended with resumable checkpoints. |
| [`session-recap`](../plugins/factory-stack/skills/session-recap/SKILL.md) | Recap prior work, current status, and decisions waiting on the user. Use `session-navigation` to find or resume sessions. |

`ship-pr` and `watch-pr` need an authenticated `gh` CLI. Skills that spawn `droid exec` may need `FACTORY_API_KEY` in the shell if the run cannot authenticate.

## Write and refine prompts

| Skill | Use it to… |
| --- | --- |
| [`tighten-prose`](../plugins/factory-stack/skills/tighten-prose/SKILL.md) | Cut filler from docs, PRs, commits, or comments. |
| [`sharpen-prompt`](../plugins/factory-stack/skills/sharpen-prompt/SKILL.md) | Clarify a vague task without expanding its scope. |

## Custom droid

[`principled-worker`](../plugins/factory-stack/droids/principled-worker.md) implements and verifies scoped edits under factory-stack's engineering and comment rules. Use the built-in `explorer` for read-only lookups and `worker` for mechanical steps. The custom droid does not pin a model; it inherits the session's model. See [Factory's subagents guide](https://docs.factory.com/harness/subagents).
