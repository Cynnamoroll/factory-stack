---
name: unattended-run
description: "Run a defined task unattended with a decision log and resumable checkpoints."
license: MIT
compatibility: droid
disable-model-invocation: true
---

# Unattended run

Drive to a defined outcome. Keep an accurate trail for later review.

## 1. Set the exit condition

State a checkable predicate before the first iteration: tests green, repro fixed, a metric past a target, N PRs open. Write it as the first row of the log.

## 2. Open the decision log

Keep one TSV log outside git, `/tmp/<slug>-decisions.tsv` or `.factory/runs/<slug>.tsv` if `.factory/runs/` is gitignored. Append rows with:

```sh
"${DROID_PLUGIN_ROOT}/skills/unattended-run/scripts/log.sh" <log> <phase> "<decision>" "<why>" "<evidence>" "<result>"
```

Log decisions, verified units, reverts and triggers, and blockers, not every action. Evidence is a pointer (commit, `file:line`, artifact path), not prose. Append only; supersede wrong rows with new ones.

## 3. Pick the wake

- For an event (CI, a merge, a long build), run the waiting command in the background so Droid wakes you when it ends, and add a `loop_create` heartbeat as a fallback.
- With no event, use a `loop_create` interval sized to when a result is worth checking.
- Cancel the loop with `loop_cancel` when the run finishes or pauses.

Droid keeps the plan and the approved spec through compaction. The log keeps everything else.

## 4. Iterate

Each iteration makes the smallest evidence-supported change, runs `prove-it-works` against the predicate, commits progress or reverts, and logs one row. Revert speculative changes.

Fix what blocks the goal yourself: broken scripts, flaky checks, related bugs. Put unrelated fixes in their own commit. Do not stop to ask about reversible work. Stop only for an irreversible action, a product call no experiment can settle, or a real dead end.

A plateau is not a stop. Change approach. Never relax the predicate.

## 5. Pause safely

When the user asks to pause, or the run must stop:

1. Finish or back out of the current step. Start nothing new.
2. Take no irreversible action. No push unless one was already out.
3. Commit everything as one `wip:` commit on the current branch. If the tree is broken, say so in the commit body.
4. Write `/tmp/<slug>-resume.md`: the goal, the predicate state, what is verified, the next step, key files, and traps. Point at the log instead of repeating it.

## 6. Audit before handing back

Audit every row against the run. Require real actions, resolving evidence pointers, and rows for every consequential pivot or abandoned approach. Supersede errors without editing or deleting rows.

Then issue one `explorer` Task to review the log and the diff for weak evidence, skipped verification, and risky calls, and fold its flags into the reply.

## Done when

The predicate is met, or the run paused or hit a dead end with a `wip:` commit and a resume note. The reply gives the predicate and its final state, iterations run, what landed, what was reverted, the log path, and an "Attention" section with the reviewer's flags or "no flags".
