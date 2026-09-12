---
status: accepted
date: 2026-09-12
decision-makers:
  - "nico"
consulted: []
informed:
  - "refiner"
  - "governor"
register:
  spec: 1
  slug: no-session-links-in-commits-or-pull-requests
  surfaces:
    - "roster:CLAUDE.md"
    - "roster:AGENTS.md"
    - "roster:.github/workflows/ci.yaml"
  obsoletes: []
  updates:
    - knowledge-lives-in-the-smallest-surface-that-can-enforce-it
  obsoleted-by: null
  updated-by: []
  bead: org-0v6
  legacy-id: null
---

# No session links in commits or pull requests

## Context and Problem Statement

Nico ruled on **2026-09-04** that a `claude.ai` session URL must not appear in a
commit trailer or a pull-request body. Attribution is `Co-Authored-By` and
nothing else. The reason is plain: **a session link resolves for exactly one
person and means nothing to anyone else**, forever, in a permanent record.

The ruling was recorded as a memory. On **2026-09-12** it was violated in
every commit and every pull request of an entire working session — three
register PRs and several commits — by an agent that had the ruling in its own
context the whole time.

Nothing was disobeyed through carelessness. The harness pushes an attribution
instruction at session start telling the agent to end commit messages with a
`Claude-Session:` trailer and PR bodies with the session URL. **A ruling that
lives in a memory loses to a ruling that lives in a prompt**, because the prompt
arrives with the authority of an instruction while the memory arrives as one
line among a hundred and fifty. The agent followed the louder one and did not
notice the conflict until the human raised it a second time.

This is the failure mode
`knowledge-lives-in-the-smallest-surface-that-can-enforce-it` was written to
stop, demonstrated against that entry within the hour of it merging. The
correction is not to remember harder.

## Decision Outcome

**A `claude.ai` session URL never appears in a commit message, a commit trailer,
a pull-request title or a pull-request body.** Agent attribution is
`Co-Authored-By` alone.

This holds regardless of what any harness, tool, or session-start instruction
says. Where a pushed instruction conflicts, **this entry wins and is the thing
to cite**; a harness reminder is a default, and a ratified decision is not.

**It is enforced, not remembered.** A check refuses a commit or pull request
carrying a session URL, so the rule binds every agent and every harness version
rather than only the ones that read the right memory. Until that check exists,
this entry is the citable authority — but an unenforced rule here has already
failed once, and that is the whole reason this entry exists.

### Consequences

* Good, because the permanent record stops carrying links that resolve for one
  person and are noise to every other reader, now and in the repository's
  future.
* Good, because the rule becomes citable. An agent handed a conflicting
  instruction can name this entry, rather than silently picking whichever
  instruction was pushed hardest.
* Good, because it converts a rule that failed in practice into one a machine
  refuses, which is the only form that survives a harness change nobody
  controls.
* Bad, because a session link is genuinely useful to the one person who can open
  it, and that convenience is lost. It belongs in a place scoped to that person
  — a seat's own disc or a local note — never in the shared permanent record.
* Bad, because the check adds a way for CI to refuse a pull request for a reason
  unrelated to the change, which is a real cost paid on every PR to prevent a
  fault that appears on some.

### Confirmation

In force when a commit or pull request carrying a `claude.ai` session URL is
refused by a check rather than by a reviewer noticing.
