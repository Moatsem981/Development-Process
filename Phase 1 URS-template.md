# URS — [Tool Name]

| | |
|---|---|
| **Owner (builder)** | |
| **Stakeholder (approves)** | |
| **Date** | DD/MM/YYYY |
| **Status** | Draft / Approved |
| **Approved by** | *(name goes here only after the read-back, Appendix A)* |

**Tags:** every captured statement is marked **(Q)** — quoted, the stakeholder said it — or **(I)** — inferred, you filled the gap. Every (I) must be confirmed in the read-back before approval.

**Banned words:** should, could, fast, easy, simple, user-friendly, robust, flexible, ensure, appropriate, etc. If a requirement contains one, rewrite it until a stranger could mark it pass/fail.
**Also banned anywhere in the document:** TBD, TBC, "to be confirmed", "later", "keep in mind". An open decision hiding in any section counts as §9 not being empty.

---

## 1. Problem
One paragraph: what goes wrong today, for whom, and how often. No solution language.

## 2. Success metric
The one number that proves the tool worked. (e.g. "quote prep drops from 45 min to under 10.") If you can't write the number, go back to §1.

## 3. Functional requirements
Numbered. Each one testable — a stranger could mark it pass/fail. Each tagged (Q) or (I).

| # | Requirement | Tag |
|---|---|---|
| FR1 | | |
| FR2 | | |

## 4. Inputs & outputs
- **Goes in:** what data, in what format, from where. Include one real example.
- **Comes out:** what result, in what shape, and what the user does with it next.
- **Must never do:** the hard prohibitions. (e.g. "never invents a rate not in the rate card.")

## 5. Out of scope
What this tool deliberately does NOT do. Kills scope creep before it starts.

## 6. Constraints
Where it runs, who can reach it, what it depends on. Only what's genuinely fixed.

## 7. Assumptions
Everything you believe but haven't verified. Each tagged (I) until confirmed.

## 8. Data check
Confirm: no customer data, personal data, or credentials touch the AI tool. If any data is business-critical (rates, margins), name who owns it.

## 9. Open questions
**Must be empty before Status = Approved.** Anything still here means the URS isn't done.

---

## Appendix A — Read-back
20 minutes with the stakeholder. Read every **(I)** line aloud. They correct it or confirm it. When every (I) is confirmed, they put their name in the header. No read-back, no approval.

## Appendix B — Quality Gate (run before Status = Approved)
1. **Morning check (you):** next morning, not the same evening. ~15 min, four sweeps:
   - No banned words anywhere (including TBD/TBC/later); every requirement testable + tagged; §9 empty.
   - **Read the FRs as a set:** flag any pair that cannot both be true, and any requirement that is precise but looks unwise — you don't resolve these yourself, you raise them at the read-back.
   - **Verify §8 against the FRs:** does any requirement actually feed customer or personal data into the AI? §8's answer must match what the FRs say, not what you hope.
   - **§5 must not be empty** — every tool has at least one tempting non-feature to name.
2. **Cold test:** fresh AI session with zero context. Paste §3 + §4, ask for a mockup. Any clarifying question that comes back = a hole in the URS. Fix and retest. ~5 min.
3. **Read-back:** run Appendix A. Stakeholder signs the header. ~20 min.

---

*Light mode (tools under ~3 days): §1, §2, three FRs, §4, §5 — half a page. The gate still runs, just faster.*
