---
name: test-first
description: "Write a failing behavior test, make it pass, then refactor. Use for TDD, regression tests, or bugs with obvious repros; use eval-runs or eval-hillclimb for skill or prompt evals."
license: MIT
compatibility: droid
---

# Test first

Before changing production code, make the intended behavior executable. Require failure before and success after.

## Steps

1. **Pin the behavior.** State the intended behavior, the current behavior, and the smallest observable case.
2. **Pick the narrowest test.** Use the closest existing unit, component, or integration test for the path, without building a new harness just for this skill.
3. **Write the test.** Drive the code through the interface its users touch. Derive the expected value from the requirement, not from a run of the code. See `engineering-principles` (test-behavior-not-implementation).
4. **Watch it fail.** Run it. It must fail for the intended reason. If it passes, or fails for another reason, fix the test first.
5. **Make it pass.** Write the smallest production change that satisfies the test.
6. **Rerun.** The new test passes, and the nearby tests still pass.
7. **Refactor.** Clean up with the tests green. Rerun after each step.
8. **Order the commits.** The failing test lands before the fix, so a reviewer can watch it go red, then green.

## When a test is impractical

If the only test needs broad harness setup, brittle mocks, production-only state, or large fixture churn, use a script, repro command, or app drive through `prove-it-works` instead.

## Guardrails

- Never change a test to match a wrong implementation.
- Never weaken an existing assertion unless the expected behavior changed, and say why.
- Keep the test on this behavior. No unrelated coverage.
- For a flaky bug, make the test deterministic and name the signal it locks down.

## Done when

The reply names the test, pastes its failing output from before the change and its passing output after, lists the nearby checks you ran, and confirms the production change is limited to what the test required. If no failing test was practical, it says why and shows the check used instead.
