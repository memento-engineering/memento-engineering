# Bead fields

What each field holds, and a template. The station reads the description, the
design, the acceptance criteria and the validation plan. Notes are for history,
not for the builder.

## Title

The change, as one sentence in the present tense, stating the outcome:
"A landed bead's close resolves its external dependencies as admission does".
Not "Fix close bug" and not a question.

## Type and priority

- `bug` (something wrong), `task` (a change with no new capability), `feature`
  (a new capability). Use `epic` only for a parent whose children are the beads.
- Priority 0 (drop everything) to 4 (someday). Most work is 2.

## Description: why and what

```markdown
<What is wrong or missing, with path:line pointers to where it lives today.>

<Why it matters: the failure it causes, the evidence (a run, a log line, an
issue), and who needs it.>

<What this bead changes, in one or two sentences. Name the decisions that
govern it by slug, newest first: repo#slug D<n>.>

<Out of scope: what a reader might assume is included and is not.>
```

## Design: the decided steps

Numbered steps, each a decision, not a menu:

```markdown
1. <Where the change goes (path, symbol) and what it does.>
2. <The behaviour in the edge case: failure, empty input, concurrency.>
3. <What is kept unchanged, when a reader might assume otherwise.>
4. <Tests go in <path>.>
Decided: <a call you made autonomously, and why>.
```

## Acceptance criteria: pinned, testable

Each criterion is one observable outcome pinned by a named test. No criterion
runs the whole gate.

```markdown
- [ ] <Input or situation> yields <outcome>; pinned in <test path>
- [ ] <Edge case> yields <outcome>; pinned
- [ ] <What stays unchanged> is unchanged
```

## Validation plan: metadata, not text

One shell command, run from the repository root by the station's validation and
by code review. It may run the repository gate; that is its job. It runs under
`sh -c` (bash 3.2 on macOS): avoid `<(…)` and `#` inside `$(…)`.

```bash
--metadata '{"validation_plan":"dart pub get --offline && tool/gate.sh"}'
```

For a single package in a workspace, scope it:
`dart pub get && dart analyze && cd packages/<pkg> && dart test`.

## Dependencies

- `bd dep add <bead> <blocker>`: the bead waits until the blocker closes.
- Across stores, link with the external form your tooling supports. A cross-store
  dependency resolves only when the other bead is closed and provides the
  capability.
- Wire dependencies before the bead becomes eligible, or the station may start it
  early.
