---
status: accepted
date: 2026-09-12
decision-makers:
  - "nico"
  - "refiner"
consulted: []
informed:
  - "governor"
register:
  spec: 1
  slug: handoffs-are-working-memory-and-long-term-memory-stays-thin
  surfaces:
    - "roster:.grid/seats/**"
    - "roster:.claude/skills/handoff/SKILL.md"
    - "roster:.agents/skills/handoff/SKILL.md"
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
  obsoletes: []
  updates:
    - knowledge-lives-in-the-smallest-surface-that-can-enforce-it
  obsoleted-by: null
  updated-by: []
  bead: org-3io
  legacy-id: null
---

# Handoffs are working memory; long-term memory stays thin

## Context and Problem Statement

`knowledge-lives-in-the-smallest-surface-that-can-enforce-it` established that a
memory is a **push** and every other surface is a **pull**, so knowledge belongs
in the smallest surface that can enforce it. It did not say which surface holds
knowledge that must simply *last*. Two failures followed from that gap, and they
are opposite in shape.

**A handoff was being used as long-term storage.** Counting commits per handoff
file on the lunar station disc on 2026-09-12:

| handoff | commits | written across |
|---|---|---|
| governor, `epoch-69-first-night` | **30** | 23:25 to 08:45, nine hours |
| governor, `gates-cleared-ofpn-workspace-ruling` | **13** | 12:14 to 13:18 |
| refiner, every note | **2** | one create, one delete-on-consume |

A note whose filename stamps `042326z` was still being rewritten at 08:45, so the
timestamp lied. A handoff rewritten thirty times has no single author moment: its
Resume section describes the state at the last write and its earlier sections
describe earlier states, with nothing marking which is which. A successor cannot
tell a decision that still stands from one superseded four hours later in the
same file.

The cause was structural, not carelessness. **Consuming** a handoff is a verb and
is enforced; **writing** one is a skill — prose an agent may follow or not — and
nothing refused a second write. A governor on a nine-hour watch had real
mid-shift state and no channel for it, so it overloaded the one writable note it
had.

**Meanwhile the long-term index kept regrowing**, because nothing said which
store owns durable knowledge. A triage the same day verified twenty-two
remembered "defects" against the live tree: **eight were already shipped and five
were already filed as open beads.** The backlog was true. The memory was stale —
and every stale entry was still billed on every turn of every session.

## Considered Options

Three shapes for a mid-shift checkpoint channel were genuinely weighed:

* **An ephemeral journal**, consumed with the handoff. Smallest disc, but it
  destroys a shift's working detail at the moment a successor might want it.
* **A durable indexed journal**, treated like a receipt. Loses nothing, but at
  roughly one checkpoint every nineteen minutes it would add about 1,800 tokens
  per turn per shift — the exact cost this register already ruled against.
* **A durable unindexed journal**, kept on disc but never in the index. Keeps
  the record at no per-turn cost.

All three were rejected. Each assumed a seat needs a *second* durable channel,
and that premise is what was wrong.

## Decision Outcome

**A handoff is WORKING memory.** It is written once at a boundary, picked up, and
deleted — a lifetime measured in minutes. It is never amended. A handoff that has
outlived its session is not an amended handoff; it is a seat that never handed
off. No journal note kind is added, because the checkpoint *is* a handoff, cycled
fast, and the succession verb already consumes one.

**Long-term memory stays THIN.** Durable knowledge about the system, its stations
and its substations lives in **beads, decisions and trajectories** — each
queryable on demand at zero standing cost. A memory entry or disc note that
duplicates what one of those already holds is deleted, not kept.

**The test for retiring one** is not whether a bead covers it. It is: *retire when
the knowledge is available on demand from a surface that WORKS; keep it when the
broken surface is exactly what the note describes.* Both halves bit in one pass.
A note recording `rework`'s real flags was retired even though its README is
still wrong, because `rework --help` is correct and one command away. A note
recording `link --prefix` was kept, though the same bead covers it, because that
option carries no help string at all — the on-demand surface is itself the
defect, and retiring the note would leave a reader with only a refusal that says
"unarmed" and points at the roster instead of the command line.

### Consequences

* Good, because a successor reads one document authored at one moment, and can
  trust that everything in it was true at the same time.
* Good, because a handoff's filename timestamp becomes reliable, so an aging
  unconsumed note is visible evidence that a seat is not handing off.
* Good, because it names the durable stores explicitly, which turns "should this
  be a memory?" from a judgement call into a lookup.
* Bad, because a seat that wants to checkpoint must now actually hand off and
  come back, which costs a succession cycle it previously avoided by amending.
* Bad, because retiring a note whose bead is filed but unlanded removes an
  in-the-moment warning while the defect is still reachable. The retirement test
  above bounds this, but it does not eliminate it.

### Confirmation

`power_station#pow-4gqo` makes the first half mechanical: a second write to an
existing handoff note is refused, no new note kind is added, and the age of an
unconsumed handoff is reported wherever a seat's state is read. The second half
is confirmed by the index shrinking without losing anything a reader still needs
— it went from 136 entries to 124 on the day this was ruled.
