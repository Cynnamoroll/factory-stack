# Rationale template

One page that ships with the design. Sentence-case headings. Replace each note with content.

## Problem
One paragraph. What we are doing, and which constraints make the shape non-obvious: types to interoperate with, callers we cannot break, invariants that cross the boundary.

## Usage
Write this first. The quickstart a consumer reads, plus two or three realistic call sites. The shape below must agree with it. When they disagree, change the shape.

## Shape
Data structures first, then how data flows through the signatures. Which invariants the types encode, where validation lives, and what the system deliberately does not do. What complexity the interface hides and why it is no larger than needed.

## Tradeoffs accepted
One bullet each: "we accept X in exchange for Y." Include anything a reader might mistake for an oversight.

## Alternatives considered
At least one concrete alternative shape and why it lost, judged on what it exposes to callers and what it hides.

## Open questions and risks
Phrased as questions the user can answer.

## Next step
The first thing to build. One sentence.
