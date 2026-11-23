---
name: check-blast-radius
description: "Find and reproduce breakage outside the diff. Use adversarial-review for failures in the changed code."
license: MIT
compatibility: droid
---

# Check blast radius

Find breakage a caller search misses. Identify the one or two facts the change's safety depends on and prove them by running code.

## Evidence ladder

Take each safety fact as far down this list as is cheap. Report where it stopped.

1. You said so. Worthless alone.
2. You pointed at the line: a real `file:line`, or the dependency's own source.
3. You walked the failure step by step and showed it cannot happen.
4. You ran it: a script or test that calls the real code and fails loudly if you are wrong.
5. You reproduced it in the running app.

## Steps

1. **Read the change.** The diff, the symbols it adds, changes, and deletes, and what it now does differently, including what the diff does not spell out.
2. **Find the safety fact.** For example, "this call only drops cache entries that are already dead." Prove the fact that clears the most risks.
3. **Look where search stops.** Issue `explorer` Tasks in one message, one per outside surface. Typical surfaces are the pinned version and local patches of a dependency you call, timing (teardown, async ordering, retries), serialized data (API responses, DB columns, wire formats, another language reading the same bytes), feature flags, and code several hops downstream.
4. **Grade each risk.** Give it a real likelihood and a real cost. Keep the confirmed risks. List the checked-and-cleared ones separately. Cite a real `file:line`. A search that finds nothing is an answer. Never invent a caller or an API.
5. **Prove it.** Write a script or test that runs the real code against the safety fact or the worst risk, run it, and paste the output. Put a throwaway probe under `/tmp/`. Add a test to the repo only when it is worth keeping as a regression test, and say so.

For a large or wide change, run `adversarial-review` on the diff too.

## Done when

The reply has these parts:

- **What it does.** Including the part that is not obvious.
- **Safety fact.** Stated, with the ladder step it reached and the proof, or marked unproven.
- **Risks.** Each with how it breaks, `file:line`, likelihood, cost, and how to check. Paste proof for the ones that matter.
- **Cleared.** What you checked and why it is fine.
- **Before merge.** The cheapest test or repro that would catch the real bug.

If the search of callers, tests, dependents, and outside surfaces finds no failure, say that and list what was searched.
