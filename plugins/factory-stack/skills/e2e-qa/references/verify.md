# Verify

Match evidence to every promised postcondition. At each proof point, check the target and build, the action, and its observed effect. For comparisons, pair the same interaction point on both real builds. Report a missing observation separately from observed incorrect behavior.

- **QA:** Give each step `PASS` (observed true), `FAIL` (observed false), or `BLOCKED` (not observable). Attach evidence or the exact blocker. Continue independent steps; don't use a failed prerequisite as a pass.
- **Claim:** Use `CONFIRMED`, `REFUTED`, or `INCONCLUSIVE` according to the evidence. A blocked step needed for the claim makes it inconclusive.
- **Video:** Probe the finished file with `ffprobe` and decode it with `ffmpeg -v error -xerror -i <video> -f null -`. Compare duration, dimensions, and file size with renderer commitments. Inspect frames at each proof point, including the last content frame before the outro; metadata cannot prove content. Check readability, labeling, overlays, and matched final states where applicable.

Fix and recheck the stage that produced an invalid artifact. If blocked, report partial evidence without calling the deliverable complete.
