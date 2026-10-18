---
status: accepted
date: 2026-10-18
decision-makers:
  - "nico"
consulted: []
informed: []
register:
  spec: 1
  slug: homebrew-tap-token-is-visible-to-every-org-repo
  surfaces:
    - "roster:.github/workflows/release.yaml"
  obsoletes: []
  updates:
    - org-clis-ship-through-one-homebrew-tap
  obsoleted-by: null
  updated-by: []
  bead: org-gv6
  legacy-id: null
---

# The Homebrew tap token is visible to every org repo

## Context and Problem Statement

`org-clis-ship-through-one-homebrew-tap` said the `HOMEBREW_TAP_TOKEN` org secret is shared with
selected repos, and that each repo starting to release to the tap is added to its list. The secret
was created visible to every org repo instead. Many of the org's Dart tools are about to start
shipping through the tap, so a per-repo allowlist would become one manual step for every one of
them.

## Decision Outcome

**`HOMEBREW_TAP_TOKEN` is visible to every repo in the org.** A repo that starts releasing a CLI to
the tap needs no change to the secret.

The rest of `org-clis-ship-through-one-homebrew-tap` stands. The token's own scope is unchanged —
contents read and write on `homebrew-tap` only — and only a release workflow pushing a generated
formula may use it.

### Consequences

* Good, because adding a CLI to the tap is a change to that CLI's repo alone.
* Bad, because any org repo's workflow, including one written by an agent, can push to the tap.
  The token's single-repo scope bounds what that push can reach; nothing bounds which workflow
  makes it.
