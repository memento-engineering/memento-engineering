# Finding the decisions that bind a bead

Every repository in the organization keeps a decision register in
`docs/decisions/` (one file per decision), and the organization keeps one in
memento-engineering. A bead cites every entry that governs the surfaces it
touches. An uncited governing entry is the most common reason a reviewer sends a
bead back.

## Find them

Use the `decisions` CLI, from the repository root:

1. For each path the bead touches, ask which entries govern it. The surface is
   register-qualified: the register's name, a slash, then the path.
   ```bash
   decisions index docs/decisions --surface <register>/<path>
   ```
2. Search for precedent by single distinctive tokens, not phrases:
   ```bash
   decisions search <token> --json --status accepted
   ```
3. Read each match's Decision Outcome. Cite the clause (`D2`) the bead relies on
   or changes, and quote it when the bead's correctness depends on it.

A repository that composes the verbs into its own CLI (grid's `grid decisions`)
takes the same arguments.

## Cite the newest

When several entries cover a surface, the newest one in force is the one that
binds. An entry with `obsoleted-by` set no longer binds; cite its successor. An
entry with `updated-by` set is amended; read the amendments too.

Grep the register for the bead's nouns (`grep -l "<noun>" docs/decisions/*.md`)
and read the newest hits, not the one that agrees with the bead. A reviewer only
catches a contradiction with entries it surfaces; citing an older, agreeable
entry steers it away from the newer one that forbids the work. When a design
document and a register entry disagree, the entry binds: cite it, and note the
document's drift on the bead.

## When the bead changes a decision

If the work contradicts a recorded decision, the bead is not ready.
1. Record the new ruling as its own entry, through the verbs (`decisions update`
   for an amendment, `decisions obsolete` to replace one).
2. Sweep the entries that depend on the one you changed, and record which of
   their clauses lapse.
3. Only then file the bead, citing the new entry.

## Gotchas

- Never hand-edit an entry's cached front matter (`status`, `obsoleted-by`,
  `updated-by`). The verbs write it.
- Never cite a slug the bead's own work will create. Cite only entries on the
  default branch.
