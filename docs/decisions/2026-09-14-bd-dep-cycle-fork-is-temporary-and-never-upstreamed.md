---
status: accepted
date: 2026-09-14
decision-makers:
  - "nico"
consulted: []
informed:
  - "governor"
register:
  spec: 1
  slug: bd-dep-cycle-fork-is-temporary-and-never-upstreamed
  surfaces:
    - "roster:AGENTS.md"
    - "roster:CLAUDE.md"
    - "roster:.claude/agents/governor.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: org-9ov
  legacy-id: null
---

# The bd dependency-cycle fork is temporary, never upstreamed, and installed by the governor

## Context and Problem Statement

The fleet runs the Homebrew HEAD lineage of `bd` (`a45199a`). On every blocking-edge
insert that binary runs a dependency cycle check whose two-table form re-materialises an
un-indexed `UNION` of `dependencies` and `wisp_dependencies` on each recursion hop. On a
state store carrying hundreds of closed sessions this costs about 110 ms per deep edge
against about 3 ms for an indexed walk, and a molecule pour of one round — roughly thirty
step beads and eighty dependency rows — takes 6.6 to 7.3 seconds against a 10 second
`DoltQueryService` deadline. `tg-4gaz` fixed the query and the fix was merged, tagged on
`nicholasspencer/beads` as `grid-head-a45199a-dep-cycle-indexed-recursion.1`
(`f82590301`, the Homebrew base plus exactly one commit), and then left uninstalled for
eleven days as a human step while the G1 soak could not produce a certifiable boot.

Two facts constrain the ruling. First, the pour is a legacy write: trajectory schema
section 9 Stage 2 (`tg-ersi.7`) retires step and molecule bead creation outright, and
Stage 3 (`tg-lt0s`) retires mount-attempt beads and slims session beads, so the query
the fork speeds up loses its dominant caller once the migration lands. Second, an
earlier ruling already holds that bd performance symptoms are trajectory-migration
beads, never beads fixes (`tg-f6zv`, won't-do, 2026-09-13); the fork exists to fix our
own misuse of beads as a lifecycle store, not to improve beads.

## Decision Outcome

Three clauses, all ruled by Nico on 2026-09-14.

1. **The fork is temporary.** It is a stopgap that carries the station through the G1
   soak and until Stage 2 lands. After `tg-ersi.7` retires step and molecule bead
   creation and one state-store prune has run, the remaining per-round edge inserts
   (the session-to-work link and the gate edges) are RE-MEASURED on stock `bd`; the work
   stores, which now carry `external:` dependency rows, get the same timing check. If
   those inserts are sub-second on stock `bd`, the fork is dropped by `brew link
   --overwrite beads`. A measurement that is not sub-second is a new bead with its own
   receipt, never a reason to keep the fork by default.

2. **The fork's changes are never upstreamed, and no seat may ask Nico to open a pull
   request for them.** The patch addresses a workload that the migration is deleting;
   it is not a contribution to beads. Any seat that finds itself drafting an upstream
   PR, or a request to Nico to open one, is off-policy and stops.

3. **Installing the fork is governor work, not a human step.** The governor builds the
   ratified tag in a detached worktree with the Makefile's own flags
   (`CGO_ENABLED=0 go build -tags gms_pure_go -ldflags="-X main.Build=f82590301"`),
   installs the binary outside the Homebrew cellar, and re-points
   `/opt/homebrew/bin/bd` at it — with the station DOWN, because `bd` is spawned per
   call and every seat on the machine resolves the same link. The SQL runs in the CLI
   client, not in the `db-proxy-child` (which only manages the dolt server and relays
   connections), so long-lived proxy children need no restart. Installed 2026-09-14.

### Consequences

* Good, because the G1 soak can proceed on the query it was dying on without waiting
  on a toolchain step, and nothing about the install touches stored data or the soak's
  measurement window.
* Good, because the exit is defined by a measurement and a stage boundary rather than
  by preference, so the fork cannot quietly become permanent.
* Bad, because the fork binary is a local artefact outside package management: a
  `brew upgrade` can silently re-link the unpatched build, and any seat that trusts
  `bd version` must read the build hash, not the version number.
* Bad, because the fork is machine-wide; every other system on this host that shells
  out to `bd` runs the patched binary too, and coexistence was accepted as a cost.

### Confirmation

`bd version` reports `1.1.0 (f82590301)` while the fork is installed. The exit
condition is a recorded timing of session-link and gate-edge inserts on stock `bd`
after Stage 2 and a prune, attached to the bead that retires the fork.
