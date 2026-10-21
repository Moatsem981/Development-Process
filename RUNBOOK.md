# RUNBOOK — how to run the process on any project

Follow top to bottom. Don't skip a gate. Full detail: `Development-Process.md`.

---

## 0 — Set up the records (once per project, before any code)
- Start `docs/WORKLOG.md` with a header and one entry, using `WORKLOG-entry-template.md`. An empty file invites a first entry in the wrong shape.
- Copy `CODE_WORKLOG-template.md` → `docs/CODE_WORKLOG.md`; fill the Module map from the real top-level directories; leave the entry list empty.
- Copy `check_worklog.sh` → `scripts/`, `chmod +x`, set `PRODUCT_PREFIXES` and the two record paths. **Repo already has a worklog gate? Extend it, don't add a second.**
- Wire it into the aggregate gate the pre-push hook runs, so nobody pushes around it by accident. Optional Layer 2: merge `stop-hook-settings.json` into `settings.json`.
- Paste the rule block from `Progress-Documentation.md` into `CLAUDE.md`.
- Prove it: change product code with no entries → gate must exit 1 naming both records; add one → still fails naming the other; add both → passes. **A gate nobody has watched fail is not known to work.**
- ☑ **Gate:** both records exist · gate wired into pre-push · all three outcomes observed by eye.

## 1 — URS
- Open `Phase 1 URS-template.md`, fill it by interviewing the customer (or translating their artifact/HTML).
- Run the template's own quality gate: morning check → cold test → read-back.
- ☑ **Gate:** §9 empty · every (I) confirmed · approver's name in the header.

## 2 — Prototype
- New Claude session → paste `Phase 2 prompt-claude.md` + the approved URS.
- **Every prototype is built in Next.js** (owner, 16/10/2026), never a single HTML file. Inside an existing Next.js app it lives in the tool's own home, in the app's real shell; otherwise it is one new Next.js app.
- Save the prototype to ONE canonical path; record that path in the URS header.
- Add the **Invented-to-Render register** at the bottom: every rule/threshold/taxonomy the URS didn't state, with an ID and an owner.
- Walk the customer through it; capture corrections back into the URS as (Q).
- ☑ **Gate:** customer confirmed the prototype · register written · URS updated.

## 3 — Architecture
- New session → paste `Phase 3 Technical Architecture & Data Flow.md` + the URS.
- Fill Section 0 first; take the FIRST shape row that fits; run the best-choice challenge on every layer.
- ☑ **Gate:** every choice names its loser and the profile fact · shape ratified by you · §8 (open questions) empty.

## 3.5 — Compliance review (gate before Plan)
- **Applies when** the system sends to third parties, handles personal data, or sits under a regulatory regime (PECR, UK/EU GDPR, CAN-SPAM, HIPAA, PCI, etc.). Pure read-only or ephemeral-processing tools skip this step.
- Produce, dated and committed under `docs/compliance/`:
  1. **Legitimate Interests Assessment** (or legal basis note).
  2. **Data map** — what data, from where, stored where, read by which component, written to which, retained how long.
  3. **Opt-out / suppression plan** — how the request arrives, where it is stored, how every downstream slice checks it inside its send transaction.
  4. **Retention policy** — per data class, with the mechanism that enforces it.
  5. **Privacy notice** — for any public surface.
- ☑ **Gate:** all five docs committed · adviser consulted OR risk explicitly accepted in writing · every planned send/write has its compliance anchor named · URS §8 (data check) consistent with the data decisions made here.

## 4 — Plan
- New session → paste `Master-Build-Prompt.md` + five inputs:
  1. approved URS · 2. prototype (with register) · 3. `keys.md` (this folder; `keys-core.md` is the short form) · 4. `pre-ship-hardening.md` (the hardening playbook, this folder) · 5. Phase 3 doc.
- Light shapes (single HTML / script / CLI): tell it "light mode — apply the Register's principles at the depth this shape warrants."
- ☑ **Gate:** plan has all sections + the Self-Audit Appendix (journeys, concurrency, recovery, manifest, contradictions, guard-context table).

## 5 — Test
- New session → paste `Master-Test-Prompt.md` + the URS + the plan (+ any previous reports).
- Read the verdict.
- ☑ **Decision rule:**
  - No P0s, no journey-blocking findings → **go to 6**.
  - Otherwise → give the plan session the report, remediate, re-test **once**. Still failing → the problem is the spec: **back to step 1**.
- Fold any NEW defect class (the report's final paragraph) into `Master-Build-Prompt.md`'s Register.

## 6 — Execute build
- New session → paste `Master-Execute-Prompt.md` + inputs: the verified plan · the final risk report (with Certification Condition) · the URS · `keys.md` (this folder) · `BUILD-STATUS.md` (first session creates it).
- One slice per cycle: announce → build → verify with real output → report → update ledger. Every later session resumes from `BUILD-STATUS.md`.
- Plan can't be executed as written? → Deviation Protocol: stop, record, get approval. Never a silent repair.
- Recycle the prototype as the frontend against a stubbed API first; before ship, `grep MOCK:` = zero hits.
- Finish with the plan's §8 pre-ship hardening audit (method: `pre-ship-hardening.md`) + the Certification Condition, item by item; clear blockers; then roll out.
- ☑ **Gate:** all slices done with evidence · deviations resolved or accepted · audit blockers cleared.

## 7 — Record (every slice, not at the end)
- `docs/WORKLOG.md`: new dated entry at the top, in the layout the neighbouring entries already use. Don't invent a new one.
- `docs/CODE_WORKLOG.md`: add or update the `CW-` entry for every unit touched — **both** halves of each dependency edge, plus the reverse-index row.
- New units take the next id in sequence. Ids are never reused and never renumbered, because narrative entries cite them.
- ☑ **Gate:** `check_worklog.sh` exits 0 without `SKIP_WORKLOG_CHECK`. If it fails, write the entries — do not weaken the gate to get the push through.

---

**Never:** land product code without both records · build from a Draft URS · trust a prototype number · skip step 5 · let the plan escalate the shape Phase 3 chose · put customer/personal data into an AI tool.
