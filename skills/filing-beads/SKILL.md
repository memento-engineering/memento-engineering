---
name: filing-beads
description: >-
  Files and refines work beads so a grid station can build them on first read:
  one decided change, acceptance criteria as pinned tests, a validation plan,
  the surfaces it touches and the register decisions that bind them. Use when
  turning a conversation, finding, bug, GitHub issue or idea into a bead, when
  capturing a quick follow-up to refine later, or when a bead was held by
  readiness. Works with a person in the loop (interview them) or autonomously
  (decide, and record what was assumed). Triggers: "file a bead", "track this",
  "make a ticket", "capture that", "refine this bead", "why was it held".
compatibility: Requires the bd CLI, run from inside the repository whose store holds the bead. The register verbs (grid decisions or the decisions CLI) help but are optional.
metadata:
  author: memento-engineering
  version: "0.1.0"
---

# Filing beads

A bead is a brief for an agent that has never seen this conversation. The
station's readiness review asks one thing of it: would two independent agents,
given this bead and nothing else, write the same acceptance criteria and take
the same approach? Everything here serves that test.

Pick a mode first.

| Mode | When | Ends with |
|---|---|---|
| **Capture** | Something worth tracking came up mid-task and refining it now would derail the task | A deferred draft the station will not build |
| **File** | The work is understood well enough to decide it now | An open bead that passes intake |
| **Refine** | A draft, or a bead readiness held | The same bead, now passing intake |

## Capture

Write what you know, keep the station off it, and move on.

```bash
bd create --actor <you> --type <task|bug|feature> --priority 3 \
  --title "<the change, as a sentence>" \
  --description "<what prompted it, what you know, what is undecided>" \
  --defer +30d --labels draft
```

- `--defer` keeps it out of admission until it is refined; `draft` marks why.
- Put open questions in the description as questions. Do not invent answers to
  make it look finished.
- Tell the person you captured it, with its id.

## File

Progress:
- [ ] 1. Find the home store and check for an existing bead
- [ ] 2. Settle scope: one change
- [ ] 3. Decide the load-bearing calls (interview, or decide and record)
- [ ] 4. Name the surfaces and the decisions that bind them
- [ ] 5. Write the fields
- [ ] 6. Lint, fix, lint again
- [ ] 7. Create, wire dependencies, read it back

**1. Home store and duplicates.** The bead lives in the store of the repository
whose code it changes. `cd` into that repository and run bd there. Search before
creating: `bd search "<two or three distinctive words>"` and `bd list --status open
--json | grep -i <word>`. An existing bead that covers it gets an edit, not a twin.

**2. Scope.** Two changes are independent when each has its own acceptance
criteria and either can ship and be reverted alone. Independent changes are two
beads, linked with `bd dep add` when one must land first. A question ("should
we…", "investigate whether…") is not a bead to build: it is a ruling for the
owner, or a spike typed as such.

**3. Load-bearing calls.** List every place two agents could diverge: what done
means, where the change lives, which of two designs, what happens on failure.
- With a person: interview them. Read [references/interviewing.md](references/interviewing.md)
  before the first question.
- Autonomous: make each call yourself, from the register and the code, and say in
  the design which you made and why. A call you cannot ground in either is the
  owner's: capture the bead instead and name the question.

**4. Surfaces and constraints.** Name the files, symbols and packages it touches
with `path:line` pointers, and cite every register decision that governs them,
newest first. Read [references/register.md](references/register.md) for how to
find them.

**5. Fields.** Read [references/fields.md](references/fields.md) for the template
of each field. In short: description says why and what; design holds the decided
steps; acceptance holds `- [ ]` criteria each pinned by a named test; the
validation plan goes in metadata.

**6. Lint.** Run `scripts/lint-bead.sh <file-or-id>` (see the script's header).
Fix every FAIL; read every WARN and fix it or say why it stands.

**7. Create and verify.**
```bash
bd create --actor <you> --type <type> --priority <0-4> --title "<…>" \
  --body-file desc.md --design "$(cat design.md)" \
  --acceptance "$(cat acceptance.md)" \
  --metadata '{"validation_plan":"<command>"}' --json
bd dep add <new-id> <blocker-id> --actor <you>    # only after both ids exist
bd show <new-id> --json                            # read it back
```

## Refine

1. `bd show <id> --json`. For a held bead, read the hold first: see
   [references/held-beads.md](references/held-beads.md).
2. Fix the finding in the field it belongs to: scope and approach in the design,
   done-ness in the acceptance. Never answer a finding only in notes; the builder
   reads the design and the acceptance, not the notes.
3. A finding that names a missing decision you cannot ground is the owner's. Ask
   (with a person) or note it and leave the bead held (autonomous).
4. Lint, then for a draft: `bd update <id> --status open --actor <you>` and
   `bd label remove <id> draft`.

## Gotchas

- Never write a bead id that does not exist yet. Create the bead, then reference
  the id bd returned. The station refuses text that names an unresolvable id.
- Never put "the gate passes" (`tool/gate.sh`, or the repository's gate command)
  in acceptance criteria. It turns into a build step that runs the whole gate,
  which the station forbids. The gate belongs in the validation plan only.
- No absolute paths (`/Users/…`, `/tmp/…`) in bead text: they become failed
  anchors. Use repository-relative paths.
- `--notes` replaces the notes; use `--append-notes` to add.
- Always pass `--actor`. Without it bd records the git user, and nobody can tell
  your edits from the owner's.
- Write long text through `--body-file` or `"$(cat file)"`. Backticks inside a
  double-quoted shell argument get executed; a NUL truncates silently. Read the
  bead back after every write.
- Never cite a decision that the bead's own work will create. Cite what exists.
- Never write an either/or into the design. An undecided fork is a readiness hold.
- Run bd from the store's repository, never through `bd -C`, which can read the
  wrong store.
- A bead filed while a station runs can be picked up within minutes. File it
  deferred if it must wait.
