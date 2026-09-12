---
status: accepted
date: 2026-09-11
decision-makers: [nico, agent]
consulted: []
informed: []
register:
  spec: 1
  slug: roster-wide-surfaces-use-the-roster-marker
  surfaces:
    - ".github/workflows/ci.yaml"
    - "AGENTS.md"
    - "README.md"
    - "docs/decisions/**"
    - "tool/**"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: org-bhs
  legacy-id: null
---

# Roster-wide surfaces use an explicit roster marker

## Context and Problem Statement

The org register needs to name files in every repository governed by a roster-wide decision. Its
existing convention encoded that reach as a glob beneath the `engineering.memento` umbrella
directory. That path happened to resolve for the seven org repositories mounted there, but it
could never reach `lunar_station`, `butane_flutter`, `swift-infer`, or `radioactive_dart`, which the
same station mounts from a different umbrella.

The path was also doing two incompatible jobs. Where the expected filesystem layout existed, it
was a physical glob. In a clean checkout it became an exemption marker: standalone lint recognized
the prefix and ignored the resulting `surface.unmatched` diagnostic. A directory name cannot be an
honest expression of roster membership, and filesystem discovery cannot recover a coded roster
whose substations may be mounted anywhere.

## Decision Outcome

**Roster-wide surfaces use the literal marker `roster:`. The suffix is a repository-relative
glob. `roster:<path>` means "this path in every substation the roster mounts".**

At tier 2, the authority is the composing station's coded `SpaceDelegate.substations` roster, not
a filesystem walk. The resolver applies the suffix within every mounted substation regardless of
the directory from which that substation was mounted. For example,
`roster:.claude/agents/*.md` names `lunar_station/.claude/agents/*.md` even though `lunar_station`
is mounted outside the memento umbrella.

At standalone tier 1, every unmatched repo-local surface remains fatal. The org register may
exempt an unmatched diagnostic only when its rule is `surface.unmatched` and the surface carries
the `roster:` marker. A different rule is fatal even if its message mentions a marked surface.

Implementing the tier-2 resolver is out of scope for this entry. This decision defines the
notation, its roster authority, and the exact temporary standalone-lint boundary so the resolver
can later implement one stable contract.

### Consequences

* Good, because roster membership rather than a shared parent directory determines reach.
* Good, because the explicit marker makes cross-repo intent greppable and distinguishable from a
  repo-local glob.
* Good, because standalone lint retains typo detection for every repo-local surface and every
  diagnostic class other than unmatched marked surfaces.
* Bad, because marked surfaces remain unverified until tier-2 resolution is implemented and run by
  a composing station.
