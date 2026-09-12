---
status: accepted
date: 2026-09-09
decision-makers: [nico]
consulted: [governor]
informed: []
register:
  spec: 1
  slug: agent-instructions-have-one-source
  surfaces:
    - "CLAUDE.md"
    - "AGENTS.md"
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
  obsoletes: []
  updates: ["maintainer-and-user-docs-are-separate"]
  obsoleted-by: null
  updated-by: []
  bead: org-jlx
  legacy-id: null
---

# Agent instruction files have one source, and CLAUDE.md imports it

## Context and Problem Statement

`memento-engineering#maintainer-and-user-docs-are-separate` settled which audience each document
serves, and named `CLAUDE.md` and `AGENTS.md` together as the maintainer surface. It did not say
how the two relate, and treating them as peers is what went wrong immediately after it landed:
both files were rewritten in the same change, each got its own hand-written account of the repo,
and the result was two copies of the same guidance that would drift the moment either was edited
alone.

That is the same defect the entry was recorded to fix, one level down. The audience rule accepts
duplication *across* audiences, because a user doc and a maintainer doc genuinely say different
things in different voices. It does not license duplication *within* one audience, where the two
files say the same thing to two harnesses.

Different harnesses read different filenames — Claude Code reads `CLAUDE.md`, other agents read
`AGENTS.md` — so the filenames must both exist. Only the content needs to be singular.

## Decision Outcome

**`AGENTS.md` is the single source of agent instruction for a repo. `CLAUDE.md` carries no
content of its own: it imports `AGENTS.md` with an `@AGENTS.md` directive, or is a symlink to it.**

Prefer the `@AGENTS.md` directive over a symlink in any repo that is public or may be cloned on
Windows, where symlinks do not survive reliably. Both spellings satisfy this decision.

A tool-managed block that a generator writes into one file and not the other — `bd setup`'s
beads integration is the case in hand — is not a violation, because nobody maintains it by hand.
The rule governs authored prose.

### Consequences

* Good, because the guidance cannot drift between harnesses: there is one file to edit and one
  file to review.
* Good, because it removes the standing question of which file is authoritative when the two
  disagree. Previously the answer was "whichever the reader happened to open".
* Bad, because most of the roster does not comply today. `space_station`, `power_station` and
  `lenny` carry a substantive `CLAUDE.md` beside a boilerplate `AGENTS.md` — the inverse of this
  rule — and `the_grid` and `genesis` have no `AGENTS.md` at all. Bringing them into compliance is
  real work on five repos and is deliberately not bundled with this entry.
* Neutral, because `CLAUDE.md` remains a maintainer doc for the purposes of the entry this one
  updates. Its audience is unchanged; only its content is now a pointer.
