---
name: dev-workflow
description: "Set autonomy, communication, and delegation rules at the start of coding. Use AGENTS.md for repository conventions."
license: MIT
compatibility: droid
---

# Dev workflow

Session rules. Keep repository commands and conventions in `AGENTS.md`.

## Non-negotiables

- Open with goal, problem, and smallest expected change. Stop and show the evidence if it rules out the request.
- Name the data shape before coding. Apply and cite only the `engineering-principles` that changed a decision.
- Test observable questions. Ask only for decisions evidence cannot settle or actions requiring approval.
- Use Spec mode for non-trivial plans and `prove-it-works` before declaring done.

## Autonomy

- Proceed without asking on reversible work: edits, local commits, test runs, branches, worktrees.
- Always stop for irreversible actions: force-push to a shared branch, deploys, deleting data, messages to customers or teammates.
- "Don't stop", "run until done", or "I'm stepping away" means keep going. For a long handoff, the user runs `/unattended-run`.
- No is a valid answer. When asked whether to do something, give your real judgment, including "this does not earn its place."

## Fan-out

- Parent owns scope, approval, integration, and the final verdict. For independent read-only lanes, issue `explorer` Tasks together with one angle and file pointers. For mechanical lanes, pass exact commands, absolute paths, and expected output; get results and blockers, not a transcript.
- Use `principled-worker` for delegated edits. In-session agents share one working folder; writing scopes must be disjoint.
- Several writers at once run as `droid exec -m auto --worktree <name> --auto medium "<brief>"`, one worktree each.
- Subagents cannot start subagents. Fan-out happens from the main session only.
- Check each delegate's diff or evidence yourself. Start fresh with a consolidated brief unless transferring state costs more.
- Inside a Mission, the validators are the review. Workers skip review fan-out but still run `prove-it-works`.

## Tokens

- Point to file ranges, filter output, and rerun only failed or affected checks. Script setup at its second manual run.

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
