# URS — Platform Foundations (URS-0)

| | |
|---|---|
| **Owner (builder)** | Mo |
| **Stakeholder (approves)** | Mo (self; Mo is the customer for this tool — the Consultancy OS serves Mo) |
| **Date** | 15/10/2026 |
| **Status** | **Draft** |
| **Approved by** | *(empty — pending read-back of every (I))* |

**Tags:** each statement is **(Q)** (quoted — stakeholder said it) or **(I)** (inferred — Mo filled the gap). Every (I) must be confirmed in Appendix A before approval.
**Banned words:** should, could, fast, easy, simple, user-friendly, robust, flexible, ensure, appropriate. No TBD, TBC, "to be confirmed", "later", "keep in mind".
**Canonical prototype path:** `prototype/` (Next.js, per the Phase 2 web-app exception).

---

## 1. Problem

Running the Consultancy OS as six independent agents (Prospector, Outreach Writer, Content Agent, Inbound Concierge, Reply Handler, Pipeline Analyst) means six copies of the same plumbing: lead storage, approval queue, eval harness, suppression check, auth, scheduling, compliance. Building each one in-slice means Week 1 ships without a lead table, Week 2 ships without an eval harness, and Week 3 discovers that opt-outs cannot be enforced across agents built before the suppression schema existed. Dev Process rule R6 (privileges from day one) and R13 (guard-context) both require shared platform surfaces to exist in the slice that first touches them. Without a walking skeleton that already has every seam wired, every later slice fights the same platform problems instead of adding business value. (I)

## 2. Success metric

**The walking skeleton test.** On the deployed URL, a fresh browser session can: land on the public page → see the three offers → open the chat widget (placeholder brain) → book a slot via Cal.com → produce a `bookings` row (from the webhook) and a `touches` row (from the chat exchange). End-to-end, no 500s, under production privileges, every CI gate green, every compliance doc committed. First time this passes end-to-end = Platform foundations is done. (I)

## 3. Functional requirements

| # | Requirement | Tag |
|---|---|---|
| FR1 | A Next.js 15 app (App Router, TypeScript, Tailwind, shadcn/ui) deploys to a public URL via Vercel. Landing page lists three offers: AI Feature Sprint, Multi-Agent Workflow Engine, LLM Cost & Latency Audit, each as a card with price and timeline. | (I) |
| FR2 | Postgres (via Supabase) holds seven migrated tables: `contacts`, `companies`, `signals`, `touches`, `replies`, `bookings`, `deals`. Each column, type, FK and index is defined in a versioned forward-only migration under `migrations/`. Migrations apply green from empty → head in CI. | (I) |
| FR3 | `contacts` has a `suppressed_at timestamptz` column and a unique index on a canonical email hash. Suppression writes are permanent (no `UPDATE suppressed_at = NULL` path exists in code or policy). Every outbound slice (planned in later URSes) queries `suppressed_at IS NULL` inside the same transaction as its send-claim. | (I) |
| FR4 | An approval queue table (`approvals`) and an admin UI at `/approvals` lets Mo review each drafted outbound action, approve or reject it, and see the result reflected in the downstream row. A dummy agent writes three sample drafts on first run so the queue is non-empty. | (I) |
| FR5 | A prompt registry table (`prompts`) stores every prompt with `name`, `version`, `author`, `model_id`, `model_version`, `created_at`, `superseded_by`. Code loads prompts by `name`, resolving to the newest non-superseded version. No prompt string literal appears in `src/` outside the registry seed. | (I) |
| FR6 | An eval harness runs from the CLI (`pnpm eval <prompt-name>`) against a golden set under `evals/<prompt-name>/`. GitHub Actions runs it on every push that changes a prompt or an eval, failing the build if any prompt scores below its stated threshold. One sample prompt + golden set exists so the harness is runnable from day one. | (I) |
| FR7 | Mo authenticates via Supabase Auth (magic link). The `/approvals`, `/prompts` and `/dashboard` routes require authentication. The public landing page and chat widget do not. | (I) |
| FR8 | Inngest is wired as the durable job runner. One scheduled job (daily, logs a heartbeat) and one event-triggered job (fires on `booking.created`, logs the payload) run successfully in the deployed environment, each visible in Inngest's dashboard. | (I) |
| FR9 | A Cal.com booking webhook writes a `bookings` row idempotently. Replaying the same payload creates no duplicate (unique key on Cal.com event id + attendee). | (I) |
| FR10 | Compliance docs under `docs/compliance/` are committed, dated, and complete: Legitimate Interests Assessment, data map, suppression plan, retention policy, privacy notice. The privacy notice is linked from the public landing-page footer. | (I) |

## 4. Inputs & outputs

- **Goes in:** page views from strangers (public landing), webhook calls from Cal.com (`booking.created`), scheduled triggers from Inngest, prompt edits from Mo via the registry UI (or seed script), magic-link sign-ins from Mo.
- **Comes out:** chat answers from the placeholder widget (hardcoded for now; real brain in Week 1), `bookings` rows, `touches` rows, approval-queue state transitions, eval scores to CI, structured JSON logs on every request. No email, DM, LinkedIn post, or paid-API call leaves the system in this URS — Platform foundations has no sender wired. (I)
- **Must never do:** send any external message (no sender slices in this URS). Store a plaintext email on `contacts` without the `email_hash` column populated (suppression is keyed on the hash). Run a schema migration that drops a column or table (forward-only). Bypass the approval queue for anything E11 covers. Hardcode a prompt string in `src/` outside the registry seed. Deploy with a failing CI gate.

## 5. Out of scope

- Any of the six agents' brains — URS-1 (Inbound Concierge), URS-2 (PoC + Content Agent), URS-3 (Prospector + Outreach Writer), URS-4 (Reply Handler + Pipeline Analyst), plus the Proposal Generator.
- Real cold email sending, LinkedIn posting, inbound chat answers, prospect enrichment, reply classification.
- Mobile app, desktop app, native integrations.
- Multi-user auth (team seats, roles) — single-user for the next 6 months.
- Customer billing or invoicing.
- Rate card storage (lives with the Proposal Generator, URS-5+).

## 6. Constraints

- Runs on Vercel (frontend + routing) + Supabase (Postgres + Auth + Storage) + Inngest (jobs). Local-only or static-site setups are out.
- Repo decision — monorepo with Dev Process templates or a separate repo — is open; Phase 3 resolves it.
- Every push passes the Dev Process worklog gate (`check_worklog.sh`) and the aggregate CI gate.
- Must honour the newly-patched Dev Process rules: R1–R14 (plan), E1–E11 (execute), including the step 3.5 Compliance Review gate.
- Target region of operation: UK-first; US/EU added in a later URS. Compliance docs reflect UK-first scope. (I)

## 7. Assumptions

Every item below is tagged (I) until confirmed at the read-back.

- (I) Mo owns a domain already, or acquires one in Week 0 as part of this URS.
- (I) UK-only prospects for the first 90 days; US/EU added in a later URS with a compliance addendum.
- (I) Model provider is Anthropic (Claude) accessed via the Vercel AI SDK; the SDK makes it swappable.
- (I) Supabase free tier + Vercel hobby + Inngest free + Cal.com free cover Platform foundations' running cost; upgrade decision deferred to the first slice that genuinely needs a paid plan.
- (I) Mo commits 15–30 minutes/day to the approval queue once Week 3 goes live; the queue UX is designed for that budget.
- (I) Single-user mode is acceptable for the next 6 months; multi-seat is a separate URS.
- (I) The three offers on the landing page match the playbook: AI Feature Sprint, Multi-Agent Workflow Engine, LLM Cost & Latency Audit.

## 8. Data check

- No customer data, personal data, or credentials touch an AI tool during this URS's build (no agent brains are wired yet).
- Future PII touches an LLM via the Inbound Concierge chat (Week 1 / URS-1). The step 3.5 Compliance Review for URS-1 must address that specifically before URS-1 is planned.
- Business-critical values owned here: the suppression list (replicated nowhere outside Postgres backups), the prompt registry (owned by Mo), the compliance docs (owned by Mo, reviewed with an adviser before Week 3 ships).

## 9. Open questions

**Must be empty before Status = Approved.** Five items block approval:

| # | Question |
|---|---|
| OQ1 | Which three offers go on the landing page? Current (I): the playbook's three. Confirm or revise. |
| OQ2 | Monorepo with Dev Process templates, or a separate repo for the consultancy app? Decided in Phase 3 but needed before. |
| OQ3 | Domain: already owned, or acquired as part of Week 0? If acquired: which registrar, which TLD? |
| OQ4 | Primary model provider for the agents (Anthropic / OpenAI / mix)? Determines the prompt-registry seed and the eval harness's provider SDK. |
| OQ5 | Infra budget ceiling for month 1 (zero / £50 / £150+)? Shapes free-tier vs paid decisions on Supabase, Vercel and Inngest. |

Everything else is (I) in §7 and §8 — those get confirmed at read-back (Appendix A), not blocked here.

---

## Appendix A — Read-back

20 minutes with yourself (you are the stakeholder here, but still do the read-back out loud or in writing — the discipline catches the same errors it does with a customer).

1. Answer OQ1 through OQ5 in §9. Any still open = §9 is not empty = Status stays Draft.
2. Read each **(I)** line in §2, §3, §4, §6, §7, §8 aloud. For each, say "confirmed" or "revise to: X". Any revise = fix the line, then re-read.
3. Verify §8 against §3: does FR1–FR10 feed any customer or personal data into an AI? Answer must match §8, not hope.
4. Verify §5: is anything tempting-but-out ($PoC embedding, a dashboard chart, a real send) already named in §5? If no, add it.
5. Put your name in the header. No name, no build.

## Appendix B — Quality gate (run before Status = Approved)

1. **Morning check** (next morning, not same evening, ~15 min):
   - Zero banned words anywhere.
   - Every FR testable + tagged.
   - §9 empty.
   - FR set reads as a coherent whole — no pair that cannot both be true.
   - §8 matches §3 against the data path.
   - §5 non-empty.
2. **Cold test** (~5 min): fresh Claude session, zero context. Paste §3 + §4, ask for a mockup. Any clarifying question = hole in the URS. Fix and retest.
3. **Read-back** (Appendix A, 20 min). Approver's name in header.

---

## Decision log — things worth capturing before URS-1

Items that will come up repeatedly across URS-1..6, decided here once:

- **Monorepo vs separate repo** (OQ2) — once decided, URS-1+ inherits.
- **Primary model + SDK path** (OQ4) — same.
- **Email-hash function** — FR3 depends on this. Candidate: SHA-256 of `lower(trim(email))`. Decide in Phase 3.
- **UK-first compliance scope** — step 3.5 Compliance Review's LIA assumes UK PECR; a US/EU addendum arrives with the URS that first targets those regions.

---

*Light mode considered but declined.* Platform foundations is the web-app shape per Phase 3's decision table, with 10 FRs and a non-trivial trust boundary. The full URS gate applies; the Phase 2 prototype is built in Next.js, as every prototype is (owner's rule, 16/10/2026).
