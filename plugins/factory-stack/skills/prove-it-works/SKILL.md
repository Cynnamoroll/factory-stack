---
name: prove-it-works
description: "Verify fixes, features, and refactors in the running system using verify-<app>, otherwise agent-browser or tuistory, plus tests. Use before finishing; use /review or adversarial-review for diffs, or simplify for reuse, quality, and efficiency."
license: MIT
compatibility: droid
---

# Prove it works

Check the real artifact directly. Compilation, self-reports, proxies, and unit tests alone do not prove the user-facing result.

## 1. Name the claim

State one user-checkable claim, such as "saving a note with a 500-character title keeps the full title after reload." For bugs, use the original repro.

## 2. Pick the surface

Drive the change on the surface a user touches:

- the project's verify skill, if `.factory/skills/verify-*/` exists. Follow its Launch, Doctor, Drive, Evidence, and Cleanup sections.
- otherwise Droid's built-in `agent-browser` skill for web and Electron apps, `tuistory` for terminal apps, or `curl` for HTTP services
- for a library, a small script that imports the built package and calls the changed API the way a consumer would

Wrong surface or "inconclusive" is not a pass. Say which it was.

## 3. Run it

1. Run the project's tests that cover the change (from `AGENTS.md` or the package scripts). Rerun only what failed plus what the fix touched.
2. Drive the claim on the chosen surface. Capture the action and the resulting state: a screenshot, a terminal transcript, a response body, a row read back.
3. Check side effects as well as what is visible: files written, rows stored, messages sent.
4. When a check fails, suspect the observation method first, then the system.

Prefer a script that reruns the same comparison over a one-time look. Keep it under `/tmp/` unless it is worth committing as a regression test.

## 4. When it fails

Fix the cause and rerun step 3 without weakening assertions or skipping steps. If credentials, production-only state, or hardware block the run, name the blocker and the closest check's result.

## Done when

The reply states the claim, the surface used, the commands run, and the evidence (pasted output or artifact paths). A bug fix shows the repro failing before and passing after. Otherwise the reply says why the change could not be exercised and what was checked instead.
