---
name: add-guardrail
description: "Turn a repeated mistake into a blocking guardrail: a type, a lint or CI check, a hook, or a permission rule, with AGENTS.md last. Use after the same correction comes up twice, or to mine a past session with droid search; not for merely opening /hooks or editing permissionRules by hand."
license: MIT
compatibility: droid
disable-model-invocation: true
---

# Add guardrail

Change the repo so the next agent cannot make the same mistake. Assume every contributor sees only the files it opened, copies the nearest example, and takes the shortest path that compiles.

## 1. Find the mistake classes

Gather the corrections from one of these sources:

- this session
- past sessions: `droid search "<phrase>" --kind message_text --json`, then read the matching turns
- recent commits, reverts, review comments, and `AGENTS.md`

Group them into classes. A class counts once it has happened twice. Show the evidence for each.

## 2. Pick the highest rung that works

1. **Architecture.** One owner per piece of state and one supported way per task. Hide internals so the wrong import fails. Replace hand-synced lists with one source. Delete the old way an agent would copy.
2. **Types, lint, or CI.** Make the bad state fail to compile. If it still compiles, add a lint rule or CI check whose error names the right file, type, or function. If the pattern is already common, fail only when a change adds more.
3. **Hook or permission rule.** For agent actions code cannot catch:
   - a `PreToolUse` hook in `.factory/hooks.json` that exits `2` with the reason on stderr, matched on `Execute`, `Edit`, `Create`, or `ApplyPatch`, with the script under `.factory/hooks/` and called through `"$FACTORY_PROJECT_DIR"`
   - a `permissionRules` entry in `.factory/settings.json` with `block` or `ask` and `tests.match` / `tests.noMatch` cases, for shell commands only
4. **`AGENTS.md`, last.** Only for judgment calls nothing can check. A personal habit goes in `~/.factory/AGENTS.md`. A repo rule goes in the project `AGENTS.md`.

Pick the highest rung that catches the class. Say why each higher rung did not work.

Changes to a skill go through `/create-skill`, not a hand edit here.

## 3. Prove each guardrail fails

Show each new check failing on a real past instance of the mistake, then passing on the corrected code:

- type, lint, or CI: run the same command locally that CI runs
- hook: pipe a sample payload into the script and check the exit code, for example `echo '{"tool_name":"Edit","tool_input":{"file_path":"gen/x.ts"}}' | .factory/hooks/protect.sh; echo $?`
- permission rule: `droid rules check --command '<bad command>'` reports the decision, and `droid rules check` passes its self-tests

If a check does not fail on the real mistake, fix the check, not the example. Hooks load at session start, so tell the user to review the new hook in `/hooks` and start a new session.

## 4. Record it

Keep a table in `AGENTS.md` that pairs each rule with what enforces it. Drop a rule once its mistake cannot happen.

## Done when

Each class has its evidence, the rung chosen, why higher rungs failed, and a pasted run showing the guardrail fail then pass. One commit per class.
