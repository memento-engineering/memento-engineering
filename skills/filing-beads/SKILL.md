---
name: filing-beads
description: >-
  Files and refines beads (bd issues) so an agent that never saw the
  conversation can build them on first read: one decided change, acceptance
  criteria as pinned tests, the surfaces it touches and the recorded decisions
  that bind them. Use when turning a conversation, finding, bug, GitHub issue or
  idea into a bead, when capturing a quick follow-up to refine later, or when a
  bead was held or sent back. Works with a person in the loop (interview them)
  or autonomously (decide, and record what was assumed). Triggers: "file a
  bead", "track this", "make a ticket", "capture that", "refine this bead",
  "why was it held".
compatibility: Requires the bd CLI, run from inside the repository whose store holds the bead. The decisions CLI is used where the repository keeps a register.
metadata:
  author: memento-engineering
  version: "0.3.0"
---

# Filing beads

A bead is a brief for an agent that has never seen this conversation. The test
every bead must pass: would two independent agents, given this bead and nothing
else, write the same acceptance criteria and take the same approach?

**Built by a grid station?** If the repository's beads are built by a grid
station (it appears in a station roster, such as lunar's), read
[references/grid-station.md](references/grid-station.md) now. The station adds
fields and rules on top of everything below.

Pick a mode.

| Mode | When | Ends with |
|---|---|---|
| **Capture** | Something worth tracking came up mid-task and refining it now would derail the task | A deferred draft nothing will build |
| **File** | The work is understood well enough to decide it now | An open bead that passes lint |
| **Refine** | A draft, or a bead that was held or sent back | The same bead, now passing lint |

## Capture

Write what you know, keep it out of the ready queue, and move on.

```bash
bd create --actor <you> --type <type> --priority 3 \
  --title "<the change, as a sentence>" \
  --description "<what prompted it, what you know, what is undecided>" \
  --defer +30d --labels draft
```

- `--defer` keeps it out of `bd ready` and out of any station's admission; the
  `draft` label says why.
- Put open questions in the description as questions. Do not invent answers to
  make it look finished.
- Tell the person you captured it, with its id.

## File

Progress:
- [ ] 1. Find the home store and check for an existing bead
- [ ] 2. Settle the type and the scope: one change
- [ ] 3. Decide the load-bearing calls (interview, or decide and record)
- [ ] 4. Name the surfaces and the decisions that bind them
- [ ] 5. Write the fields
- [ ] 6. Lint, fix, lint again
- [ ] 7. Create, wire dependencies, read it back

**1. Home store and duplicates.** The bead lives in the store of the repository
whose code it changes. `cd` into that repository and run bd there. Search first:
`bd search "<two or three distinctive words>"`. An existing bead that covers it
gets an edit, not a twin.
- Search from three or four angles. A search that returns nothing is not proof
  nobody owns the work: searches cap their results.
- Read the closed hits too. A close reason names where a bead's leftover work
  went ("split to X"), and that bead is often the real owner. A closed bead can
  also have left part of its listed surface undelivered: compare its surface list
  with what its close reason says landed, and file the missing part as a
  follow-up that cites it (`--deps discovered-from:<id>`), not as a fresh bead.

**2. Type and scope.** Run `bd types` for the types this store accepts, each with
its meaning, and `bd types --sections` for the sections each type requires. Two
changes are independent when each has its own acceptance criteria and either can
ship and be reverted alone; independent changes are two beads, linked with
`bd dep add` when one must land first. A question ("should we…", "investigate
whether…") is a `spike` or a `decision`, not a change to build.

**3. Load-bearing calls.** List every place two agents could diverge: what done
means, where the change lives, which of two designs, what happens on failure.
- With a person: interview them. Read [references/interviewing.md](references/interviewing.md)
  before the first question.
- Autonomous: make each call from the register and the code, and write in the
  design which calls you made and why. A call you cannot ground in either is the
  owner's: capture the bead instead and name the question.

**4. Surfaces and constraints.** Name the files, symbols and packages it touches
with `path:line` pointers. Where the repository keeps a decision register
(`docs/decisions/`), cite every entry that governs those surfaces, newest first:
read [references/register.md](references/register.md).
- **Name the primitives the package already owns.** When the change touches a
  package with established seams (a service, a parser, a runner), name the one to
  compose, with its `path:start-end` and the code that already uses it that way.
  A bead that names only the defect site invites a from-scratch design. Cite
  line ranges for large files, not bare paths: a reviewer's gathered context
  clips a long file.
- **Put the architecture in every child bead.** An epic's design never reaches
  the agent that builds a child: state the target package, the dependency
  direction and the seams not to touch in each child's own text.

**5. Fields.** Read [references/fields.md](references/fields.md) for what each
field holds and a template.

**6. Lint.** `bd lint <id>` checks the sections the type requires. For the rest,
run `scripts/lint-bead.sh <id>`, or `scripts/lint-bead.sh --draft <dir>` before
the bead exists (see the script's header). Fix every FAIL; read every WARN and
fix it or say why it stands.

**7. Create and verify.**
```bash
bd create --actor <you> --type <type> --priority <0-4> --title "<…>" \
  --body-file desc.md --design "$(cat design.md)" \
  --acceptance "$(cat acceptance.md)" --json
bd dep add <new-id> <blocker-id> --actor <you>    # only after both ids exist
bd show <new-id> --json                            # read it back
```

## Refine

1. `bd show <id> --json`, and read why it was held or sent back (for a station's
   hold, see references/grid-station.md).
2. Fix the finding in the field it belongs to: scope and approach in the design,
   done-ness in the acceptance. Never answer a finding only in notes; a builder
   reads the design and the acceptance, not the notes. When a ruling voids part
   of an earlier design, rewrite the description and acceptance to carry it and
   clear or rewrite the design too: a binding note beside a contradicting design
   is not a decided approach.
   - Verify a reviewer's claim before it goes into the bead. A rationale mixes
     what the reviewer checked with framing it did not; "X is already wired" is
     the claim most often wrong. Run the grep, `bd show` or file read yourself.
3. A finding that needs a decision you cannot ground is the owner's. Ask (with a
   person) or note it and leave the bead held (autonomous).
4. Lint. For a draft, then: `bd update <id> --status open --actor <you>` and
   `bd label remove <id> draft`.

## Gotchas

- Never write a bead id that does not exist yet. Create the bead, then reference
  the id bd returned.
- No absolute paths (`/Users/…`, `/tmp/…`) in bead text. Use repository-relative
  paths.
- `--notes` replaces the notes; use `--append-notes` to add.
- Always pass `--actor`. Without it bd records the git user, and nobody can tell
  an agent's edits from the owner's.
- Write long text through `--body-file` or `"$(cat file)"`. Backticks inside a
  double-quoted shell argument get executed; a NUL truncates silently. Read the
  bead back after every write.
- Never cite a decision that the bead's own work will create. Cite what exists.
- Never write an either/or into the design. An undecided fork is the first thing
  a reviewer holds.
- When you fix one term in a list ("bind it to the attempt, role and fence")
  because it names something that does not exist, check every other term in that
  list against the code and the register. Lists are written in parallel, so the
  defect rarely appears alone.
- When you withdraw a design in one bead, sweep the text of every bead that
  depends on it. Their text still describes what you withdrew, and their builders
  will build it.
- Never pin an exact pre-release version of a sibling package in acceptance
  criteria. It is stale the moment a new wave publishes. Write "the version a
  plain `pub get` resolves".
- Run bd from the store's repository, never through `bd -C`, which can read the
  wrong store.
