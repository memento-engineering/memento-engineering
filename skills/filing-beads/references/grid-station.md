# Filing for a grid station

Read this when the repository's beads are built by a grid station (lunar runs
one over the organization's repositories). The station grades each bead before
it builds it, and holds any bead that fails.

## What the station adds

- **A validation plan, in metadata.** One shell command, run from the repository
  root by the station's validation and by its code review. It may run the
  repository's whole gate; that is its job.
  ```bash
  --metadata '{"validation_plan":"dart pub get --offline && tool/gate.sh"}'
  ```
  For one package in a workspace: `dart pub get && dart analyze && cd packages/<pkg> && dart test`.
  It runs under `sh -c` (bash 3.2 on macOS): avoid `<(…)`, and `#` inside `$(…)`.
- **Intake.** Before any model reads the bead, a deterministic check holds it
  unless it has a type the station builds, a description, acceptance criteria and
  a validation plan. Lint with `scripts/lint-bead.sh --grid`.
- **Approval.** The station builds a bead once it is approved: after its
  readiness review passes, the station stamps it itself. A bead filed open while
  the station runs can be picked up within minutes; file it deferred if it must
  wait.

## Rules the station enforces

- **Never put the gate in acceptance criteria.** "`tool/gate.sh` passes" becomes
  a build step that runs the whole gate, which the station forbids (the plan
  slot is the host's: one validation at a time). The gate goes in the validation
  plan only.
- **One change per bead.** The readiness review holds a bead that bundles
  independent changes.
- **Cite the decisions.** The spec review checks every touched path against the
  register and sends back a plan that misses a governing entry.

## Reading a hold

A held bead carries its reason in two places:
- its notes, when the refiner seat left it for the owner;
- the station's lane results, at `<station home>/attempts/<attempt>/readiness/<lane>/<hash>/result.json`
  (find them with `grep -l <bead-id> -r attempts --include=result.json`). Each
  holds a grade and a rationale; the rationale names what is missing.

| Held by | Grade | Usual meaning | Fix |
|---|---|---|---|
| intake | F | No acceptance criteria, or no validation plan | Write the missing field |
| critic | D | One axis fails: scope, done-ness, constraints or approach | Fix that axis in the design or acceptance |
| critic-adversary | D or E | The same axes, judged more strictly; often "two changes, split it" | Split by the independence test, or decide the open call |
| either | F | Not a coding job: a question, a ruling, an epic | Ask the owner, or retype and decompose |

- Read the rationale for the divergence it names. "Two agents would differ on X"
  means decide X, in the design.
- A split: create the second bead first, rewrite the first to cover only its
  half, cross-reference the new id, and wire the dependency if one must land
  first. The two beads' acceptance criteria together must equal the original's.
- An edit to the description, design, acceptance or validation plan admits the
  bead again. Notes, labels and priority do not.
- When the two critics disagree, the hold binds. Fix it, or ask the owner whether
  the hold is wrong.
