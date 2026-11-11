# Explorer prompt

Fill in the two placeholders and send this as the `explorer` Task prompt.

---

Other explorers are tracing different slices of the same subsystem in parallel. Stay on your angle and go deep. Do not edit anything.

## Question

{QUESTION}

## Your angle

{ANGLE}

## Report in this shape

### Components
The key types, services, and functions. For each, the name, the file path, and one sentence on what it does.

### Flow
The execution path step by step. For each step, the function, its file, what it does, and what it calls next. Include the data passed between steps.

### Files read
Every file you read, so the walkthrough can cite them.

### Boundaries
Where this slice connects to the rest of the codebase. Its inputs and outputs.

### Surprises
Anything that works differently from how it looks, or that is easy to get wrong.

### Open questions
Anything you could not trace. Say so plainly.
