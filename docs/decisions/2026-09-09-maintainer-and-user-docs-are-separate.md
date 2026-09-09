---
status: accepted
date: 2026-09-09
decision-makers: [nico, governor]
consulted: []
informed: []
register:
  spec: 1
  slug: maintainer-and-user-docs-are-separate
  surfaces:
    - "README.md"
    - "CLAUDE.md"
    - "AGENTS.md"
    - "engineering.memento/*/README.md"
    - "engineering.memento/*/CLAUDE.md"
    - "engineering.memento/*/AGENTS.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by:
    - agent-instructions-have-one-source
  bead: org-6dz
  legacy-id: null
---

# Maintainer docs and user docs are separate surfaces, and neither leaks into the other

## Context and Problem Statement

Every repo on the roster carries documentation for two audiences that do not overlap. Someone
**using** the thing needs to know what it does and how to adopt it. Someone **changing** the thing
needs to know how it is laid out, what the gate is, and which conventions bite. We had no rule
saying those are different documents, and both directions leaked.

Leaking maintainer content into user docs is the more expensive direction, because the roster now
has public repos. Decision records are the clearest case: an adopter of the decision-register
pattern does not care which of memento's internal calls produced it, and shipping that record to
them is noise at best and a disclosure at worst.

Leaking the other way is quieter but not harmless. A `CLAUDE.md` written in adopter framing tells
a maintainer nothing they need — and because nobody maintaining the repo reads the user doc for
its own sake, the user doc silently rots. Both failure modes were live when this was recorded: the
`decisions` repo is public, its `README.md` announced that the CLI, the asset pack, the skills and
the rubric were "not yet built" months after all four shipped, and its `CLAUDE.md` held four
copies of the same tracker quick-reference plus `_Add your build and test commands here_`.

## Decision Outcome

**A document serves exactly one audience, and says which.** The two surfaces are:

* **User docs** — `README.md`, `SPEC.md`, `templates/`, `schema/`, published package
  documentation, and anything else an adopter or a downstream consumer reads. Written for someone
  who will use this and never send a patch.
* **Maintainer docs** — `CLAUDE.md`, `AGENTS.md`, `docs/decisions/`, design notes, build-order
  documents, and handoffs. Written for someone who will change this and may never use it.

Neither borrows from the other. A user doc carries no decision records, no rationale for internal
choices, no build-gate mechanics, and no agent instructions. A maintainer doc does not re-explain
the product to the people maintaining it.

The test when placing a paragraph is which reader is worse off without it. If an adopter who will
never send a patch needs it, it is a user doc. If someone who will only ever change the code needs
it, it is a maintainer doc. If genuinely both need it, state it in each voice — do not link the
maintainer doc from the user doc to save the duplication.

This binds every repo the station mounts, including the private ones. It is filed in the org
register rather than in any one repo because it governs all of them.

### Consequences

* Good, because a public repo stops shipping internal noise to the people who clone it, and the
  question "does this belong here?" has a mechanical answer instead of a taste argument.
* Good, because a user doc that is nobody's by-product becomes somebody's deliverable — the stale
  `README.md` that motivated this was invisible precisely because it had no owner.
* Bad, because content that both audiences need is now written twice and can drift. The cost is
  accepted: a link from a user doc into maintainer material is the leak this entry forbids, so
  duplication is the honest form.
* Neutral, because the roster-wide `surfaces` on this entry resolve only from inside the umbrella
  directory. That is the tier-2 gap `memento-engineering#org-decisions-live-in-the-org-register`
  already recorded and CI already exempts; it is not new here.
