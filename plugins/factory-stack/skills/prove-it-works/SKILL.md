---
name: prove-it-works
description: "Verify a code change in the real system before declaring done. Use e2e-qa for standalone QA, /review for diffs."
license: MIT
compatibility: droid
---

# Prove it works

Check the real artifact directly. Compilation, self-reports, proxies, and unit tests alone do not prove the user-facing result.

## 1. Name the claim

Pin the claim, build, input method, observable postconditions, and required artifacts. For bugs, keep the original repro. Hand these commitments to the driver.

## 2. Pick the surface

Drive the change on the surface a user touches:

- **Web, mobile, Electron, terminal, or native macOS:** Load `e2e-qa` for the project recipe and driver. It routes browser panes, Electron, and terminals to Droid's built-in drivers.
- **Other project recipe:** Follow the matching `verify-<app>` skill's Launch, Doctor, Drive, Evidence, and Cleanup sections.
- **HTTP service:** Send the real request with `curl`.
- **Library:** Import the built package and call the changed API as a consumer would.

Wrong surface or "inconclusive" is not a pass. Say which it was.

## 3. Run it

1. Run relevant project tests. A test counts as the live drive when its target, actions, assertions, and evidence cover the claim. Rerun only failures and affected coverage.
2. Drive uncovered proof points. Check that each required artifact shows its promised result.
3. Check side effects as well as what is visible: files written, rows stored, messages sent.
4. When a check fails, suspect the observation method first, then the system.

Prefer a script that reruns the same comparison over a one-time look. Keep it under `/tmp/` unless it is worth committing as a regression test.

For every surface, follow [QA cleanup](../e2e-qa/references/qa-cleanup.md). Report cleanup blockers separately from observations.

## 4. When it fails

Fix the cause and rerun step 3 without weakening assertions or skipping steps. If credentials, production-only state, or hardware block the run, name the blocker and the closest check's result.

## Done when

Return `PASS` when proof and required teardown are verified, `FAIL` when a required check or teardown fails, or `BLOCKED` when proof or required teardown cannot be completed safely. `PASS+NOTES` means all requirements passed with unrelated caveats. Give claim, build, method, commands, observations, and artifact paths. For bugs, show the repro failing before and passing after.
