# Guard the context window

Apply when context is filling up: large outputs, long files, repeated reads, fan-out planning. Route bulk to subagents; keep summaries in the main thread, not raw payloads.

**Why:** Context overflow degrades reasoning quality, creates compression artifacts, and halts progress.

**Pattern:**
- **Send bulk reads to subagents.** An `explorer` Task reads the large file, log, or trace and returns the reduced finding. Keep the finding in the main session, not the payload.
- **Point, do not paste.** Give a subagent file paths and line ranges, not copied content.
- **Keep tool output small.** Filter with `rg`, `jq`, or `head` before reading. Rerun only what failed.
- **Size phases and cap scope.** Limit files per phase, set turn budgets, account for mechanism costs.
