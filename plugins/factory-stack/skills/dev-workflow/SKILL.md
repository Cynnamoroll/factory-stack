---
name: dev-workflow
description: "Set session autonomy, reply, comment, and fan-out rules at the start of coding. Use AGENTS.md for repository conventions and a task-specific skill for workflows such as fixing bugs or shipping PRs."
license: MIT
compatibility: droid
---

# Dev workflow

Session rules. Keep repository commands and conventions in `AGENTS.md`.

## Non-negotiables

- First message, restate the goal, underlying problem, and smallest expected change. Proceed without confirmation unless evidence rules out the request. Then show it and stop.
- Name the data shape before writing code. Load `engineering-principles` when a decision needs a principle, and name each principle you applied with the choice it changed.
- Run experiments to answer observable questions (behavior, timing, layout, output). Ask only for product or preference calls experiments cannot settle.
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
- Review every subagent's diff or evidence and write your own summary, not a forwarded report.
- Start a fresh Task with consolidated scope (original brief, later directives, prior report). Resume only when moving its state would be costly.
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

In every file you or a delegate write, comment only on non-obvious reasons the code cannot show. Use assertion messages to document test or verification steps.

## Done when

The first message restated the goal, every subagent result was reviewed before use, `prove-it-works` evidence exists for any change, and the final reply follows the reply rules above.
