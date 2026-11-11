# Review-bot triage

Review bots catch real bugs and also file noise. Classify each thread before acting. Do not treat every comment as a required change, and do not ignore a bot by default.

## Calls

- **fix.** The comment names a plausible correctness, security, privacy, data loss, auth, billing, migration, idempotency, race, or shipped-behavior problem, and the code confirms it. Fix it in the lowest PR that owns the code, reply with the commit SHA, and resolve the thread.
- **dismiss.** The comment matches a low-risk pattern below and the current code proves no change is needed. Reply with the concrete reason and resolve.
- **ask.** The comment is novel, high-severity, touches security or data, or is ambiguous. Ask the user.

When in doubt, ask. Skipping a noisy style comment is cheap. Skipping a real data bug is not.

## Never auto-dismiss

- security, privacy, auth, billing, data retention, and permission findings
- high-severity findings
- migration, schema, idempotency, concurrency, and cross-system findings
- a small suggested fix that clearly reduces risk without changing intent

## Usually safe to dismiss

- **Intentional visual change.** The PR description or screenshots make the change explicit, and the comment only restates that a default changed. Not when it raises accessibility, focus, or contrast.
- **Used later in the stack.** The bot calls a symbol unused, and a later PR in the stack uses it. Not when the symbol is public API or the use cannot be verified.
- **Temporary duplication.** Code is duplicated on purpose while an old path is being replaced. Not when the duplicate touches security, billing, or data access.
- **Invariant already enforced.** A shared component, type, or framework contract already guarantees the concern, visible in the diff. Not when the invariant is assumed but unenforced, or crosses async boundaries.
- **Withdrawn finding.** The bot's own comment says the finding is withdrawn or compliant, and you can confirm it locally.

## Verify cheaply first

- When a bot claims a test no longer matches the docs or code, run the test on the PR head before classifying. A red run confirms it. A green run is the disproof for the reply.
- When a security finding claims a missing check, read the PR head. A later commit may already add it before the side effect.
- When a bot asks to widen a narrow error condition (a specific errno or status) into a catch-all, check whether the narrowness encodes a real distinction before agreeing.

From the third review pass on, lean toward dismissing documented patterns, but still ask on anything in the never-auto-dismiss list.

## Adding a pattern

Offer a new pattern to the user as a candidate after the PR is merge-ready, in this shape:

```markdown
### <short name>
- Skip when: <conditions>
- Do not skip when: <risk boundaries>
- Example signal: <phrases or code context>
```
