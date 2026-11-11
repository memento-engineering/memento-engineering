# Finding the decisions that bind a bead

Every repository keeps its decision register in `docs/decisions/`, and the
organization keeps one too (memento-engineering). A bead cites every entry that
governs the surfaces it touches. A reviewer that finds an uncited governing
entry holds the bead.

## Find them

1. List the paths the bead touches.
2. Ask the register which entries govern each path. The surface is
   register-qualified: the repository's register name, a slash, then the path.
   ```bash
   # in grid (the station's verbs):
   dart run packages/grid_workflows/bin/grid.dart decisions index docs/decisions \
     --surface grid/packages/grid_core/lib/src/tree/close_holds.dart
   # elsewhere, the decisions CLI takes the same arguments:
   decisions index docs/decisions --surface <register>/<path>
   ```
3. Search for precedent by single distinctive tokens, not phrases:
   `decisions search <token> --json` (add `--status accepted` to skip retired
   entries).
4. Read each matching entry's Decision Outcome. Cite the clause (`D2`) the bead
   relies on or changes, and quote it when the bead's correctness depends on it.

## Cite the newest

When several entries cover the same surface, the newest one in force is the one
reviewers check against. An entry with `obsoleted-by` set no longer binds; cite
its successor. An entry with `updated-by` set is amended; read the amendments
too.

## When the bead changes a decision

If the work contradicts a recorded decision, the bead is not ready. First record
the new ruling as its own entry, with the register's verbs (`decisions update`,
`decisions obsolete`). Then sweep the entries that depend on the one you
changed, and record which of their clauses lapse. Only then file the bead,
citing the new entry. A bead that silently departs from the register fails
review every round.

## Gotchas

- Do not hand-edit an entry's cached front matter (`status`, `obsoleted-by`,
  `updated-by`). The verbs write it.
- Do not cite a slug the bead's own work will create. Cite only entries that
  exist on the default branch.
