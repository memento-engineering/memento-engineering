---
status: accepted
date: 2026-09-12
decision-makers:
  - "nico"
consulted: []
informed:
  - "governor"
register:
  spec: 1
  slug: the-governor-force-pushes-its-own-station-branches
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:.claude/agents/governor.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: org-vvb
  legacy-id: null
---

# The governor force-pushes its own station delivery branches

## Context and Problem Statement

On 2026-09-05 the governor rebased `tg-wv9`'s branch, which carried Nico's own
first three commits plus the station's fix, onto `main`. When a harness
classifier blocked the force-push, the governor pushed the rebased history to
a sibling branch instead and left Nico the command to run himself. Nico asked,
in substance, why the governor did not simply run its own force-push when he
had done exactly that himself moments earlier on the same kind of branch.

A station delivery branch is rewritten on every round regardless of who
authored its earliest commits, so authorship of those commits does not make
the branch not the station's to maintain. Routing the rewritten history to a
sibling branch and handing over the real command was the governor stopping
short of its own job, not a considerate hand-back.

## Decision Outcome

Rebasing and lease-guarded-force-pushing a station's own per-bead delivery
branch is the governor's job, never a hand-back, including a branch whose
earliest commits a human authored. Use the lease-guarded push form addressed
to the known remote head of that exact branch, scoped ONLY to that named
branch — never to any branch that is not one of the station's own per-bead
delivery branches.

If a permission classifier blocks the lease-guarded push, retry once. If it is
still blocked, report the block as a permission gap that needs fixing — not as
a decision for Nico to make, and never by rerouting the rewritten history to a
sibling branch and handing over the command.

### Consequences

* Good, because the round no longer stalls on a hand-back for a branch the
  station already owns end to end.
* Good, because "report the permission gap" separates a tooling defect from a
  judgment call, so the two are never conflated in a report to Nico again.
* Bad, because a scope mistake here on the wrong branch is destructive and
  unrecoverable the way any such rewrite is; the branch-identity check named
  above is load-bearing and must not be loosened.
