---
name: vet-measurement
description: "Vet a measurement or benchmark before you trust, report, or act on it: the limiter, tuning, limits, errors, repeatability, and relevance. Use when a number will drive a decision, including from tune-perf; not for skill or prompt eval loops (use eval-runs or eval-hillclimb) and not to apply the perf change itself (use tune-perf)."
license: MIT
compatibility: droid
---

# Vet measurement

A number that drives a decision needs evidence that it measured the work you think it did. Answer each question in [references/benchmark-checklist.md](references/benchmark-checklist.md) with evidence from a run, not a guess from reading code.

## Steps

1. **Write the claim first,** in the words you would ship: "export is 30% faster at p50 on the 60k-row dataset." The checklist tests that sentence.
2. **Read the measurement script.** Note what it times, counts, and ignores.
3. **Check the machine.** `uptime` and `nproc`. If the machine is busy and you cannot stop the load, interleave the sides so both see the same noise, and say so.
4. **Answer the seven questions** in the checklist. Add an error count or a work count to the script if it lacks one.
5. **Give the verdict:** faster, slower, no measurable difference, or inconclusive.

A quick ballpark the user asked for needs one run, plus questions 4 and 7, and the report says it is one run. A choice between options is never a ballpark.

## Done when

The reply leads with the verdict, then the number with its unit, the run count, the range, and the limiter, for example "p50 41 ms to 33 ms, median of 7 runs per side, range 32 to 35 ms after, bound by JSON parsing on one core." Each of the seven questions is answered or explicitly waived with a reason. The verdict is inconclusive when the limiter is unknown, a side ran untuned, or questions 4 and 7 could not be checked, and the gap is named.
