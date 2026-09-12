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
  slug: knowledge-lives-in-the-smallest-surface-that-can-enforce-it
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:.beads/PRIME.md"
    - "roster:docs/decisions/*.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by:
    - no-session-links-in-commits-or-pull-requests
  bead: org-gze
  legacy-id: null
---

# Knowledge lives in the smallest surface that can enforce it

## Context and Problem Statement

The user memory index reached **151 entries in 24,652 bytes** — roughly **9,165
tokens re-billed on every turn of every session**, growing at about **440 tokens
per day, permanently**.

It got there honestly. A memory is the only surface with no gatekeeper: writing
one takes a sentence, needs no review, no release and no consumer. So a memory
became the default home for every durable lesson, whatever its actual shape.

Triaging all 151 entries found that only **41 were genuinely memories**. The
other 110 had a better home:

| what it really was | count |
|---|---|
| resolved, shipped, or obsoleted | 15 |
| an incident narrative around one residual lesson | 13 |
| a standing ruling | 23 |
| a rule nothing enforces | 39 |
| a procedure executed by remembering to | 18 |

Three findings sharpened the problem past cost:

* **A memory can be a workaround for an undiscovered flag.** "Capture bead ids
  from the Created line" existed because nobody had found `--silent`, which
  prints only the id. The system paid ~61 tokens per turn, forever, to remember
  something a flag already did.
* **A memory can be a bug report in disguise.** Three entries existed only to
  warn that a `CLAUDE.md` was wrong. On checking, two of those documents had
  already been fixed and the warnings had outlived them silently.
* **A memory cannot bind anything but the reader.** "No session links in PRs"
  is a standing ruling that lives only in the index — while the harness pushes
  an attribution instruction that contradicts it. A ruling in a memory loses to
  a ruling in a prompt, every time.

The cost asymmetry is the mechanism. **A memory is a push; every other surface
is a pull.** A register entry, a check, or a circuit step costs zero tokens
until something reaches for it. A memory costs its tokens on every turn whether
the session needed it or not — and the entries most likely to be dropped under
context pressure are exactly the ones that matter most.

## Considered Options

* **Cap or prune the index periodically.** Rejected: it treats the symptom. The
  rate is the problem, and a prune leaves the same default in place, so the
  index regrows at 440 tokens per day.
* **Trim skill descriptions and instruction files instead.** Rejected on
  measurement: the 13 skill descriptions are ~2,074 tokens, and their wording is
  what makes a skill fire at the right moment. They are the smallest of the
  controllable surfaces and the wrong thing to shrink.
* **Rule where knowledge goes, and make memory the last resort.** Chosen.

## Decision Outcome

**A durable lesson goes to the smallest surface that can enforce it.** Work down
this order and stop at the first that fits:

1. **Fix the defect.** If the lesson exists because something is broken,
   confusing, or undiscoverable — a wrong help string, a missing flag, a silent
   failure — the fix is the repair. A memory about a defect is a bug report that
   has given up.
2. **A check, flag, or requirement in code.** If a machine could refuse the
   mistake, it must. This binds every agent, including the ones that never read
   the memory.
3. **A step in the circuit that already runs it.** If the lesson is "do X before
   Y", the pipeline owns the ordering, not the reader's discipline.
4. **A register decision.** If it is a standing ruling, ratify it. It is then
   searchable, attributable, survives every session, and can be cited against a
   contradicting instruction.
5. **A memory.** Only what none of the above can hold: host and environment
   quirks, third-party bugs, measurement method, architectural facts, and
   judgement calibration.

**Three obligations follow.**

* **An entry that resolves is retired.** When the incident behind a memory is
  fixed, the memory is deleted or cut to its residual lesson in the same change.
  A memory marked FIXED or RESOLVED in its own text is already overdue.
* **Instruction surfaces are version-controlled.** An org-wide or station-wide
  instruction file that no repository tracks cannot be reviewed, cannot be
  received by anyone else, and cannot be corrected when it goes stale.
* **The index reports its own weight.** Entry count and byte size are recorded
  where a reader will see them, so growth is observed rather than discovered.

### Consequences

* Good, because the surface that is billed on every turn stops being the default
  home for everything, and stops growing by default.
* Good, because a lesson promoted to a check binds agents that never read the
  memory — including future seats and cheap models.
* Good, because a ruling in the register can be cited, and so can win against a
  contradicting instruction that a memory would silently lose to.
* Bad, because every route except the memory costs more to write — a check needs
  a test and a release, a decision needs a PR. The friction is the point, but it
  is real, and a lesson worth keeping can be lost while waiting for its proper
  home. Write the memory when the better surface is not ready, and mark it as
  owing a promotion.
* Bad, because "the smallest surface that can enforce it" is a judgement, and
  two readers will sometimes place the same lesson differently.

### Relationship to the self-description ruling

A sibling entry ruling that a station explains itself through `prime` and
bounded `--help` rather than through pushed instruction files is in review at
the time of writing. The two answer the same pressure from opposite ends: that
one governs what a station *publishes* about itself, this one governs where a
lesson *lands*. No register edge is authored here, because an edge must name an
entry that exists; add one when both are in force.

### Confirmation

In force when the index stops growing on net, and when a memory added after this
entry names which of the five rungs it sits on and why the rungs above it could
not hold it.
