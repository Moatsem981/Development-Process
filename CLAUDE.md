# CLAUDE.md: how we work

This file is the standing set of development rules for every tool built with this process. It
was extracted on 2026-09-18 from the rules Claude follows on the MotionTech AI Platform, with the
platform-specific commands and package names taken out so the rules apply to any repository.
Copy it into a new project's `CLAUDE.md` at step 0 of the `RUNBOOK.md`, adjust paths and directory
names to that repository, and do not soften anything.

Rank the Hard prohibitions with "never push to main". Everything else follows in the order a
session meets it: the process, before work, during work, before push, the records, the UI, and
how to ask.

---

## The process

The process is `RUNBOOK.md`. Follow it top to bottom and do not skip a gate. The reasoning behind
each step is in `Development-Process.md`. The steps, each with a gate before moving on:

0. **Records** set up before any code: `WORKLOG.md`, `CODE_WORKLOG.md`, the worklog gate wired into
   pre-push, this file pasted into the repo.
1. **URS** from `Phase 1 URS-template.md`. No name in the header, no build.
2. **Prototype** from `Phase 2 prompt-claude.md`. One canonical path, Invented-to-Render register.
3. **Architecture** from `Phase 3 Technical Architecture & Data Flow.md`. Every choice names the
   option it beat and the profile fact that decided it.
4. **Plan** from `Master-Build-Prompt.md` with all five inputs and the Self-Audit Appendix.
5. **Test** from `Master-Test-Prompt.md`. No P0s, no journey-blocking findings. One remediation
   round, then back to step 1.
6. **Execute** from `Master-Execute-Prompt.md`. One slice per cycle, `BUILD-STATUS.md` ledger,
   Deviation Protocol, never a silent repair.
7. **Record** every slice, not at the end.

Standing rules of the process:

- **No name, no build.** A Draft URS blocks everything downstream.
- **The prototype's numbers and rules are dummy until confirmed.** Nothing invented-to-render
  reaches code as an untagged literal.
- **Every rule is data with provenance.** Changing a business rule is a data change with a record
  of who and why, never a release.
- **The profile decides the shape; the shape decides the depth.** Complexity is bought only when a
  profile fact forces it.
- **Verification judges by blast radius, not happy path.** A journey the central requirement cannot
  complete is an automatic top finding.
- **Customer and personal data never enter an AI tool**, verified against the FRs, not against hope.
- **Every gate that matters has a human name on it:** URS approval, prototype read-back, shape
  ratification, blocker cut line.
- **No record, no landing.** See the NON-NEGOTIABLE section below.

---

## Hard prohibitions (rank these with "never push to main")

- **NEVER invent anything. Everything must be verified before it ships.** No value, URL, field
  name, object id, endpoint, format or factual claim goes into code, a document or a message unless
  it has been proved against the real system: a query against the data, a read against the API, or
  a link confirmed working by a person. If it cannot be verified, say so and do not ship it. A shape
  derived by pattern-matching from a real neighbouring shape is still invented: on 2026-08-28 a view
  shipped links built by symmetry with a working neighbour; the object ids were real, the API paths
  were real, and the page did not exist. It was dead for two people before anyone opened one.
  Record the proof in a comment beside the value, and prefer the coarser link, number or claim that
  is proven over the precise one that is assumed.

- **NEVER change the checked-out branch of the user's working directory.** `git checkout -b` off
  the current HEAD is fine, because the working tree does not change. Moving the checkout onto a
  branch with different content is not: git deletes every tracked file absent from the target
  branch, so another concern's work disappears from the folder the user is looking at, and any
  running dev server silently starts serving a different branch's app. Committing first protects
  the content but not the appearance, and the appearance is the harm. If a different base is
  genuinely needed, `git worktree add` a separate directory and say so; if you switched anyway, put
  it back and say plainly that you moved it.

- **Check for a running dev server before anything that changes the tree.** For example
  `netstat -ano | grep :3000`. A live server plus a branch switch means the browser shows a
  different branch with no warning. LISTENING is not serving: prove a server is serving with a real
  request, not with the port list.

- **One directory, one concern, one branch.** Multiple sessions run against a repo at once, each
  owning a directory. Do not stand on a branch another session owns, and do not tidy up branches,
  worktrees or PRs that are not yours.

- **Never delete anything.** Files, records, branches, entries, history. Nothing is removed without
  an explicit instruction naming the thing. Touch only the files the named task requires.

- **Do not run unasked side-effecting commands.** A bare production build clobbers a running dev
  server's output directory; deleting that directory under a live server makes it listen without
  serving. Run the targeted command for the package or file in question, and run a whole-repo build
  or reset only when asked.

---

## Before any non-trivial change

- Read the project's `HANDOVER.md` (the canonical session-to-session resume doc) and its
  `INCIDENTS.md` (standing prevention rules learned from real outages). `CONTRIBUTING.md` is the
  durable summary of how work is done in that repo.
- Resume a tool from its `progress record/handover.md` first, then `status.md`, then the worklog.
  A build in progress resumes from `BUILD-STATUS.md`.
- Architectural conflicts with an existing `INCIDENTS.md` rule are always escalated, never
  defaulted.

---

## The tool model

- A tool lives in ONE self-contained home: `tool-library/<slug>/` on the platform, or the
  equivalent single folder in the repo you are in.
  - `Coding/` holds ALL the tool's code. `Coding/core/` is the pure package: no I/O, unit-tested.
    The app layer in `Coding/` holds route bodies, server actions and components.
  - `planning docs/` holds the URS and the build and implementation plans.
  - `progress record/` holds `status.md`, `worklog.md` and `handover.md`, the tool's live state.
- Route-special files outside the home are one-line **shims** that re-export from `Coding/`.
- Where the repo has a structure gate (`tools:check` on the platform), it runs inside the
  aggregate gate and is never bypassed.
- Scaffold a new tool with the repo's scaffolder rather than by hand, so the migration, the
  manifest registration and the folder shape are right from the first commit.
- Every tool's home-page contribution is aggregated under a settle-all wrapper so one failing tool
  cannot break the page for everyone.

---

## Engineering invariants (enforced or incident-derived)

- **Data isolation.** A tool reaches data only through the one shared data module; a lint rule
  fails the build otherwise. Likewise only the one shared AI module may import the model SDK.
- **Boundary schema.** Parse every persisted JSONB or external payload through a Zod boundary
  schema on read; degrade a malformed row to a safe null rather than trusting a blind cast or
  throwing.
- **Resilience.** Every outbound call is bounded by a timeout. Every fan-out across independent
  units runs under a settle-all wrapper with a count-only degraded log. An implausibly-empty
  upstream result must NOT overwrite good data (the empty-result-refusal guard). Read-side egress
  of sensitive tables is audited, fire-and-forget, OFF the hot path.
- **Audit vs telemetry.** The audit log is the governed, PII-redacted security record: a lost entry
  is a compliance failure. Product analytics is best-effort: a lost event is a missing data point.
  Never conflate them.
- **Server-only primitives** (audit, resilience helpers, anything importing `server-only`) throw if
  imported into a client component. Emit usage and audit events from the server action or route
  handler, not from client UI.
- **Multi-tenancy.** Default-deny row-level security with a schema per tool is the isolation
  guarantee. The RLS test suite is a gate even where it is not part of the local aggregate gate.
- **Source of truth.** The upstream system (HubSpot for projects and deals) is the source of
  truth. Local tables store derived, regenerable snapshots and identifier-only rows, never a
  mirror of a mutable upstream field.
- **Migrations are forward-only and versioned.**
- **Do NOT reset the database casually.** A reset wipes the local users and admin. When the local
  migration ledger lags concurrent work, unrelated test suites may fail for reasons that predate
  your change; separate those from your own, and do not apply unrelated pending migrations to
  "fix" them.

---

## Branches, commits, and pushing

- **Branch model.** `main` is branch-protected trunk: never push or force-push to it. Changes land
  via reviewed, CI-green PRs. Feature branches are `<author>/<topic>`, one concern per branch, one
  branch per PR. A local integration branch (`moatsem/working`) is never PR'd or merged.
- **Commits.** Conventional Commits (`type(scope): imperative subject`). Stage files **by name**,
  never `git add -A` or `git add .`. Do not amend or force-push a pushed commit; add a new commit.
  Every commit runs the secrets scanner (gitleaks) pre-commit on staged changes.
- **Quality gates run before pushing, and CI runs the same on every PR.** One aggregate gate, run
  by the pre-push hook, containing: structure check, lint with ZERO warnings allowed, typecheck
  across every package, production build, unit and integration tests with coverage thresholds,
  contract tests, licence allowlist, CVE audit, bundle size, SAST, and the worklog gate. Use the
  targeted per-package or per-file commands while iterating; the whole gate before the push.
- **Do not weaken a gate to get a push through.** If it blocks you, fix the cause or name the
  exception explicitly, with the reason and the undo written beside it.
- **Evidence before claims.** Never state that something works, passes or is done without having
  run the command in this session and shown its real output. "Should work" and green-by-assumption
  are banned. If you did not run it, say "not verified".
- **ADRs.** Architecture decisions of any weight get an ADR in `docs/adr/`.

---

## NON-NEGOTIABLE: Progress documentation

Every piece of real work updates **both** records before it is considered done. This is not a
preference and not a nice-to-have. Product code does not ship without it, and the gate refuses
the change if it is missing.

1. `docs/WORKLOG.md` is the narrative: why this work happened, what was tried, what went wrong,
   what the lesson is. Newest entry at the top. Follow the format of the entries already there
   exactly: a plain intro paragraph defining the one term the entry turns on, then `### 1.
   Situation`, `### 2. Task`, `### 3. Action`, `### 4. Result`, `### 5. Technical
   implementation`, `### 6. What I would tell someone about this`, `### 7. Where it lives in the
   code`, then a one-sentence summary a non-engineer could repeat. Prose paragraphs, bold only
   for the named lever, no em dashes. Do not invent a new layout. Template:
   `WORKLOG-entry-template.md`.
2. `docs/CODE_WORKLOG.md` is the per-unit index: what each unit is, why it is shaped that way,
   what it depends on and what depends on it. Every unit gets a `CW-` id, assigned in sequence,
   never reused and never renumbered. Dependency edges are reciprocal: if A lists B under
   `Depends on`, B lists A under `Depended on by`. Add the reverse-index row too. Template:
   `CODE_WORKLOG-template.md`.
3. The two are not interchangeable. The worklog answers "why did this happen", the code worklog
   answers "what breaks if I change this file". A session ends; a unit outlives every session
   that touched it.
4. A tool also keeps its own `progress record/worklog.md`, `status.md` and `handover.md`. Update
   them after real work and keep `handover.md` current as the resume mechanism.
5. Enforcement is the worklog gate (`check_worklog.sh` on a greenfield repo, or the repo's
   existing gate extended), run inside the aggregate gate the pre-push hook runs. If a branch
   changes product code that is not a `.md` file and adds no lines to either record, the gate
   exits 1 and names which record is missing. **If the repo already has a worklog gate, extend
   it; never add a second.**
6. `SKIP_WORKLOG_CHECK=1` bypasses both and exists for a genuine one-off (a pure infra hotfix
   logged another way). Using it as a habit is the exact failure the gate exists to stop.
7. Do not weaken the gate to get a push through. If it blocks you, either write the entries or
   name the exception explicitly, with the reason and the undo beside it.
8. Prove the gate before trusting it: change product code with no entries and watch it exit 1
   naming both records; add one and watch it fail naming the other; add both and watch it pass.
   A gate nobody has watched fail is not known to work.

Full reasoning and the two enforcement layers: `Progress-Documentation.md`.

---

## Writing and UI conventions

- **No em dashes** anywhere: code, comments, commits, docs. Use commas, colons, parentheses, or
  separate sentences.
- **Never put a backtick inside a `<style>{...}` template literal.** A backtick ends the template
  string, so the file stops parsing and the page 500s. Quote CSS identifiers in those comments
  with single quotes. This broke the same file twice on 2026-09-17.
- **A new table header copies the product's existing one.** A deeper rail so it reads as a header
  rather than the first row of data, a 1px line beneath, sticky to the top, small uppercase text
  on wide tracking in the heading face. A second header style on one product is how two screens
  start feeling like two products.
- **Never set TEXT in the hairline colour.** Measured against the surface it is 3.00:1, and WCAG
  AA body text needs 4.50:1, so any label, value, caption, hint, footnote or timestamp set in it
  is unreadable rather than subtle. It is a hairline colour: borders, dividers, the dashed edge of
  an empty state. Nothing a person has to read. On an SVG `<text>` the property is `fill`, not
  `color`, and the same floor applies.
  - Text that carries meaning uses the primary ink token and is **bold** when it is a label
    somebody scans for, such as a phase, a stage, a status or an owner.
  - The muted ink token is the floor for genuinely secondary prose, and only prose.
  - For maximum-contrast text prefer the ink token over a literal `#000`. A hardcoded black turns
    invisible on the dark themes and on the one nobody has written yet.
  - Minimum size for any label a person reads while scanning is **13px**. 11px greys were how
    this rule got written, on 2026-09-17, against a screen the reviewer could not read.
- **Prototype mocks are marked.** Every mock in a prototype carries `// MOCK:`; before ship,
  `grep MOCK:` returns zero hits.

---

## Question budget and how to answer

- Batch questions and cap them at three per checkpoint. Ask only where a wrong assumption would
  cost real time or money to unwind. For everything else, pick the most defensible default, act on
  it, and list what you assumed in a "Defaults applied" block at the end of the response so it can
  be corrected in one message.
- Never ask permission about empty files, obvious gitignore candidates, or anything a `git diff`
  would settle.
- Exception: architectural conflicts with an existing `INCIDENTS.md` rule are always escalated,
  never defaulted, regardless of budget.
- Be direct. Short answers, decisions first, act on answers already given, no menus of options.
