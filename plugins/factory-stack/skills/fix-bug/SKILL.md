---
name: fix-bug
description: "Reproduce a defect, fix its root cause, and verify the repro with prove-it-works. Use for defect reports; use Normal mode for direct fixes needing no repro-first loop, or tune-perf for performance regressions."
license: MIT
compatibility: droid
---

# Fix bug

Ship only changes supported by runtime evidence. Revert changes when evidence refutes their hypothesis.

## Steps

1. **Reproduce it yourself** on the surface the user hit, with the project's verify skill, `agent-browser`, `tuistory`, or a script. Ask the user only when no tool here can reach the target, and say exactly why. If it will not reproduce, synthesize the trigger, tighten the conditions, or add logging until it fires. Save the repro command.
2. **Binary-search the cause.** List candidate hypotheses. Seed them with `explain-how` on the subsystem and `explain-why` for regression history (`git log -S`, `git bisect` when a known-good commit exists). Each pass, take the split that rules out the most, get runtime evidence, and eliminate. When state is unclear, instrument and read it as the code runs. Do not guess. Confirm the surviving mechanism with evidence before planning the fix. For a long hunt, use the `Loop` tool to wake and continue.
3. **Fix the root cause.** Fix the first place the system went wrong, not where the symptom surfaced (`engineering-principles`, fix-root-causes). Check for the same fault elsewhere. For a fix that crosses a function boundary, plan it in Spec mode. Delegate the edit to one `principled-worker` Task with exact file scope, or make it yourself. Review the diff.
4. **Verify on the same surface.** Run `prove-it-works` with the saved repro. Require a pass, not an inconclusive or wrong-surface result.
5. **Order the commits.** When the bug has a cheap local test, follow `test-first` so the failing test lands before the fix.

## When validation fails

If the repro fails, revert the fix and return to step 2. Test the premise shared by failed fixes (`engineering-principles`, attack-the-premise) before another.

## Done when

The reply states what was broken, the root cause with its evidence, the fix, and the repro output failing before and passing after, pasted verbatim.
