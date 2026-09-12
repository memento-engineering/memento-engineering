---
status: accepted
date: 2026-09-12
decision-makers: [nico, refiner]
consulted: []
informed: [governor]
register:
  spec: 1
  slug: releases-publish-only-through-the-gated-release-command
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:.github/workflows/publish.yml"
    - "roster:packages/*/extension/station_overlay/*/skills/release/SKILL.md"
  obsoletes: []
  updates:
    - power_station#adr-0003-private-git-tag-releases-and-prerelease-gate
  obsoleted-by: null
  updated-by: []
  bead: org-pdn
  legacy-id: null
---

# A release publishes only through the gated release command

## Context and Problem Statement

The org's release gate is real and it works. `ReleaseService.validateDeclaredFloors` copies a
candidate out of its pub workspace, resolves its exact declared floor from pub.dev, and analyzes
it — the check that catches a package using a sibling's unreleased API. `_runScrubGate` refuses a
whole release wave when it fails, before any tag exists.

Nothing requires a release to go through it.

The upload is tag-triggered trusted publishing: a `<package>-v<version>` tag push runs
`publish.yml`, which performs no floors check. So the gate binds one path — the governor-run
`release publish --workspace` command — while the mechanism that actually publishes binds none.
An agent that hand-writes a release PR chooses its own gate list.

That is not hypothetical. `grid_cli` 0.5.0-rc.22 published on 2026-09-11 unbuildable against its
own declared floors, three days after the gated command shipped. Its release PR recorded a Gate
section of `dart analyze`, `dart format`, `dart test` and `dart pub publish --dry-run`. The
declared-floors leg is absent from that list. The gate existed, was correct, and was not run.

Two further facts shaped the ruling. First, `power_station#adr-0003-private-git-tag-releases-and-prerelease-gate`
D4 already placed this gate with the governor deliberately — *"not CI, not station-driven, for
now"* — and named evolving it to a CI job as *"a deliberate later step"*. The gap is therefore a
known, deferred step, not an oversight. Second, D4 lives in `power_station`'s repo-local register,
while the agents cutting releases work in `the_grid`, `lenny`, `genesis` and `space_station`. A
ruling resolved from a repo those agents never read reaches none of them, which is the most
plausible reason rc.22's author assembled a gate list of their own.

## Considered Options

* **CI enforcement alone** — make `publish.yml` refuse an ungated tag. Closes the hole for every
  route, but amends D4 immediately and needs workflow work in five repos before anything improves.
* **Convention alone** — rule that the gated command is the only path, and change no code. Free
  and immediate, but rc.22 happened under exactly that regime; a convention cannot stop the next
  agent writing its own Gate section.
* **Convention now, CI enforcement behind it** — bind the path today where every release agent
  reads it, and file the mechanical enforcement as the D4 later step.

## Decision Outcome

**A release publishes through the gated release command. A hand-cut release PR is not a sanctioned
path.**

Concretely, for every repo on the roster:

1. Cutting a release means running the vended release command over the workspace. It computes the
   changed set, runs the gates — content scrub and declared floors — orders the publishes, cuts
   and pushes the tags, and polls each one to published.
2. An agent does not hand-author a release PR that bumps versions and pushes tags, and does not
   substitute a self-assembled gate list for the command's gates. `analyze`, `format`, `test` and
   `dry-run` are not a release gate: none of them resolves the package against its own declared
   floors, which is the failure that ships a broken package to consumers.
3. When the command cannot be used, that is a defect to report, not a path to route around.

D4 remains in force and is narrowed, not replaced: the gate is still governor-run through the
release command, and this entry states that the command is the only sanctioned route to a tag.
Moving the gate into CI is the enforcement half and is filed as its own work; until it lands, this
ruling is what binds.

### Consequences

* Good, because the rule now resolves from the org register, so it reaches every substation's
  release agent instead of only `power_station`'s.
* Good, because it names the specific false gate list that shipped rc.22, so the next agent
  recognises its own behaviour in the prohibition rather than reading an abstraction.
* Good, because it costs no code and binds today, while the CI enforcement is scheduled honestly
  as ADR-0003 D4's named later step.
* Bad, because a convention is unenforced by construction: until the CI half lands, a determined
  or careless tag push still publishes ungated.
* Bad, because it adds a second register entry governing release behaviour, so a reader must hold
  this and D4 together until the enforcement bead retires the gap.
