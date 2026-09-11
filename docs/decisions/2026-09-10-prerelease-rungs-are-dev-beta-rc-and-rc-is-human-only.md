---
status: accepted
date: 2026-09-10
decision-makers: [nico, refiner]
consulted: []
informed: [governor]
register:
  spec: 1
  slug: prerelease-rungs-are-dev-beta-rc-and-rc-is-human-only
  surfaces:
    - "CLAUDE.md"
    - "AGENTS.md"
  obsoletes: []
  updates:
    - agents-publish-prereleases-humans-promote-to-stable
  obsoleted-by: null
  updated-by: []
  bead: org-6ku
  legacy-id: null
---

# Prerelease rungs are dev, beta, rc — and only a human sets rc

## Context and Problem Statement

`agents-publish-prereleases-humans-promote-to-stable` freed agents to publish prereleases and kept
the promotion to stable in human hands. It closed with an admitted gap: *nothing yet forces a
package to leave the prerelease ladder*, and automating the cheap half without designing that
pressure risks making the accumulation worse. This entry closes that gap and fixes the rung
vocabulary the earlier decision said was not yet buildable.

The drift is measured, against the pub.dev API on 2026-09-10: `grid_sdk` has published 27 versions,
22 of them prereleases, and is still stable at 0.2.0. `grid_assets` has published 30, 25 of them
prereleases, still stable at 0.4.0. `genesis_tree` has published ten versions and **zero**
prereleases. lenny published eleven and promoted the whole wave. Three release cultures in one
roster, and the word "rc" has quietly come to mean "published" rather than "candidate".

The cause is not habit. Reading the enforcement point — the vended release verb in
power_station's `dart_grid_assets` — `rc` is not a rung at all: it is bound to *breaking*. Its own
doc calls it "a breaking-release candidate", `isBreaking` is true for it, and **three** routes make
a package use it. A breaking wave is refused outright and the caller is told to cut candidates with
`--change rc`; a consumer-validation failure sends the caller to `--change rc`; and `rc` is the only
prerelease identifier the enum offers. A 0.x package doing breaking work is forced to `rc` every
single time. The label degraded because the tool had nowhere else to put it.

## Decision Outcome

The ladder has **three rungs, per package**: `dev`, `beta`, `rc`.

* **dev** — the API is still moving. Any prerelease starts here.
* **beta** — the API is frozen for this target version; the bugs are not. The entry condition is
  machine-checkable and an agent evaluates it: no breaking API change against the previous
  prerelease of the same target version.
* **rc** — this exact commit ships as stable unless something surfaces.

**Only a human sets `rc`.** Its entry condition is not computed: it is a person declaring intent to
promote. This is what stops the drift by construction — a package cannot accrete two dozen
candidates at a rung only a person can set.

This **narrows** the earlier decision's third clause rather than contradicting it. Rung movement is
agent work *below* `rc`: agents walk `dev` to `beta` freely. `rc`, and the stable promotion beyond
it, are both human-initiated.

The rung is a property of **each package**, not of the wave it ships in. One package genuinely at
`rc` while another in the same wave is still at `dev` is the normal case; a wave is a batch of
independently runged publishes.

Mechanically, and following semver rather than invention: skipping **up** is allowed, because a
human may declare intent at any moment; moving **backwards** is legal and is required by the demote
mechanism below; and the counter resets when the identifier changes — `dev.3` becomes `beta.1`.

### What forces a package off the ladder

Three mechanisms, and one explicit rejection.

1. **A stale `rc` is demoted.** A package sitting at `rc` past a threshold is demoted to `beta` on
   its next prerelease. This answers the actual complaint — that `rc` no longer carries its signal
   — by making the label honest, rather than by forcing out a release nobody is waiting for.
2. **A staleness prompt is filed as work.** Past the threshold the release machinery files a
   promotion bead. It lands on the board and competes for attention like anything else, and a human
   still initiates the promotion. It is a prompt, not a trigger.
3. **A consumer pulls.** A package promotes when a dependent needs a stable dependency. This needs
   no new machinery at all: `release validate-consumers` and `release promote` already exist, and
   promotion already requires a green consumer-validation report. The gap was never the mechanism —
   it was that nothing ever invokes it.

**Rejected: capping the rung.** No forcing mechanism may red-gate a release past `rc.N` or
otherwise block work that has nothing to do with the release.

### Consequences

* Good, because `rc` recovers its meaning: it is reached only when a person intends to ship, so it
  can no longer degrade into a synonym for "published".
* Good, because the rung and the semver move stop being the same field. A breaking change may be
  published by an agent at `dev` or `beta`, which is what keeps agent autonomy intact once `rc`
  becomes human-only — without this split the ruling would have stopped agents publishing any
  breaking change at all.
* Good, because the entry conditions are falsifiable rather than advisory, which is what lets an
  agent evaluate them instead of a person judging them.
* Bad, because a demotion makes a package's history read as going backwards, and a reader who does
  not know this rule will find `beta.1` after `rc.9` alarming.
* Bad, because the threshold is a tuned number, not a derived one. It is set against measured drift
  and will need revisiting as the roster's release culture changes.
