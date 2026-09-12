---
status: accepted
date: 2026-09-11
decision-makers: [nico, refiner]
consulted: []
informed: [governor]
register:
  spec: 1
  slug: main-stays-at-the-released-version-until-a-change-earns-a-bump
  surfaces:
    - "engineering.memento/*/packages/*/pubspec.yaml"
    - "engineering.memento/*/packages/*/CHANGELOG.md"
    - "engineering.memento/*/packages/*/extension/station_overlay/*/skills/release/SKILL.md"
    - "engineering.memento/*/AGENTS.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: org-0t7
  legacy-id: null
---

# main stays at the released version until a change earns a bump

## Context and Problem Statement

On 2026-09-11 thirteen packages were promoted from release candidate to stable
across `the_grid`, `power_station` and `space_station`. That emptied the
prerelease ladder the roster had been accumulating on for months — `grid_engine`
had reached `rc.25`, `grid_assets` `rc.26` — and raised the immediate question
of where each package's `main` should sit afterwards.

A working template pre-allocated the next MINOR at the `dev` rung:
`x.next.0-dev.0`, applied immediately after a release so `main` is always ahead
of what is published.

Two facts decide this.

**A version is a claim about a diff, and immediately after a release the diff is
empty.** Under `0.y.z`, a minor bump is the breaking signal — `ReleaseChange`
maps `docs`, `additive` and `fix` all to PATCH, and only `breaking` to the next
minor. Pre-allocating the minor therefore asserts "a breaking change is coming"
before any code exists that could break anything, and it picks the *rarest* of
the four change classes as the default.

**Nothing would catch it.** `ReleaseService.classifyRelease` diffs the public
API against the last published release and compares the required move to the
declared one, but it returns `understated` in exactly one direction: a version
too LOW for a breaking delta. An overstated version returns `ok` —
`no public API change between 0.6.0 and 0.7.0-dev.0; declared … is a breaking
change`, verdict `ok`. The one gate that exists to check versions is
deliberately one-directional, so an inflated version passes it silently and
forever.

## Decision Outcome

**A package's `main` stays at its released version.** It is not bumped on
release, and no next version is pre-allocated.

The FIRST change that warrants a release chooses the move, classified by what
the change actually is, and enters the prerelease ladder at `dev`:
`release plan --change <docs|additive|fix|breaking> --rung dev`. The tooling
computes the version from the change class rather than inheriting a number
chosen before the work existed — which is what its own dev-first target message
(`a breaking change requires 0.4.0-dev.1`) already assumes.

Unreleased work accumulates under an `## Unreleased` heading in the package's
`CHANGELOG.md`, and the release step retitles that heading to the computed
version. That is not a new invention: `dart_grid_assets` carried its entire
`0.2.0-dev.1` body under `## Unreleased` until the release retitled it.

This decides only WHERE main sits between releases. It does not touch who may
publish or promote, which
`prerelease-rungs-are-dev-beta-rc-and-rc-is-human-only` governs.

### Consequences

* Good, because a version number never claims a change that has not happened,
  and in `0.y.z` that claim is specifically "this breaks you".
* Good, because the semver move is decided when the information to decide it
  exists — after the diff — rather than before, which is also the only point at
  which `classify` can meaningfully check it.
* Good, because it does not re-create the accumulation just cleared. A package
  sitting at `0.7.0-dev.N` collecting dev releases is the same drift as two
  dozen candidates, one rung down.
* Bad, because `main`'s version alone no longer distinguishes it from the
  published release. The `## Unreleased` changelog section carries that
  information instead, and a reader who consults only `pubspec.yaml` will not
  see it.
* Bad, because it puts a judgement — which change class — into every first
  release after a GA, where the template offered a mechanical answer.
