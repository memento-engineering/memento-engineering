---
status: accepted
date: 2026-09-12
decision-makers:
  - "nico"
consulted:
  - "operator"
informed:
  - "governor"
  - "refiner"
register:
  spec: 1
  slug: approval-is-stamped-last-and-an-agent-stamps-its-own-bugs
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:.claude/skills/intake-refinement/SKILL.md"
    - "roster:.agents/skills/intake-refinement/SKILL.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: org-1w6
  legacy-id: null
---

# Approval is stamped last, and an agent stamps its own bugs

## Context and Problem Statement

The approval stamp is the mount gate: a bead carrying it becomes drivable, and a
bead without it does not. Two questions about that stamp — **who** may write it
and **when** — were each answered by a human ruling, and neither answer was ever
written anywhere that binds an agent.

**The ordering half was ratified and then owed.** `the_grid#tg-89y8` recorded
the filing protocol on 2026-08-30 and said in as many words that it "needs a
MADR doc in the decisions register… this bead is the durable record until the
doc lands." The doc never landed. Thirteen days later the bead still carries the
note "the MADR doc this decision asks for is still owed."

**It is also homed wrong.** `tg-89y8` sits in one repository's local register,
but the filing protocol governs every store the station arms. A decision homed
in one repo governs one repo, so agents filing into the other stores were never
reachable by it.

**The ordering had already failed in production.** `pow-n6n.2`, `.3` and `.4`
were approved at create time and mounted seconds later, ahead of their own
blocker, because the stamp landed before the dependency edges did. Nico: *"we
need to fix this mechanically."*

**The authority half lived only in the memory index**, which by
`knowledge-lives-in-the-smallest-surface-that-can-enforce-it` is the one surface
that binds nobody but its reader.

## Decision Outcome

**WHO writes the stamp.**

* An agent stamps **bug**-type beads itself, with no per-bead ask. Nico,
  2026-08-31: *"approve jgaz. you should be free to approve bugs."*
* The governor **self-approves** operator-filed defect and hygiene beads,
  receipts required. The `--defer` staging step that used to precede this is
  retired ceremony, not a gate (ratified 2026-09-01).
* **Every other type needs the human**, and the stamp records which human ruled.
  A collective wave at a list of beads is not a ruling; the ruling is per bead.

**WHEN it is written: LAST.**

1. File the bead **unapproved**, carrying evidence, acceptance criteria, and a
   **draft `validation_plan`**. The plan is mandatory at filing time, so a
   committee can never read its absence as an F-grade implementation plan.
2. Deduplicate against prior art, then adjust scope and priority.
3. Wire **every** dependency — local `dep` edges and cross-store link beads
   alike.
4. Only then stamp, recording the approver, the time, and **the bead revision
   the approval was made against**.

A stamp written before step 3 is the `pow-n6n` failure: the child mounts ahead
of its blocker and the graph is a lie.

**It is enforced, not remembered.** `power_station#pow-kps` shipped the approve
verb with the FilingContract preflight, and the mount predicate refuses a bare
label — only a verb-written stamp mounts. That is why this entry can be short:
it records an authority boundary and an order, and the machine already holds the
rest.

### Consequences

* Good, because the common case — a bug — stops costing a round trip, while the
  cases where a human's judgement actually differs still reach them.
* Good, because it discharges `tg-89y8` and re-homes the protocol to the register
  that every substation resolves, so agents outside `the_grid` are reachable by
  it for the first time.
* Good, because "recorded against a revision" makes an approval auditable after
  the fact rather than a bare boolean.
* Bad, because stamping last means a correctly-shaped bead sits unapproved while
  its edges are wired, and an agent that stops there leaves work stranded that
  looks ready.
* Bad, because the bug/not-bug line is a type field, and a mis-typed bead
  therefore silently changes who is allowed to approve it.

### Confirmation

`the_grid#tg-89y8` closes with receipts when this entry merges; that bead's own
exit condition is this document existing. The mechanism is already provable: a
bead carrying a bare `grid.approved` label does not mount, and the approve verb
refuses to stamp until the filing contract's four requirements pass.
