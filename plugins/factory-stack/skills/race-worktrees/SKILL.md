---
name: race-worktrees
description: "Race competing designs in separate worktrees and combine the strongest verified changes."
license: MIT
compatibility: droid
disable-model-invocation: true
---

# Race worktrees

Race isolated candidates, pick a base, and graft their best parts. Before launching, open a todo list with one item per phase.

## 1. Frame

Give every candidate the same prompt.

1. State the artifact each candidate produces.
2. Write a rubric of 3 to 6 gradeable criteria for this task. Candidates do not see it.
3. Pick N, usually 2 to 4. Use more when the design directions differ widely.
4. Commit or stash your own work first. Candidates branch from `HEAD`.

## 2. Fan out

Write the task to a file, then start every candidate at once from the repo root:

```sh
for i in $(seq 1 "$N"); do
	droid exec -m auto --auto medium --worktree "race-$i" -o json \
		-f /tmp/race-task.md > "/tmp/race-$i.json" 2>&1 &
done
wait
```

The task file tells each candidate to produce the artifact, leave its changes uncommitted in its worktree, and end with a short rationale naming the alternatives it rejected. `droid exec` removes a worktree that is clean on exit, so uncommitted changes keep it. Find each worktree with `git worktree list`.

If a run exits non-zero or produces nothing, continue with N-1 and note the dropout. If every run fails on authentication, stop and ask the user to export `FACTORY_API_KEY` in their shell. Never write a key to a file.

## 3. Judge

Issue one `explorer` Task as the judge. Give it the rubric and each worktree path by label. It scores each criterion per candidate and recommends a base. Read every candidate end to end yourself while it runs.

## 4. Pick a base

Score every candidate on every criterion. Agreement with the judge confirms the pick; otherwise read both rationales for bias or an unclear rubric. Prefer a base maintainers can extend without breaking invariants. Break ties with the smaller interface.

## 5. Graft

Walk each losing candidate once more for the one or two things worth porting. Fold each in by hand so the result reads as one design. If the candidates converge, ship the shared shape. If they diverge wildly, the frame was underspecified, so reframe and rerun.

## 6. Verify and clean up

Run `prove-it-works` on the merged result in the main checkout. If it finds a problem the race missed, go back to Frame or Graft. Then remove the candidate worktrees with `git worktree remove <path>` and `git worktree prune`.

Run candidate app captures in parallel only if ports, profiles, data, and input surfaces are independent. Worktrees alone do not isolate a desktop. A blocked required check is not a verified result.

## Done when

The reply names the base and why, the judge's verdict, each graft with its source candidate, what was rejected, any dropouts, and the `prove-it-works` result. No `race-*` worktree remains.
