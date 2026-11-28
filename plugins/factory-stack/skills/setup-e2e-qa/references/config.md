# config.yaml

`.factory/skills/qa/config.yaml` is the single source for environments, personas, and apps. Drivers and test mappings live in `e2e.yaml`, never here. Users may edit this file; generated skills read it on every run.

```yaml
project: <Project>
platform: <github|gitlab>
generated_by: setup-e2e-qa
imagemagick: <true|false>      # GIF diffs of before and after screenshots
video_evidence: <true|false>   # record interactive flows with the driver's own recorder

environments:
  <name>:
    url: <url>
    restrictions: [<optional rules>]
    # previews: <how the preview URL is published>; previews behave like development
default_target: <name>

auth:
  method: <otp|oauth|email-password|magic-link|api-key|saml>
  provider: <provider>

personas:
  - name: <role>
    description: '<what this user does>'
    email: <test account>
    credentials_source: <env-var|aws-secrets-manager|vault|manual>
    secret_name: <env var or secret path>
    test_focus: [<areas>]
    cannot_do: [<negative checks>]
  - name: new_user
    description: 'Fresh signup with no data'
    email_pattern: 'qa+signup_{RUN_ID}@<domain>'
    test_focus: [onboarding, empty states]

apps:
  <app>:
    kind: <web|ios|android|macos|electron|cli|api>
    path_patterns: [<globs>]
    skill: qa-<app>
    build_command: '<optional>'
    dev_command: '<optional>'

feature_flags:
  provider: <provider|none>
  how_to_override: '<instructions>'

integrations:
  <type>:
    provider: <provider>
    mode: <sandbox|test>

cleanup:
  strategy: <api-call|admin-panel|reset-db|manual|none>
  instructions: '<how>'

failure_learning: suggest_in_report
```

- Store resolved answers only here. Generated skills and CI branch on these values at run time.
- `failure_learning` is always `suggest_in_report`: suggestions appear in the report and a person applies them, or `maintain-qa-skills` applies the confirmed ones.
