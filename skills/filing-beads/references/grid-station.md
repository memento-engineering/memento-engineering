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
  Before filing, run it as the station will: `sh -c "$plan"` from the worktree
  root, not in zsh and not one clause at a time.
- **Intake.** Before any model reads the bead, a deterministic check holds it
  unless it has a type the station builds, a description, acceptance criteria and
  a validation plan. Lint with `scripts/lint-bead.sh --grid`.
- **Approval.** The station builds a bead once it is approved: after its
  readiness review passes, the station stamps it itself. A bead filed open while
  the station runs can be picked up within minutes; file it deferred if it must
  wait.

## Writing the plan

- **Cover the consumers, not only the edited packages.** A change to a public
  API breaks the packages that call it, and a plan scoped to the edited packages
  stays green. Run each affected package's analyzer and whole test suite; where
  CI runs the analyzer at the repository root, run it there too. Narrow to named
  test files only when a whole suite will not fit, and say in the bead which
  suite was dropped.
- **Compare diffs three-dot:** `origin/main...HEAD`. A diff against `HEAD` is
  empty once the builder commits.
- **No exact file-set legs.** A leg asserting the diff equals a listed set of
  files fails whenever the build must touch one more test. Fence the negative
  space instead: nothing changed outside the named directories.
- **Anchor absence checks.** `! rg 'package:x/'` also matches a test that lists
  that string in its ban list; match the import line instead.
- **No branch commit SHAs.** The org squash-merges, so a commit on a
  dependency's branch never reaches main. Assert content (`test -f <path>`), or a
  commit already on main.
- **Do not grep accepted decision prose.** A builder may rightly record a new
  entry instead of editing an accepted one, and the grep then fails with no
  output. A failing plan with an empty log is a failing grep or test leg, not a
  crash.

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
