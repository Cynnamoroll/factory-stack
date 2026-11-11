---
name: ship-pr
description: "Verify each PR in its own worktree with prove-it-works, run simplify on the diff, and open the PR with gh. Use when work is done and ready for review; not for a bare gh pr create when no isolated verify and simplify pass is needed, and not to watch an already-open PR (use watch-pr)."
license: MIT
compatibility: droid
disable-model-invocation: true
---

# Ship PR

Open PRs that a reviewer can trust: each one verified by a run that did not write the code, cleaned up, and described in one minute of reading.

## 1. Shape the commits

Rebase into small, ordered commits. Each future PR lands on its own and the order tells the story: the failing test before the fix, the removal before the reshape. Prefer several narrow PRs to one large one. Stage only your files (`git add <files>`).

A stack is a chain of base branches. The bottom PR targets the default branch, and each child targets its parent's branch.

## 2. Verify each PR independently

For each PR branch, start a fresh run in its own worktree so the verdict does not come from the session that wrote the code:

```sh
droid exec -m auto --auto medium --worktree "verify-<branch>" -o json \
	"Check out <branch>. Run /prove-it-works on the change between <base> and <branch>. End with PASS, PASS+NOTES, or FAIL and the evidence."
```

Run several at once with `&` and `wait`. Green CI and a bot approval are not verdicts, because neither runs the change the way a user would. A FAIL goes back to the author step. Do not open that PR.

Record the verdict's commit. Before trusting a verdict after a rebase, compare `git diff <base>...<verdict-sha> | git patch-id --stable` with the same for the current head. Different patch IDs mean a fresh verification.

If `droid exec` fails on authentication, ask the user to export `FACTORY_API_KEY` in their shell. Never write a key to a file.

## 3. Clean the diff

Run Droid's built-in `simplify` skill on each PR's diff and apply the fixes that hold up. Remove comments that narrate steps. Rerun `prove-it-works` if `simplify` changed behavior-bearing code.

## 4. Write the PR

- **Title.** Conventional Commits, `type(scope): subject`, imperative, no trailing period, naming a real symbol when one carries the change.
- **Body.** Run `tighten-prose` on it. Use `##` headings in this order and drop any with nothing to say:
  - `## Why`: the problem and approach in 1 to 3 sentences.
  - `## What changed`: 1 to 3 bullets.
  - `## Scope`: what it covers and what it leaves out.
  - `## Tradeoffs`: only rejected alternatives a reviewer would ask about.
  - `## Blast radius`: who or what it touches and why that is safe or risky.
  - `## Verification`: the verdict and 1 to 3 run paths with outcomes. Perf gets one number, before and after.

Write the body to a file. Open the PR ready, not draft:

```sh
gh pr create --base <base> --head <branch> --title "<title>" --body-file /tmp/pr-body.md
```

Then read it back with `gh pr view <number>`.

## Done when

Every PR opened has a PASS or PASS+NOTES verdict whose patch ID matches its head, `simplify` ran on its diff, and the reply lists each PR as a full `https://github.com/<owner>/<repo>/pull/<number>` URL with its verdict. Opening a PR does not start a watch. The user runs `/watch-pr` when the stack is complete. Remove the `verify-*` worktrees when done.
