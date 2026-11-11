# Epistemics

How to grade confidence when the evidence is historical and partial, and how to say it without false certainty.

## Confidence tiers

Every claim sits in one tier. The tier sets its section and its wording.

1. **Direct.** An author wrote the reason down: a PR body, a ticket, a code comment, a design doc, a chat message from the author. Wording is plain and cited. "This exists because X (PR #123)."
2. **Supported.** Several indirect items point the same way, and none states it outright. Wording is confident but shows each item. "The evidence points to X: the PR title, the `perf` label, and three commits on the same hot path."
3. **Inferred.** A reasonable reading that nothing states. Wording is hedged and shows the chain. "Given A and B, C seems likely because D."
4. **Speculative.** A plausible guess on thin evidence where other stories fit too. "One possibility is X, but we found no evidence for it." Usually goes under competing hypotheses.
5. **Unknown.** You searched and found nothing. Say what you searched, with the queries.

## Wording

- "Because", "the reason is", "was designed to", "fixes", and "the team decided" claim intent or outcome. Use them only next to a Direct or Supported citation.
- Hedges for inferences: "appears to", "likely", "suggests", "is consistent with".
- Avoid "obviously", "clearly", "of course", "just", and "I think".

## Traps

- **Code is not evidence of its own intent.** "The author chose a functional style" is an observation, not a reason.
- **Rationalizing.** Code that makes sense today may have been written for reasons that no longer hold, or were wrong. Do not retrofit a tidy story. A consistent pattern may be copy-paste.
- **Absence is not evidence.** "Nobody mentioned security" does not mean security was not a concern.
- **The user's guess.** "I assume it's for performance?" is a candidate to test, not a conclusion to confirm.
- **Recency bias.** The latest commit is rarely the whole story. Trace back.
- **Contradictions.** Show both sides with citations. Do not pick the one with the tidier narrative.

## Before you answer

Check every claim in the found and inferred sections. Each has a citation or moves down a tier. Its wording matches its tier. The answer has a "What we don't know" section. If it lists no gaps, be suspicious.
