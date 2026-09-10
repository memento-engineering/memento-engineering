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

# Protect the governor: relay seats absorb what a cheap model can resolve

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
* A relay seat that absorbs the signal and escalates only what it cannot resolve.

## Decision Outcome

Chosen option: **a relay seat**.

**Relay** here means a PROTECTIVE relay, in the power-grid sense that already gives the governor its
name — the device that senses an abnormal condition and decides whether it warrants action. It does
not mean a forwarding relay in the mail-server sense. The distinction matters and is the whole
design: in a power system the relay decides and the breaker acts, and a relay seat is deliberately
given the deciding half and never the killing half.

The name carries two further properties of the real device, both of which are load-bearing below.
Relay COORDINATION — selectivity — is the established practice of letting the device closest to a
fault clear it so upstream devices never see it, which is this decision's title stated in
engineering terms. Relay TIME GRADING — waiting longer for smaller deviations — is rule 2.

Relay seats are a seat category alongside the build, spec, critic and gather seats, expressed the
same way those are: as a type, so that a station arms one without naming a string and without a role
map. A relay seat has a narrow, well-defined mission, a limited but configurable tool set, and runs
a cheap, fast model.

The rules that make it "protecting the governor" rather than just another agent:

1. **A liveness signal triggers observation, never eviction.** A time-to-live on a work session may
   only cause something to look at that session. It may never end it. The relay inspects and
   decides whether the desired state needs to change because the session is stuck, or whether to
   let it ride.
2. **The relay sets its own next horizon.** When it decides to let a session ride it offers the
   interval or duration after which the question should be asked again, or declines and lets the
   system choose. A verdict therefore extends the window rather than merely passing, so a healthy
   long-running session is not re-inspected on every tick.
3. **Relay seats never consume work-slot capacity.** They are not admitted against the pool that
   work sessions draw from. They are still bounded, under their own separate ceiling — not counting
   against work is not the same as being uncounted, and an unbounded relay population is its own
   failure.
4. **Their existence is optional and declared by presence.** A station that mounts a relay has one;
   a station that does not, does not. This follows the register's existing availability rule —
   presence in the tree is the truth, and nothing consults a separate configuration flag to
   discover it.
5. **Absence fails open to the governor.** When no relay is mounted the signal escalates: the
   governor is flared, and the protection is simply not in force. Omission degrades the system to
   today's behaviour; it never silently drops the signal.

### The refuse-by-default posture, and its one exception

A mounted relay's default verdict is to ABSORB — to refuse to pass the signal upstream. Escalation
is the exceptional outcome a relay must justify, not the fallback it reaches for when unsure. That
default is what makes rule 1 safe to arm widely: a relay that escalates when uncertain is a slower,
more expensive governor.

The exception is not optional. Refuse-by-default governs the relay's VERDICT, never its FAILURE. A
relay that cannot answer — unmounted, erroring, timed out, out of capacity under rule 3, or
otherwise unable to reach a verdict — must escalate, exactly as rule 5 requires for absence. Any
implementation in which a broken relay silently absorbs has inverted this decision and reintroduced
the two-day stall it was written to prevent.

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
* Bad, because "relay" collides with the forwarding sense of the word that is common in software.
  The protective-relay reading is stated above and in the seat's own documentation, and the
  coordination framing is the tell, but the collision is real and a reader may need the pointer.
* Bad, because rule 5 is not yet real. Flare delivery does not exist: emitting a flare today reaches
  no operator surface, so until that is built, omitting the relay is silent rather than escalating.
  Rule 5 is a commitment that flare delivery must land before relays are treated as optional in
  practice.

### Confirmation

This decision is only in force once a flare emitted with no relay mounted reaches the governor
through some subscribed surface. Until then, treat relay seats as required rather than optional,
because the documented fallback is inert.
