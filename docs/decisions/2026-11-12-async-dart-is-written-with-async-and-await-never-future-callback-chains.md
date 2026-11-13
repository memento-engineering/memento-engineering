---
status: accepted
date: 2026-11-12
decision-makers:
  - "nico"
consulted: []
informed:
  - "governor"
register:
  spec: 1
  slug: "async-dart-is-written-with-async-and-await-never-future-callback-chains"
  surfaces:
    - "roster:analysis_options.yaml"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: "org-dfw"
  legacy-id: null
---

# Async Dart is written with async and await, never Future callback chains

## Context and Problem Statement

Nico ruled on 2026-08-09 that memento code uses only `async` and `await`, and
that the Future API is used only through its static methods. The ruling was
kept as a memory and never recorded, so nothing in a repository states it and
nothing enforces it. On 2026-11-12 the org's repositories held 78 Future
callback chains: 43 in grid, 23 in lenny, 7 in genesis and 5 in beads_dart.

The ruling came from a defect. A persist path in the_grid wrapped a bd write in
`.catchError`, and the handler swallowed the typed failure bd reported, so the
write failed silently. A callback chain moves error handling out of the
`try`/`catch` a reader looks for, and lets a handler turn a typed failure into
a value.

## Decision Outcome

**Asynchronous Dart in every memento repository is written with `async` and
`await`.** An awaited call that can fail is handled with `try`/`catch` around
the `await`.

* Callback chains on a `Future` are not written: `.then`, `.catchError`,
  `.whenComplete` and `.onError`.
* The Future API's static members stay in use: `Future.wait`, `Future.value`,
  `Future.error`, `Future.delayed`, `Future.sync` and the like. So do instance
  members that are not a callback chain, such as `.timeout` and `.ignore`.
* A `Stream`'s own API is not governed by this entry.

The rule is enforced by a `genesis_lint` rule, which every repository that
enables `genesis_lint` gets when it adopts the release that carries it. Code
written before that release is converted in the change that adopts the rule,
not left half-converted across unrelated changes.

### Consequences

* Good, because every error path is a `try`/`catch` a reader can find, and a
  handler can no longer swallow a typed failure inside a chain.
* Good, because a lint enforces it, so it binds agents that never read it.
* Bad, because adopting the lint in a repository means converting that
  repository's existing chains first, and grid alone holds 43.
* Bad, because some chains read more naturally, such as a one-line
  `.then` on a fire-and-forget future. They become an `unawaited` call to a
  small `async` function instead.
