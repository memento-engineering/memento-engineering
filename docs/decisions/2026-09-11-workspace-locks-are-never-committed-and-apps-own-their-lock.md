---
status: accepted
date: 2026-09-11
decision-makers:
  - "Nico Spencer"
consulted:
  - "refiner seat (lunar_station)"
informed: []
register:
  spec: 1
  slug: workspace-locks-are-never-committed-and-apps-own-their-lock
  surfaces:
    - "tool/pubspec.lock"
    - "roster:.gitignore"
    - "roster:pubspec.yaml"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: org-0ga
  legacy-id: null
---

# Workspace locks are never committed, and apps own their own lock

## Context and Problem Statement

The working convention had been stated as "apps commit lockfiles, libraries do
not". It cannot be applied as stated, because every repository on the roster is
a pub workspace with exactly ONE root `pubspec.lock` covering its apps and its
libraries together. There is no per-package lock to make the per-package rule
decide.

The state at the time of the ruling, verified against the trees rather than
assumed:

* `the_grid` tracks a root `pubspec.lock` and has no ignore rule, although
  every package in it is a library.
* `space_station` ignores `pubspec.lock` at `.gitignore:15` and tracks the root
  lock anyway — the file predates the rule, so the repository states one
  convention and practises the opposite.
* `lunar_station` ignores its lock while carrying an app under `apps/lunar`.
* `memento-engineering` tracks only `tool/pubspec.lock`, which is app-shaped
  and already correct under the rule below.

A committed workspace lock also hides the failure it is most needed to catch. A
workspace binds a sibling package by PATH, so a declared constraint on that
sibling is only ever matched against the sibling's local version string and
never against a published artifact. `apps/lunar` declares `lunar_grid_assets`
as a git-tag dependency at `^0.1.0` and resolves it by path; `apps/space`
declares `space_station_assets: any`, which is not a constraint at all. That is
the same mechanism by which `grid_cli` 0.5.0-rc.22 was published unbuildable
against its own declared floors (`the_grid#tg-qwsx`, P0).

## Considered Options

* **Commit the workspace lock everywhere and add a fresh-resolve CI lane.**
  Keeps reproducible builds and catches floor gaps in a second lane. Rejected:
  it pays for a new lane in every repository to restore a signal that not
  committing the lock gives for free.
* **Never commit a workspace lock.** Exercises every library's declared floors
  on each CI run at no additional cost, but on its own leaves apps without a
  reproducible build.
* **Defer the rule and file the observation only.** Rejected: the hazard is
  already live in two repositories.

The ruling extends the second option with the clause that resolves its one
weakness — an app leaves the workspace, so it can keep a reproducible lock of
its own.

## Decision Outcome

A package workspace's root `pubspec.lock` is never committed; it is ignored in
every workspace repository.

An app does not belong to a package workspace. It lives outside one, declares
real version constraints on the packages it consumes, and tracks its own
`pubspec.lock`.

An app-shaped directory that is not a workspace member — a `tool/` utility, a
package's `example/` — tracks its lock under the same rule that governs an app.

### Consequences

* Good, because a library's declared constraints are resolved from their real
  sources on every CI run, so an unbuildable published floor fails at once
  instead of reaching a consumer.
* Good, because an app keeps a reproducible build, which a shared workspace
  lock could not give it without also blinding its libraries.
* Good, because it removes an ambiguity that no per-package rule could settle:
  the unit of the decision is now the workspace, not the package.
* Bad, because co-editing a workspace sibling from an extracted app requires
  tagging the sibling instead of resolving it by path, which slows the inner
  loop until a mechanical dev-linking verb exists
  (`power_station#pow-q8zn`).
* Bad, because a red CI run can now originate in an upstream publish rather
  than in the change under test, and must be read accordingly.

### Confirmation

In each workspace repository, `git ls-files '*pubspec.lock'` returns no root
workspace lock, and `.gitignore` carries a `pubspec.lock` entry. Each extracted
app tracks its own lock and declares no dependency resolved by workspace path.

The roster-wide surfaces above govern the two files this ruling actually
changes in each workspace repository: the `.gitignore` that must carry a
`pubspec.lock` entry, and the root `pubspec.yaml` whose `workspace:` list must
no longer name an app. They resolve only where the checkout sits inside the
umbrella directory, so CI exempts `surface.unmatched` for them as it does for
every roster-wide entry.

`lunar_station` is governed by this decision and is reachable by no surface
here, because an `engineering.memento/`-relative surface cannot name a
repository in another umbrella. That is the gap
`memento-engineering#org-z20` closes with marked notation; these surfaces widen
to cover it once that lands.
