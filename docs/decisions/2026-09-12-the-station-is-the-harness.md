---
status: accepted
date: 2026-09-12
decision-makers:
  - "nico"
consulted: []
informed:
  - "governor"
  - "refiner"
register:
  spec: 1
  slug: the-station-is-the-harness
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:.claude/agents/governor.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: org-tzs
  legacy-id: null
---

# The station is the harness

## Context and Problem Statement

On 2026-09-07, asked about basing station workflows on Claude Code's own
Workflow tool, Nico answered: *"i'm not particularly excited about basing our
workflows off of claude skills. This should be harness agnostic... the station
is the harness."* At that point a wave-2 design round (the `r6` cut-wiring run
— a design seat, two adversarial judges, and a verifier looping up to three
passes) was running as a Claude Code Workflow because the station had no
circuit of that shape yet. Nico let that specific run finish as the last one
of its kind, rather than interrupt it.

Running station-shaped multi-agent work — a design round, a judge panel, a
refinement sweep, a session-liveness watch — through the harness's own
orchestration instead of the station means its receipts land in a transcript
directory rather than the trajectory store, and the judge/verify shape gets
hand-rolled again each time instead of composed once. Two narrower gaps
existed at the time this ruling was made and needed a stopgap until their own
circuits landed: refinement work (spec-readiness holds, decompositions) and
session-watching (polling a resident station for stuck sessions).

**The design-round gap has since closed.** `power_station#pow-gy7o` gave the
docs-review circuit a fourth `ChangeShape` (`design`, admitted by an
`isDesignPath` predicate per ADR-0000/A36), four adversarial judge rubrics, and
a `DesignVerifyCapability` between the judges and the route step. It landed as
`power_station#251` (squash-merged 2026-09-08, plan re-run green, grades
A/B/B). A design round is a station bead today, not a Workflow run.

## Decision Outcome

**Station-shaped multi-agent work drives through a station circuit, never
Claude Code's Workflow tool and never an ad-hoc subagent panel.** Where the
station already has the circuit — code (spec → build → critic → land) and now
design (the docs-review circuit's `design` shape) — that circuit is the only
acceptable path. Where the station does not yet have the circuit for a given
shape of work, the gap is filed as a bead against the relevant substation and
driven as a station bead once it lands; it is not patched over with a
harness-side Workflow run.

**Two narrower stopgaps hold only until their own circuits land, and are
scoped tightly in the meantime:**

* **Refinement.** A spec-readiness hold or a decomposition is routine work a
  governor delegates to a scoped autonomous subagent (the `intake-refinement`
  skill, opus) that cures the bead body — deciding forks, naming surfaces,
  decomposing, wiring deps, running the filing exit check — and stops there;
  the governor still runs the gate exit and approves children under standing
  policy. The interactive refinement session is never messaged for routine
  cures; it is interrupted only for something that must reach the human there
  directly (a lock handoff, a bounce of a resident it booted, a ruling relay).
* **Session-watching.** Polling a resident station for a stuck or wedged
  session runs on a background cheap-model (sonnet) subagent that qualifies
  events against a fixed playbook and finishes with a digest only when the
  governor must decide or land. That subagent never merges, closes a bead,
  reworks, writes bead text, resets git state, or kills a process; it absorbs
  qualification turns, nothing more. `memento-engineering#protect-the-governor`
  (relay seats, tracked at `the_grid#tg-pwpy`) is the circuit that retires this
  stopgap once built — a relay seat replaces the sentinel subagent, not the
  governor's own watch.

**Whatever multi-agent work genuinely runs outside a station circuit — because
it is exploratory, one-off, or ahead of a circuit that does not exist yet —
is sized per seat, not run at blanket flagship effort.** Mechanical fan-out
(sweeps, inventories, extraction, forensics) runs on sonnet, or haiku for
trivial mechanical work, at low or medium effort. Rubric-scoped judging,
verification, and adversarial refutation runs on opus: a judge with a tight
rubric is verification, not invention, and does not need the flagship model.
Architecture design seats and the final synthesis deliverable are the only
seats that warrant the flagship, run as few seats at high effort. A harness's
own guidance that "token cost is not a constraint" does not override this; the
usage window is real and sizing against it is the owner's standing directive.

### Consequences

* Good, because circuit-driven work has its receipts in the trajectory store
  and its grades in the state store, reachable the same way as every other
  station bead, instead of scattered across a harness transcript directory.
* Good, because a design round no longer hand-rolls its own judge/verify shape
  each time it is needed.
* Good, because the two named stopgaps stay narrow and reviewable: each has an
  explicit "never does X" boundary and an explicit circuit that retires it.
* Bad, because a shape of work with no circuit and no acceptable stopgap named
  here still has no station-native path until one is filed and built; the
  temptation to reach for a Workflow run in that gap is exactly what this
  entry forecloses, so the gap has to be driven as a bead instead.
* Bad, because sizing every non-circuit seat by hand is a judgment call made
  fresh each time, and a miscalibrated seat (too cheap for a genuinely hard
  judgment, or flagship for mechanical fan-out) is a quality or cost mistake
  that survives until someone notices it.
