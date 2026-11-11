---
name: test-first
description: "Write a failing test that pins the behavior, make it pass, then refactor. Use when the user asks for TDD or a regression test, or when a bug has an obvious reproduction; not for skill or prompt eval loops (use eval-runs or eval-hillclimb)."
license: MIT
compatibility: droid
---

# Test first

Make the intended behavior executable before changing production code. The test fails before the change and passes after it.

## Steps

1. **Pin the behavior.** State the intended behavior, the current behavior, and the smallest observable case.
2. **Pick the narrowest test.** Use the closest unit, component, or integration test the codebase already has for that path. Do not build a new harness just to satisfy this skill.
3. **Write the test.** Drive the code through the interface its users touch. Derive the expected value from the requirement, not from a run of the code. See `engineering-principles` (test-behavior-not-implementation).
4. **Watch it fail.** Run it. It must fail for the intended reason. If it passes, or fails for another reason, fix the test first.
5. **Make it pass.** Write the smallest production change that satisfies the test.
6. **Rerun.** The new test passes, and the nearby tests still pass.
7. **Refactor.** Clean up with the tests green. Rerun after each step.
8. **Order the commits.** The failing test lands before the fix, so a reviewer can watch it go red, then green.

## When a test is impractical

If the only test would need broad harness setup, brittle mocks, production-only state, or large fixture churn, use the closest executable check instead: a script, a repro command, or an app drive through `prove-it-works`. No new test beats a bad test.

## Guardrails

- Never change a test to match a wrong implementation.
- Never weaken an existing assertion unless the expected behavior changed, and say why.
- Keep the test on this behavior. No unrelated coverage.
- For a flaky bug, make the test deterministic and name the signal it locks down.

## Done when

The reply names the test, pastes its failing output from before the change and its passing output after, lists the nearby checks you ran, and confirms the production change is limited to what the test required. If no failing test was practical, it says why and shows the check used instead.
