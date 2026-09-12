# Agent Instructions — `memento-engineering`

The org decision register. This is the ONE agent doc for this repo; `CLAUDE.md`
imports it.

**This repo is PUBLIC, and it holds no code.** It is memento's register of decisions that govern
the whole roster rather than any one repository.

The *format* — spec, schema, templates, CLI, skills, rubric — is a separate product and lives in
[memento-engineering/decisions](https://github.com/memento-engineering/decisions). Nothing here
reimplements it. Entries here cite it with the `decisions#<slug>` handle.

## Maintainer docs vs. user docs

This file and `AGENTS.md` are **maintainer docs**: how to work *on* this register. `README.md` is
a **user doc**: what the register is, for someone reading it rather than editing it.

Never leak one into the other. That is itself an entry in this register —
`org-6dz`, `memento-engineering#maintainer-and-user-docs-are-separate` — and it binds every repo
on the roster, not just this one.

## What belongs here, and what does not

| decision reaches | register |
|---|---|
| one repo | that repo's own `docs/decisions/` |
| more than one repo on the roster | **here** |
| the decision-register format itself | `decisions` |

The split is mechanical, not bookkeeping: a register's `surfaces` are resolved from the repo that
holds it, so an entry filed in the wrong repo cannot be checked from a clean checkout. See
`memento-engineering#org-decisions-live-in-the-org-register`.

## Adding an entry

Use the `decide` skill — it owns the write path (slug reservation, honest authorship, edge
choice, bead minting, first-write validation). In short:

1. Mint the bead **before** the file cites it, and never guess an id:
   `bd create "<title>" --type decision --description "..."`
2. Write `docs/decisions/YYYY-MM-DD-<slug>.md` carrying that id in `register.bead`.
3. Lint before reporting done:
   `dart run lunar:lunar decisions lint docs/decisions --repo-root .`

Entries are born `status: accepted`; this profile never uses `proposed`. `status`,
`obsoleted-by` and `updated-by` are a tooling-maintained cache — never hand-write a back-edge.

## The surface caveat — read before touching CI

An entry that governs other repos declares roster-wide `surfaces` such as
`roster:CLAUDE.md`. The suffix is a repository-relative glob, and `roster:<path>` means "this path
in every substation the roster mounts".

That is a known, accepted gap, not a bug to paper over: roster-wide surfaces resolve at tier 2,
where the composing station uses its coded `SpaceDelegate.substations` roster rather than walking
the filesystem. Until that path exists, `.github/workflows/ci.yaml` runs the full standalone lint
and exempts exactly one diagnostic class — `surface.unmatched` whose message begins
`surface "roster:`. Every other diagnostic, including an unmatched repo-local surface, is fatal.

Do not "fix" a red CI by narrowing a surface to something repo-local. The reach is real, and
flattening it records something false.

## Publishing — what an agent does without asking

Two entries here govern this, and they bind every repo on the roster:
`agents-publish-prereleases-humans-promote-to-stable` and
`prerelease-rungs-are-dev-beta-rc-and-rc-is-human-only`.

**An agent publishes PRERELEASES freely, with no per-release human ask.** That includes candidates:
once a package sits at `rc`, cutting `rc.2`, `rc.3`, `rc.4` is ordinary agent work. A release here
is a tag push, and pub.dev publishes it over trusted publishing — there is no credential and no
classifier refusal standing in the way.

**A human makes the PROMOTIONS.** Separate the two acts, because conflating them is what the
original wording got wrong and it cost a live session on 2026-09-11:

| act | example | who |
|---|---|---|
| Setting the rung — one-time | `beta.4` → `rc.1`, `rc.9` → `1.0.0` | **human** |
| Publishing at a rung — repeatable | `rc.1`, `rc.2`, `rc.3` … | **agent** |

`dev` → `beta` is the exception an agent owns, because its entry condition is machine-checkable:
no breaking API change against the previous prerelease of the same target version.

Nothing about this loosens the gates that carry outward or irreversible effect — merging to a
substation's main, the first live arm of a new composition, persistence and credential changes.
Nor does it retire the deterministic gates: the scrub, the declared-floors check and the dry-run
all still apply, and an agent still owes a plain statement when it publishes a breaking
prerelease.

## The substation

This repo is an armed substation on the memento roster: substation `memento-engineering`, bead
prefix `org`, work store in `.beads` (proxied Dolt, database `org`, custom type `decision`). It is
coded in `space_station`'s `SpaceDelegate.substations`, so it carries org App delivery and GitHub
issue intake like every other org substation.

There is no build and no test suite. The gate is the register lint above.

## Non-interactive shells

`cp`, `mv` and `rm` may be aliased to `-i` and will hang waiting for y/n. Always pass `-f`
(`rm -rf`, `cp -rf`); use `-o BatchMode=yes` for `ssh`/`scp`, `-y` for `apt-get`, and
`HOMEBREW_NO_AUTO_UPDATE=1` for `brew`.

<!-- BEGIN BEADS INTEGRATION v:1 profile:minimal hash:46cd31e7 -->
## Beads Issue Tracker

This project uses **bd (beads)** for issue tracking. Run `bd prime` to see full workflow context and commands.

### Quick Reference

```bash
bd ready              # Find available work
bd show <id>          # View issue details
bd update <id> --claim  # Claim work
bd close <id>         # Complete work
```

### Rules

- Use `bd` for ALL task tracking — do NOT use TodoWrite, TaskCreate, or markdown TODO lists
- Run `bd prime` for detailed command reference and session close protocol
- Use `bd remember` for persistent knowledge — do NOT use MEMORY.md files

**Architecture in one line:** issues live in a local Dolt DB; sync uses `refs/dolt/data` on your git remote; `.beads/issues.jsonl` is a passive export. See https://github.com/gastownhall/beads/blob/main/docs/core-concepts/sync-concepts.md for details and anti-patterns.

## Agent Context Profiles

The managed Beads block is task-tracking guidance, not permission to override repository, user, or orchestrator instructions.

- **Conservative (default)**: Use `bd` for task tracking. Do not run git commits, git pushes, or Dolt remote sync unless explicitly asked. At handoff, report changed files, validation, and suggested next commands.
- **Minimal**: Keep tool instruction files as pointers to `bd prime`; use the same conservative git policy unless active instructions say otherwise.
- **Team-maintainer**: Only when the repository explicitly opts in, agents may close beads, run quality gates, commit, and push as part of session close. A current "do not commit" or "do not push" instruction still wins.

## Session Completion

This protocol applies when ending a Beads implementation workflow. It is subordinate to explicit user, repository, and orchestrator instructions.

1. **File issues for remaining work** - Create beads for anything that needs follow-up
2. **Run quality gates** (if code changed) - Tests, linters, builds
3. **Update issue status** - Close finished work, update in-progress items
4. **Handle git/sync by active profile**:
   ```bash
   # Conservative/minimal/default: report status and proposed commands; wait for approval.
   git status

   # Team-maintainer opt-in only, unless current instructions forbid it:
   git pull --rebase
   bd dolt push
   git push
   git status
   ```
5. **Hand off** - Summarize changes, validation, issue status, and any blocked sync/commit/push step

**Critical rules:**
- Explicit user or orchestrator instructions override this Beads block.
- Do not commit or push without clear authority from the active profile or the current user request.
- If a required sync or push is blocked, stop and report the exact command and error.
<!-- END BEADS INTEGRATION -->
