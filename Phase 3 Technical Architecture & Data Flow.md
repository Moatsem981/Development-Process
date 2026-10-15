# Phase 3 — Technical Architecture & Data Flow

**Goal:** every technical choice is made, justified, and written down BEFORE code exists — so building is execution, not invention.
**Failure this phase prevents:** rebuilding the tool in month two because the first architecture couldn't hold the real requirements.

> **How to use this document**
> **You, manually:** work top to bottom. Section 0 first — every later choice is derived from it. Follow each decision guide, write down what you chose AND what it beat.
> **Claude:** you are producing the Phase 3 architecture document for the URS provided. Fill Section 0 from the URS, then make every choice by applying the decision guides below to that profile — never by habit or by what is most impressive. The tables below are defaults, not the universe: consider the full current landscape, and if something outside the tables is genuinely better for THIS profile, choose it and show your working. Every choice must name the alternative it beat (including the table default, if it lost) and the profile fact that decided it. If the URS doesn't answer a Section 0 question, stop and ask — do not guess. Output: this same structure, filled in, with all guidance text removed.

---

## 0. Project Profile — answer these seven before choosing anything

Every architecture decision in this document is a function of these answers. If two people disagree on a choice later, come back here — they're really disagreeing about one of these.

| # | Question | This project's answer |
|---|---|---|
| P1 | How many users, and are they concurrent? | |
| P2 | Is there logic or data that must stay hidden from users? (margins, rates, keys) | |
| P3 | Does it need data from, or send data to, another system? | |
| P4 | Does state need to persist between sessions? Shared between users? | |
| P5 | Expected lifespan — weeks, or years? | |
| P6 | Who maintains it when you're away? | |
| P7 | Where does it physically run, and what's the connectivity there? (office network / customer site / offline) | |

**Why these seven:** P1–P2 decide whether a backend exists at all. P3 decides integration complexity. P4 decides storage. P5–P6 decide how boring the stack must be. P7 can veto a whole shape — a tool needed offline on a factory floor cannot be a web app, whatever the other answers say.

---

## 1. Technology Stack

### The master rule
The best choice for THIS profile wins — no restrictions, no loyalty to any stack. But "best" is argued against the profile in writing, never felt. The tables below are opening bids: proven defaults that must be beaten, not obeyed. Two forces to hold in balance:
- **Against novelty:** complexity is only bought when a profile fact forces it — never for learning, résumés, or "we might need it later." You can always upgrade a tool that's too simple; you can rarely simplify one that's too complex.
- **Against comfort:** the default is not automatically right either. Before recording a choice, ask once: *is there anything — in the tables or outside them — that beats this for this profile?* If yes, it wins, and the default is recorded as the loser with the reason it lost.

### Decision guide — the shape of the tool

Work down this list; take the FIRST row that fits. Each step down costs roughly 10× the maintenance of the one above.

| If the profile says... | Build... | Because... |
|---|---|---|
| P2 = nothing hidden, P4 = no shared state | **Single HTML file** (HTML + Tailwind CDN + vanilla JS) | Zero hosting, zero deployment, survives you leaving. Double-click and it works. |
| Users already live in Excel and the data is already there | **Spreadsheet + script** (Office Scripts / VBA) | Meets users where they are; no new tool to adopt. |
| No UI needed — it transforms files or runs on a schedule | **Python script / CLI** | UI is the most expensive part of any tool; skip it when nobody needs one. |
| P2 = yes (hidden logic/secrets) OR P4 = shared state OR P3 = live integration | **Web app: backend + thin frontend** | The browser is enemy territory (see §3) — anything secret needs a server to hide behind. This is the ONLY row where a backend is justified. |
| It extends an existing platform/codebase | **Whatever that platform uses** | Consistency beats preference — one estate, one stack. Inherit, don't choose. |
| None of the rows above fits | **Stop — write the new shape down with its own because** | The table is a default, not a law. But a new shape must be argued in writing, never slid into. |

**Red flag to catch yourself on:** if you picked "web app" and P2/P3/P4 are all "no", you picked it because it feels more real. Go back up the list.

### Decision guide — inside the web app row

| Layer | Default | Change it only if... |
|---|---|---|
| Frontend | HTML5 + Tailwind (CDN) + vanilla JS | The UI has genuinely complex shared state (drag-drop boards, live collaboration) → then a framework (React, Vue, Svelte…) earns its build step. Forms + tables + results never justify one. |
| Backend | Python + FastAPI | An existing system dictates otherwise, or the workload genuinely favours something else (heavy realtime → Node/Go; the point is fit, not the brand). |
| Storage | See the storage ladder below | — |
| Hosting | Wherever the last tool lives; the deployment target from Phase 6 | Never invent new infrastructure per tool. |

These are defaults, not a whitelist — any technology on earth is eligible if it beats the default *for this profile*, in writing. What's banned is not "other tech"; it's an unargued choice.

### The best-choice challenge (run once, before recording)
For each layer, ask — or have Claude research — one question: *"Given this exact profile, is there a better option than what I've picked, anywhere in the current landscape? Argue for it, then tell me if it truly beats my pick or not."* Two minutes. Most of the time the default survives, and now it's a decision instead of a habit. When it doesn't survive, you just avoided building on the wrong foundation.

### Decision guide — the storage ladder
Climb only when the current rung provably fails. Each rung up adds a real operational burden (backups, migrations, access control).

1. **Nothing** — recompute every time. *Fails when:* users must see past results (P4).
2. **localStorage** — per-user, in the browser. *Fails when:* data is shared between users, or must survive a cleared browser.
3. **SQLite (one file)** — shared, persistent, zero admin. *Fails when:* many concurrent writers, or the platform already runs a DB.
4. **Postgres / platform DB** — only if the tool lives inside a platform that already operates one.

**A rate card is not "storage"** — it's versioned config. A JSON file in the repo, with a version field, beats a database table for anything that changes monthly and must be auditable (you must be able to answer "which rates produced March's quote?").

### Record it

| Layer | Choice | Beat (alternative) | Deciding profile fact |
|---|---|---|---|
| Shape | | | |
| Frontend | | | |
| Backend | | | |
| Storage | | | |
| Hosting | | | |

---

## 2. Data Flow

One request, five layers. **Collapse rule:** a single HTML file has no Transport/Processing split — layers 2–4 merge into "JS computes" and the diagram shrinks to three boxes. Never draw layers the project doesn't have.

1. **Input** — user acts on the frontend.
2. **Transport** — JS packages it as an HTTP POST to the API.
3. **Processing** — backend validates, runs the business logic, calls external systems if needed.
4. **Response** — backend returns structured JSON (one consistent shape for success, one for errors).
5. **Rendering** — JS updates the DOM.

```
┌──────────┐   ┌───────────┐   ┌──────────────────┐   ┌──────────┐   ┌───────────┐
│  INPUT   │──▶│ TRANSPORT │──▶│   PROCESSING     │──▶│ RESPONSE │──▶│ RENDERING │
│ form/UI  │   │ HTTP POST │   │ validate + logic │   │   JSON   │   │ update DOM│
└──────────┘   └───────────┘   └────────┬─────────┘   └──────────┘   └───────────┘
                                        │
                                        ▼ (only if P3 = yes)
                               ┌──────────────────┐
                               │ External API / DB│
                               └──────────────────┘
```

**Draw yours** with real names ("costing sheet upload", not "user input"). If you can't name what moves across an arrow, you don't understand the flow yet.

---

## 3. Trust Boundary — what lives where

**The one question, asked per asset:** *would it hurt if a user read it, or edited it?* Reads-hurt or edits-hurt → backend. Neither → frontend is fine.

Anything in the browser is fully readable and editable by anyone who presses F12. This is not a maybe.

| Asset | Frontend / Backend / Both | Why |
|---|---|---|
| Business formulas, margins, rates | Backend | Reads hurt (proprietary) and edits hurt (wrong quotes) |
| Input validation | Both | Frontend for instant feedback; backend as the actual control |
| API keys, secrets | Backend only, via env vars | Never in client JS, never in the repo |
| Display formatting | Frontend | Neither hurts |

**Rule:** a client-side check is a usability aid, never a security control. Every rule enforced in the browser is enforced again on the server. (Single-HTML-file tools have no backend — which is exactly why they're only allowed when P2 = nothing hidden.)

---

## 4. API Contract

Agree this before either side is built — it's what lets the frontend be built against a stub (see §7) and is the only page both halves of the build must agree on.

**Rules:** every endpoint validates its input and returns errors in ONE shape: `{ "error": true, "message": "...", "field": "..." }` — never a raw stack trace. Name fields in the domain's language (`part_number`, not `input1`).

| Method | Path | Request body | Success response | Errors |
|---|---|---|---|---|
| POST | `/api/[name]` | `{ ... }` | `{ ... }` | 400 invalid, 401 unauthorised, 500 server |

Include one real example request and response per endpoint — examples catch what schemas miss.

---

## 5. Data Handling

**Rule: store nothing unless a URS requirement demands it.** Every stored byte is a liability you now back up, secure, and eventually explain.

- **Stored:** [what persists, or "nothing — processing is ephemeral"]
- **Personal data:** [what's touched; stored or discarded. Customer/personal data never enters an AI tool — URS §8 already confirmed this]
- **Versioned config:** [rate cards etc. — version field, who owns updating it, by what process]
- **Retention:** [how long, what deletes it. **"Forever" is not a retention policy** — every stored personal detail needs a reason and an end date]
- **Access:** [who reads data, who changes the rules]

---

## 6. Failure Modes

**Rule: one row per external dependency, minimum — no exceptions.** If §2's diagram shows an arrow leaving your system, that arrow gets a row. Wrong output is worse than a crash; every failure here must be loud.

| What fails | What the user sees | What the system does |
|---|---|---|
| Backend unreachable | [specific message] | [block with message / retry] |
| External API down or slow | [specific message] | [fallback / fail loud — never a silent wrong answer] |
| Bad input reaches the backend | [specific message naming the field] | Reject 400, log it |
| Config/rate file missing or malformed | [specific message] | Refuse to start — never compute on defaults |

---

## 7. Build Sequence

Order of construction — each piece provable as it lands, and the Phase 2 prototype is recycled, not discarded:

1. Agree the API contract (§4).
2. Take the Phase 2 prototype as the frontend; wire it to a stubbed response matching the contract. UI provable with no backend.
3. Build the backend logic as pure functions first (no web framework), tested directly.
4. Wrap the functions in the API endpoints.
5. Swap stub for real call — a one-function change. Grep for `// MOCK:` — must return zero hits.
6. Verify end to end against the URS acceptance criteria.

---

## 8. Open Questions

**Must be empty before Phase 4 starts.** Same rule as the URS's §9.

| # | Question | Owner | Needed by |
|---|---|---|---|
| 1 | | | |

---

## Exit Criteria (all must be true)

1. Section 0 is filled and every §1 choice cites the profile fact that decided it.
2. Every choice records the alternative it beat (the table default counts as an alternative if it lost). "Chose X" with no loser named = decision not actually made.
2a. The best-choice challenge was run on every §1 layer — each choice survived an open-field comparison, not just the table.
3. The data-flow diagram uses this project's real names, with only the layers this project has.
4. Every §3 asset placement answers the reads-hurt/edits-hurt question.
5. Every external arrow in §2 has a row in §6.
6. §8 is empty.
7. **Cold test:** a stranger (or a fresh Claude session) given only this document and the URS could start building without asking a question.
8. **Collision rule:** any URS requirement this architecture contradicts (a requirement the trust boundary, the shape, or the profile makes impossible or unsafe) has gone back to the stakeholder as a named decision — never silently obeyed, never silently overridden.

---

*Light mode (tools under ~3 days): Section 0, the shape decision from §1, the trust-boundary table, and one failure row per dependency. Half a page. The exit criteria still apply.*
