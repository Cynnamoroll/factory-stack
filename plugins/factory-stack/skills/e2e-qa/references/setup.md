# Agent-owned setup

1. **Check.** Confirm the route is supported. Use the driver docs and project config to identify missing skills, tools, runtime assets, and configuration. Reuse what is installed.
2. **Ask.** Use `AskUser`: “May I set up [missing items] for [target]?” Name what will change. Wait for approval. If declined, leave setup unchanged and report what is blocked.
3. **Finish.** Plan [QA cleanup](qa-cleanup.md) before starting temporary resources. Run the approved installs, configuration, and readiness checks yourself, then resume the requested test or drive. Pause only for actions you cannot perform, such as sign-in or OS grants, or for changes outside the approved scope. After the user completes that action, recheck and resume.

For e2e, follow [e2e setup](e2e-setup.md). For browser or terminal routes, use the install instructions of the selected built-in skill, Factory's `droid-control` plugin, or its helpers.
