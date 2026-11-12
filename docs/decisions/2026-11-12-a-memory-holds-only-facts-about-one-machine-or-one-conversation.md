---
status: accepted
date: 2026-11-12
decision-makers:
  - "nico"
consulted: []
informed:
  - "governor"
register:
  spec: 1
  slug: "a-memory-holds-only-facts-about-one-machine-or-one-conversation"
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
  obsoletes: []
  updates:
    - "knowledge-lives-in-the-smallest-surface-that-can-enforce-it"
  obsoleted-by: null
  updated-by: []
  bead: null
  legacy-id: null
---

# A memory holds only facts about one machine or one conversation

## Context and Problem Statement

`memento-engineering#knowledge-lives-in-the-smallest-surface-that-can-enforce-it`
made a memory the last of five rungs, and
`memento-engineering#handoffs-are-working-memory-and-long-term-memory-stays-thin`
ruled that long-term memory stays thin. Both are in force. Neither held.

The governor's memory index stood at **124 entries** the day the second entry
was ruled. On 2026-11-12 it held **150**. The first entry's own confirmation,
that the index stops growing on net, has failed. Three causes showed up when
those 150 were sorted for a move into the lunar station's repository:

* **The last rung admits too much.** It keeps "host and environment quirks,
  third-party bugs, measurement method, architectural facts, and judgement
  calibration" in memory. Only the first of those is specific to a machine.
  Architectural facts, third-party bugs and measurement method are true on every
  machine, so a memory is the one surface that guarantees most readers never
  see them.
* **A memory store is local and keyed by checkout path.** A session started
  from another directory, or on another machine, starts without it. When the
  governor's sessions were to move from the grid checkout to lunar, lunar's
  store turned out to be a stale copy, eight entries behind. A repository that
  needs those files to be worked in cannot be cloned and worked in.
* **Nothing refuses a memory write.** The rule binds only a reader who
  remembers it, which is the defect the first entry names in everything else.
  About a third of the 150 record a mistake that a check could refuse, and no
  check was ever filed for them.

Nico, 2026-11-12: a memory is for facts about this machine or this
conversation; anything a fresh clone needs must live in a repository; anything
a mistake can violate should be enforced by code, not remembered; and this
holds for every project.

## Decision Outcome

**A fresh clone of a repository, on any machine, holds everything needed to
work in it.** No harness memory store is required to work correctly in any
memento repository.

**A memory holds only facts about one machine or one conversation:** the host,
its hardware, its local services and where its credentials live, and what the
current user said in the current conversation. Every other lesson takes the
first rung of
`memento-engineering#knowledge-lives-in-the-smallest-surface-that-can-enforce-it`
that fits it. That entry's last rung is narrowed to this, and its other four
are unchanged. The kinds it used to keep in memory move as follows:

* **Architectural facts** go to the repository's docs or its decisions.
* **A third-party bug** goes into a workaround in the code that hits it, with
  a test. Where no code can hold it, it goes into the docs of the repository
  that depends on that third party.
* **Measurement method** goes into the tool that measures, or into a script
  checked in beside it.
* **A procedure an operator follows** goes into a station verb, or into what
  `prime` and `--help` print, per
  `memento-engineering#a-station-explains-itself-through-prime-and-bounded-help`.
  Only a procedure no verb can answer is written as prose, in the repository
  of the station or tool it operates.
* **How to work with the owner** (vocabulary, how a ruling is put to him) goes
  in the agent instructions of the repository it applies to.

**Enforcement comes before remembering.** A lesson about a mistake that a
process could refuse is a defect, and it is filed as one: a bead for the
check, flag or verb that refuses it. When the warning cannot wait for that
check to land, a memory may hold it, and the memory names the bead that
retires it and is deleted when that bead closes.

This holds in every repository and for every harness. A harness's memory
system is a cache of what one machine and one conversation learned, never a
store of record.

### Consequences

* Good, because a new machine, a new seat or another harness works from a
  clone alone. Nothing it needs is stranded in a directory it never opens.
* Good, because a mistake that turns into a check binds every agent,
  including the ones that never had the memory.
* Good, because the test is a question with a yes or no answer: would a
  fresh clone on another machine need this? If yes, it is not a memory.
* Bad, because every lesson now costs a change to a repository: a doc edit, a
  decision entry or a filed bead. A lesson can be lost while its proper home
  waits. The bead-named memory above bounds that, but does not remove it.
* Bad, because the existing stores must be sorted down to machine and
  conversation facts. That is a one-time migration of roughly 140 entries for
  the governor alone, and each one needs a check against the code it
  describes before it is retired.
* Bad, because a memory write is still unchecked until a harness-side check
  refuses one that does not name its machine, its conversation or its
  retiring bead. Until that lands, this entry binds only a reader who has read it.
