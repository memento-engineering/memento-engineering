#!/usr/bin/env bash
# lint-bead.sh: check a bead against what the grid station's intake and readiness
# review require, before or after it is filed.
#
# Usage:
#   lint-bead.sh <bead-id>          lint a filed bead (run inside its repository)
#   lint-bead.sh --draft <dir>      lint a draft before filing; <dir> holds
#                                   description.md, design.md, acceptance.md and
#                                   validation_plan.txt (any may be missing)
#
# Exit 0 when nothing FAILs (WARNs may remain), 1 on any FAIL, 2 on a usage error.
# Requires: bd and python3 for the filed form; python3 alone for --draft.
set -uo pipefail

usage() { sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//' >&2; exit 2; }
[ $# -ge 1 ] || usage

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

if [ "$1" = "--draft" ]; then
  [ $# -eq 2 ] && [ -d "$2" ] || usage
  for f in description.md design.md acceptance.md validation_plan.txt; do
    if [ -f "$2/$f" ]; then cp "$2/$f" "$tmp/$f"; else : > "$tmp/$f"; fi
  done
  echo "draft" > "$tmp/id"
  echo "" > "$tmp/known_ids"
else
  id="$1"
  if ! json="$(bd show "$id" --json 2>&1)"; then
    echo "FAIL: bd show $id: $json" >&2; exit 1
  fi
  printf '%s' "$json" | python3 -c '
import json, sys, os
d = json.load(sys.stdin)
if isinstance(d, dict) and "data" in d: d = d["data"]
if isinstance(d, list): d = d[0]
out = sys.argv[1]
meta = d.get("metadata") or {}
if isinstance(meta, str):
    try: meta = json.loads(meta)
    except ValueError: meta = {}
for name, val in (("description.md", d.get("description")), ("design.md", d.get("design")),
                  ("acceptance.md", d.get("acceptance_criteria")),
                  ("validation_plan.txt", meta.get("validation_plan"))):
    open(os.path.join(out, name), "w").write(val or "")
open(os.path.join(out, "id"), "w").write(d.get("id", ""))
open(os.path.join(out, "type"), "w").write(d.get("issue_type", ""))
' "$tmp" || { echo "FAIL: could not read bead $id" >&2; exit 1; }
  # Ids the store knows, to check references against.
  bd list --all --json --limit 0 2>/dev/null | python3 -c '
import json, sys
d = json.load(sys.stdin)
if isinstance(d, dict) and "data" in d: d = d["data"]
print("\n".join(x["id"] for x in d))' > "$tmp/known_ids" 2>/dev/null || : > "$tmp/known_ids"
fi

python3 - "$tmp" <<'PY'
import os, re, sys
d = sys.argv[1]
rd = lambda n: open(os.path.join(d, n)).read() if os.path.exists(os.path.join(d, n)) else ""
desc, design, acc, plan = rd("description.md"), rd("design.md"), rd("acceptance.md"), rd("validation_plan.txt")
me, btype = rd("id").strip(), rd("type").strip()
known = set(rd("known_ids").split())
fails, warns = [], []

# Intake: what the station's deterministic check requires.
if not desc.strip(): fails.append("no description")
if not acc.strip(): fails.append("no acceptance criteria (intake holds the bead)")
if not plan.strip(): fails.append("no validation plan in metadata (intake holds the bead)")
if btype in ("epic", "decision", "gate", "molecule", "message"):
    warns.append(f"type {btype!r} is not one the station builds")

# Acceptance shape.
items = [l for l in acc.splitlines() if l.strip().startswith("- [")]
if acc.strip() and not items: warns.append("acceptance has no '- [ ]' items")
gate = re.compile(r"tool/gate\.sh|\bgate\.sh\b|run(?:s)? the (?:whole |full )?gate", re.I)
for l in items:
    if gate.search(l):
        fails.append(f"acceptance runs the whole gate (belongs in the validation plan only): {l.strip()[:90]}")

text = "\n".join((desc, design, acc))
# Absolute paths become failed anchors.
for m in sorted(set(re.findall(r"(?<![\w.])/(?:Users|tmp|private|home|var)/[^\s`'\")]+", text))):
    fails.append(f"absolute path in bead text: {m[:80]}")

# Referenced bead ids must exist (same store only; cross-store ids are checked by hand).
if known:
    prefixes = {k.rsplit("-", 1)[0] for k in known if "-" in k}
    for m in sorted(set(re.findall(r"\b([a-z][a-z0-9_]*-[a-z0-9]{2,5}(?:\.\d+)*)\b", text))):
        if m == me or m in known: continue
        if m.rsplit("-", 1)[0] in prefixes:
            fails.append(f"names a bead id this store does not have: {m}")

# Determinacy: an undecided fork in the design or acceptance.
for pat, why in ((r"\beither\b[^.\n]{0,80}\bor\b", "an either/or"),
                 (r"\b(TBD|TODO|to be decided|open question)\b", "an undecided item"),
                 (r"\b(should we|investigate whether|figure out)\b", "a question, not a decided change")):
    for m in re.finditer(pat, design + "\n" + acc, re.I):
        warns.append(f"{why} in design/acceptance: ...{(design + chr(10) + acc)[max(0, m.start()-30):m.end()+30].strip()}...")

# Scope: signs of two independent changes.
if re.search(r"^\s*(Separately|Also|In addition)[,:]", desc, re.M | re.I):
    warns.append("description reads like two changes ('Separately'/'Also'); check the independence test")

# Citations.
if not re.search(r"\b[a-z_]+#[a-z0-9][a-z0-9-]+", text):
    warns.append("cites no register decision (repo#slug); confirm none governs the surfaces")
if not re.search(r"[\w./-]+\.(dart|md|yaml|json|sh|go|py|ts|swift|kt)(:\d+)?", text):
    warns.append("names no file; readiness wants the touched surfaces named")

for f in fails: print("FAIL:", f)
for w in warns: print("WARN:", w)
print(f"{len(fails)} fail, {len(warns)} warn")
sys.exit(1 if fails else 0)
PY
