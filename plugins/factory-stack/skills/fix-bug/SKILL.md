---
name: fix-bug
description: "Reproduce the bug, find the root cause, fix it there, and verify against the repro with prove-it-works. Use for any defect report; not for a direct fix in Normal mode when no repro-first loop is needed, and not for a performance regression (use tune-perf)."
license: MIT
compatibility: droid
---

# Fix bug

Every shipped line traces to runtime evidence. A change that "might help" is a hypothesis, not a fix, and it does not ship. When evidence refutes a hypothesis, revert what it motivated.

## Steps

1. **Reproduce it yourself** on the surface the user hit, with the project's verify skill, `agent-browser`, `tuistory`, or a script. Ask the user only when no tool here can reach the target, and say exactly why. If it will not reproduce, synthesize the trigger, tighten the conditions, or add logging until it fires. Save the repro command.
2. **Binary-search the cause.** List candidate hypotheses. Seed them with `explain-how` on the subsystem and `explain-why` for regression history (`git log -S`, `git bisect` when a known-good commit exists). Each pass, take the split that rules out the most, get runtime evidence, and eliminate. When state is unclear, instrument and read it as the code runs. Do not guess. Confirm the surviving mechanism with evidence before planning the fix. For a long hunt, use the `Loop` tool to wake and continue.
3. **Fix the root cause.** Fix the first place the system went wrong, not where the symptom surfaced (`engineering-principles`, fix-root-causes). Check for the same fault elsewhere. For a fix that crosses a function boundary, plan it in Spec mode. Delegate the edit to one `principled-worker` Task with exact file scope, or make it yourself. Review the diff.
4. **Verify on the same surface.** Run `prove-it-works` with the saved repro. It must now pass. Inconclusive or wrong-surface is not a pass.
5. **Order the commits.** When the bug has a cheap local test, follow `test-first` so the failing test lands before the fix.

## When validation fails

If the repro still fails, the mechanism was wrong. Revert the fix, return to step 2, and test the premise every failed fix shared (`engineering-principles`, attack-the-premise) before writing another.

## Done when

The reply states what was broken, the root cause with its evidence, the fix, and the repro output failing before and passing after, pasted verbatim.
