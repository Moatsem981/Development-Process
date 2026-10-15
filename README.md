# Development Process

## What the project is

A reusable development process, not a product. It's a bundle of templates, prompts, and a gate script that walks any new tool from "idea" to "shipped code" with the same discipline every time. Converged on a resource-tracker R&D run (Aug 2026) where remediation cost dropped 9 → 6 → 3.5 developer-days across three loop rounds, and 34 of 38 findings closed by round three.

## Purpose

Stop the recurring failure modes that killed previous projects: unsigned/ambiguous specs, invented data reaching code untagged, silent plan repairs during build, worklog entries that never got written. Every rule in the bundle traces to a specific past incident.

## The seven-step pipeline (`RUNBOOK.md`)

| Step | Artifact | Gate |
|---|---|---|
| **0. Records** | `docs/WORKLOG.md`, `docs/CODE_WORKLOG.md`, `check_worklog.sh` wired into pre-push | Prove the gate fails before trusting it |
| **1. URS** (`Phase 1 URS-template.md`) | Approved URS | §9 empty, every (I) confirmed, approver named. **No name, no build.** |
| **2. Prototype** (`Phase 2 prompt-claude.md`) | One canonical HTML file + Invented-to-Render register | Customer walked through it; corrections back into URS |
| **3. Architecture** (`Phase 3 Technical Architecture & Data Flow.md`) | Shape decision + data flow + trust boundary | Every choice names the loser and the profile fact that decided it |
| **4. Plan** (`Master-Build-Prompt.md` v4, Register R1–R13) | Implementation plan + Self-Audit Appendix | Appendix complete |
| **5. Test** (`Master-Test-Prompt.md` v4) | Plan Simulation & Risk Report | No P0s, no journey-blocking findings. One remediation round only, a third round means back to step 1 |
| **6. Execute** (`Master-Execute-Prompt.md` v1, rules E1–E10) | Code + `BUILD-STATUS.md` ledger | One slice per cycle, Deviation Protocol, never a silent repair |
| **7. Record** | WORKLOG + CODE_WORKLOG entries | `check_worklog.sh` exits 0 |

## The non-negotiable rules

**From `CLAUDE.md`:**

- **NEVER invent anything** — every value/URL/field/endpoint must be verified against the real system before shipping
- **NEVER change the checked-out branch** of the user's working directory (use `git worktree add` instead)
- **Check for a running dev server** before anything that changes the tree
- **One directory, one concern, one branch** — don't tidy up others' branches/worktrees/PRs
- **Never delete anything** without explicit instruction naming the thing
- **No unasked side-effecting commands** (bare prod builds, DB resets)

**The two worklog records (zero tolerance):**

- `WORKLOG.md` = narrative, "why did this happen", session-organised, newest first
- `CODE_WORKLOG.md` = per-unit index, "what breaks if I change this", stable `CW-NNNN` ids, reciprocal dependency edges
- Enforced by `check_worklog.sh` on pre-push. `SKIP_WORKLOG_CHECK=1` is the only bypass (one flag covers both records deliberately)

**Build-time anti-drift (E1–E10):** no silent plan repair, no unverified claims, never weaken a test to pass it, no scope creep, no placeholders, contract fidelity across slices, session continuity via `BUILD-STATUS.md`, failing gate = full stop, least privilege, honest reporting.

**Plan-generation defects (R1–R13):** executable code only, closed world, journey simulation, mechanism interaction, no contradictions, privileges from day one, tests that can fail, recovery-path parity, script rigor, ordering invariants, bounded degradation, invented data is tagged data, guard-context (stage-scope).

## How to use it

1. Copy this folder's contents into a new project.
2. Walk `RUNBOOK.md` top to bottom, don't skip gates.
3. Paste `CLAUDE.md` into the repo so future sessions obey the same rules.
4. Install `check_worklog.sh` into `scripts/`, wire into pre-push, prove it fails before trusting it. If the repo already has a worklog gate, extend it, never add a second.
5. At each phase, open a fresh Claude session and paste the matching master prompt plus the required inputs.
6. Light shapes (single HTML / CLI / spreadsheet+script) use the same principles at lighter depth, the full apparatus (Docker/Postgres/RLS/backups) only applies to the web-app shape.

The whole thing compounds: every adversarial report that surfaces a new defect class gets folded into the Build Prompt's Register before the next project starts.
