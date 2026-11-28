#!/usr/bin/env python3
"""Hand install-qa's generated QA skills to e2e-qa instead of droid-control.

Run from the repository root. Safe to rerun; run it again after every /install-qa,
because install-qa regenerates the files this script edits.

  rewire.py            apply the fixes it can make, then list manual follow-ups
  rewire.py --check    change nothing; list every drift

Exit codes: 0 nothing left to do, 1 drift or manual follow-ups remain,
2 a file could not be parsed, 3 no install-qa output found.
"""
import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

BEGIN = "<!-- e2e-qa:begin (managed by /adopt-e2e-qa; rerun it after /install-qa) -->"
END = "<!-- e2e-qa:end -->"
BLOCK = f"""{BEGIN}
## Interaction layer: e2e-qa

This project drives apps with the `e2e-qa` skill, not the `droid-control` plugin. This section overrides every droid-control instruction below it.

- Wherever this file says to invoke, load, or route through `droid-control`, load `e2e-qa` instead and follow its QA integration guide. Never install or enable droid-control.
- `e2e-qa` reads `.factory/skills/qa/e2e.yaml` for each app's driver, e2e config, target, and flow-to-test mapping.
- Mapped e2e tests drive the running app as a user would, so they count as interactive QA. Unit tests, lint, and typecheck stay out of scope.
- Droid Control Capture becomes the selected driver's own recorder. Compose is not available: treat `droid_control.compose` as false and never render edited video.
- Terminal apps use the built-in `tuistory` skill directly, with one session per app named `qa-$RUN_ID-<app>`.
{END}
"""
BLOCK_RE = re.compile(r"<!-- e2e-qa:begin.*?" + re.escape(END) + r"\n*", re.S)
FRONTMATTER_RE = re.compile(r"---\n.*?\n---\n", re.S)
PLUGIN = "droid-control@factory-plugins"
MARKETPLACE = "factory-plugins"
CONFIG_LINE = "interaction_layer: e2e-qa # set by /adopt-e2e-qa; drivers live in qa/e2e.yaml\n"


def repo_root(explicit):
    if explicit:
        return Path(explicit).resolve()
    try:
        out = subprocess.run(
            ["git", "rev-parse", "--show-toplevel"], capture_output=True, text=True, check=True
        )
        return Path(out.stdout.strip())
    except (subprocess.CalledProcessError, FileNotFoundError):
        return Path.cwd()


def with_block(text):
    body = BLOCK_RE.sub("", text)
    match = FRONTMATTER_RE.match(body)
    head, rest = (body[: match.end()], body[match.end():]) if match else ("", body)
    return head + "\n" + BLOCK + "\n" + rest.lstrip("\n")


def fix_settings(data):
    changes = []
    enabled = data.get("enabledPlugins") or {}
    if PLUGIN in enabled:
        del enabled[PLUGIN]
        changes.append(f"remove {PLUGIN} from enabledPlugins")
    if not enabled:
        data.pop("enabledPlugins", None)
    markets = data.get("extraKnownMarketplaces") or {}
    still_used = any(k.endswith("@" + MARKETPLACE) for k in enabled)
    if MARKETPLACE in markets and not still_used:
        del markets[MARKETPLACE]
        changes.append(f"remove the {MARKETPLACE} marketplace, which only served droid-control")
    if not markets:
        data.pop("extraKnownMarketplaces", None)
    return changes


def fix_config(text):
    changes = []
    out = []
    in_droid_control = False
    for line in text.splitlines(keepends=True):
        if re.match(r"^droid_control:\s*(#.*)?$", line):
            in_droid_control = True
        elif in_droid_control and re.match(r"^\S", line):
            in_droid_control = False
        elif in_droid_control:
            m = re.match(r"^(\s+compose:\s*)true\b(.*)$", line, re.S)
            if m:
                line = m.group(1) + "false" + m.group(2)
                changes.append("set droid_control.compose to false")
        if re.match(r"^interaction_layer:", line):
            if line == CONFIG_LINE:
                out.append(line)
            else:
                changes.append("replace interaction_layer with e2e-qa")
            continue
        out.append(line)
    if CONFIG_LINE not in out:
        if "replace interaction_layer with e2e-qa" not in changes:
            changes.append("add interaction_layer: e2e-qa")
        at = next((i + 1 for i, l in enumerate(out) if l.startswith("project:")), 0)
        out.insert(at, CONFIG_LINE)
    return "".join(out), changes


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--check", action="store_true", help="report drift without changing files")
    parser.add_argument("--root", help="repository root (default: git top level)")
    args = parser.parse_args()

    root = repo_root(args.root)
    skills = root / ".factory" / "skills"
    orchestrator = skills / "qa" / "SKILL.md"
    if not orchestrator.is_file():
        print(f"no install-qa output: {orchestrator.relative_to(root)} is missing. Run /install-qa first.")
        return 3

    fixable = []
    manual = []

    for path in [orchestrator, *sorted(skills.glob("qa-*/SKILL.md"))]:
        text = path.read_text()
        new = with_block(text)
        if new != text:
            fixable.append(f"{path.relative_to(root)}: add or refresh the e2e-qa block")
            if not args.check:
                path.write_text(new)

    settings = root / ".factory" / "settings.json"
    if settings.is_file():
        try:
            data = json.loads(settings.read_text())
        except json.JSONDecodeError as err:
            print(f"cannot parse {settings.relative_to(root)}: {err}")
            return 2
        changes = fix_settings(data)
        fixable += [f"{settings.relative_to(root)}: {c}" for c in changes]
        if changes and not args.check:
            settings.write_text(json.dumps(data, indent=2) + "\n")

    config = skills / "qa" / "config.yaml"
    if config.is_file():
        new, changes = fix_config(config.read_text())
        fixable += [f"{config.relative_to(root)}: {c}" for c in changes]
        if changes and not args.check:
            config.write_text(new)
    else:
        manual.append(f"{config.relative_to(root)} is missing; rerun /install-qa")

    if not (skills / "qa" / "e2e.yaml").is_file():
        manual.append(".factory/skills/qa/e2e.yaml is missing; write it (adopt-e2e-qa step 2)")

    ci_files = sorted((root / ".github" / "workflows").glob("*.y*ml")) + [root / ".gitlab-ci.yml"]
    for path in ci_files:
        if path.is_file() and "droid-control" in path.read_text():
            manual.append(f"{path.relative_to(root)} still references droid-control; edit it (adopt-e2e-qa step 3)")

    label = "drift" if args.check else "fixed"
    for item in fixable:
        print(f"{label}: {item}")
    for item in manual:
        print(f"manual: {item}")
    if not fixable and not manual:
        print("clean: install-qa output is wired to e2e-qa")
    return 1 if manual or (args.check and fixable) else 0


if __name__ == "__main__":
    sys.exit(main())
