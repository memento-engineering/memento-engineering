---
status: accepted
date: 2026-09-13
decision-makers:
  - "Nico Spencer"
consulted:
  - "governor"
informed: []
register:
  spec: 1
  slug: register-is-the-only-decision-system
  surfaces:
    - "org/AGENTS.md"
    - "docs/decisions/**"
  obsoletes:
    - legacy-register-migration
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: null
  legacy-id: null
---

# The register is the only decision system; the mechanical ADR-0000 migration is complete

## Context and Problem Statement

[legacy-register-migration](2026-08-30-legacy-register-migration.md) committed to converting six
repos' `docs/adr/ADR-0000` registers into `docs/decisions/` mechanically, with edges left empty
until curated at dockets. That conversion is done, and the four beads that retired the now-orphaned
ADR originals — every decision in them already existed as a register entry — landed on main today:
`the_grid` (tg-vmtd, #443), `power_station` (pow-r69j, #329), `genesis` (genesis-bb5, #39), and
`lenny` (lenny-incj, #142). A migration entry whose job was to describe and govern that conversion
has nothing left to govern once the thing it converted no longer exists, and `org/AGENTS.md` still
carried a standalone "ADR-0000 register rule" instructing agents to write to a document that is
gone in every repo that had one.

## Decision Outcome

`legacy-register-migration` is obsoleted by this entry — the migration is complete, not amended.
`org/AGENTS.md`'s ADR-0000 instruction is replaced by a rule naming the actual system: every repo's
`docs/decisions/` is the one decision register, maintained only through the `decide` skill and the
register verbs (`index`, `search`, `lint`, `obsolete`, `update`, `vacate`); cached front matter
(`obsoleted-by`, `updated-by`, `status`) is written by those verbs, never by hand. No repo keeps a
`docs/adr/ADR-0000` document any more, and none should be re-created.

### Consequences

* Good, because the register stops citing a conversion target that no longer exists — one surface,
  stated once, instead of a live rule pointing at a retired document.
* Good, because `org/AGENTS.md` now names the actual current tooling (the `decide` skill, the
  register verbs) instead of a mechanism that predates this repo's own register.
* Bad, because `legacy-register-migration`'s own authored surfaces
  (`roster:docs/adr/**`, `roster:docs/adrs/**`) are cached front matter this obsoleting entry
  cannot rewrite by hand; they stay on the superseded entry as a historical record of what it once
  governed.

### Confirmation

`dart run lunar:lunar decisions lint docs/decisions --repo-root .` reports `legacy-register-migration`
as `superseded by register-is-the-only-decision-system` with its `obsoleted-by` cache set by the
`decisions obsolete` verb. Every `roster:`-prefixed surface across this register — on this entry and
on entries this decision does not touch — reports `surface.unmatched` under a bare, non-roster-aware
lint run; that is the linter's own by-design behavior for a surface meant to be resolved by a
roster-aware caller across mounted substations (see `isRosterWideSurfaceUnmatched` in the
`decisions` package), not a defect this entry introduces or one within its surface to fix.
