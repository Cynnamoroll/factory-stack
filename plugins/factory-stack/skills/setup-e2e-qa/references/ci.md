# CI

Generate one job that runs `/qa` headlessly and posts one report per PR or MR, updated on every run. Match the repository's existing runner labels, images, stage names, and caching. Read `video_evidence` and `imagemagick` from `config.yaml` at run time instead of hardcoding answers.

## Required in every job

- Full history for diffing: `fetch-depth: 0` or `GIT_DEPTH: '0'`, plus the base branch ref.
- Node.js 22 and the project's package install, so `npx --no e2e` resolves the project's e2e and engines.
- Engine assets for each `e2e` target, for example `npx --no e2e-web install chromium`, or a booted simulator.
- `tuistory` for terminal apps; `asciinema` and `ffmpeg` when `video_evidence` is true; `imagemagick` when `imagemagick` is true.
- The Droid CLI and factory-stack, installed explicitly:

  ```sh
  curl -fsSL https://app.factory.ai/cli | sh
  export PATH="$HOME/.local/bin:$HOME/.factory/bin:$PATH"
  droid plugin marketplace add https://github.com/Cynnamoroll/factory-stack
  droid plugin install factory-stack@factory-stack --scope user
  ```

- `FACTORY_API_KEY` and every persona or integration secret named in `config.yaml`, passed as environment variables. Never echo them.
- This prompt, plus the diff base:

  ```text
  You are running in non-interactive CI with no human available. Do not use AskUser or wait for input.
  Run the qa skill. Drive every interactive flow through e2e-qa. Report missing prerequisites as BLOCKED
  with the install command. Write the final report to qa-results/report.md.
  ```

- A QA step that cannot fail the job before the report is posted, a job timeout of 20 to 25 minutes, concurrency keyed on the PR or MR with cancel-in-progress, and `qa-results/` uploaded as an artifact for 14 days.

## GitHub Actions: `.github/workflows/qa.yml`

```yaml
name: QA
on:
  pull_request:
  workflow_dispatch:
  # With preview deployments, add workflow_run on every deploy workflow and read the preview URL from it.
concurrency:
  group: qa-${{ github.event.pull_request.number || github.ref }}
  cancel-in-progress: true
permissions:
  contents: read
  pull-requests: write
jobs:
  qa:
    runs-on: <runner from existing workflows>
    timeout-minutes: 25
    steps:
      - uses: actions/checkout@v4
        with: { fetch-depth: 0 }
      - uses: actions/setup-node@v4
        with: { node-version: 22 }
      - run: <project install>
      - run: <engine assets and terminal tools per "Required">
      - run: <droid and factory-stack install per "Required">
      - id: qa
        continue-on-error: true
        timeout-minutes: 20
        env:
          CI: true
          FACTORY_API_KEY: ${{ secrets.FACTORY_API_KEY }}
          # QA_EVIDENCE_TOKEN: ${{ secrets.QA_EVIDENCE_TOKEN }}  # only when video_evidence is true
          # <persona and integration secrets from config.yaml>
        run: droid exec --auto high "<prompt> The diff base is origin/${{ github.base_ref }}." 2>&1 | tee qa-output.txt
      - uses: actions/upload-artifact@v4
        if: always()
        with: { name: qa-results, path: qa-results/, retention-days: 14 }
      - name: Post QA report
        if: always() && github.event.pull_request
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
          PR: ${{ github.event.pull_request.number }}
        run: |
          { echo '<!-- qa-report -->'
            if [ -f qa-results/report.md ]; then cat qa-results/report.md
            else echo '## QA Report'; echo; echo ':no_entry: QA produced no report. See the run log.'; fi
            printf '\n\n---\n[Run log and artifacts](%s)\n' "$GITHUB_SERVER_URL/$GITHUB_REPOSITORY/actions/runs/$GITHUB_RUN_ID"
          } > body.md
          ID=$(gh api "repos/$GITHUB_REPOSITORY/issues/$PR/comments" --paginate \
            --jq '[.[] | select(.body | startswith("<!-- qa-report -->"))][0].id // empty')
          if [ -n "$ID" ]; then gh api -X PATCH "repos/$GITHUB_REPOSITORY/issues/comments/$ID" -F body=@body.md
          else gh api "repos/$GITHUB_REPOSITORY/issues/$PR/comments" -F body=@body.md; fi
      - if: steps.qa.outcome == 'failure'
        run: exit 1
```

For an informational check, drop the last step and say so in a comment at the top of the file.

## GitLab CI: a `qa` job in `.gitlab-ci.yml`

Read the whole file first. Append the job; reuse a `test` stage or add `qa` to `stages:`. If a `workflow:` rules block blocks `merge_request_event` pipelines, fix it or tell the user. Change nothing else.

```yaml
qa:
  stage: test
  image: node:22
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
  interruptible: true
  timeout: 25m
  allow_failure: <true|false>
  variables:
    GIT_DEPTH: '0'
  before_script:
    - apt-get update -qq && apt-get install -y -qq git curl jq
    # Add chromium for web targets, plus tools per "Required". Do not rely on installers that call sudo.
    - <project install>
    - curl -fsSL https://app.factory.ai/cli | env -u GITLAB_TOKEN -u FACTORY_API_KEY sh
    - export PATH="$HOME/.local/bin:$HOME/.factory/bin:$PATH"
    - droid plugin marketplace add https://github.com/Cynnamoroll/factory-stack
    - droid plugin install factory-stack@factory-stack --scope user
  script:
    - export RUN_ID="$CI_PIPELINE_ID"
    - git fetch origin "+refs/heads/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME:refs/remotes/origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME"
    - droid exec --auto high "<prompt> The diff base is origin/$CI_MERGE_REQUEST_TARGET_BRANCH_NAME." 2>&1 | tee qa-output.txt || QA_FAILED=1
    - |
      { echo '<!-- qa-report -->'
        if [ -f qa-results/report.md ]; then cat qa-results/report.md
        else echo '## QA Report'; echo; echo ':no_entry: QA produced no report. See the job log.'; fi
        printf '\n\n---\n[Job log](%s)\n' "$CI_JOB_URL"
      } > body.md
      NOTES="$CI_API_V4_URL/projects/$CI_PROJECT_ID/merge_requests/$CI_MERGE_REQUEST_IID/notes"
      ID=""; PAGE=1
      while [ -z "$ID" ]; do
        RESP=$(curl -sS --fail-with-body -H "PRIVATE-TOKEN: $GITLAB_TOKEN" "$NOTES?per_page=100&page=$PAGE")
        ID=$(printf '%s' "$RESP" | jq -r '[.[] | select(.body | startswith("<!-- qa-report -->"))][0].id // empty')
        [ "$(printf '%s' "$RESP" | jq length)" -lt 100 ] && break
        PAGE=$((PAGE + 1))
      done
      jq -Rs '{body: .}' < body.md > note.json
      if [ -n "$ID" ]; then M=PUT; U="$NOTES/$ID"; else M=POST; U="$NOTES"; fi
      curl -sS --fail-with-body -X "$M" -H "PRIVATE-TOKEN: $GITLAB_TOKEN" -H "Content-Type: application/json" \
        --data @note.json "$U" > /dev/null || { echo "Could not $M the QA note; check GITLAB_TOKEN scope"; exit 1; }
    - '[ -z "${QA_FAILED:-}" ]'
  artifacts:
    when: always
    paths: [qa-results/]
    expire_in: 14 days
```

GitLab variables, all masked: `FACTORY_API_KEY`; `GITLAB_TOKEN` with `api` scope (`CI_JOB_TOKEN` cannot post notes or uploads); and the secrets named in `config.yaml`.
