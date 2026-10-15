# CODE_WORKLOG template

Copy this to `docs/CODE_WORKLOG.md` at the start of a project and fill it as you build.

## What this file is for, and why it is not the worklog

`WORKLOG.md` answers **"why did this happen"**. It is organised by session, and a session is over
once it ends.

`CODE_WORKLOG.md` answers **"what breaks if I change this file"**. It is organised by unit, and a
unit outlives every session that touched it.

Neither substitutes for the other. Without the narrative you cannot tell why a design is the way
it is. Without the per-unit index you cannot tell the blast radius of a change before you make
it, which is the question you actually have at the moment you are about to edit something.

## The three things that make it work

1. **Stable ids.** Every unit gets a `CW-NNNN` id, assigned in sequence, never reused and never
   renumbered. Narrative entries cite ids, so an id that moves breaks every citation. When a file
   is renamed, the path in the entry changes and the id does not.
2. **Reciprocal edges.** If A lists B under `Depends on`, then B lists A under `Depended on by`.
   A one-directional edge is a bug in the file, not a shortcut. Reciprocity is the whole point:
   the direction you need when you are about to edit something is the one nobody writes down.
3. **A reverse index.** Alphabetical by path, so the lookup starts from what you have (a filename
   from a stack trace or a diff) rather than from what you do not have (the id).

## Field definitions

| Field | What goes in it |
|---|---|
| `Path` | Repo-relative path. Multiple paths only when they are genuinely one unit of ownership: they change together, for the same reason, and a reviewer would want them in one diff. |
| `Created` | The date the unit first appeared. From `git log`, not from memory. |
| `Last touched` | Short commit hash of the most recent change, verified against `git log` when the entry was written. Not inferred from the file contents. |
| `Thread` | Which `WORKLOG.md` entry tells the story. Date plus title, so it survives the file being reordered. |
| `What it is` | One or two sentences. Define the concept before naming the file's role in it. |
| `Why it is built this way` | The decision and the alternative it beat. This is the field that stops a future tidy-up undoing a deliberate design. If you cannot name what it beat, you have not recorded a decision. |
| `Depends on` | Ids this unit reads, imports, or relies on for a property. Empty is `(none)`. |
| `Depended on by` | Ids that would break or silently weaken if this unit changed. Empty is `(none)`. |
| `Gotchas` | What is genuinely surprising. Especially: **safety properties that depend on something being ABSENT.** An omission is invisible to a reader and gets added back by accident, so it must be documented at the omission. |

## Rules

1. New unit, next id. Never reuse, never renumber.
2. Add both halves of every edge, and the reverse-index row, in the same change.
3. File moved: update the path, keep the id.
4. Unit deleted: mark the entry removed with the date and commit. Do not delete the entry, because
   narrative entries still point at it.
5. Do not create an entry per file when the files are one unit. Framework-mandated shims that only
   re-export are one unit.
6. If you cannot fill `Why it is built this way` with a real alternative, the entry is not ready.

---

# Code worklog

<one-paragraph statement of what this repository is, so the file is readable cold>

## Purpose

1. Make the blast radius of a change visible before it is made.
2. Record why a unit is shaped the way it is, at the unit, so the reason survives the person.
3. Give the narrative worklog stable identifiers to cite.

## How to search this file

1. By file path: the REVERSE INDEX at the bottom, alphabetical, gives the id.
2. By id: search the literal `CW-NNNN`, which finds the entry and every citation of it.
3. By concept: the concept table in the reverse index.
4. By area: the Module map, then the entries listed against that area.

## Conventions

<copy the six Rules above, or link to this template>

## Module map

1. `<top-level dir>` is <what it owns>. Entries: <ids, or "none yet">.
2. `<top-level dir>` is <what it owns>. Entries: <ids, or "none yet">.

## Entries

### CW-0001 <path>

- **Path:** `<path>`
- **Created:** YYYY-MM-DD. **Last touched:** `<sha>`
- **Thread:** WORKLOG YYYY-MM-DD, "<entry title>"
- **What it is:** <one or two sentences, concept defined first>
- **Why it is built this way:** <the decision and the alternative it beat>
- **Depends on:** (none)
- **Depended on by:** (none)
- **Gotchas:** <what is surprising, including anything protected by an absence>

## REVERSE INDEX

### By file path

| Path | Entry |
| --- | --- |
| `<path>` | CW-0001 |

### By concept

| Concept | Entries |
| --- | --- |
| <named idea> | CW-0001 |

### Dependency edges, both directions

| Entry | Depends on | Depended on by |
| --- | --- | --- |
| CW-0001 | (none) | (none) |

## Maintaining this file

1. Every product-code change requires a change here as well as in `WORKLOG.md`, machine-enforced
   by the worklog gate on pre-commit and pre-push.
2. New unit, next id. Never reused, never renumbered.
3. Both halves of every edge, every time. The edges table exists so a one-directional edge is
   visible at a glance rather than buried in prose.
4. File moved: path changes, id stays.
5. Unit deleted: mark removed, do not delete the entry.
