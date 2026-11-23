---
name: tune-perf
description: "Measure and fix a slowdown, regression, or metric target. Use vet-measurement to assess a number without changing the system."
license: MIT
compatibility: droid
---

# Tune perf

Measure every change rather than relying on source inspection. Keep or revert each change.

## 1. Fix the target

Pick a reproducing workload, one metric, improvement direction, and a stop predicate combining target and minimum attempts, such as "at least 30% faster than baseline and at least 5 attempts." Use the user's numbers.

## 2. Build and vet the harness

Write one repeatable command that prints the metric (median of N runs), an error count, and a count of work done. Confirm it separates the slow case from an easy case. Run `vet-measurement` on the baseline, then freeze the harness. Record the baseline and a green run of the tests that must keep passing.

## 3. Find the limiter

Profile a run you do not report. For live processes and captured traces, follow [references/perf-forensics.md](references/perf-forensics.md). Map the hot spot to source. Run `explain-how` on that code if it is unfamiliar.

## 4. Loop

Order hypotheses cheapest first:

1. Don't do it. Stop work whose result nothing uses.
2. Do it, but not again (cache or memoize).
3. Do it less.
4. Do it later.
5. Do it when the user is not waiting.
6. Do it concurrently.
7. Do it cheaper.

For each hypothesis, name the mechanism ("defer X off startup because it blocks first paint"), change one thing, and rerun the frozen harness and tests. Keep only gains beyond noise with green tests; otherwise revert fully. Commit each kept change separately with `git add <files>`. Log each attempt in `/tmp/<slug>-decisions.tsv` (hypothesis, change, before, after, verdict).

When several independent hypotheses are live, run them in parallel as `droid exec -m auto --auto medium --worktree perf-<n>` and measure each in its own worktree.

On a plateau, change category or combine near-misses before stopping. Correctness and simplicity outrank the number. For an unattended climb, start it with `/unattended-run`.

## 5. Stop

Stop when the predicate is met or the remaining ideas cost more than they would gain. Never relax the predicate to meet it. Run `vet-measurement` on the final number.

## Done when

The reply gives the metric and target, baseline to final with the percent change, attempts kept and reverted, each kept change in one line, the decision log path, the limiter at the end, and the next idea worth trying.
