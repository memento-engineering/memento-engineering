# memento-engineering

memento's **org decision register** — the decisions that govern the whole roster rather than any
one repository.

A decision that shapes a single repo lives in that repo's own `docs/decisions/`. A decision that
reaches across repos — how every repo records decisions, what the umbrella's `CLAUDE.md` carries,
how legacy registers convert — lives here. The split is not bookkeeping: a register's `surfaces`
are resolved from the repo that holds it, so an entry filed in the wrong repo cannot be checked
from a clean checkout. See
[`org-decisions-live-in-the-org-register`](docs/decisions/2026-09-02-org-decisions-live-in-the-org-register.md).

The format, the schema, the templates and the CLI are the **decisions pattern**, published
separately at [memento-engineering/decisions](https://github.com/memento-engineering/decisions).
Entries here cite that register with the `<repo>#<slug>` handle.

| | |
|---|---|
| [`docs/decisions/`](docs/decisions) | the register — one file per decision |
| [`docs/decisions/views/`](docs/decisions/views) | rendered lineage views, generated |

Roster-wide surfaces resolve at tier 2, where a station enumerates its mounted substations at
runtime. A standalone `decisions lint` in this repo cannot verify them, so this register runs no
surface lint in CI.
