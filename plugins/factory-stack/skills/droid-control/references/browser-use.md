# Browser and Electron

Load `agent-browser` for Factory pane, session, snapshot, and recording mechanics. For Electron use `agent-browser skills get electron`; attach to the authorized endpoint and pin the intended tab. For `--restore`, verify the active tab and account before input. Disambiguate dialogs and keep credentials out of evidence.

If a locally launched browser is missing, use [agent-owned setup](setup.md), then run `agent-browser install` yourself and recheck with `agent-browser doctor --offline --quick`. An attached browser does not need a local browser install.

For video, record on the same session and tab from before the first action through the final proof point. Check decoded frames for unreadable content, including transparent pages recorded against black. Retry capture without changing the app or report the blocker. Stop the owned recorder; leave the Factory pane and attached browsers open.
