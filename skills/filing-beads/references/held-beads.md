# Reading a readiness hold

A bead the station held carries the reason in two places:
- the bead's notes, when the refiner left it for the owner ("The refiner seat
  left this for the owner…");
- the station's lane results, when you can reach the station's home:
  `<grid home>/attempts/<attempt>/readiness/<lane>/<hash>/result.json`, where
  `grep -l <bead-id> -r attempts --include=result.json` finds them. Each holds a
  grade and a rationale; the rationale names what is missing.

## What each hold means

| Who held it | Grade | Usual meaning | Fix |
|---|---|---|---|
| intake | F | No acceptance criteria, or no validation plan | Write the missing field (fields.md) |
| critic | D | One axis fails: scope, done-ness, constraints or approach | Fix that axis in the design or acceptance |
| critic-adversary | D/E | The same axes, judged more strictly; often "two changes, split it" | Split per the independence test, or decide the open call |
| either | F | Not a coding job: a question, a ruling, an epic | Ask the owner, or retype and decompose |

## Fixing it

- Read the rationale for the divergence it names. "Two agents would differ on X"
  means decide X, in the design.
- A split: create the second bead first, then rewrite the first to cover only its
  half, cross-reference the new id, and wire the dependency if one must land first.
  The union of the two beads' acceptance criteria must equal the original's.
- An edit to the description, design, acceptance or validation plan admits the
  bead again. Notes, labels and priority do not.
- If the two critics disagree (one passes, one holds), the hold binds. Fix it, or
  ask the owner whether the hold is wrong.
