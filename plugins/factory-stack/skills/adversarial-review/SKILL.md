---
name: adversarial-review
description: "Attack a diff with parallel read-only reviewers, one angle each, and verify every finding before reporting it. Use before merging a risky change; not for a routine pass (use /review), a reuse, quality, and efficiency sweep (use simplify), or fallout outside the changed lines (use check-blast-radius)."
license: MIT
compatibility: droid
---

# Adversarial review

Reviewers try to break a change. A finding survives only when a run proves it. Report findings. Do not apply fixes.

## 1. Frame

The scope is what the user names. Otherwise it is the branch diff from its merge base with the default branch, plus uncommitted changes (`git diff $(git merge-base HEAD origin/HEAD)`). Restate the intent in your own words from the user's message, the commits, and the PR body. Ask only if the intent cannot be read from those.

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

Every reviewer's verified findings stay in the verdict. Reviewers find different failures, so there is no winner to pick.

## Done when

The reply has three parts:

- **Intent.** Your restatement.
- **Findings.** For each verified finding, the command, its output, how it breaks the intent, and which angles found it. Say "no verified findings" when none survive.
- **Dropped.** Per angle, the count of dropped findings and why.

The repo has no new or changed files.
