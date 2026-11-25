# Feature map example

A worked example for a fictional notes app. Copy the shape, not the content.

## `features/README.md`

```markdown
# Notes verification map

The maintained source for verifying what Notes users can do. Read this index before driving the app, then use the matching feature file.

## Baseline

- Launch Notes at `http://127.0.0.1:4173` with `NOTES_DATA_DIR=/tmp/notes-verify-$RUN_ID`.
- Seed notes titled `Quarterly plan` and `Grocery list`.
- Run the doctor and require the expected URL, data dir, and build revision.
- Never drive an instance this run did not start.

## Conventions

- Start every recipe from the baseline unless its preconditions say otherwise.
- Prefer ARIA roles and names over CSS selectors.
- Restore seeded data after a mutation. Keep proof artifacts.

## Proof

- UI proof is an ARIA snapshot plus a screenshot with the app identity visible.
- CLI proof is the command, stdout, stderr, and exit code.
- Mutation proof includes a second, read-only view of the stored value.
- An unreachable path is reported with the attempted command and the missing precondition. Never report it as verified through a different path.

## Features

- [Create a note](./create-note.md): browser and CLI creation, cancel, persistence.
- [Search notes](./search.md): toolbar, keyboard, and CLI search.
```

## `features/create-note.md`

Each feature file has an H1, one paragraph on the user-visible behavior, then exactly these four H2 sections.

```markdown
# Create a note

A user saves a titled note from the browser or the CLI, can cancel a draft, and sees the saved note from a second view.

## Sub-features

- `create-save` persists a title and body.
- `create-cancel` discards an unfinished draft.
- `create-cli` creates the same note from the terminal.

## How to get to it (user POV)

- The `New note` button in the toolbar.
- The `n` key when focus is outside a text field.
- `notes create --title <title> --body <body>` in a terminal.

## Driving it with e2e and the CLI

Preconditions: the doctor passes and no note is titled `Release checklist`.

- **Web.** Run `npx --no e2e run tests/create-note.e2e.ts --target web`. Require `create-save` and `create-cancel` to pass on `web`. Check the report for the saved title and body from a reopened note, and the attached snapshot and screenshot.
- **CLI.** Run `notes create --title "CLI note" --body "From terminal" --format json`. Require exit code 0 and the new ID in stdout. Check that ID in a read-only view.

## Gotchas

- Pressing `n` inside a text field types the letter.
- Titles are trimmed on save. Assert the rendered title.
- A save status alone is not proof. Reopen the note from the list.
```
