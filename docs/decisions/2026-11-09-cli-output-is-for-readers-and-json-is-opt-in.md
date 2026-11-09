---
status: accepted
date: 2026-11-09
decision-makers:
  - "nico"
consulted: []
informed: []
register:
  spec: 1
  slug: "cli-output-is-for-readers-and-json-is-opt-in"
  surfaces:
    - "roster:**/bin/**"
  obsoletes: []
  updates: []
  obsoleted-by: null
  updated-by: []
  bead: null
  legacy-id: null
---

# Org CLIs print for a reader by default and switch to JSON with --json

## Context and Problem Statement

Org CLIs are read by people and by agents, so most verbs print two ways: prose for a reader and a
document for a program. Each CLI chose its own switch. In the `decisions` CLI, `lint`, `search` and
`doctor` print for a reader and take `--json`, while `index` printed JSON and took `--human`. An
agent that learned one verb guessed wrong on the next, and every caller had to know which verb
went which way. A new verb had no rule to follow, so the drift would continue.

## Decision Outcome

**Every org CLI spells its output mode with the same flags, and every verb in it reads the same
way.**

1. **A verb prints for a reader by default.** `--json` switches it to one compact JSON document on
   stdout. A verb may also offer `--json-pretty`: the same document, indented.
2. **A verb whose only honest output is a document** defaults to JSON and takes `--no-json` for
   the readable form. This is the exception, and it needs a reason in the verb's help.
3. **No other spellings.** No `--human`, `--format`, `--output` or `--machine` for this choice. A
   verb that has one is changed to match these flags, not kept for compatibility.
4. **Breaking a flag is allowed and is versioned.** Renaming or removing an output flag is a
   breaking change to the CLI's interface. It ships under semantic versioning: a major bump, or a
   minor bump while the CLI is below 1.0. Its changelog names the old and new spelling.

### Consequences

* Good, because an agent that learns the flags on one verb can drive every verb on every org CLI
  without reading each one's help.
* Good, because callers learn about a breaking change from the version number, not from a failed
  run.
* Bad, because bringing an existing verb into line breaks its callers, who must update when they
  take the new version. `decisions index` is the first such case.
