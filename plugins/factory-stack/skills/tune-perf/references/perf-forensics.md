# Perf forensics

Diagnose from an artifact, not from source. The deliverable is a cited finding mapped to source.

## Live process

1. Capture the signal on the real surface: a CPU profile for a busy process, a heap snapshot for a leak, a trace for a visual stall. Typical tools are `node --cpu-prof`, `py-spy record`, `perf record`, Chrome DevTools traces through `agent-browser`, and `pidstat` or `top` for a first look.
2. Reduce it to the cause: the function on the hot path, the retainer chain from a leaked object to a GC root, the loop that fires without input. Send a large artifact to an `explorer` Task and keep only the reduced finding.
3. Prove the mechanism cheaply before believing it: add a log line or a timer around the suspect, or disable it, and watch the signal change.
4. Map it to source: file, symbol, and the line that allocates or schedules.

## Captured artifact

1. Identify the format (cpuprofile, `.json.gz` trace, heap snapshot, spindump) and load it with a matching parser.
2. Make it queryable before reading: dump samples, frames, or nodes into SQLite, one row each.
3. Query for the frames holding the most time and walk the call tree. For a leak, follow retainers to a root. For a spindump, find the thread stuck on CPU or blocked, and its wait reason.
4. Map the hot frame to file, symbol, and line. A frame with no symbols is not yet a diagnosis.
5. With a paired before and after capture, diff them to confirm. Without one, call the finding the strongest hypothesis the artifact supports.
