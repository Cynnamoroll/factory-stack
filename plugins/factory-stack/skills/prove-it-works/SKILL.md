---
name: prove-it-works
description: "Verify a change in the running system before calling the work done, using the project's verify-<app> skill if one exists, otherwise agent-browser or tuistory, plus tests. Use before finishing a bug fix, feature, or refactor; not for a diff review (use /review or adversarial-review) or a reuse, quality, and efficiency sweep (use simplify)."
license: MIT
compatibility: droid
---

# Prove it works

The gate before "done". Check the real thing directly, not a proxy, a self-report, or "it compiles". Unit tests show branch behavior, not that the user-facing problem is gone.

## 1. Name the claim

Write one sentence a user could check, such as "saving a note with a 500-character title keeps the full title after reload." For a bug fix, the claim is that the original repro now behaves correctly.

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

Fix the cause, not the check. Rerun from step 3. Never weaken an assertion or skip a step to get a pass. If the change cannot be exercised here (missing credentials, production-only state, hardware), say exactly what blocks it and what the closest check showed.

## Done when

The reply states the claim, the surface used, the commands run, and the evidence (pasted output or artifact paths). A bug fix shows the repro failing before and passing after. Otherwise the reply says why the change could not be exercised and what was checked instead.
