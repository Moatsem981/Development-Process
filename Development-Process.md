# The Development Process

**Three phases, then plan → test → build.** Simple, and every step has a gate.
**Converged on the resource-tracker R&D run (Aug 2026):** remediation cost fell 9 → 6 → 3.5 developer-days across three loop rounds; 34 of 38 findings closed by round three. Real projects use **real data** — dummy values exist only for genuinely unconfirmed facts, always tagged.

---

## The pipeline

| Step | What | Artifact | Gate before moving on |
|---|---|---|---|
| **Phase 1** | URS — interview the customer, fill the template | Approved URS | §9 empty, every (I) confirmed at read-back, named approver signed. **No name, no build.** |
| **Phase 2** | Design spec — give the URS to Claude with the Phase 2 prompt | Working HTML prototype | Customer walked through it; corrections captured back into the URS; Invented-to-Render register written |
| **Phase 3** | Architecture — fill the Phase 3 doc against the URS | Architecture & data-flow doc | Exit criteria met; shape decision human-ratified; open questions empty |
| **Compliance review** *(when applicable)* | LIA, data map, suppression plan, retention policy, privacy notice | `docs/compliance/*.md` dated and committed | Every planned send/write has its compliance anchor; adviser consulted or risk accepted in writing. Applies when the system sends to third parties, handles personal data, or sits under a regulatory regime |
| **Plan** | Master Build Prompt + all inputs | Implementation plan (with Self-Audit Appendix) | Appendix present and complete |
| **Test** | Master Test Prompt + URS + plan | Plan Simulation & Risk Report | **No P0s, no journey-blocking findings.** Otherwise: one remediation round, one re-test, cap there — a third round means the problem is upstream in the spec; go back to Phase 1 |
| **Execute build** | Master Execute Prompt + verified plan | The tool + `BUILD-STATUS.md` ledger | Each slice: full DoD with evidence, under production privileges; deviations recorded and approved, never silently repaired. Ends with the plan's §8 pre-ship hardening audit + the Certification Condition — blockers cleared before rollout |
| **Record** | `check_worklog.sh` + the two templates | `WORKLOG.md` (narrative) + `CODE_WORKLOG.md` (per-unit index) | **Mandatory, machine-enforced, zero tolerance.** A branch that changes product code and adds nothing to *both* records does not land. The gate exits 1 and names the missing record. Runs inside the aggregate gate the pre-push hook runs, so it cannot be walked around by accident |

---

## Why each step exists

**Phase 1 — URS.** The highest-leverage step. Every deep defect in the R&D run traced back to an unsigned, ambiguous URS: misidentified domain, invented taxonomy, ambiguous rules. The template's discipline — (Q)/(I) tags, banned words, read-back, cold test — is the control. The gate is the value: never start Phase 2 against a Draft.

**Phase 2 — Prototype.** It shows me what I'm building and shows the customer exactly how the product will work before engineering money is spent. Its rules: mark every mock (`// MOCK:`); list every invented business rule (thresholds, limits, taxonomies, formulas the URS didn't state) in an **Invented-to-Render register** — invented rules look identical to real ones once in code; keep **one canonical file**, path recorded in the URS header; walk the customer through it and capture corrections as (Q).

**Phase 3 — Architecture.** The profile (7 questions) decides the shape; the shape decides everything downstream, including how heavy the plan needs to be. The Master Build Prompt's full apparatus (Docker, Postgres, RLS, backups) applies to the web-app shape only — lighter shapes get the same *principles* at light-mode depth. Every choice records the alternative it beat and the profile fact that decided it. Any URS requirement the architecture contradicts goes back to the stakeholder as a named decision.

**Compliance review** *(when applicable).* The one gate that lives between architecture and plan rather than inside a prompt. The architecture decides what data moves where; before planning the slices that move it, the legal and regulatory surface is written down (LIA, data map, suppression plan, retention policy, privacy notice) and either an adviser has signed off or the risk has been named and accepted. Pure read-only or ephemeral-processing tools skip it. Everything that sends to third parties, handles personal data, or sits under PECR/GDPR/CAN-SPAM/HIPAA/PCI goes through it — because a compliance mistake caught in Phase 4 costs a redraft; one caught after Phase 6 costs a domain reputation, a fine, or a client.

**Plan.** One generation with the converged Master Build Prompt, fed all five inputs (URS, prototype + register, keys.md, hardening playbook, Phase 3 doc). Its Defect Register (R1–R14) encodes every defect class previous projects paid for, including R14 — eval harnesses for LLM outputs and prompts as data with provenance — for any slice that calls a model. Its Self-Audit Appendix forces the journey traces, concurrency trace, recovery traces, and guard-context table to be written before delivery.

**Test.** One mandatory adversarial pass — an hour of review against days of building from a flawed plan. **Generation without verification is never acceptable**, because the prompt carries forward defect *classes* but can never pre-encode project-specific *instances* (a misidentified domain, two correct mechanisms with incompatible stage assumptions). After every report: fold any NEW defect class into the Build Prompt's Register. That's what makes the process compound — each project's review improves every future project's first draft.

**Execute build.** The Master Execute Prompt turns the verified plan into code with zero drift. Its enemy is different from the Build Prompt's: not gaps in the plan, but silent repairs, unverified "done" claims, weakened tests, scope creep, and context loss across sessions — the anti-drift rules E1–E11 name each one, including E11 — external side-effects ship behind an approval queue by default — for agentic systems that reach outside themselves. The plan is the single source of authority; the **Deviation Protocol** is the only path by which built code may differ from it (stop → record → approve → fix), because no plan survives contact perfectly and a silent repair invalidates the review the plan already passed. `BUILD-STATUS.md` is the ledger every session resumes from, so a build spanning many sessions behaves like one continuous disciplined engineer. One slice per cycle, full Definition of Done with real command output as evidence, never the whole app in one pass. The Phase 2 prototype is recycled as the frontend against a stubbed API first; `grep MOCK:` must return zero before ship. The plan's §8 pre-ship hardening audit plus the risk report's Certification Condition run on the *built system* before rollout, even when every earlier gate was green — plan verification and code verification are different claims.

**Record.** The step every previous project skipped, which is why it is now the only step with a gate that runs on *every* push rather than once per phase. Two records, because they answer different questions with different lifetimes: `WORKLOG.md` says *why this happened* and is organised by session, `CODE_WORKLOG.md` says *what breaks if I change this file* and is organised by unit with a stable `CW-` id. A session is over once it ends; a unit outlives every session that touched it. **The question you actually have at the moment you are about to edit something is the blast radius, and it is the question nobody writes down.** Enforcement is two layers and you must not confuse what each guarantees: the gate is deterministic and proves the entries *exist*; the Stop-hook auditor is judgment and pushes for them to be *right*. One bypass flag covers both records deliberately — two flags would let one be skipped while the other is enforced, which is the exact state the gate exists to prevent. And if a repo already has a worklog gate, **extend it, never add a second**: two gates over overlapping rules drift, disagree, and each grows its own bypass.

---

## Standing rules

1. **No name, no build.** A Draft URS blocks everything downstream.
2. **The prototype's numbers and rules are dummy until confirmed.** Nothing invented-to-render reaches code as an untagged literal.
3. **Every rule is data with provenance.** Changing a business rule is a data change with a record of who and why — never a release.
4. **The profile decides the shape; the shape decides the depth.** Complexity is bought only when a profile fact forces it.
5. **Verification judges by blast radius, not happy path.** A journey the central requirement cannot complete is an automatic top finding.
6. **Customer and personal data never enter an AI tool** (URS §8), verified against the FRs, not against hope.
7. **Every gate that matters has a human name on it:** URS approval, prototype read-back, shape ratification, blocker cut line.
8. **No record, no landing.** Product code does not ship without an entry in *both* the narrative worklog and the per-unit code worklog. Machine-enforced on pre-push, zero tolerance, one bypass flag for a genuine one-off logged another way. A rule no gate enforces is a rule that gets ignored — that is the whole reason this one has a gate.

---

## The two loops (don't confuse them)

- **Prompt R&D loop** — done once, already run: iterate plan → report → fold-in until the report stops finding *general* classes (v3's count: 14 new of 17, classes migrating upward, cost falling — converged enough).
- **Production loop** — every project: generate once, test once, remediate P0s, build. Max two rounds. The test never gets skipped, at any prompt maturity — the standard is excellent *because* review never stops, and review never stops *because* the standard can't see the plan in front of it.

---

## Files

| File | Role |
|---|---|
| `Phase 1 URS-template.md` | The URS template + its quality gate |
| `Phase 2 prompt-claude.md` | The prototype-generation prompt |
| `Phase 3 Technical Architecture & Data Flow.md` | The architecture decision doc |
| `Master-Build-Prompt.md` | Generates the implementation plan (v4, Register R1–R13) |
| `Master-Test-Prompt.md` | Adversarially simulates the plan (v4) |
| `Master-Execute-Prompt.md` | Executes the verified plan slice by slice, drift-free (v1, anti-drift rules E1–E10) |
| `RUNBOOK.md` | The one-page "how to run it" |
| `keys.md` + hardening playbook | The engineering standard both prompts enforce |
| `Progress-Documentation.md` | The mandatory record step: the two records, the two enforcement layers, the CLAUDE.md rule block |
| `WORKLOG-entry-template.md` | Narrative entry template (the layout, and why not to invent a new one) |
| `CODE_WORKLOG-template.md` | Per-unit index template: CW-id conventions, field definitions, reverse-index structure |
| `check_worklog.sh` | The gate. Greenfield only; a repo with an existing gate extends it instead |
| `stop-hook-settings.json` | Stop-hook snippet for the Layer 2 auditor |
