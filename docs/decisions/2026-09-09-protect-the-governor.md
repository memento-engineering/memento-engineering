---
status: accepted
date: 2026-09-09
decision-makers: [nico, refiner]
consulted: []
informed: [governor]
register:
  spec: 1
  slug: protect-the-governor
  surfaces:
    - "CLAUDE.md"
    - "AGENTS.md"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: org-5wf
  legacy-id: null
---

# Protect the governor: auxiliary advisor seats absorb what a cheap model can resolve

## Context and Problem Statement

The governor is the station's operator seat. It runs a frontier model with the whole board in
context, and its attention is serial: every anomaly routed to it is paid for twice, once in tokens
and once in the operator's queue. That makes "wake the governor" the most expensive available
response to a signal, and it is currently the only one.

The cost became concrete on 2026-09-09. A work session had been paused since 2026-09-07 with no
writes to its worktree, holding one of six agent slots for two days. Nothing noticed. The bead it
carried could never finish on its own terms — its acceptance needed a human bounce window — so no
amount of waiting would have terminated it. It was found by reading worktree timestamps by hand.

The system is about to produce more signals of this kind, not fewer: two substations are about to
drive tests against one physical device with nothing arbitrating access to it.

Two obvious responses are both wrong.

Evicting a session on a timer is wrong. A time-to-live that hard-kills assumes we know how long
legitimate work takes, and we do not: the dispatched harness is not ours, and we do not control
whether it is designed for long autonomous runs. Hours-long sessions are unlikely under the
current architecture but entirely possible, and killing one is unrecoverable.

Escalating every anomaly to the governor is also wrong, because that is precisely the cost this
decision exists to avoid.

There is a third problem underneath both: the signals already exist and go nowhere. Flares are
emitted richly, but as fire-and-forget calls to an optional transport whose failures are
deliberately swallowed so that observability can never break admission. No operator-facing surface
subscribes to them — the watch verb's wait conditions are a closed set covering gates, session
terminals, bead status and ready count, and flares are not among them.

## Considered Options

* A time-to-live that evicts or reaps a stalled work session.
* Escalate every stall, refusal and contention signal to the governor.
* An auxiliary advisor seat that absorbs the signal and escalates only what it cannot resolve.

## Decision Outcome

Chosen option: **an auxiliary advisor seat**.

Auxiliary seats — advisor, assistant, helper — are a seat category alongside the build, spec,
critic and gather seats, expressed the same way those are: as a type, so that a station arms one
without naming a string and without a role map. An auxiliary seat has a narrow, well-defined
mission, a limited but configurable tool set, and runs a cheap, fast model.

The rules that make it "protecting the governor" rather than just another agent:

1. **A liveness signal triggers observation, never eviction.** A time-to-live on a work session may
   only cause something to look at that session. It may never end it. The advisor inspects and
   decides whether the desired state needs to change because the session is stuck, or whether to
   let it ride.
2. **The advisor sets its own next horizon.** When it decides to let a session ride it offers the
   interval or duration after which the question should be asked again, or declines and lets the
   system choose. A verdict therefore extends the window rather than merely passing, so a healthy
   long-running session is not re-inspected on every tick.
3. **Auxiliary seats never consume work-slot capacity.** They are not admitted against the pool
   that work sessions draw from. They are still bounded, under their own separate ceiling — not
   counting against work is not the same as being uncounted, and an unbounded advisor population is
   its own failure.
4. **Their existence is optional and declared by presence.** A station that mounts an advisor has
   one; a station that does not, does not. This follows the register's existing availability rule —
   presence in the tree is the truth, and nothing consults a separate configuration flag to
   discover it.
5. **Absence fails open to the governor.** When no advisor is mounted the signal escalates: the
   governor is flared, and the protection is simply not in force. Omission degrades the system to
   today's behaviour; it never silently drops the signal.

### Consequences

* Good, because the governor is woken only for what a cheap model could not resolve, which is the
  stated purpose.
* Good, because a stalled session is finally noticed by something, without any timer being given
  the authority to kill work it cannot evaluate.
* Good, because it composes from patterns the org already ratified — a typed seat, availability by
  presence in the tree, and the existing per-station work-policy hook — rather than introducing a
  new mechanism.
* Bad, because a cheap model will sometimes be wrong, and a mistaken "let it ride" delays detection
  by at least the horizon it just set.
* Bad, because rule 5 is not yet real. Flare delivery does not exist: emitting a flare today reaches
  no operator surface, so until that is built, omitting the advisor is silent rather than
  escalating. Rule 5 is a commitment that flare delivery must land before advisors are treated as
  optional in practice.

### Confirmation

This decision is only in force once a flare emitted with no advisor mounted reaches the governor
through some subscribed surface. Until then, treat auxiliary seats as required rather than
optional, because the documented fallback is inert.
