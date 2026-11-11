# Factory Droid harness: research notes

Scope: primary sources only (docs.factory.com, Factory changelog, github.com/Factory-AI, factory.ai/news, and the `droid` CLI v1.8.0 binary installed on the box).
Accessed: 2026-11-10 (America/Vancouver). `docs.factory.ai` 308-redirects to `docs.factory.com`; every docs page has a raw `.md` twin, listed in `https://docs.factory.com/llms.txt`.
Raw copies of every page and the CLI output used here are in `research/raw/`. Key files: `cli-help.txt`, `list-tools.txt`, `tool-descriptions.txt`.

Legend: **[D]** = docs page, **[CLI]** = observed from the `droid` v1.8.0 binary on the box, **[GH]** = Factory-AI GitHub repo, **[CL]** = changelog, **[B]** = blog. **UNVERIFIED** = I could not confirm it from a primary source, or the sources disagree.

CLI capture notes: the box has no `FACTORY_API_KEY` and no login. `droid --help`, every subcommand's `--help`, and `droid exec --list-tools` all ran without auth. I did not run any prompt, because that needs auth.

---

## 1. What Droid is: agent loop, context, compaction

- Droid is "Factory's AI coding agent in your terminal" [CLI `droid --help`]. The same runtime backs the CLI, `droid exec`, the Factory App, Missions and Automations [D droid-cli/overview].
- Factory's own definition: "Droid is our agent harness. An agent harness is everything around the model: the prompts, the tools, how tool results come back, and the loop that runs it all." [B frontier-harness, 2026-10-29]
- **The loop.** Droid 1.0 made programmatic tool calling (PTC) the default. In PTC the model writes JavaScript for the **`Script`** tool, and that program calls other tools: "runs in a sandbox with no file, network, or system access of its own"; "Calls that don't depend on each other run concurrently"; "Printed output is capped in size, and the full results are logged where the model can search them later." [B frontier-harness]. The tool's own description adds: up to 128 nested calls in flight, inputs under 1 MiB in total, and nested calls made through `tools.<Name>(...)` [CLI tool-descriptions.txt]. `WaitForScript` waits for, reads, or stops a running Script [CLI].
- **Background work.** "When the model starts work that will take a while, such as a subagent or a long-running command, it can move that work to the background and sleep. Droid wakes it with a reminder when the work finishes." [B frontier-harness]. `Execute` has `fireAndForget=true` for long-running processes [CLI tool-descriptions.txt].
- **Deferred tools.** The `ToolSearch` tool loads schemas for deferred tools. A system reminder lists the deferred tools; a query is `select:<name>` or keywords [CLI].
- **Execute semantics.** Every call runs in a new shell in the session cwd; `cd` and env vars do not persist between calls; output shares a 32 KiB result budget and keeps head and tail [CLI tool-descriptions.txt].
- **Context loading.** AGENTS.md is loaded at startup and rediscovered as files are touched (see §2). Skills load by progressive disclosure: only name and description until invoked (§3). Subagents run in fresh context windows (§4).
- **Compaction.**
  - Settings: `compactionTokenLimit` (model-dependent; "250,000 by default" per [D model-independence/byok]), `compactionTokenLimitPerModel` (`{modelId: number}`), `compactionModel` (`same` or a model ID) [D droid-cli/settings#context-and-compaction].
  - Manual: `/compress [prompt]` ("Compress session and move to new one with summary") [D droid-cli/cli-reference#slash-commands]. `/context` shows context usage.
  - Hooks: `PreCompact` (trigger `manual|auto`) and `SessionStart` with `source: "compact"` [D harness/hooks].
  - "compaction summaries now have room for 16,000 tokens, up from 8,000" [B frontier-harness].
  - The open plan and the approved spec survive compaction [CL v0.228.0, v1.7.0].
  - SDK: `session.compact()` returns a successor session [D sdk/typescript].
- The first request (system prompt, tools, startup context) shrank from 20,887 to 13,055 input tokens between v0.170.0 and v0.250.0 [B frontier-harness].
- Parallel sessions and subagents share one daemon process (about 20 MB each, down from about 350 MB) [B frontier-harness].

## 2. AGENTS.md

Source: [D harness/agents-md] https://docs.factory.com/harness/agents-md

- **Filenames:** `AGENTS.md` (recommended), `agents.md`, `Agents.md`, `CLAUDE.md`, `Claude.md`. A separate `DESIGN.md`/`Design.md`/`design.md` is "loaded separately as design guidelines".
- **Discovery:** "When a git root is present, Droid searches from the current working directory up to the git root. At each level, it checks the directory itself and these context directories: `.factory/`, `.agents/`, `.agent/`." Personal: `~/.factory/`, `~/.agents/`, `~/.agent/`.
- **Dynamic discovery:** "Reading, editing, listing, or searching files in a directory triggers discovery; shell commands run through `Execute` do not." Editing `apps/web/src/page.tsx` loads `apps/web/AGENTS.md`. This also works across repositories.
- **Precedence** (a "mental model", not a strict merge algorithm): the current user request wins over standing instructions; nested files refine root files; project files override personal ones; personal files hold preferences only.
- **Budget:** 80,000 characters for the initial guideline load; 40,000 characters per tool call for dynamic discovery.
- **Format:** free Markdown, no frontmatter. Doc example:

```markdown
# Repository guide

## Commands

- Install dependencies: `pnpm install`
- Run unit tests: `pnpm test`
- Run type checks: `pnpm typecheck`

## Verification

Before calling work finished, run:

1. `pnpm test`
2. `pnpm typecheck`
3. `pnpm lint`

If a command fails, fix the issue and rerun it.
```

- The doc's nested template opens with: "This file applies when working inside this directory tree. Follow the root `AGENTS.md` unless this file gives a more specific rule."
- Missions workers follow AGENTS.md [D missions/reference].
- Real example: `Factory-AI/droid-action` ships a root `AGENTS.md` [GH].

## 3. Skills

Source: [D harness/skills] https://docs.factory.com/harness/skills

- **Layout:** a directory with a required `SKILL.md` (the name must be exactly `SKILL.md`; "Do not use `skill.mdx`"). Supporting files sit beside it and are **not auto-loaded**: "Mention them from `SKILL.md` so Droid knows when to read or run them."

```text
.factory/skills/review-api-change/
  SKILL.md
  checklists.md
  schemas/ship-check.schema.json
  scripts/verify-api-change.sh
```

- **Locations:**

| Scope | Path |
|---|---|
| Project | `<repo>/.factory/skills/<name>/SKILL.md` |
| Folder-specific | `<repo>/<area>/.factory/skills/<name>/SKILL.md` (found after Droid inspects that area) |
| Personal | `~/.factory/skills/<name>/SKILL.md` |
| Compat (repo) | `<repo>/.agents/skills/**/SKILL.md`, `<repo>/.agent/skills/**/SKILL.md` |
| Compat (personal) | `~/.agents/skills/**`, `~/.agent/skills/**` |
| Mission | `{missionDir}/skills/**/SKILL.md` |
| Automation | `~/.factory/automations/<automation>/skills/<name>/SKILL.md` |
| Plugin | `skills/<name>/SKILL.md` in the plugin; `${DROID_PLUGIN_ROOT}` expands inside SKILL.md |
| Built-in | ships with Droid (turn off with `--disable-builtin-skills`) |

- "Droid searches skill folders recursively. The first directory that contains `SKILL.md` is treated as a skill directory."
- **Precedence** for the same sanitized name: org plugin skills > (mission skills in missions / automation skills in automations) > folder and project > project plugin > personal > user plugin > built-in. A duplicate name within one source: one copy is ignored and `/diagnostics` reports it.
- **Frontmatter** (copied from the docs):

```yaml
---
name: my-skill
description: What this skill does and when to use it. Use when the user asks to ...
allowed-tools:
  - Read
  - Grep
  - Glob
enabled: true
user-invocable: true
disable-model-invocation: false
license: MIT
compatibility: droid
version: 1.0.0
metadata:
  owner: platform-team
---
```

| Field | Req | Default | Notes |
|---|---|---|---|
| `name` | yes | none | "lowercase letters, numbers, and hyphens" |
| `description` | yes | none | the routing surface; say what it does and when to use it |
| `allowed-tools` | no | none | **metadata only**: "does not add tools or sandbox standard skill invocation" |
| `enabled` | no | `true` | `false` disables the skill but keeps it on disk |
| `user-invocable` | no | `true` | `false` hides it from `/skill-name` |
| `disable-model-invocation` | no | `false` | `true` means only the user can invoke it |
| `license`, `compatibility`, `version`, `metadata` | no | none | free metadata |
| `tools` | legacy | none | deprecated; use `allowed-tools` |

- No length limits are documented for `name` or `description` (see Gaps).
- **Discovery and invocation:** (1) discover name and description, (2) the model matches the request against descriptions, (3) the full body loads on invocation. Droid invokes a skill through the **`Skill`** tool [CLI list-tools]. That tool is always given to custom droids [D harness/subagents].
- **Slash invocation: yes.** "A valid enabled skill with `user-invocable` enabled appears as `/skill-name`." It can appear anywhere in the prompt, several per prompt: `review this branch with /review-api-change, then /summarize-diff`. "Droid sends your prompt exactly as typed and attaches each named skill's instructions after it." A custom slash command with the same name takes the slash; the skill stays model-invocable.
- **Management:** `/skills` (tabs Effective/User/Project/Plugins/Built-in/Import from Claude); `/create-skill` forks into a Spec-mode session to draft a skill. Disable a skill without deleting it via `"disabledSkills": ["name"]` in user or project `settings.json` (unioned across levels).
- Real-world SKILL.md [GH Factory-AI/skills `template/SKILL.md`]:

```markdown
---
name: template-skill
description: Replace with description of the skill and when Droid should use it.
---

# Insert instructions below
```

## 4. Custom droids (subagents)

Source: [D harness/subagents] https://docs.factory.com/harness/subagents

- **Locations:** `<repo>/.factory/droids/*.md` (project) and `~/.factory/droids/*.md` (personal). Only the top level of each `droids/` folder is scanned. Project beats personal on a name clash. Plugins add droids from `droids/<name>.md`. Droids are enabled by default and can be toggled under `/settings` → Experimental.
- **Format:** YAML frontmatter, then the system prompt body (must not be empty).

```markdown
---
name: deep-analyzer
description: Thorough analysis with extended thinking
model: claude-opus-5-5
reasoningEffort: high
tools: ["Read", "Grep", "Glob", "WebSearch"]
---

Perform deep analysis of the code or problem presented.
```

| Field | Notes |
|---|---|
| `name` | required, `^[a-z0-9-_]+$`; becomes the `subagent_type` value and the filename |
| `description` | optional; a warning above 500 characters; shown in `/droids` and the available-subagents reminder |
| `model` | `inherit` (default) or a model ID; BYOK uses `custom:<model field>` |
| `reasoningEffort` | `low`/`medium`/`high`; ignored when `model: inherit` |
| `tools` | omit for all tools; a category string (`read-only`, `edit`, `execute`, `web`, `mcp`); or an array of case-sensitive IDs. `tools: all` is rejected |
| `mcpServers` | array of MCP server names; `[]` excludes all servers; omitting it inherits the parent's servers |

- **Tool rules:** `TodoWrite` and `Skill` are always included. `ExitSpecMode` and `GenerateDroid` are forbidden. The `edit` category = `Create`, `Edit`, `ApplyPatch` (ApplyPatch is added automatically for OpenAI models). The `web` category = `WebSearch`, `FetchUrl`.
- **Subagent limits:** subagents run non-interactively, without `AskUser` and without `Task` (**no nested subagents**).
- **Built-in droids:** `worker` (all tools, `medium` complexity) and `explorer` (read-only, `light`). Mission-only built-ins such as `scrutiny-feature-reviewer` and `user-testing-flow-validator` are written to `~/.factory/droids/`.
- **Invocation:** through the **Task** tool with parameters `subagent_type` (req), `description` (req), `prompt` (req), `image_paths`, `complexity` (`light|medium|heavy`), `run_in_background`, `resume` (a task_id). Companion tools: `TaskOutput` (`block` true/false, `timeout` default 30000 ms) and `TaskStop` (SIGTERM, then SIGKILL).
- **Parallelism:** "issue multiple Task tool calls in the same turn, or launch several with `run_in_background: true`" [D].
  - **Conflict:** the v1.8.0 Task tool description says "**Every Task runs in the background**: the call returns a task_id immediately and its completed report is delivered to you automatically … To run subagents in parallel, issue all of their Task calls in the same assistant message." [CLI tool-descriptions.txt]. The docs still describe foreground as the default. Treat the background-by-default behavior as the current runtime.
- **Model resolution:** (1) the droid's pinned `model`; (2) if `inherit` and the parent passed `complexity`, the `subagentModelSettings.{light,medium,heavy}Model` and `…ReasoningEffort`; (3) the parent's model; (4) a disallowed pinned model falls back to the parent's.
- **Autonomy:** `subagentAutonomyLevel` (`inherit` default, `off|low|medium|high`), clamped to the org `maxAutonomyLevel`. `tools: read-only` droids never run above Low. A parent in Spec Mode makes subagents read-only.
- Scaffolding: `/droids` wizard, the `GenerateDroid` tool, and "Import from Claude Code" (`.claude/agents/`).
- Real example [GH Factory-AI/droid-action `.factory/droids/security-reviewer.md`]:

```markdown
---
name: security-reviewer
description: Performs security-focused review of PR changes. Spawned as a parallel subagent alongside code review to identify security vulnerabilities.
model: inherit
tools: ["Read", "Grep", "Glob", "LS", "Skill"]
---

You are a senior security engineer performing a security-focused code review.
...
1. **Load security review methodology (REQUIRED)**: Before starting, invoke the `security-review` skill using the Skill tool. ...
```

  This is the pattern of a droid loading a skill as its first step. Note that it lists `Skill` explicitly even though the docs say it is always included.

## 5. Parallel and multi-workstream options

| Primitive | What it is | Source |
|---|---|---|
| Task subagents | in-session fan-out; parallel Task calls in one message; background, `TaskOutput`, `resume` | [D harness/subagents], [CLI] |
| Script tool | concurrent tool calls inside one model request (`Promise.allSettled`), max 128 in flight | [B], [CLI] |
| Spec mode | read-only planning, then `ExitSpecMode` proposes the plan for approval; `--use-spec`, `--spec-model` | [D autonomy-and-safety/specification-mode] |
| Missions | orchestrator plus worker and validator agents; `/missions`, `droid exec --mission` (needs `--auto high` or `--skip-permissions-unsafe`); `--worker-model`, `--validator-model`, etc.; settings `missionModelSettings.*`, `missionOrchestratorModel` | [D missions/*] |
| Workstreams (beta) | orchestrator plus agents on machines, a shared folder, PRs; started from the Factory App; Pro/Plus/Max/Teams only | [D workstreams/overview] |
| Worktrees | `-w/--worktree [name]` on `droid` and `droid exec`; exec removes clean worktrees on exit | [D droid-cli/cli-reference#git-worktrees] |
| Headless fan-out | shell `&` / `xargs -P` over `droid exec`, each with `--worktree` or `--cwd` | [D droid-exec/overview] |
| Loop tool | session-scoped cron prompts (`create/list/pause/resume/cancel`) | [CLI] |
| Cloud compute | Environments (snapshots), Droid Computers (persistent), Remote Control (`droid computer register`, `droid daemon --remote-control`); Sessions API `POST /api/v0/sessions` ("enabled for selected organizations only") | [D environments/overview], [D api-reference/sessions] |
| Automations | scheduled, webhook, Slack and chained runs; `CreateAutomation`/`RunAutomation` tools | [D automations/custom], [CLI] |

### `droid exec` (headless), verbatim from `droid exec --help` (v1.8.0)

```text
-o, --output-format <format>  Output format: text|json|stream-json|stream-jsonrpc|acp (default: "text")
--input-format <format>     Input format: stream-json for multi-turn sessions; stream-jsonrpc is controlled via JSON-RPC requests
-f, --file <path>           Read prompt from file
--auto <level>              Autonomy level: low|medium|high
--skip-permissions-unsafe   Skip ALL permission checks - allows all permissions (unsafe)
--disable-builtin-skills    Disable Factory-provided builtin skills (not supported in ACP modes)
-s, --session-id <id>       Existing session to continue (requires a prompt)
--fork <id>                 Fork an existing session into a new session (requires a prompt)
-m, --model <id>            Model ID to use (default: gpt-6.1-sol)
-r, --reasoning-effort <level>  Reasoning effort (defaults per model)
--spec-model <id> / --spec-reasoning-effort <level> / --use-spec
--only-tools <ids> / --add-tools <ids> / --remove-tools <ids>   (tool IDs or MCP:<server>[/<tool>])
--cwd <path> / --settings <path> / -w, --worktree [name]
--tag <spec> / --log-group-id <id>
--mission / --worker-model / --worker-reasoning-effort / --validator-model / --validator-reasoning-effort
--append-system-prompt <text> / --append-system-prompt-file <path>
--list-tools
```

- **Autonomy:** the default is read-only. `--auto low` = file edits; `medium` = installs, builds, local git; `high` = push, deploy, arbitrary code; `--skip-permissions-unsafe` cannot be combined with `--auto`. Permission rules with `block` still apply under `--skip-permissions-unsafe`, and an `ask` rule is not cleared by `--auto high` (the run fails fast) [D droid-exec/overview].
- **Fail-fast:** an action above the autonomy level makes the run exit non-zero, and earlier edits stay. Exit 0 means "Droid finished, not that the task succeeded".
- **Output:** `json` is one object `{type:"result", subtype, is_error, duration_ms, num_turns, result, session_id, usage{input_tokens, output_tokens, cache_*, factory_credits, ttft_ms}}`. `stream-json` events are `system`, `message`, `tool_call`, `tool_result`, `completion`. `stream-jsonrpc` exposes the methods `droid.initialize_session`, `droid.load_session`, `droid.add_user_message`, `droid.session_notification`, `droid.request_permission`, `droid.ask_user`. `acp` = Agent Client Protocol (in `--help`; not described in the docs).
- **Session continuation:** `-s <id>` continues in place ("does NOT replay old messages in output"); `--fork <id>` branches. Chain runs with `droid exec -s "$(jq -r .session_id <<<"$out")" "..."`.
- **Model aliases** [CLI]: `anthropic-latest-{premium,balanced,medium,fast}`, `openai-latest-{…}`, `oss-latest-{premium,balanced,fast}`, plus wildcards `claude-opus-*`, `gpt-*-sol`, `gpt-*-luna`, `glm-*`. All are resolved at session start.
- **Auth:** `FACTORY_API_KEY=fk-...` (keys from app.factory.ai/settings/api-keys).
- **Platform:** glibc only; Alpine is not supported.
- **SDKs:** `@factory/droid-sdk` (TS) and `droid-sdk` (Python) [D sdk/*; GH droid-sdk-typescript, droid-sdk-python].
- **CI:** the GitHub Actions matrix example in the docs installs with `curl -fsSL https://app.factory.ai/cli | sh` and adds `$HOME/.local/bin` to `$GITHUB_PATH`. The packaged action `Factory-AI/droid-action@main` takes `factory_api_key` (required), `github_token`, `automatic_review`, `review_depth` (`deep|shallow`), `review_model`, `reasoning_effort`, `include_suggestions` [D automations/code-review-ci; GH droid-action `action.yml`]. GitLab, Bitbucket and Azure DevOps templates are in the same repo.

```bash
droid exec --worktree codemod-a --auto medium "apply codemod A" & a=$!
droid exec --worktree codemod-b --auto medium "apply codemod B" & b=$!
wait "$a"; status_a=$?; wait "$b"; status_b=$?
```

## 6. In-chat features

- **Built-in slash commands** [D droid-cli/cli-reference#slash-commands]: `/account /archive /billing /btw /bug /clear /commands /compress /context /copy /cost /create-skill /cd /cwd /diagnostics /droids /missions /fast /favorite /fork /help /hooks /ide /install-code-review /install-slack-app /language /limits /login /logout /mcp /model /new /plugins /quit /readiness-fix /readiness-report /rename /review /rewind-conversation /sessions /settings /setup-incident-response /share /skills /stats /status /statusline /terminal-setup /themes /tree /vim`. `/side` was added in v1.6.0 [CL]. `/loop` is referenced by the Loop tool [CLI] but is not in the docs table (UNVERIFIED as a slash command).
- **Custom slash commands** [D harness/custom-slash-commands]: `<repo>/.factory/commands/` (wins) and `~/.factory/commands/`, recursive. A file registers if it is `*.md` or starts with `#!`. Names are slugged (`Code Review.md` → `/code-review`). The docs now say: "For new reusable workflows, prefer Skills".
  - Markdown frontmatter has only `description` and `argument-hint`. `$ARGUMENTS` expands to the whole argument string; **no `$1`/`$2`**. **No tool scoping.**
  - Executables get positional args; stdout and stderr (up to 64 KB) plus the script itself are posted to the chat.
  - Example [D]:

```markdown
---
description: Send a structured code review checklist
argument-hint: <branch-or-PR>
---

Review `$ARGUMENTS` and respond with:

1. Summary of what changed and why it matters.
2. Correctness checks: tests, edge cases, and regressions.
```

  - Real one: `Factory-AI/factory-plugins/plugins/droid-control/commands/verify.md` [GH] starts with `Load skills: **droid-control**.`. In other words, the command is a thin trigger that loads a skill.
- **Modes** [D autonomy-and-safety/specification-mode]: Normal, Spec, Mission. `Shift+Tab` toggles Normal and Spec; `--use-spec` starts in Spec. In Spec mode the agent may not edit and proposes its plan via `ExitSpecMode`. At approval the user chooses "Proceed" (manual approvals) or Low/Medium/High for implementation. Plans can be saved as Markdown (setting "Save spec as Markdown"; dir `.factory/docs`, or `specSaveDir`, see Gaps).
- **Autonomy** [D autonomy-and-safety/auto-run]: Off/Low/Medium/High; `Ctrl+L` cycles them. "Allow always" raises the level. Defaults go in `sessionDefaultSettings.{interactionMode: auto|spec, autonomyLevel, specModeModel, specModeReasoningEffort}`.
- **Model switching:** `/model` mid-session (applies between turns); `/fast`; the `model` and `reasoningEffort` settings; Spec mode can use its own model.
- **Approvals:** each tool risk level is compared with the autonomy level. `permissionRules` allow/ask/block take precedence over that. Sandbox prompts and the Droid Shield secret scan are separate (`enableDroidShield`).
- Other: `!` toggles bash mode; output styles (`outputStyle`, `.factory/output-styles/*.md`) do not apply to subagents [D plugins, droid-cli/output-styles].

## 7. Tooling

### Built-in tools (from `droid exec --list-tools`, v1.8.0) [CLI list-tools.txt]

- Read: `Read`, `LS`, `Glob`, `Grep`, `FetchUrl`, `WebSearch`, `TodoWrite`, `ExitSpecMode`, `GenerateImage`, `ListAutomations`, `ListAutomationTemplates`, `ReadAutomation`, `ProposeMission`, `StartMissionRun`, `EndFeatureRun`, `DismissHandoffItems`.
- Edit: `Create` and `Edit` (Anthropic models), or `ApplyPatch` (OpenAI models).
- Execute: `Execute`, `Script`, `WaitForScript`, `Task`, `TaskOutput`, `TaskStop`, `Skill`, `ToolSearch`, `Loop`, `GenerateDroid`, `CreateAutomation`, `EditAutomation`, `DeleteAutomation`, `RunAutomation`.
- `AskUser` appears in the docs (it is disabled for subagents) but not in the exec list. It is presumably interactive-only (UNVERIFIED).
- MCP tool IDs: `mcp__<server>__<tool>` in hook matchers [D hooks]; `MCP:<server>/<tool>` in exec flags [CLI].

### MCP [D harness/mcp]

- Files: `~/.factory/mcp.json` (user), `.factory/mcp.json` in ancestor folders (folder), and `.factory/mcp.json` in the project root (project). Org-managed servers win.
- `droid mcp add <name> <urlOrCommand...> --type stdio|http|sse [--env K=V] [--header "K: V"] [--no-oauth]` always writes to user config. Also `droid mcp remove|list|auth|permissions`.
- Fields: `type`, `disabled`, `enabledTools`, `disabledTools`, `timeout` (ms), `connectTimeout`; stdio `command/args/env`; http/sse `url/headers/oauth`. Env expansion uses `${VAR}`.
- `blockOnMcpLoad` setting.

```json
{ "mcpServers": { "playwright": { "command": "npx", "args": ["-y", "@playwright/mcp@latest"], "disabled": false } } }
```

### Hooks [D harness/hooks]

- Files: `~/.factory/hooks.json`, `.factory/hooks.json`, org-managed. Legacy `.factory/hooks/hooks.json` still loads. If no `hooks.json` exists, hooks are read from the `hooks` key in `settings.json`. Plugins use `hooks/hooks.json`. `hooksDisabled: true` turns all hooks off. Org `allowManagedHooksOnly` ignores user and project hooks.
- Events: `PreToolUse`, `PostToolUse`, `UserPromptSubmit`, `Notification`, `Stop`, `SubagentStop`, `PreCompact`, `SessionStart`, `SessionEnd`.
- Group fields: `matcher` (exact or regex, case-sensitive, `*`/empty = all), `commandRegex` (Execute only), `hooks[]` of `{type:"command", command, timeout(s, default 60)}`. Use `$FACTORY_PROJECT_DIR` or absolute paths; plugins use `${DROID_PLUGIN_ROOT}` (or `CLAUDE_PLUGIN_ROOT`).

```json
{
  "PreToolUse": [
    { "matcher": "Execute", "commandRegex": "^git ",
      "hooks": [ { "type": "command", "command": "/usr/local/bin/audit-git-command.sh", "timeout": 30 } ] }
  ]
}
```

- **Stdin payload:** `{session_id, transcript_path, cwd, permission_mode: "off"|"spec"|"auto-low"|"auto-medium"|"auto-high", hook_event_name, message_id?}` plus per-event fields:
  - tools: `tool_name`, `tool_input`, `tool_response`
  - `UserPromptSubmit`: `prompt`, `has_images`
  - `Stop`: `stop_hook_active`, `tool_execution_count`, `elapsed_time`
  - `SubagentStop`: `task_name`, `task_result`, `task_error`, `stop_hook_active`
  - `PreCompact`: `trigger`, `custom_instructions`, `message_count`, `estimated_tokens`
  - `SessionStart`: `source`
  - `SessionEnd`: `reason`, `session_duration_ms`, `message_count`
  - `Notification`: `message`, `notification_type`
- **Output:**
  - exit `0` = ok; stdout becomes context for `UserPromptSubmit` and `SessionStart`.
  - exit `2` = block or feedback (blocks PreToolUse; stderr goes back to the model for PostToolUse and Stop; blocks the prompt for UserPromptSubmit).
  - JSON `continue:false` + `stopReason`, and `suppressOutput`.
  - PreToolUse: `hookSpecificOutput.{hookEventName, permissionDecision: allow|deny|ask, permissionDecisionReason, updatedInput}`.
  - PostToolUse: `decision:"block"` + `reason`, `hookSpecificOutput.additionalContext`.
  - Stop and SubagentStop: `decision:"block"` + `reason` prevents stopping.
  - SessionStart: `additionalContext`.
- Cancelling a turn fires `Notification`, not `Stop`.
- Hooks are snapshotted at startup and Droid warns on external edits. `droid --debug` is recommended for debugging (it is **not** in `droid --help` v1.8.0, UNVERIFIED).

### Settings [D droid-cli/settings], [D enterprise/hierarchical-settings-and-org-control]

- Files: `~/.factory/settings.json`, `<git-root>/.factory/settings.json`, nested-folder `.factory/settings.json`, a `settings.local.json` beside any of them, `--settings <path>` (runtime overlay), and org-managed settings.
- Build order (highest first): Org > Runtime > Folder > Project > User > Dynamic > BuiltIn.
  - **Hard controls**: the highest level wins (org is authoritative).
  - **Session defaults** (`sessionDefaultSettings.*`, mission model keys): the most-local level wins.
- Each `.factory/` may contain `settings.json`, `hooks.json`, `mcp.json`, `droids/`, `commands/`, `skills/`, `output-styles/`.
- Keys used most for porting:
  - `model`, `reasoningEffort`, `sessionDefaultSettings.*`
  - `subagentAutonomyLevel`, `subagentModelSettings.{light,medium,heavy}{Model,ReasoningEffort}`
  - `missionModelSettings.*`, `missionOrchestratorModel`
  - `compactionTokenLimit[PerModel]`, `compactionModel`, `modelFallbacks`
  - `permissionRules`, `hooks`, `hooksDisabled`, `disabledSkills`
  - `customModels`, `enabledPlugins`, `extraKnownMarketplaces`
  - `outputStyle`, `enableDroidShield`, `includeCoAuthoredByDroid`, `cloudSessionSync`, `specSaveDir`, `worktreeDirectory`

### Permissions [D autonomy-and-safety/permission-rules]

- `permissionRules` (version 1) applies only to Execute shell commands. Each rule: `{id, decision: allow|ask|block, match.prefix: [...tokens or [alternatives]], tests.match[], tests.noMatch[], reason?, enabled?}`. Prefix tokens are exact, case-sensitive and ordered (not globs).
- Resolution: block > ask > allow. Same ID: Org > Runtime > Folder > Project > User. Project and folder rules need workspace trust.
- Validate with `droid rules check [--command '...'] [--file rules.json] [--json]`. This subcommand exists in v1.8.0 even though top-level `--help` does not list it [CLI].
- Legacy `commandAllowlist`/`commandDenylist`/`commandBlocklist` are deprecated but still respected.
- Per-run tool restriction for exec: `--only-tools`/`--remove-tools`. Per-droid: the `tools` field.

```json
{ "permissionRules": { "version": 1, "rules": [ {
  "id": "project/git-push", "decision": "ask", "reason": "Review remote Git changes before pushing.",
  "match": { "prefix": ["git", "push"] },
  "tests": { "match": ["git push origin main"], "noMatch": ["git status", "git log --oneline"] } } ] } }
```

## 8. Plugins and marketplaces [D harness/plugins], [D enterprise/internal-plugin-marketplaces]

- A plugin is a directory with `.factory-plugin/plugin.json` (metadata; "Droid does not require or read the fields inside") plus root-level `skills/`, `commands/`, `droids/`, `output-styles/`, `hooks/hooks.json`, `mcp.json`.
- Claude Code layouts (`.claude-plugin/`, `agents/`, `.mcp.json`) are translated when copied into the cache.
- A marketplace is a repo with `.factory-plugin/marketplace.json` (or `.claude-plugin/marketplace.json`) containing `{name, description?, owner?, plugins:[{name, source, description?, category?, ...}]}`. Sources: a relative path, `{source:"url", url, ref|sha}`, `{source:"git-subdir", url, path}`, or `{source:"npm", package, version, registry?, authTokenEnvVar?}`.
- CLI: `droid plugin marketplace add|remove|list|update`, `droid plugin install <plugin@marketplace> --scope user|project`, `uninstall`, `update`, `list`. There is no enable/disable command; use `enabledPlugins`. A local test needs a wrapper marketplace (`droid plugin marketplace add ./my-marketplace`).
- Team distribution goes in settings: `extraKnownMarketplaces` + `enabledPlugins` (the scope follows the file); org can enforce `strictKnownMarketplaces`/`strictEnabledPlugins`.
- The official marketplace is `Factory-AI/factory-plugins` [GH]. Plugins: security-engineer, droid-evolved, core, droid-control, autoresearch, typescript, code-review, debugging, and more.

```json
{ "name": "your-marketplace", "owner": { "name": "Platform Team" },
  "plugins": [ { "name": "plugin-one", "description": "Description of plugin one", "source": "./plugin-one" } ] }
```

---

## Gaps / unverified

1. **Task foreground vs background (conflict).** The docs say foreground is the default and `run_in_background` is optional. The v1.8.0 Task tool description says "Every Task runs in the background" and reports are delivered automatically. I could not see the Task JSON input schema (`--list-tools -o json` gives descriptions only), so whether `run_in_background` and `complexity` are still accepted parameters is **UNVERIFIED**.
2. **Custom droid discovery in exec** was not observed. I created a project droid and skill in a temp repo; `--list-tools` output does not show subagent types or skills, and a real run needs auth. Runtime visibility of `.factory/droids` and `.factory/skills` is **UNVERIFIED by observation** (it is documented only).
3. **Skill `name`/`description` length limits** and the exact sanitization rule are not documented (only "lowercase letters, numbers, and hyphens"). **UNVERIFIED.**
4. **Droid `reasoningEffort`** is documented as `low|medium|high` only, while models support `xhigh`/`max` etc. Whether droid files accept the higher levels is **UNVERIFIED**.
5. **Docs example model IDs** such as `claude-haiku-5-5` (subagents page) do not appear in the v1.8.0 model list. Treat model IDs in examples as illustrative; use `droid exec --help` or the tier aliases.
6. **Spec save directory conflict:** `.factory/docs` (spec-mode page) vs `specSaveDir` default `~/.factory/specs` (settings page). **UNVERIFIED** which is current.
7. **`--worktree` default branch name conflict:** the docs say `<current-branch>-wt`; `droid exec --help` says `<current-branch>-<id>`.
8. **`droid --debug`** is recommended in the hooks doc but missing from `droid --help`. **UNVERIFIED.**
9. **`/loop` slash command:** only inferred from the Loop tool description. **UNVERIFIED.**
10. **`acp` output format:** listed in `--help`; no docs page found. **UNVERIFIED** semantics.
11. **AGENTS.md precedence** is described as a "mental model", not a deterministic merge order; whether all levels are concatenated is **UNVERIFIED**.
12. **Do hooks fire inside subagents** (PreToolUse for subagent tool calls)? Not stated; only `SubagentStop` is documented. **UNVERIFIED.** This matters for enforcement.
13. **Sessions API session creation** is "enabled for selected organizations only". Whether an individual plan can launch cloud sessions programmatically is **UNVERIFIED**.
14. **Skills invoked inside subagents:** droids always get `Skill`, and CL v0.236.0 says "A task delegated with a leading skill command now starts". The exact semantics of `/skill` inside a Task prompt are **UNVERIFIED**.
15. **Agent loop internals** (turn limits, max-turns, retry policy) are undocumented. droid-action has a `run-droid-max-turns.test.ts` [GH], which hints at a max-turns control, but I did not find it in CLI help. **UNVERIFIED.**
16. **Blog coverage:** only `factory.ai/news/frontier-harness` was read in full. I did not review other posts (e.g. `/news/automations`, `/news/droids-now-have-a-fleet-of-sandboxes`).

## Sources (all accessed 2026-11-10)

- https://docs.factory.com/llms.txt (redirect from https://docs.factory.ai/llms.txt)
- https://docs.factory.com/harness/agents-md
- https://docs.factory.com/harness/skills
- https://docs.factory.com/harness/subagents
- https://docs.factory.com/harness/custom-slash-commands
- https://docs.factory.com/harness/hooks
- https://docs.factory.com/harness/mcp
- https://docs.factory.com/harness/plugins
- https://docs.factory.com/droid-cli/overview
- https://docs.factory.com/droid-cli/cli-reference
- https://docs.factory.com/droid-cli/settings
- https://docs.factory.com/droid-cli/output-styles
- https://docs.factory.com/droid-exec/overview
- https://docs.factory.com/autonomy-and-safety/auto-run
- https://docs.factory.com/autonomy-and-safety/specification-mode
- https://docs.factory.com/autonomy-and-safety/permission-rules
- https://docs.factory.com/autonomy-and-safety/sandbox
- https://docs.factory.com/missions/overview
- https://docs.factory.com/missions/reference
- https://docs.factory.com/workstreams/overview
- https://docs.factory.com/environments/overview
- https://docs.factory.com/api-reference/sessions
- https://docs.factory.com/automations/code-review-ci
- https://docs.factory.com/enterprise/hierarchical-settings-and-org-control
- https://docs.factory.com/enterprise/internal-plugin-marketplaces
- https://docs.factory.com/model-independence/byok
- https://docs.factory.com/sdk/typescript
- https://docs.factory.com/changelog/release-notes (CLI v0.188 to v1.8.0)
- https://factory.ai/news/frontier-harness ("Droid 1.0: Building a Frontier Harness", 2026-10-29)
- https://github.com/Factory-AI (repo list via api.github.com/orgs/Factory-AI/repos)
- https://github.com/Factory-AI/droid-action (`.factory/droids/security-reviewer.md`, `action.yml`, `AGENTS.md`)
- https://github.com/Factory-AI/factory-plugins (`.factory-plugin/marketplace.json`, `plugins/droid-control/commands/verify.md`)
- https://github.com/Factory-AI/skills (`template/SKILL.md`)
- https://app.factory.ai/cli (official install script; installed droid v1.8.0 to `~/.local/bin/droid`)
- Local CLI captures: `research/raw/cli-help.txt`, `research/raw/list-tools.txt`, `research/raw/tool-descriptions.txt`
