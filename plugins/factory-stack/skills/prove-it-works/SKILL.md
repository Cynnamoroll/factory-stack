---
name: prove-it-works
description: "Verify a code change in the real system before declaring done. Use droid-control for standalone QA or demos, /review for diffs."
license: MIT
compatibility: droid
---

# Prove it works

Check the real artifact directly. Compilation, self-reports, proxies, and unit tests alone do not prove the user-facing result.

## 1. Name the claim

Pin the claim, build, input method, observable postconditions, and required artifacts. For bugs, keep the original repro. Hand these commitments to the driver.

## 2. Pick the surface

Drive the change on the surface a user touches:

- **Web, Electron, terminal, or native desktop:** Load `droid-control` for the matching project `verify-<app>` recipe, driver selection, and evidence.
- **Other project recipe:** Follow the matching `verify-<app>` skill's Launch, Doctor, Drive, Evidence, and Cleanup sections.
- **HTTP service:** Send the real request with `curl`.
- **Library:** Import the built package and call the changed API as a consumer would.

Wrong surface or "inconclusive" is not a pass. Say which it was.

## 3. Run it

1. Run relevant project tests. Rerun only what failed plus what the fix touched.
2. Drive the action and observe its result. Check that every required screenshot, recording, or other artifact shows its promised proof points.
3. Check side effects as well as what is visible: files written, rows stored, messages sent.
4. When a check fails, suspect the observation method first, then the system.

Prefer a script that reruns the same comparison over a one-time look. Keep it under `/tmp/` unless it is worth committing as a regression test.

For every surface, use `droid-control`'s QA cleanup checklist. Verify owned resources are gone and mutations restored on success or failure. Keep delivered proof accessible and report any cleanup blocker separately from what you observed.

## 4. When it fails

Fix the cause and rerun step 3 without weakening assertions or skipping steps. If credentials, production-only state, or hardware block the run, name the blocker and the closest check's result.

## Done when

Return `PASS` when proof and required teardown are verified, `FAIL` when a required check or teardown fails, or `BLOCKED` when proof or required teardown cannot be completed safely. `PASS+NOTES` means all requirements passed with unrelated caveats. Give claim, build, method, commands, observations, and artifact paths. For bugs, show the repro failing before and passing after.
