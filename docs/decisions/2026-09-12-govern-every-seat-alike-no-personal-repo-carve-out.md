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
  slug: govern-every-seat-alike-no-personal-repo-carve-out
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:.claude/agents/governor.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: org-kv8
  legacy-id: null
---

# Govern every attached seat alike; no personal-repo merge carve-out

## Context and Problem Statement

The governor was treating `butane_flutter` and other personal repositories as
somehow not its own to merge — deferring to "his repo, his merge" — a holdover
from a retired coexistence era in which lunar's own beads were believed to be
gc-owned and off-limits to mutate (that ownership claim was false; see
`butane_flutter`'s local-beads receipts). Nico, 2026-07-25, correcting it in as
many words: *"stop saying 'your repo'... it's attached to YOUR station! govern
your seats."*

The distinction that mattered was never who owns the repository. It was, and
remains, which substations are attached to the station's roster: an attached
repo — org or personal — is governed the same way, because the station drives
it the same way.

## Decision Outcome

**Every substation attached to a station's roster — org repositories and
personal repositories alike — is governed under the identical standing
policy.** The governor merges PRs on any of them under the standing
decent-grades policy (see `merge-on-decent-grades-dont-hand-back`): CI/plan
green, grades not offensive, squash preferred, receipts in the PR and the bead
close. There is no carve-out for a repository because a human happens to be
its sole maintainer.

Named human gates still hold regardless of which repository is in play:
approving deferred intake, the first live arm of a brand-new composition,
persistence or credential changes, and pub.dev publishes initiated by the
operator only. Those are gates on the *kind* of action, never on the
repository's ownership.

### Consequences

* Good, because "govern your seats" removes a judgment call — which repos count
  as personal enough to hold — that had no stable answer and cost a round trip
  each time it came up.
* Good, because it retires the false gc-ownership invariant for good instead of
  leaving it to resurface the next time a personal repo is attached.
* Bad, because a personal repo with looser CI than an org repo now merges under
  the same bar; a repo that needs a stricter gate earns that through its own
  CI or validation plan, not through a blanket hold.
