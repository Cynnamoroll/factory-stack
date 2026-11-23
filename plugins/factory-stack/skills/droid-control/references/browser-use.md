# Browser and Electron

1. Load `agent-browser`. Follow its Factory pane and session rules; preserve any harness-assigned session. If setup is uncertain, run `agent-browser doctor --offline --quick`. For Electron, attach to the intended app's authorized CDP endpoint and pin the tab.
2. Open the target. Get `snapshot -i`; act using fresh refs or accessible roles and names. Reacquire refs after navigation, tab/frame changes, or rerenders. Disambiguate dialogs before accepting or dismissing them.
3. Wait for the expected element, text, URL, or app event. Verify the result with a fresh snapshot and, when requested, `screenshot --annotate <absolute-path>`. Inspect a separate read-only view for persistent mutations.
4. Stop any owned recorder before closing the owned session. Leave attached browsers and personal sessions as found unless closure was requested.

For a restored session, verify the active tab and account first. Use the configured auth flow; keep credentials out of commands, traces, and evidence. Read the external `browser-use` atom if you need its restored-profile or Electron attachment recipes.

## Record

On the same browser session and tab, run `record start <absolute-path>.webm` before the first action and `record stop` after the final proof point. Keep screenshot captures at their promised proof points. Check the decoded baseline and result: a transparent page can record against black and hide dark text. If a committed state is unreadable, retry with a supported capture setup or report it incomplete; don't restyle the app to make the evidence pass. Stopping the recorder does not close the Factory pane. Basic recording needs the driver's encoder dependencies, not the external checkout.
