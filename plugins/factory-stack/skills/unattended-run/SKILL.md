---
name: unattended-run
description: "Run long work with nobody watching, using Loop to wake, a decision log, and wip: commits with a resume note so the run can stop safely. Use when the user hands off a task and steps away; not for multi-feature orchestration (use Missions) or a scheduled job (use Automations)."
license: MIT
compatibility: droid
disable-model-invocation: true
---

# Unattended run

Define done, then drive to it without stopping. The user reviews the trail later, so the trail must be true.

## 1. Set the exit condition

State a checkable predicate before the first iteration: tests green, repro fixed, a metric past a target, N PRs open. Write it as the first row of the log.

## 2. Open the decision log

Keep one TSV log outside git, `/tmp/<slug>-decisions.tsv` or `.factory/runs/<slug>.tsv` if `.factory/runs/` is gitignored. Append rows with:

```sh
"${DROID_PLUGIN_ROOT}/skills/unattended-run/scripts/log.sh" <log> <phase> "<decision>" "<why>" "<evidence>" "<result>"
```

Log decision points, not every action: a fork chosen, a unit verified, a revert and its trigger, a blocker. Evidence is a pointer (a commit, `file:line`, an artifact path), never a paragraph. The log is append-only. A wrong row gets a new row that supersedes it.

## 3. Pick the wake

- For an event (CI, a merge, a long build), run the waiting command in the background so Droid wakes you when it ends, and add a `Loop` heartbeat as a fallback.
- With no event, use a `Loop` interval sized to when a result is worth checking.

Droid keeps the plan and the approved spec through compaction. The log keeps everything else.

## 4. Iterate

Each iteration makes the smallest change the evidence supports, runs `prove-it-works` against the predicate, commits if it advanced, and reverts if it did not. A change that "might help" is reverted, not left in. Log one row per iteration.

Fix what blocks the goal yourself: broken scripts, flaky checks, related bugs. Put unrelated fixes in their own commit. Do not stop to ask about reversible work. Stop only for an irreversible action, a product call no experiment can settle, or a real dead end.

A plateau is not a stop. Change approach. Never relax the predicate.

## 5. Pause safely

When the user asks to pause, or the run must stop:

1. Finish or back out of the current step. Start nothing new.
2. Take no irreversible action. No push unless one was already out.
3. Commit everything as one `wip:` commit on the current branch. If the tree is broken, say so in the commit body.
4. Write `/tmp/<slug>-resume.md`: the goal, the predicate state, what is verified, the next step, key files, and traps. Point at the log instead of repeating it.

## 6. Audit before handing back

Walk the log against what actually happened this run. Every row maps to a real action, every evidence pointer resolves, and every pivot or abandoned approach that shaped the work has a row. Add superseding rows for anything wrong. Never edit or delete a row.

Then issue one `explorer` Task to review the log and the diff for weak evidence, skipped verification, and risky calls, and fold its flags into the reply.

## Done when

The predicate is met, or the run paused or hit a dead end with a `wip:` commit and a resume note. The reply gives the predicate and its final state, iterations run, what landed, what was reverted, the log path, and an "Attention" section with the reviewer's flags or "no flags".
