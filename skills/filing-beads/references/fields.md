# Bead fields

What each bd field holds, and a template. These are bd's own fields and apply in
any store. A grid station adds a metadata field and rules of its own; see
grid-station.md for those.

## Title

The change, as one sentence in the present tense, stating the outcome:
"A landed bead's close resolves its external dependencies as admission does".
Not "Fix close bug", and not a question.

## Type and priority

- Run `bd types` for the types this store accepts and what each means. Most work
  is `task`, `bug` or `feature`; a question is a `spike` or a `decision`.
- Run `bd types --sections` for the sections each type requires. `bd lint`
  checks them. A `bug`, for example, requires `## Steps to Reproduce`.
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

For a `bug`, add the section bd requires:

```markdown
## Steps to Reproduce
1. <command or action>
2. <what happens, and what should happen instead>
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

Each criterion is one observable outcome pinned by a named test.

```markdown
- [ ] <Input or situation> yields <outcome>; pinned in <test path>
- [ ] <Edge case> yields <outcome>; pinned
- [ ] <What stays unchanged> is unchanged
```

## Dependencies

- `bd dep add <bead> <blocker>`: the bead waits until the blocker closes.
- A dependency on another store uses bd's external form; it is satisfied when
  the other store has a closed bead providing that capability.
- Wire dependencies before the bead becomes ready, or a worker may start it early.
