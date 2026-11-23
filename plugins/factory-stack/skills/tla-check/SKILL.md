---
name: tla-check
description: "Run TLC on existing models, render states, and report violations. Use create-tla-model or maintain-tla-model to edit models."
license: MIT
compatibility: droid
---

# TLA check

Check an existing model, show state transitions, and describe broken rules in the code's words.

## Run

```sh
"${DROID_PLUGIN_ROOT}/skills/tla-check/scripts/tla-check.sh" path/to/Model.tla [path/to/Model.cfg] [/tmp/tla-out]
```

The script needs Java 11 or later and Python 3. On first run it downloads a pinned `tla2tools.jar` to `~/.cache/factory-stack/` (set `TLA2TOOLS_JAR` to use your own). It runs SANY, then TLC with one worker, and writes `sany.out`, `tlc.out`, `states.dot`, `chart.mmd`, and `summary.txt` to the output directory, outside the repo by default. Exit code 0 is a pass, 1 is a violation or deadlock, and 2 is a parse or checker error.

`chart.mmd` requires at most 200 distinct states (`TLA_CHART_LIMIT` changes it). For larger models, shrink constants or add a `CONSTRAINT` to view the graph. The check still covers every state.

## Read the result

- **parse-error.** Read `sany.out`, fix the syntax, and rerun. That fix is an edit to the model, so say so.
- **pass.** Show `chart.mmd` as a `mermaid` block. A pass covers the model under its constants and bounds, not the whole system.
- **violation.** `tlc.out` holds TLC's shortest counterexample trace. Retell it as numbered steps in the words of the code, one line per action, and name the rule it breaks.
- **deadlock.** A state with no step out. If it is a correct end state, the model needs a stuttering `Done` action in `Next`. Report it either way.
- **error.** TLC stopped for another reason (an unbounded model, a bad config). Quote the error from `tlc.out`.

## Replay against the code

Replay each counterexample against real code as a test or live repro, one step per action. An impossible step is a modeling error; if every step can happen, report a bug.

## Done when

The reply gives the result line from `summary.txt`, the distinct state count, the chart or the reason there is none, each violation as numbered steps with the rule and its harm in one sentence, whether each was replayed against the code, and the command that reproduces the run. No model file changed unless a parse error forced it.
