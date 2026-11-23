---
name: create-tla-model
description: "Create TLA+ models for new state machines, flows, or protocols. Use maintain-tla-model for drift and tla-check for unchanged models."
license: MIT
compatibility: droid
---

# Create TLA model

Model the code where checking every step ordering within bounds matters most. Record enough for the next agent to keep the model accurate.

## 1. Choose the target from the code

Use the user's target, otherwise the strongest code promise whose failure harms users and tests rarely reach. Candidates include retries, idempotency, locks, leases, multi-step flows with cancel or timeout, and handshakes.

TLA+ answers "can these events happen in a bad order?" If the question is "does this function behave for every input" (overflow, memory safety, a data-structure invariant), TLA+ is the wrong tool. Say so and recommend a verifier that runs on the code or property-based tests instead.

## 2. Write the model

Put it in the project, for example `specs/tla/<Area>/<Area>.tla` with `<Area>.cfg`. Then:

- **True to the code.** Each variable and action points to code a reviewer can open. One atomic step in the code is one action in the model. Names come from the repo.
- **Rules as invariants.** Write each promise as an `INVARIANT` in the config. If the model lacks a variable for a rule, add one. Never weaken a rule so it holds.
- **Named actions.** Write `Next` as a disjunction of named actions, so traces say which step happened.
- **Correct end states.** Add a stuttering `Done` action for states that legitimately stop, or TLC reports a deadlock.
- **Small bounds.** Keep constants small, or add a `CONSTRAINT`, so a run finishes in seconds.

## 3. Show it can fail

Run `tla-check`. Break the model as the code could break (remove a guard, split an atomic step), confirm `tla-check` catches it, and revert the break.

If the current model of the current code breaks a rule, that is a finding. Report it with the counterexample in the code's words. Do not change product code unless the user asks.

## 4. Record coverage

Write `COVERAGE.md` beside the model:

- each rule in one plain sentence, with the harm if it breaks
- the files and functions each action models
- the bounds and assumptions, and what the model leaves out
- the command that runs it
- the commit at which you confirmed the model matches the code

## Done when

The model and config are in the project, `tla-check` passed (or failed only on reported findings), the deliberate break was caught, and `COVERAGE.md` records the sync commit. The reply says what was modeled, the bounds, what the check found in plain words, how to rerun it, and what it does not cover.
