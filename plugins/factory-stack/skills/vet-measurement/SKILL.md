---
name: vet-measurement
description: "Vet a decision-driving measurement's limiter, tuning, limits, errors, repeatability, and relevance, including within tune-perf. Use before trusting, reporting, or acting; use eval-runs or eval-hillclimb for skill or prompt evals, or tune-perf to change performance."
license: MIT
compatibility: droid
---

# Vet measurement

Answer every question in [references/benchmark-checklist.md](references/benchmark-checklist.md) with run evidence, not source-based guesses.

## Steps

1. **Write the claim first,** in the words you would ship: "export is 30% faster at p50 on the 60k-row dataset." The checklist tests that sentence.
2. **Read the measurement script.** Note what it times, counts, and ignores.
3. **Check the machine.** `uptime` and `nproc`. If the machine is busy and you cannot stop the load, interleave the sides so both see the same noise, and say so.
4. **Answer the seven questions** in the checklist. Add an error count or a work count to the script if it lacks one.
5. **Give the verdict:** faster, slower, no measurable difference, or inconclusive.

A requested ballpark needs one run and questions 4 and 7. Report the single run. Choosing between options is never a ballpark.

## Done when

The reply leads with the verdict, then the number with its unit, the run count, the range, and the limiter, for example "p50 41 ms to 33 ms, median of 7 runs per side, range 32 to 35 ms after, bound by JSON parsing on one core." Each of the seven questions is answered or explicitly waived with a reason. The verdict is inconclusive when the limiter is unknown, a side ran untuned, or questions 4 and 7 could not be checked, and the gap is named.
