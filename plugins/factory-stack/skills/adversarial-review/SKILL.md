---
name: adversarial-review
description: "Review risky diffs from independent angles; report only reproduced failures. Use check-blast-radius for fallout outside the diff."
license: MIT
compatibility: droid
---

# Adversarial review

Report only failures proved by a run. This review does not apply fixes.

## 1. Frame

Use the named scope, otherwise the branch diff from the default branch's merge base plus uncommitted changes (`git diff $(git merge-base HEAD origin/HEAD)`). Restate intent from the user's message, commits, and PR body. Ask only if those leave intent unclear.

## 2. Pick angles

Choose 3 to 5 angles that fit this diff, one per reviewer. Typical angles:

- the change does not do what the intent says on some input
- error, empty, and boundary paths
- state, ordering, and concurrency
- security, auth, and data handling
- tests that would still pass if the behavior broke

## 3. Fan out

Issue one `explorer` Task per angle, all in one message. Give each the scope command, the intent, its angle, and this brief:

> Break this change from your angle. For each finding, give a title, the exact command or test that shows the failure, the output you expect it to print, and the output the intent requires. Read the real code to build it. Leave out style, naming, and risks that need a future change to matter. No findings is a valid result.

## 4. Verify each finding

Run each proposed command or test yourself, in a scratch directory outside the repo (`/tmp/adv-<slug>/`). Keep a finding when the output shows the failure and the failure breaks the intent. Drop the rest. Merge findings that share a root cause. Delete the scratch directory when done.

Keep every reviewer's verified findings. Do not pick a winning reviewer.

## Done when

The reply has three parts:

- **Intent.** Your restatement.
- **Findings.** For each verified finding, the command, its output, how it breaks the intent, and which angles found it. Say "no verified findings" when none survive.
- **Dropped.** Per angle, the count of dropped findings and why.

The repo has no new or changed files.
