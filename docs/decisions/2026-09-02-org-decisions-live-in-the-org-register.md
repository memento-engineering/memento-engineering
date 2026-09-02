---
status: accepted
date: 2026-09-02
decision-makers: [nico, agent]
consulted: []
informed: []
register:
  spec: 1
  slug: org-decisions-live-in-the-org-register
  surfaces:
    - "docs/decisions/**"
    - "README.md"
  obsoletes: []
  updates: ["decisions#the-decision-register"]
  obsoleted-by: null
  updated-by: []
  bead: null
  legacy-id: null
---

# Decisions that govern the whole roster live in the org register, not in the repo that happens to hold the tool

## Context and Problem Statement

memento adopted the decision-register pattern in `decisions#the-decision-register`, and the
entries recording that adoption were written into the `decisions` repo alongside the entries that
define the format itself. Two of them do not govern that repo at all: one mandates the org's
`CLAUDE.md` carry the register's authority, and one directs every repo on the roster to convert
its legacy `ADR-0000` register.

That mixing had a visible cost. Those entries declare `surfaces` that climb out of the checkout —
`engineering.memento/CLAUDE.md`, `engineering.memento/*/docs/adr/**` — so `decisions lint` could
only resolve them on a machine where the checkout sits inside the umbrella directory. The register
that defines the pattern failed its own lint in a clean clone, and the first CI ever added to that
repo went red on exactly those two entries. The entanglement was legible as a build failure before
it was legible as a filing mistake.

The tool repo is also becoming public so other orgs can adopt the pattern. An adopter cloning it
should find the format and the reference implementation, not memento's roster decisions.

## Decision Drivers

* A register's `surfaces` should resolve from the repo that holds it, so the lint means the same
  thing on every machine.
* An adopter of the pattern should not inherit memento's org decisions.
* Cross-repo union is already a tier-2 property in `SPEC.md`: it needs a live roster, not a
  standalone CLI.

## Considered Options

* An org register in its own repo, citing the pattern repo.
* Keep org decisions in the `decisions` repo and relax the surface rule so unresolvable globs are
  skipped.
* Rewrite the affected entries so their surfaces are repo-relative.

## Decision Outcome

Chosen option: **an org register in its own repo**, `memento-engineering/memento-engineering`.
Decisions that govern more than one repo on the roster are recorded here. The `decisions` repo
keeps only what governs the format and its implementation.

Relaxing the surface rule was rejected: it buys portability by making a typo'd surface silently
pass, which is the case the rule exists for. Rewriting surfaces was rejected because the reach is
real — these decisions genuinely govern other repos — and flattening that into repo-relative globs
would record something false.

### Consequences

* Good, because every register lints from its own checkout, CI included.
* Good, because the pattern repo can go public without shipping memento's internal roster
  decisions to adopters.
* Bad, because roster-wide surfaces are still unverifiable from a standalone checkout. They
  resolve at tier 2, where a station enumerates its mounted substations. This register runs no
  surface lint in CI until that path exists.
* Neutral, because this entry `updates` the adoption clause of `decisions#the-decision-register`
  rather than editing that accepted entry: the org half of it now lives here.

## More Information

The org's `README.md` profile page is a separate concern and lives in `.github/profile/README.md`;
a repo named after the organization carries no special meaning on GitHub, which is what makes this
one available as the org register.
