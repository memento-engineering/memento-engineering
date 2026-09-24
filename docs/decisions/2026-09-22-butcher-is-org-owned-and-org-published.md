---
status: accepted
date: 2026-09-22
decision-makers:
  - "nico"
consulted: []
informed:
  - "governor"
register:
  spec: 1
  slug: butcher-is-org-owned-and-org-published
  surfaces:
    - "org/AGENTS.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: null
  legacy-id: null
---

# butcher is org-owned and org-published, superseding the personal placement of the fork

## Context and Problem Statement

On 2026-09-09 a ruling placed the fork of the MIT-licensed Dart mutation-testing
package PERSONAL and PUBLIC: it was to live under the individual's namespace,
explicitly not under the org, and explicitly not vendored into any org
repository. A search of this register on 2026-09-22 found no entry recording
that ruling, so it is restated here by date and substance rather than cited by
slug, and the `obsoletes` list is empty because there is no entry to retire.

That ruling was right for what it described. The fork was one engineer's patched
copy of somebody else's package, kept as a bridge until the upstream caught up.
Nothing about it was an org deliverable, and pulling it into an org repository
would have put the org's name on a personal patch set.

The situation changed. The engine was certified sound in its own investigation —
it filters non-compiling mutants out of both mutation-score terms where the
runner it replaces counted every compiler failure as a kill, and it measured
roughly eight times faster — and it is now the instrument the org measures its
own test suites with. A tool the org depends on, publishes, and drives from its
station is no longer a personal bridge, and a superseded ruling that is not
recorded as superseded will be re-applied by the next reader.

## Decision Outcome

Four clauses, ruled 2026-09-22.

1. **butcher is org-owned and org-published.** It lives in a public repository
   under the `memento-engineering` org, and its packages publish to pub.dev
   under the org's publisher over trusted publishing, like every other org
   package. It is not a personal repository, and it is not vendored into
   another org repository either — it is its own repository.

2. **This supersedes the 2026-09-09 personal placement, for this tool only.**
   That ruling said the fork belonged under the individual's namespace and
   outside the org; it no longer governs, because the thing it governed stopped
   being one person's patched fork and became a package the org ships, depends
   on, and measures with. The earlier ruling remains TRUE of what it described:
   a personal patched fork of somebody else's package, kept as a bridge, still
   belongs under the individual's namespace. This entry moves the tool, not the
   principle.

3. **butcher is a derivative work, and it says so.** It carries the upstream
   project's full, unsquashed git history and stays under the upstream MIT
   license, with the upstream author's copyright line retained verbatim in every
   member's `LICENSE` beside the org's. The derivation is stated plainly in the
   READMEs and in the first changelog entry. Renaming the binary and restructuring
   the tree change nothing about the provenance that has to be carried.

4. **butcher is an ordinary attached substation.** Once it is armed on a
   station's roster it is governed under exactly the standing policy every other
   attached substation gets — see `govern-every-seat-alike-no-personal-repo-carve-out`,
   which already rules that there is no carve-out by repository owner. Being an
   org repository earns butcher no extra latitude and no extra hold; the named
   human gates still bind on the KIND of action, never on the repository.

This entry names no roster-wide surface. If a later amendment needs one, it uses
the `roster:` marker resolved against the composing station's coded roster, per
`roster-wide-surfaces-use-the-roster-marker`, and never a path beneath the
umbrella directory — that form could not reach butcher structurally.

### Consequences

* Good, because the placement is on the record BEFORE the repository is created,
  so the org's ownership of the tool is a decision rather than something
  rationalized after a repository already exists.
* Good, because the supersession is explicit: a reader who finds the 2026-09-09
  reasoning cannot apply it to this tool by accident, and still has it intact for
  the case it was actually about.
* Good, because the derivative-work clause is stated where placement is stated,
  so moving the tool into the org cannot quietly drop the upstream copyright.
* Bad, because an org-published package is a maintenance obligation the org now
  carries in public — deprecations, security reports and breaking-change
  discipline — where a personal fork could simply be abandoned.
* Bad, because org placement adds process the fork never had: the release gates,
  the required checks, and governance as an attached substation all apply from
  the first commit.

### Confirmation

The repository exists under the `memento-engineering` org, its members are
published on pub.dev under the org's publisher, every member's `LICENSE` carries
the upstream copyright line beside the org's, and the derivation is stated in the
READMEs and the first changelog entry. The substation is armed on the roster with
the org App and a live GitHub poll, and its pull requests merge under the standing
policy with no owner-based exception.
