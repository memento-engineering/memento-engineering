---
status: accepted
date: 2026-11-10
decision-makers: [nico]
consulted: [governor]
informed: []
register:
  spec: 1
  slug: a-release-is-a-bump-pr-then-a-guarded-tag-push
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:.github/workflows/publish.yml"
  obsoletes:
    - releases-publish-only-through-the-gated-release-command
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: null
  legacy-id: null
---

# A release is a bump PR, then a guarded tag push

## Context and Problem Statement

`releases-publish-only-through-the-gated-release-command` made power_station's release command the
only sanctioned route to a tag. power_station is retired, the command runs nowhere, and it never
handled a tag-distributed (`publish_to: none`) package anyway (decisions bead dec-fpb). Every
release since has been cut by hand, under a rule that forbids exactly that. The org needs a rule
that describes the path releases actually take, until the grid carries a release circuit.

## Decision Outcome

**A release is a pull request that bumps the version, then an annotated tag pushed on its merge
commit once the version is checked against the tag.** For every repository on the roster:

1. The release PR sets each released package's pubspec `version` and turns its CHANGELOG's
   `## Unreleased` heading into the version. It changes nothing else.
2. It merges only with CI green on its head.
3. The tag is `<package>-v<version>`, annotated, on the merge commit, and is pushed only after a
   check in the same command that the pubspec at that commit reads exactly that version.
4. Who pushes follows `agents-publish-prereleases-humans-promote-to-stable`: an agent pushes a
   prerelease tag (dev, beta), and a stable tag is pushed by the owner or on his explicit go.
5. A dependent package's tag waits until the tag it depends on has published, read from pub.dev's
   versions list or, for a tag-distributed package, from the remote's tag.

Choosing this option was Nico's ruling of 2026-11-10 ("B for now"). The alternative, a Dart assets
package for the grid carrying the conventions and a release circuit that restores the
declared-floors gate, is deferred, not rejected.

This obsoletes `releases-publish-only-through-the-gated-release-command`. It is falsified when a
release circuit is the sanctioned path, or when a tag is pushed on a commit whose pubspec does not
read its version.

### Consequences

* Good, because the rule describes the path releases take, so following it is possible.
* Good, because the version-against-tag check, which caught a mis-tag on 2026-10-04, is part of
  the rule rather than a habit.
* Bad, because no gate resolves a package against its own declared dependency floors before it
  publishes; a package using a sibling's unreleased API can ship, as `grid_cli` 0.5.0-rc.22 did,
  until a release circuit restores that check.
