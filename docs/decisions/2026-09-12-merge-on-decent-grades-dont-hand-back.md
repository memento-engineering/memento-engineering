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
  slug: merge-on-decent-grades-dont-hand-back
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:.claude/agents/governor.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: org-48e
  legacy-id: null
---

# Merge on decent grades; do not hand back a transient classifier block

## Context and Problem Statement

On 2026-08-21 a single classifier denial on `gh pr merge` (PR #207) made the governor
start handing every subsequent merge back to Nico as a `! gh pr merge …` command list,
even though nothing about the PRs themselves had changed. Nico, verbatim: *"I do not
want to merge things! If the grades are good, just merge them!"* The next four
`gh pr merge` calls, on unrelated PRs, went through unblocked — the denial had been a
transient tool-permission hiccup, not a standing prohibition on the governor merging.

The standing policy already committed to squash-merging on decent grades with
receipts (`lunar_station` CLAUDE.md, "Standing operator policies"). What was missing
was the rule for what a governor does when the merge tool itself balks once: treat
that the same as every other durable hold, and stop driving. That conflated a
one-time permission classifier artifact with the small, named set of things that are
durably blocked by policy (`pub publish`, `bd delete`, file deletions, `launchctl`).

## Decision Outcome

**A single classifier denial on `gh pr merge` is not a policy hold.** After verifying
a PR per harvest doctrine — CI green (or, on a repo with no CI, the operator's own
validation-plan re-run), committee grades not offensive, receipts ready for the close
reason — squash-merge it directly. If the classifier blocks the call, retry once on
the next turn before falling back to anything else. Only a durably-blocked class
(`pub publish`, `bd delete`, file deletions, `launchctl`, and any future class named
the same way) is handed to the operator as a command; a merge is never handed over on
the strength of one denial.

This applies to every substation the station arms alike (see
`govern-every-seat-alike-no-personal-repo-carve-out`): the merge tool, not the repo's
ownership, is the only thing that can make a merge durably not the governor's to run.

### Consequences

* Good, because a transient tool hiccup stops costing a full round-trip to the human
  for work that was already ready to land.
* Good, because the durably-blocked list stays short and named, so "hand it back" is
  never a judgment call made in the moment.
* Bad, because a retry-once rule can still merge on a second denial that was actually
  durable, if a new class of hold appears before it is named here; that failure mode
  is a bead against this entry, not a reason to hand every merge back again.
