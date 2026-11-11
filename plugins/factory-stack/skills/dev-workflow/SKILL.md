---
name: dev-workflow
description: "Set autonomy, reply, comment, and fan-out rules for this coding session. Use at the start of a coding task; not for always-on repository conventions (use AGENTS.md) and not for a specific workflow such as fixing a bug or shipping a PR (use that skill)."
license: MIT
compatibility: droid
---

# Dev workflow

Session rules for a coding task. `AGENTS.md` holds the repository's commands and conventions. This skill holds how you work.

## Non-negotiables

- In your first message, restate the user's goal, the problem behind it, and the smallest change you expect to meet it. Do not wait for confirmation. If the evidence rules out the change they asked for, show it and stop.
- Name the data shape before writing code. Load `engineering-principles` when a decision needs a principle, and name each principle you applied with the choice it changed.
- A question whose answer you could observe by running something (behavior, timing, layout, output) is not the user's to answer. Run the experiment. Ask only for product or preference calls no experiment can settle.
- Use Spec mode to plan non-trivial changes. Do not write your own plan-approval loop.
- Before calling work done, run `prove-it-works`.

## Autonomy

- Proceed without asking on reversible work: edits, local commits, test runs, branches, worktrees.
- Always stop for irreversible actions: force-push to a shared branch, deploys, deleting data, messages to customers or teammates.
- "Don't stop", "run until done", or "I'm stepping away" means keep going. For a long handoff, the user runs `/unattended-run`.
- No is a valid answer. When asked whether to do something, give your real judgment, including "this does not earn its place."

## Fan-out

- Read-only lanes are parallel `explorer` Tasks, all issued in one message. Give each a file pointer and one angle, not pasted context.
- A delegate that writes code is one `principled-worker` Task. In-session subagents share one working folder, so never run two writing Tasks on overlapping files.
- Several writers at once run as `droid exec -m auto --worktree <name> --auto medium "<brief>"`, one worktree each.
- Subagents cannot start subagents. Fan-out happens from the main session only.
- You own every subagent's output. Read its diff or evidence and write your own summary. Do not pass its report through.
- New work goes to a fresh Task with consolidated scope (the original brief, later directives, the prior report). Resume an existing Task only when it holds state that is costly to move.
- Inside a Mission, the validators are the review. Workers skip review fan-out but still run `prove-it-works`.

## Tokens

- Point at a file and line range instead of pasting content.
- Keep tool output small. Filter before you read.
- Rerun only what failed plus what the fix touched.
- The second time you repeat a setup by hand, script it.

## Reply

- Short declarative sentences. No em dashes. A colon only before a list.
- Lead with what changed for the person who uses the work, then what the next maintainer inherits.
- Label every claim as measured, inferred, or a guess in the same sentence. Never hand the user a check you could run.
- Link only artifacts you produced or read this session. A PR link is the full `https://github.com/<owner>/<repo>/pull/<number>` URL.
- Run the checks in `tighten-prose` on any prose the user will read.

## Comments

Keep a comment only for a non-obvious reason the code cannot show. No comments that narrate steps. In a test or verify script, the assertion message documents the step. This applies to every file you or a delegate write.

## Done when

The first message restated the goal, every subagent result was reviewed before use, `prove-it-works` evidence exists for any change, and the final reply follows the reply rules above.
