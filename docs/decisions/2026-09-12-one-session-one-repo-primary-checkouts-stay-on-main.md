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
  slug: one-session-one-repo-primary-checkouts-stay-on-main
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:.claude/agents/governor.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: org-viy
  legacy-id: null
---

# One session, one repo; primary checkouts stay on main

## Context and Problem Statement

On 2026-09-02 a bead in `power_station` (`pow-0nvg`) was filed with a first step
reading "extend `BdCliService` in `the_grid`, path-linked, then continue in
`power_station`." The builder did exactly that: it edited
`the_grid/packages/beads_dart/.../bd_cli_service.dart` directly in
`the_grid`'s **primary checkout** — the repo's own working copy that a
resident station runs from and every path-linked consumer resolves against —
from a session whose worktree belonged to `power_station`. It had already
committed an earlier chunk straight onto `the_grid`'s local `main`. `the_grid`
went uncompilable for every path-linked consumer: lunar's own CLI reported
DOWN, and every governor verb that depends on it died along with it. Nothing
in the station could ever land that edit, because a session's PR route is
always its own bead's repo — there was no way to open a PR for work committed
onto another repo's primary checkout.

The underlying mechanism is mechanical: the provisioner cuts exactly **one**
worktree, in the bead's own store repo. Every other repo a session can see
resolves only through its **primary checkout** — the one a resident station
runs from and hangs its own per-bead worktrees off of. A builder told to
change a dependency's API in a bead belonging to a different repo has only
that primary checkout to write into, and moving that checkout's `HEAD` (by
committing to it, or by checking out a branch on it at all) desynchronizes a
live resident from the branch its own agents assume — a class of damage that
surfaces later as confusing, unrelated-looking failures rather than
immediately.

Separately, landing conventions were unevenly applied across the roster: some
repos required a merge queue and some did not, and personal (user-owned)
repositories cannot carry a GitHub merge queue at all (`422`), which is not a
gap to close but a fact to land around.

## Decision Outcome

**A station session's work is scoped to exactly one repository.** A bead whose
steps span two repos is not filed as one bead; it is split into one bead per
repo, with the dependency-side bead filed in its own repository and the
consumer bead wired `--blocked-by` it via a link bead. A consumer bead's body
says explicitly not to edit the other repo — if the surface it needs is
missing, the bead is not ready, and the missing surface is the blocking bead's
job to deliver.

**A substation's primary checkout is never branched.** No `git checkout -b`,
`git checkout <branch>`, or `git switch` runs in a primary checkout; it stays
on `main`. Branch work happens in a separate worktree — human-driven ones at
`.grid/worktrees/manual/<name>`, alongside the station's own per-bead
worktrees at `.grid/worktrees/<store>/<bead>` — created with
`git -C <repo> worktree add .grid/worktrees/manual/<name> -b <branch> main`,
resolved with its own `dart pub get` before analyzing.

**Landing goes through a required merge queue wherever GitHub allows one.**
Every org repository carries a Main ruleset (deletion and non-fast-forward
protection, required linear history, required status checks, a squash-only
merge queue, organization-admin bypass) and lands with `gh pr merge N --auto`
— the queue selects squash; a direct `--squash` is refused by the ruleset.
Personal (user-owned) repositories cannot carry a GitHub merge queue at all,
so they land the same discipline — required checks green, squash merge,
delete-branch-on-merge — without an actual queue: `gh pr merge N --squash`
(with `--auto` where the repo's checks support it). The absence of a queue on
a personal repo is a GitHub platform constraint, not a lowered bar.

### Consequences

* Good, because a cross-repo bead can never again strand a builder with only a
  primary checkout to write into and no route to land the result.
* Good, because a live resident's primary checkout stays exactly where every
  agent assumes it is, so branch work never desynchronizes it.
* Good, because the landing discipline is named per repo class (queued org
  repo vs. non-queued personal repo) instead of being rediscovered per
  incident.
* Bad, because splitting cross-repo work into per-repo beads adds real
  filing and wiring overhead — a dependency edge and a second bead — to
  changes that would otherwise be one unit of work.
* Bad, because a merge-queue's own failure modes (a red PR-level check that
  does not stop the queue, a failed merge-group run that silently dequeues a
  PR while its own checks stay green) are not covered by this entry and still
  require reading the queue's actual state rather than trusting a PR's own
  green checks.
