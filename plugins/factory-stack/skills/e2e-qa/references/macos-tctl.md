# Factory tctl on macOS

Older revisions of Factory's `bin/tctl` use `date +%s%3N` for deadlines. Stock macOS `date` prints a literal `3N`, which can break waits or leave recorded sessions partly closed.

If the selected helper still uses that expression directly in deadline arithmetic and `date +%s%3N` does not return decimal epoch milliseconds, use the [bundled patch](../compat/macos/tctl-timestamp.patch). Apply it only in a clean, dedicated helper checkout outside this project. If the supplied root is shared or installed, use a separate checkout of the same trusted revision; do not edit the supplied root. Check that `/usr/bin/perl -MTime::HiRes -e 1` succeeds.

```sh
git -C "$FACTORY_PLUGINS_CHECKOUT" apply --check "$E2E_QA_SKILL_ROOT/compat/macos/tctl-timestamp.patch" &&
git -C "$FACTORY_PLUGINS_CHECKOUT" apply "$E2E_QA_SKILL_ROOT/compat/macos/tctl-timestamp.patch"
```

Set `E2E_QA_SKILL_ROOT` to the skill directory named at the top of `SKILL.md`, and `FACTORY_PLUGINS_CHECKOUT` to the absolute checkout directory. Use `plugins/droid-control` from that patched checkout for the entire route, including teardown. Skip the patch when the selected helper already has the fix or the active `date` supports the format. If preflight or the patch check fails, do not force-apply it; report the affected route `BLOCKED`. Verify the named session is gone after `close` and the promised evidence still opens.

The patch matches the helper change in [the tested fork commit](https://github.com/Cynnamoroll/factory-plugins/commit/70f7312bcda31a1721c047aadea23a66ae0994c2). A trusted checkout of that commit already includes the fix.

If the same older helper runs under stock Bash 3.2, pass an explicit child environment entry to `launch` (for example, `--env TERM=xterm-256color` for a compatible terminal). With no `--env`, Bash 3.2 can reject the helper's empty environment array.

If `tctl sessions` fails on BSD `find` with `-printf`, check the exact session using the backend's session list and the helper's session metadata directory instead. Do not delete the shared metadata directory.
