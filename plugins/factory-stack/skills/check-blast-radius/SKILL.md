---
name: check-blast-radius
description: "Find what a change could break outside the changed lines and prove the one failure with a repro or test. Use when the question is fallout beyond the diff; not for a multi-angle attack on the diff itself (use adversarial-review) or a routine review pass (use /review)."
license: MIT
compatibility: droid
---

# Check blast radius

Find what a change breaks somewhere else before it ships. Listing callers is not the job, because `rg` does that in a second. The job is the breakage a symbol search will not show.

A writeup that sounds right is worthless, because it reads as convincing whether or not it is true. Find the one or two facts the change's safety rests on and prove them by running code.

## Evidence ladder

Take each load-bearing fact as far down this list as is cheap, and say where it stopped.

1. You said so. Worthless alone.
2. You pointed at the line: a real `file:line`, or the dependency's own source.
3. You walked the failure step by step and showed it cannot happen.
4. You ran it: a script or test that calls the real code and fails loudly if you are wrong.
5. You reproduced it in the running app.

## Steps

1. **Read the change.** The diff, the symbols it adds, changes, and deletes, and what it now does differently, including what the diff does not spell out.
2. **Find the safety fact.** Most risky-looking changes are safe because of one fact, such as "this call only drops cache entries that are already dead." If it holds, most risks clear at once. Spend your time here.
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
