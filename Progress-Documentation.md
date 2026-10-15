# Progress documentation: the mandatory step

**Every piece of real work updates two records before it is done.** Not a preference, not a
nice-to-have, and not something the person doing the work gets to judge. This is the step that
was skipped on every project until a gate started refusing the push.

Zero tolerance. A branch that changes product code and documents neither record does not land.
There is no "I will write it up later", because later is the state this rule exists to abolish:
every previous attempt at worklog discipline depended on somebody remembering, and every one
failed the same way. Entries were skipped, then written only when chased, then written from
memory weeks later and wrong.

**A rule no gate enforces is a rule that gets ignored.**

---

## The two records

| Record | Answers | Organised by | Lifetime |
|---|---|---|---|
| `WORKLOG.md` | Why did this happen? What was tried, what went wrong, what is the lesson? | Session, newest first | The session is over once it ends |
| `CODE_WORKLOG.md` | What is this unit, why is it shaped this way, what breaks if I change it? | Unit, by stable `CW-` id | The unit outlives every session that touched it |

Neither substitutes for the other, and the reason is worth stating plainly. The narrative cannot
answer "what depends on this file", because it is organised by when rather than by what. The
per-unit index cannot answer "why did we accept this trade-off", because a field in a table has
nowhere to put the wrong turns. **The question you actually have at the moment you are about to
edit something is the blast radius, and that is the question nobody writes down.**

Templates: `WORKLOG-entry-template.md` and `CODE_WORKLOG-template.md`.

---

## The two layers of enforcement

Layer 1 is deterministic and cannot be reasoned with. Layer 2 is judgment and is best-effort.
You need both, and you must not confuse what each one guarantees.

**Layer 1: the gate.** `check_worklog.sh`, wired into the aggregate gate the pre-push hook runs.
If the branch changes product code and adds no lines to both records, it exits 1. It guarantees
the entries EXIST. It cannot tell whether they are any good, whether they describe this work, or
whether the dependency edges are reciprocal, and it says so in its own header rather than
implying more than it delivers.

**Layer 2: the Stop-hook auditor.** `stop-hook-settings.json` wires a script that runs when the
assistant finishes a turn, and pushes for the entry to be RIGHT rather than merely present. This
is judgment, so it is advisory. Treat a Layer 2 complaint as a review comment, not as a build
failure.

**If the repository already has a worklog gate, extend it. Do not add a second.** Two gates
enforcing overlapping rules drift, disagree, and each acquires its own bypass flag, so one record
ends up skippable while the other is enforced. That is precisely the state a gate exists to
prevent. `check_worklog.sh` is for a greenfield repo with no gate yet; an existing gate gets the
second record added to the record list it already checks.

**One bypass flag, deliberately.** `SKIP_WORKLOG_CHECK=1` covers both records. Two flags would
let one record be skipped while the other is enforced. It exists for a genuine one-off logged
another way. Using it as a habit is the exact failure the gate exists to stop.

---

## The rule block to paste into CLAUDE.md

Generic. Adjust the paths and the product directories to the repository.

```markdown
## NON-NEGOTIABLE: Progress documentation

Every piece of real work updates **both** records before it is considered done. This is not a
preference and not a nice-to-have. Product code does not ship without it, and the gate refuses
the change if it is missing.

1. `docs/WORKLOG.md` is the narrative: why this work happened, what was tried, what went wrong,
   what the lesson is. Newest entry at the top. Follow the format of the entries already there
   exactly. Do not invent a new layout: an entry that looks different from its neighbours stops
   the file being readable as one document, which is the only reason the file has value.
2. `docs/CODE_WORKLOG.md` is the per-unit index: what each unit is, why it is shaped that way,
   what it depends on and what depends on it. Every unit gets a `CW-` id, assigned in sequence,
   never reused and never renumbered. Dependency edges are reciprocal: if A lists B under
   `Depends on`, B lists A under `Depended on by`. Add the reverse-index row too.
3. The two are not interchangeable. The worklog answers "why did this happen", the code worklog
   answers "what breaks if I change this file". A session ends; a unit outlives every session
   that touched it.
4. Enforcement is the worklog gate, run by the aggregate gate script the pre-push hook runs. If
   a branch changes product code that is not a `.md` file and adds no lines to either record, the
   gate exits 1 and names which record is missing.
5. `SKIP_WORKLOG_CHECK=1` bypasses both and exists for a genuine one-off logged another way.
   Using it as a habit is the exact failure the gate exists to stop.
6. Do not weaken the gate to get a push through. If it blocks you, either write the entries or
   name the exception explicitly, with the reason and the undo written beside it.
```

---

## Setting it up on a new project

1. Copy `WORKLOG-entry-template.md` guidance and start `docs/WORKLOG.md` with the header and one
   entry. An empty file invites a first entry in the wrong shape.
2. Copy `CODE_WORKLOG-template.md` to `docs/CODE_WORKLOG.md`, fill the Module map from the actual
   top-level directories, and leave the entry list empty.
3. Copy `check_worklog.sh` to `scripts/`, `chmod +x`, and set `PRODUCT_PREFIXES` and the two
   record paths to match the repo. If a gate already exists, extend it instead.
4. Add the gate to the aggregate script the pre-push hook runs, so it is impossible to push
   around it by accident.
5. Merge `stop-hook-settings.json` into `settings.json` if you want Layer 2.
6. Paste the rule block above into `CLAUDE.md`.
7. Prove it works before trusting it: make a throwaway product-code change with no entries and
   confirm the gate exits 1 naming both records; add one record and confirm it still fails naming
   the other; add both and confirm it passes. **A gate nobody has watched fail is not known to
   work.**
