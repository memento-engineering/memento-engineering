# Org-wide Agent Instructions

Install from the memento-engineering repository root: `ln -sfn "$PWD/org/AGENTS.md" ../CLAUDE.md`

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this directory is

`engineering.memento/` is an **umbrella checkout of the `memento.engineering` org** (GitHub
`memento-engineering`, custom domain `memento.engineering`). It is **not itself a git repo** —
each subdirectory is an independent clone with its own remote, branch, `.beads/` tracker, and
`CLAUDE.md`. There is nothing to commit, gitignore, or build at this level. Per-repo instructions
live in each repo's own `CLAUDE.md`; **this file is the map between them + the invariants that hold
everywhere.**

## The bet

> **Apps are built in Flutter. Lenny drives and debugs the apps. Lenny files bugs as beads into the
> grid. The grid builds everything.**

The org is a long bet on Dart as a full-stack agentic platform. One substrate engine, two consumers,
a work-graph orchestrator that spawns coding agents, and a debugging harness that drives running
programs over the VM service.

## Repos & where to start

| Dir | Repo / remote | What it is | Read first |
|---|---|---|---|
| `genesis/` | `memento-engineering/genesis` (`main`) | **The substrate.** Framework-agnostic, bare-VM `Seed`→`Branch` keyed-reconcile engine (Flutter's element model extracted to pure Dart) + the layers on it (perception, taxonomy, dialogue/A2UI wire, typesetting/TUI, consent). Published to pub.dev. **Domain-free.** | `genesis/CLAUDE.md`, `genesis/docs/adr/ADR-0000`+`0001` |
| `the_grid/` | `memento-engineering/the_grid` (`m3-runtime`) | **The orchestrator.** Dart-native reactive replacement for Gas City (`gc`) over a beads work graph: observe bd mutations → diff → typed events → reconcile → **spawn a `claude` coding agent per ready bead** in a per-bead git worktree. | `the_grid/CLAUDE.md`, `the_grid/docs/PDR.md`, `ADR-0000` |
| `genesis-grid/` | `memento-engineering/genesis` (`main`) | **Not a product — a transient clone of `genesis`** used as the_grid's dogfood *workspace* (currently ~2 commits behind genesis). Its `.grid/worktrees/` hold the unlanded features the_grid's agents built during the live arm. Edit genesis in `genesis/`, never here. | (treat as read-only scratch) |
| `tgdog/` | local only, no remote | **the_grid's own state DB** (a "rig"): session/lifecycle beads land here so the *work source* stays pristine (A37). Its `CLAUDE.md`/`AGENTS.md` are still stock `bd init` stubs. | `tgdog/.beads/` |
| `.github/` | `memento-engineering/.github` (`main`) | Org GitHub Pages site (`index.html`, `CNAME` → memento.engineering, `lenny.svg` mark). | — |

**In-umbrella (relocated 2026-07-10):** `lenny` now lives at
`~/development/engineering.memento/lenny` (org `memento-engineering`; moved out of the old
`com.nicospencer` checkout — its `origin` was always `memento-engineering/lenny`). It is the
**testing/debugging
harness**: a stock "leonard" agent attaches to a running Dart/Flutter VM over `ext.exploration.*`,
perceives it as a tree, and drives it. It consumes genesis via `genesis_perception`, and it is the
debugger half of "lenny debugs the_grid." Its packages are prefixed `leonard_*` (see naming below).

## The dependency arc (the part you only get by reading across repos)

- **genesis is the shared substrate; consumers own their domains.** `lenny` (via `perception`) and
  `the_grid` (as the platform SDK / future render consumer) depend on genesis through
  **sibling-checkout path deps during dev, git refs/tags at stabilization** (genesis ADR-0001 D8).
  The arc is one-directional: genesis never imports a consumer.
- **the_grid uses genesis only at the surface/render edge, not in its engine** (the_grid A30/A31): its
  reactive core stays snapshot-diff + Riverpod + the gc-fidelity codec; genesis adoption is deferred
  to a future the_grid ADR-0005 (reserved, not yet written).
- **Three seams are shared or converging between lenny and the_grid:**
  - **`genesis_tmux`** — a zero-dep tmux client extracted *into genesis* (the_grid A34). `leonard_tmux`
    already depends on it; the_grid's planned `TmuxProvider` will. This is the precedent for how shared
    agent-harnessing primitives get named and homed.
  - **The `ext.exploration.*` VM-service protocol** — lenny defines it (the contract package; **shipped
    on disk as `leonard_contract`, though the_grid docs still call it `exploration_contract`** — confirm
    the name before path-dep'ing); the_grid *hosts* it (`grid_exploration`) so lenny can debug the_grid.
    Constants are currently **hand-duplicated and kept wire-compatible** until the contract is consumed as
    a path dep (`lenny-wisp-9h557`, in review).
  - **The inference/model-provider layer** — **lenny owns this and it's shipped** (`ModelProvider` +
    `DartanticModelProvider` over `dartantic_ai`, backends {SwiftInfer, Anthropic, OpenAI}; ADR-0003).
    the_grid does **not** call LLMs — it shells out to `claude`; its `RuntimeProvider` is process
    *transport*, not inference. If you touch the_grid's parked backend shim (`tg-xqq`): **consume lenny's
    provider / genesis's swift-infer loop (A39) — do not re-implement the swift-infer wire a third time.**

## Org-wide invariants (hold in every repo)

- **The ADR-0000 register rule.** Every repo keeps `docs/adr/ADR-0000` — a living "AI decision
  register" for decisions an AI makes **autonomously**, with no human in the loop (an unattended
  agent run). Such an API/naming/semantic decision, when not already covered by a ratified ADR, goes
  in as the next `A<n>` amendment with **Status: pending**. A decision reached collaboratively with
  Nico is already human-ratified — **do not** log it, and **never write to ADR-0000 during an
  interactive session**; just carry it out. **Only Nico** promotes an amendment into a home ADR or
  rejects it. Never write AI decisions directly into ADR-0001+ and never silently edit a ratified doc
  to match your conclusion. New scope gets a doc before it gets code.
- **The "memento house set" (genesis ADR-0001 D7).** Dart `^3.11`, pub workspace + **melos** (scripts:
  `bootstrap`/`test`/`analyze`/`format`); **freezed** sealed unions + `json_serializable`; **exhaustive
  `switch` expressions** as house style; **Fakes, not mocks**; pure logic tested before IO is wired;
  doc comments on public API; no `print` in lib code; shared lints (`strict-casts`/`-inference`/
  `-raw-types`, `prefer_single_quotes`, `unawaited_futures`, `avoid_print`). Riverpod is a *consumer*
  choice — genesis's `tree` core is its own owner/sink (per-repo CLAUDE.md gives the exact Riverpod
  flavor; they differ).
- **Terminology — non-negotiable:**
  - **"extension," never "plugin"** (genesis A21, the_grid A33) in memento code, docs, and names. The
    seam word is *extension* (the wire key is `extensions`). "Plugin" is reserved for third-party
    artifacts named that way by their own ecosystems (e.g. Flutter platform plugins). *(There is still
    residue — see ORG-REVIEW.md — do not add more.)*
  - **Persona vs package prefix.** The product/persona name is short and human; the pub package prefix
    is the formal name. `lenny` (persona) → `leonard_*` (packages). `genesis` (persona/repo) →
    `genesis_*` (pub names) but **unprefixed types** (`Seed`/`Branch`/`Perception`, never `Genesis*`).
    Don't expect a `lenny_*` or `Genesis*` symbol to exist.
  - **Package names are human faculties/crafts/achievements, never agent-nouns** (`typesetting`, not
    `etcher`). genesis is domain-free: `City`/`Rig`/`Agent`/`Order` are the_grid domain nouns and stay
    in the_grid.
- **Beads (`bd`) for all task tracking — and coexistence safety.** Each repo tracks work in a local
  Dolt-backed `.beads/` DB. `BD_JSON_ENVELOPE=1`; mutations via the **bd CLI only**, `--actor <name>`,
  **never SQL writes, never touch `.beads/hooks/`**. **Never call `bd show` from a re-query/controller
  path** (it writes `.beads/last-touched` and self-triggers the watcher). Crucially, **a live Gas City
  (`gc`) still runs and assumes a single writer per bead** — any experiment against live convergence
  traffic is strictly read-only; never reconcile or mutate beads gc owns.

## Working glossary — NOT yet ratified (the conflicts are real)

These words mean **different things in different repos**. Until Nico locks them in (this is itself an
ADR-0000-class decision; see ORG-REVIEW.md for the proposed resolution), assume nothing and check which
repo you're in:

| Term | In lenny | In the_grid | Note |
|---|---|---|---|
| **agent** | the LLM **brain/driver** that attaches to a running VM and drives it (client; `leonard_agent`, never spawns a process) | an external **`claude` subprocess** the_grid spawns & supervises per bead (`grid_runtime`) | **Hard conflict — opposite roles.** |
| **host** | the server surface *inside the target* that registers `ext.exploration.*` (`leonard_flutter`/`leonard_host`) | same idea: `grid_exploration`'s `GridExplorationHost` (so lenny can debug the_grid) | Consistent — the cleanest shared term. |
| **orchestrator** | — (single-target harness) | the whole system: observes a work graph, spawns/supervises many agents | the_grid-only. |
| **session** | one ephemeral drive-loop instance (`LeonardSession`, in-memory) | a durable, crash-tracked **lifecycle bead** for a supervised subprocess | **Conflict.** |
| **rig** | — | an ownership partition of the work graph (id-prefix + `metadata.rig`); also a registered root checkout. Dogfood rig = `tgdog` | the_grid/gc domain noun. |
| **workspace** | — | a `.beads/` root the controller reads (`--workspace`) vs writes (`--state-workspace`) | distinct from a per-bead *worktree*. |
| **extension** | a namespaced unit of tools + observation + lifecycle under `ext.exploration.<ns>.*` | same | the org standard (replaces "plugin"). |

**`genesis_agent`? No.** It violates the naming rule (agent-noun) and the domain-free rule, and there
is no single seam under it ("agent" is two opposite things). The real shared seams are
`exploration_contract` (protocol) and `genesis_tmux` (process control). See ORG-REVIEW.md §overlap.

## Tech-debt review in progress

A thorough, read-only org review (redundancy, complexity, doc-drift, the lenny↔the_grid orchestration
overlap, the glossary, community-research inventory) plus a **drafted, ready-to-file bead backlog**
lives in **`ORG-REVIEW.md`** at this level. Findings were not filed as beads or acted on — Nico blesses
the backlog first.
