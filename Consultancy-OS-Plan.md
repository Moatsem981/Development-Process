# Consultancy OS — the plan behind the playbook

**Owner:** Mo · **Date:** 2026-10-15 · **Status:** Draft, pending URS-0
**Target:** build a steady, sustainable pipeline. Not 1 client/week — aim for consistent inbound and a healthy funnel, pace via the weekly report.

Dev Process (`CLAUDE.md`, `RUNBOOK.md`, the three master prompts) is the delivery engine. This document is the acquisition engine that keeps it fed. Every row in §2 is itself a tool to be built *via* Dev Process.

---

## 1. Short answer

Dev Process is a delivery engine, not a consultancy. It makes sure every tool shipped is reliable, documented and drift-free. It does nothing to **get** clients, **qualify** them, or **measure** revenue. Those three gaps are what sit between the playbook and 1 client per week.

**What Dev Process covers today.** Shipping one tool for one known client, from URS to code to records, with no silent drift. Scales linearly: one disciplined build at a time. Nothing about marketing, prospecting, pricing, measurement.

---

## 2. What's missing — the Consultancy OS

Each row is a tool to be built via Dev Process. Build order matters.

| # | Tool | Why it's load-bearing |
|---|---|---|
| 0 | **Platform foundations** (schema, auth, approval queue, eval harness, suppression list, compliance gate) | Everything else blocks on this. Not in the original Growth Engine Plan; added because every agent downstream fights the same platform problems without it. |
| 1 | **Starter Kit repo** | Launch Plan step 1 of the playbook. Next.js + Vercel AI SDK + Supabase pgvector + Drizzle + LangGraph.js + Inngest + auth + zod + eval harness + CI, pre-wired. Protects margin on every client project after. |
| 2 | **Prospect Signal Agent** (the Prospector + Outreach writer from the Growth Engine Plan) | Scrapes real buying signals: Seed/Series A B2B SaaS funding, "AI engineer" job posts, HN/Reddit pain threads, GitHub issues tagged RAG/LLM, LinkedIn posts by target founders. Scores leads, drafts a signal-referenced first-touch email, drops into the approval queue. **This is the enquiry pump.** |
| 3 | **PoC Factory** | The three playbook PoCs (Auto-Architect / Smart-Routing / PRD Engine) built once as public demos, each with a 2-min Loom + LinkedIn post. Inbound magnet, not a product. |
| 4 | **Inbound Concierge** (chat + RAG + Cal.com) | Public landing page with the three offers. Chat widget answers questions from offers and case studies, qualifies, books a call. Converts an enquiry into a draft URS ready for the human read-back. |
| 5 | **Reply Handler** | Classifies inbound replies (interested, not now, question, unsubscribe), drafts answers, processes opt-outs instantly. |
| 6 | **Content Agent** | Turns build logs, PoCs and commits into LinkedIn posts and short technical articles. Human approval before publish. |
| 7 | **Proposal / Scope Generator** | Takes the draft URS + rate card, emits a fixed-price, fixed-scope proposal (AI Feature Sprint / Workflow Engine / Audit). Keeps billing off hourly. |
| 8 | **Pipeline Analyst / Dashboard** | Weekly report: reply rates by signal and message angle, calls booked, cost per lead; the only thing that answers "is this working?" |

Items #2 + #3 + #6 + #7 together **are** the marketing system. There is no separate marketing tool.

---

## 3. Three Dev Process additions needed for agentic systems

Dev Process was designed for deterministic code. Agentic systems break three of its implicit assumptions. These additions close the gap and should go into `Master-Build-Prompt.md`, `Master-Execute-Prompt.md` and the RUNBOOK before URS-0 is drafted.

| Rule | Addition | Why |
|---|---|---|
| **R14** | LLM outputs are tested by **eval**, not by invariant. Golden-set evaluation per agent, run on every prompt change, fail CI below threshold. Prompts stored as **data with provenance** (version, author, win-rate), never as string literals in code. | R7 says "tests that can fail"; `assertEqual(output, expected)` is wrong for LLMs. R12 (invented data is tagged data) extends: prompts are invented rules. |
| **E11** | External-side-effect slices ship **behind an approval queue by default**. No email, DM, booking, LinkedIn post, or paid API call leaves the system without a human-approved action unless the plan explicitly says otherwise with a Deviation Protocol note and a stated bound. | Stops future slices quietly auto-sending once the queue "feels mature". |
| **New gate** | **Compliance Review** between Phase 3 (Architecture) and Phase 4 (Plan). Legitimate Interests Assessment (UK PECR), data map, suppression schema, retention policy, opt-out plumbing — written down and signed before any send slice is planned. | Phase 3 handles trust boundary but not legal boundary. |

---

## 4. Three gaps in the Agentic Growth Engine Plan to close before build

1. **Eval harness is missing.** Six LLM agents, no way to tell when one gets worse. Add it as the Platform foundation (week 0), not as a later agent. Golden set of 30–50 labelled inputs per agent, Vercel AI SDK plays well.
2. **Suppression list isn't a schema invariant.** `suppressed_at` column on contacts with a unique index. Every outbound slice queries it **inside the same transaction as the send-claim**. Opt-out = permanent, instant, uncheckable. This is R13 territory (guard context).
3. **Idempotency on sends.** Inngest retries. Without an idempotency key per `(contact_id, campaign_id, step_n)`, a transient failure double-sends a cold email and costs a domain reputation. R4 territory (idempotency × retries).

Two smaller: feedback loop from won/lost deals back into Prospector scoring, and a DR drill for the lead DB.

---

## 5. Success measurement — the only numbers that matter

Pick one leading, one converting, one lagging. Everything else is vanity.

| Metric | Target (first 90 days) | What it proves |
|---|---|---|
| Qualified inbound DMs / week | 5+ | Signal agent + PoC content is landing |
| Discovery call → signed URS | 25% | Intake agent + positioning is tight |
| Cash collected / month | $8k (one Sprint) → $25k | Delivery capacity + pricing works |

"Instantly getting enquiries" **is** that first row. If it's zero after 30 days, the problem is distribution (PoCs not shipped, Signal Agent not firing, LinkedIn silent), not delivery. Dev Process can't fix a distribution problem.

Pace from the weekly Pipeline Analyst report. Scale sending volume, PoC output and content cadence based on reply rates by signal and message angle — not on a fixed client-per-week quota that forces compromises on quality or compliance.

---

## 6. Build order — mapped to Dev Process cycles

| Week | URS | Dev Process shape | Done when |
|---|---|---|---|
| **0** | **URS-0 Platform foundations** (schema, auth, approval queue, eval harness, suppression list, compliance docs) | Full web-app pipeline | A stranger can land, DB and queues exist, LIA on file, eval harness runs green |
| 1 | **URS-1 Inbound Concierge + landing page** | Light mode (prototype is the landing) | Stranger can ask questions and book a call |
| 2 | **URS-2 PoC #1 + Content Agent** | Light mode per PoC | First two LinkedIn posts live, Loom published |
| 3 | **URS-3 Prospector + Outreach Writer + approval queue** | Full pipeline | First 50 scored leads, first approved emails sent |
| 4 | **URS-4 Reply Handler + opt-out automation + Pipeline Analyst** | Full pipeline | Replies classified and drafted; first weekly report |
| 5–8 | Tune on the weekly report; URS-5 Proposal/Scope Generator; PoCs #2 and #3 | Mix | Reply rate ≥ 5%, discovery calls ≥ 1/week |
| 9–12 | Scale sending volume; price iterations | Mix | Pipeline fires consistently; targets in §5 hit |

---

## 7. Open questions (must be answered before URS-0)

- [ ] Monthly budget for data (Apollo/Clay/Hunter), sending (Instantly/Smartlead), model API?
- [ ] Existing domain and website, or week 0 starts from zero?
- [ ] Minutes/day available for the approval queue?
- [ ] UK-only prospects, or UK + US + EU? (Compliance surface changes.)
- [ ] Which PoC (GitHub / HubSpot / Notion) ships first?

---

## 8. Where to go from here

1. **Patch Dev Process** — write R14, E11 and the Compliance Review gate into the master prompts and RUNBOOK. 10 minutes.
2. **Answer §7 open questions** — half an hour with pen and paper.
3. **Draft URS-0 Platform foundations** using `Phase 1 URS-template.md`, light mode acceptable. Half a day.
4. **Start building week 0.** From here on it's Dev Process.

Related docs:
- `CLAUDE.md` — standing rules for every tool built from this repo
- `RUNBOOK.md` — the seven-step pipeline
- Playbook (Claude Doc): https://claude.ai/code/artifact/91e347ac-b83b-44f4-b939-9931080279ce
- Agentic Growth Engine Plan (Claude Doc): https://claude.ai/code/artifact/ea52a519-cffc-403c-9c25-7c52063a3bb0
