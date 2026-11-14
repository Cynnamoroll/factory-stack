# Model the domain

Apply when writing stateful logic, or when code branches a lot or repeats a shape assumption across files.

Encode the domain in a data structure instead of scattered conditionals. A matching structure makes invalid states unrepresentable and deletes branches. Choose it at write time, before the work becomes a deferred refactor.

Reach for:

- A state machine instead of scattered booleans, phases, or lifecycle checks.
- A typed model instead of loose parameters or repeated shape assumptions.
- A map, registry, lookup table, or discriminated union instead of branching spread across files.
- A reducer or command/event model instead of ad hoc state mutations.
- A module organized around one body of domain knowledge instead of a sequence such as load, validate, transform, and save. Execution order is not ownership.
- A small module boundary that gathers repeated behavior, ownership, or invariants.
- A queue, cache, index, graph, tree, or normalized collection where the access pattern calls for it.
- Any other structure that fits. When none fits, work out what the code must never allow and how the data gets read, then find the structure that encodes exactly that.

Prefer boring code when the current shape is clear, local, and unlikely to grow. An abstraction should remove branches, duplicated rules, invalid states, or lifecycle risk, not merely add indirection.

The sign that you skipped this is a new feature that grows an existing if/else chain by one more branch, or a second boolean that must stay in sync with the first. Temporal decomposition is another sign. Phase-named modules repeat the same domain rules across steps.
