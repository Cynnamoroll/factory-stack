---
name: tla-check
description: "Check existing TLA+ models with TLC, render the state diagram, and report violations. Use to verify a model or when asked to run the checker; not to author or revise models (use create-tla-model or maintain-tla-model), and not for skill or prompt eval (use eval-runs or eval-hillclimb)."
license: MIT
compatibility: droid
---

# TLA check

Run the checker on a model that already exists, show how the system moves between states, and report each broken rule in the code's own words.

## Run

```sh
"${DROID_PLUGIN_ROOT}/skills/tla-check/scripts/tla-check.sh" path/to/Model.tla [path/to/Model.cfg] [/tmp/tla-out]
```

The script needs Java 11 or later and Python 3. On first run it downloads a pinned `tla2tools.jar` to `~/.cache/factory-stack/` (set `TLA2TOOLS_JAR` to use your own). It runs SANY, then TLC with one worker, and writes `sany.out`, `tlc.out`, `states.dot`, `chart.mmd`, and `summary.txt` to the output directory, outside the repo by default. Exit code 0 is a pass, 1 is a violation or deadlock, and 2 is a parse or checker error.

`chart.mmd` is written only when TLC finds at most 200 distinct states (`TLA_CHART_LIMIT` changes it). For a larger model, shrink the constants or add a `CONSTRAINT` to see the graph. The check itself still covers every state.

## Read the result

- **parse-error.** Read `sany.out`, fix the syntax, and rerun. That fix is an edit to the model, so say so.
- **pass.** Show `chart.mmd` as a `mermaid` block. A pass covers the model under its constants and bounds, not the whole system.
- **violation.** `tlc.out` holds TLC's shortest counterexample trace. Retell it as numbered steps in the words of the code, one line per action, and name the rule it breaks.
- **deadlock.** A state with no step out. If it is a correct end state, the model needs a stuttering `Done` action in `Next`. Report it either way.
- **error.** TLC stopped for another reason (an unbounded model, a bad config). Quote the error from `tlc.out`.

## Replay against the code

When the model describes real code, replay each counterexample against it, as a test or a live repro, one step per action. If a step cannot happen in the code, the model is wrong, so report a modeling error, not a bug. If every step can happen, it is a bug.

## Done when

The reply gives the result line from `summary.txt`, the distinct state count, the chart or the reason there is none, each violation as numbered steps with the rule and its harm in one sentence, whether each was replayed against the code, and the command that reproduces the run. No model file changed unless a parse error forced it.
