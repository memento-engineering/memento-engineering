---
status: accepted
date: 2026-09-10
decision-makers: [nico, refiner]
consulted: []
informed: [governor]
register:
  spec: 1
  slug: agents-publish-prereleases-humans-promote-to-stable
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:packages/*/extension/station_overlay/*/agents/*.md"
    - "roster:packages/*/extension/station_overlay/*/skills/release/SKILL.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by:
    - prerelease-rungs-are-dev-beta-rc-and-rc-is-human-only
  bead: org-928
  legacy-id: null
---

# Agents publish prereleases; humans initiate promotion to stable

## Context and Problem Statement

Publishing has been treated as a human act across the roster, on the standing belief that the
auto-mode classifier refuses `dart pub publish`. That belief is recorded, and for the org's actual
release path it is false. Nothing in the pipeline runs `dart pub publish`: a release is a **tag
push**, and the workflow publishes through pub.dev trusted publishing over OIDC, with no
long-lived credential in CI. `git push <tag>` is an ordinary git operation the station already
performs when it pushes branches and opens pull requests.

So the gate that was in force had never been argued on its merits. Asked directly, the merit is
irreversibility: pub.dev has no unpublish, and `dart pub` offers no retract — retraction is a
site-admin action. But irreversibility is not uniform. A prerelease in a series already two dozen
deep is close to costless; a stable version is the one-way act that every resolver in the
ecosystem then sees by default.

The cost of the undifferentiated gate is visible in the tags. Measured 2026-09-10 against the
pub.dev API: `grid_sdk` shipped stable through 0.2.0 and has been `0.3.0-rc.*` ever since, now
rc.21; `grid_assets` shipped stable through 0.4.0 and is now `0.6.0-rc.24`. Two dozen release
cycles inside one unpromoted minor, each one waiting on a person for an act that carries almost no
risk. Meanwhile lenny published eleven prereleases and promoted the whole wave to stable, and
genesis has published thirty-one versions with no prerelease at all — three release cultures in one
roster, none of them chosen.

## Decision Outcome

Station agents and processes may publish **prereleases** freely, with no per-release human ask.

Promotion to a **non-prerelease** version is a **human** act, and it is human-**initiated**: the
trigger is a person saying which features and fixes need to ship. There is no machine condition
that promotes a package to stable, and none should be sought.

Prerelease **rung** movement — advancing a package through the prerelease ladder — is likewise
agent work. It is not yet buildable, because the rung vocabulary has only one prerelease value
today, and that gap is tracked separately.

"Freely" removes the **human** gate and nothing else. Every deterministic gate still applies —
the scrub, the dry-run, the declared-floors check — and so does the agent's own obligation to make
best efforts not to publish a breaking change unannounced. An agent that publishes a breaking
prerelease without saying so has failed this decision even though nothing refused it.

### Consequences

* Good, because the act that is performed dozens of times per package is automated and the act
  that is performed once, and cannot be undone, keeps a person in it.
* Good, because the authority line now falls on a real property — irreversibility — rather than on
  a misremembered tool refusal.
* Good, because a seat can satisfy this today with no new machinery: the release skill already
  owns the judgement, and the vended release command already separates cutting a prerelease from
  promoting to stable.
* Bad, because an agent may now publish a version no human reviewed, and a bad prerelease cannot
  be withdrawn — only superseded by another.
* Bad, because nothing yet forces a package to leave the prerelease ladder. Automating the cheap
  half without designing that pressure risks making the accumulation worse rather than better.
