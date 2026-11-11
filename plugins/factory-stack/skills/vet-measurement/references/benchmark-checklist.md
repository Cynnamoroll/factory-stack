# Benchmark checklist

Answer each with evidence from a run.

1. **Why not double?** Name the limiter. Profile in a run you do not report, because profilers slow the work. Use CPU per process (`top`, `pidstat`), a runtime profiler (`node --cpu-prof`, `py-spy`, `perf`), I/O wait, and syscall counts (`strace -c`), then map the hot spot to source. Watch the load generator too. If it saturates first, you measured the load generator. If a change did not move the number, the limiter explains why.
2. **Was it tuned?** Run every side the way production runs it: release builds, production flags, batching and transaction settings, pools, caches as warm or cold as production sees them, same versions and data. A side on defaults means you compared configurations. Tune it and measure again before picking a winner.
3. **Did it break limits?** Do the arithmetic. Compare bytes per second with disk and network bandwidth, and operations per second times cost per operation with your cores. Removing a piece that takes 10% of the run can make it at most about 11% faster. A result past a limit measured a cache, a no-op, or a bug.
4. **Did it error?** Count failures and non-success responses, and check that outputs are correct, not just present. Rejections are fast. Timeouts and retries are slow.
5. **Does it reproduce?** Run each side at least 5 times, alternating A, B, A, B, so warmup and drift favor neither. Report the median and the range. A gap smaller than run-to-run spread is no measurable difference. For a close call, use a rank-sum test or the harness's statistics.
6. **Does it matter?** Next to a micro result, measure the end-to-end path a user waits on with realistic data and concurrency. Report the micro result as a share of the whole.
7. **Did it happen?** Confirm the work ran inside the timed region: the request reached the server, the rows were written, the result was used. Lazy code (unconsumed generators, unawaited promises, results a JIT can drop) and timeouts produce numbers for work that never happened.

Keep a PR body to one primary number. Put runs, range, and limiter evidence in a linked notes file.
