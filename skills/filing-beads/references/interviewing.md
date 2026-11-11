# Interviewing the owner

Use this when a person is in the loop and the bead has load-bearing calls you
cannot ground in the register or the code.

## Rules

- **One question at a time.** Wait for the answer before the next.
- **Lead with your recommendation.** "I'd do A because …; B costs …; which?" is
  faster to answer than an open question, and shows your reasoning.
- **Multiple choice when the space is small**, open-ended when it is genuinely wide.
- **Ask only what changes the bead.** If either answer leads to the same
  acceptance criteria and design, do not ask.
- **Stop when the determinacy bar holds.** Two agents would now write the same
  criteria and take the same approach. Do not keep going for completeness.
- **Say what you heard back** in one line before filing, when the answers changed
  the shape of the bead.

## What to ask, by readiness axis

Work down this list and skip any axis already settled.

**Scope**
- "This looks like two changes: X and Y. Can either ship alone? If so, two beads,
  with X first?"
- "Is this a change to build, or a question you want answered first?"

**What done means**
- "How will we know it works? I'd pin it with a test that does …; enough?"
- "What should happen when <the failure case>?"
- "Does anything visible change for a user or caller, or is it internal?"

**Approach**
- "There are two ways: A (…) or B (…). I'd take A because …. Which?"
- "Where should this live: <package/file> or <other>?"
- "Is it acceptable to change <public API / wire format / stored data>?"

**Constraints**
- "Decision <slug> says …; does this bead follow it, or is it changing it?" A
  change to a recorded decision is a ruling: record it first, then file the bead
  citing the new entry.
- "Does this wait on anything else, in this repo or another?"

## Grilling yourself when no one is there

An autonomous agent asks the same questions of the register and the code. For
each one:
1. Answer it from a citation (`path:line` or a decision slug), or
2. Make the call and write "Decided: … because …" in the design, or
3. If neither is honest, the bead is the owner's: capture it as a draft with the
   question in its description.

## Anti-patterns

- A questionnaire: five questions in one message.
- Asking what the code or register already answers.
- Asking for approval of every section after the owner has made the call.
- Filing with "TBD" or "either X or Y" because the interview stopped early.
