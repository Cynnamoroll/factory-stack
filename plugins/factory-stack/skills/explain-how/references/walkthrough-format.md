# Walkthrough format

Use these sections in this order. Drop any that has nothing to say.

## Overview
One or two paragraphs. What the thing is, what it does, and why it exists. A reader can stop here and decide whether to continue.

## Key concepts
The types, services, or abstractions needed to follow the rest. Short definitions.

## How it works
The longest section. Walk the flow: what triggers it, each step, where the data goes, and where decisions happen. Use prose, not pseudocode. Name real files and functions. Show a code snippet only when the point needs it.

When several components talk to each other or data moves through stages, add a `mermaid` diagram. Skip it when prose already carries the flow.

## Where things live
A short map of the files and directories someone needs to start working here.

## Gotchas
Surprising behavior, history that explains an odd shape, and traps.

## Style

- Concrete names. Write "`UserService` calls `AuthClient.refresh()`", not "the service delegates to the client".
- When something is complex, say why it is complex.
- When something is simple, keep it short.
- List the gaps the explorers reported instead of papering over them.
