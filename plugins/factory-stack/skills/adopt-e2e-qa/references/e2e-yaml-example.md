# e2e.yaml example

A worked example for a fictional notes project with a web app and a CLI. Copy the shape, not the content. App keys match `apps` in `config.yaml`, and flow labels match the flow menu headings in each `qa-<app>` skill exactly.

```yaml
# .factory/skills/qa/e2e.yaml
# Maintained by adopt-e2e-qa and maintain-qa-skills. install-qa never writes this file.
version: 1
apps:
  web:
    driver: e2e
    config: apps/web/e2e.config.ts # repository-relative
    target: web
    flows:
      Sign in as member: apps/web/tests/sign-in.e2e.ts:8
      Create a note: apps/web/tests/create-note.e2e.ts
      Viewer cannot edit a note: apps/web/tests/permissions.e2e.ts:41
      Share a note by link: null # no test covers it; e2e-qa drives it live
  cli:
    driver: tuistory
    flows:
      Create a note from the terminal: null
```

- `driver` is one of `e2e`, `tuistory`, `agent-browser`, or `curl`.
- `config` and `target` apply only to `e2e`. Omit `config` for a config-free live drive.
- A `null` flow is valid. It tells e2e-qa to drive the flow live.
