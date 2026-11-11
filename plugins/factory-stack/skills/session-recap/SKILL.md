---
name: session-recap
description: "Summarize what changed since the user's last message, or across past sessions found with droid search: files touched, decisions made, and what is waiting on the user. Use when coming back to a session or picking up earlier work; not for searching, listing, or resuming sessions (use droid search, droid resume, or session-navigation)."
license: MIT
compatibility: droid
allowed-tools:
  - Read
  - Grep
  - Glob
  - Execute
---

# Session recap

Catch the user up and lay out every call waiting on them, so they can decide from your reply alone. Assume they remember their last message and nothing after it. This turn is read-only: change no code, start no job, post nothing.

## 1. Gather

- **This session.** Your work since the user's last message, subagent reports, and the current state of each branch, PR, CI run, or worktree the session touched (`git status`, `git log`, `gh pr view`).
- **Past sessions.** `droid search "<topic>" --json` finds them. Read the matching turns. If the user wants to continue one, point them at `droid resume`.

Check each number you will show against its source.

An action item is a call only the user can make: a product choice, an approval, an irreversible step, or access you lack. Work you can still do yourself is not an action item. Never invent one.

## 2. Write

- Open with one sentence that names what waits on the user, or says nothing does.
- What happened, in under 100 words. One plain bullet per thing the user asked for: what came of it and whether it is done, running, failed, or unchecked. "Search was slow from a missing index", not "Search review: done."
- Add a `mermaid` diagram only when a picture explains a change better than sentences (a PR stack, a flow before and after). At most six boxes.
- Then the action items. For each, the call, your pick, what it changes for users, the evidence, and the risk. Give the PR or issue number. For a choice between options, give each option's gain and cost.

Use plain words. Leave out hashes, paths, and commands unless the user needs one to act.

## Done when

Every action item still waiting on the user is listed with a pick, every status line stays true read alone, nothing marked done still waits on the user, and no file changed.
