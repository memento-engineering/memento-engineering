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
  slug: a-station-explains-itself-through-prime-and-bounded-help
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:.beads/PRIME.md"
    - "roster:packages/*/extension/station_overlay/*/skills/*/SKILL.md"
    - "roster:packages/*/extension/station_overlay/*/agents/*.md"
  obsoletes: []
  updates:
    - power_station#a-mechanical-lookup-is-a-vended-command-with-a-bounded-output
  obsoleted-by: null
  updated-by: []
  bead: org-pee
  legacy-id: null
---

# A station explains itself through `prime` and bounded `--help`, not through pushed instruction files

## Context and Problem Statement

An agent learns a station today by being handed prose at session start. Every
session pays for the union of everything any session might need, before knowing
what this one is for.

Measured on a lunar session open — roughly **58,900 tokens** before the first
instruction is read:

| surface | tokens | share |
|---|---|---|
| user memory index | 8,985 | 15.3% |
| `CLAUDE.md` | 4,490 | 7.6% |
| 13 skill descriptions | 2,074 | 3.5% |
| tracker prime hook | 2,053 | 3.5% |

Station prose tokenizes at **2.69 characters per token, not 4**, so every
byte-based estimate previously made about these surfaces ran about 48% low. The
memory index also grows: roughly **440 tokens per day, permanently, in every
future session**.

Meanwhile the station already vends 25 verbs that can describe themselves, and
the discipline among them is uneven:

```
lunar --help          4,587 b   ~1,700 tokens   25 verbs, full paragraphs
lunar up --help       4,133 b   ~1,530 tokens   one verb
lunar read --help       778 b     ~288 tokens
lunar search --help     631 b     ~233 tokens
```

Two problems follow. First, the station that ratified
`a-mechanical-lookup-is-a-vended-command-with-a-bounded-output` has an
**unbounded `--help`**: that entry bound a command's *results* and never
mentioned the command's *description*, so the largest self-describing surface
in the system escaped the contract it was written to impose.

Second, `prime` — the one verb whose literal job is to orient a new session —
emits 1,850 bytes that are **entirely the issue tracker's reference** and say
nothing about the station it is named after.

The cost is not only tokens. An instruction file is a **copy** of what the code
does, and copies drift with nothing to catch them: the vended skills still name
`dart run lunar:lunar` for every verb, which is correct for the resident boot
and wrong for everything else, and no test failed, because prose has no
compiler.

## Considered Options

* **Keep pushing at session start.** Costs the union on every session, and the
  drift is unbounded because nothing verifies prose against code.
* **Put more into `AGENTS.md`.** Rejected: it enlarges the surface that already
  drifts, and concentrates into one file what each verb could answer for itself.
* **Progressive disclosure through `prime` and `--help`.** An agent pulls what
  this session needs. Chosen.

## Decision Outcome

**Three obligations.**

1. **`prime` explains the STATION, and points rather than restates.** It names
   the station's own verbs and where to learn each one. It does not copy a
   verb's contract into itself: whatever a verb's `--help` can answer, `prime`
   links to and must not duplicate. A `prime` that is entirely a dependency's
   reference is not answering for the station.

2. **Every vended verb's `--help` carries its own contract, within the bounded
   output budget the org already ratified.** This extends
   `a-mechanical-lookup-is-a-vended-command-with-a-bounded-output` to command
   descriptions, which it did not previously cover. A help text that cannot fit
   its budget **says what it withheld and how to ask for the rest**, exactly as
   the bounded read verb does. `read` and `search` already meet this bar and are
   the reference shape.

3. **Instruction files shrink to what no verb can answer** — policy, human
   rulings, and the constraints with no command behind them. Anything a verb can
   answer is **deleted** from prose, not duplicated into it. Duplication is the
   defect this entry exists to stop; a second copy that starts accurate is still
   a second copy.

### Consequences

* Good, because a session pays for what it asks for rather than for the union of
  what it might need, and the pulled set is measurably smaller than the pushed
  one.
* Good, because `--help` ships in the same binary as the verb it describes, so
  it cannot drift the way a separate prose file does.
* Good, because it makes the uneven discipline visible and fixable instead of
  invisible: two verbs already meet the bar and the outliers are now nameable.
* Bad, because discovery costs round trips, and a tool call is billed the whole
  context regardless of what it returns. The saving is real only while the
  pulled set stays smaller than the pushed set; a verb whose help must be read
  every session belongs in `prime`, not behind it.
* Bad, because a verb's help is only as good as that verb's author, where prose
  had a single editor. The bounded budget is the floor, not a substitute for
  writing the help well.

### Confirmation

In force when `prime` answers for the station rather than for the tracker, and
when the session-open measurement above is repeated with the share held by
pushed surfaces as the leading indicator.
