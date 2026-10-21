# Pre-ship hardening: the adversarial multi-dimension audit (reusable playbook)

A reusable method for answering one question honestly before a system meets real users: **"is this safe to roll out to multiple people, or only safe to demo?"** Extracted from a real pre-ship hardening run on a production internal platform (2026-06-19), generalised so any tool the factory builds inherits the same discipline instead of re-deriving it.

This is a VERIFY-TIME / OPERATE-TIME practice. It plugs in after build, before rollout. It reinforces keys 4 (security), 14 (reliability), 15 (performance), 12 (monitoring), 18 (backup/DR), 3 (testing), 26 (accessibility). See `keys.md` and `pipeline-stage-map.md`.

## Why this exists (the lever)

"The code is good" and "the system is safe to roll out" are different claims, and teams routinely conflate them. A clean, typed, well-factored codebase can still be unshippable because the **perimeter** (who can get in, what they can see) and the **operational net** (does an outage page anyone, is there a tested restore) are not ready. The hardening audit separates code quality from rollout readiness and produces a severity-graded, evidence-backed verdict a manager can act on.

The transferable principle: **judge the system at its blast radius, not its happy path.** One unguarded middleware call that runs on every request is a bigger risk than a hundred messy-but-isolated functions.

## The method (repeatable)

1. **Audit across fixed dimensions in parallel, not as one pass.** Run independent reviewers (or review passes) over a fixed set of dimensions so coverage is systematic and nothing hides in a gap between two people's mental models. The original run used nine: security, error-handling, testing, performance, reliability, code-quality, accessibility, ops, plus one deep-dive on the slowest real user path. Each dimension maps to a framework key, so the audit is the scorecard applied adversarially.
2. **Adversarially verify every high/critical finding before it counts.** A finding is not real until you have traced it to a file:line and confirmed the exploit/failure path actually reaches it. This kills the two failure modes of audits: false positives (a guessed risk that the code already handles) and false confidence (a real risk waved away). The original run explicitly refuted some findings on verification (e.g. a snapshot-RLS worry that a sibling code path made moot) and *downgraded* others, which is what makes the surviving list trustworthy. **Method note: verify against ground truth (the actual file, the actual config, the live state), never from memory or assumption.**
3. **Grade by severity and separate blockers from backlog.** Critical = do not roll out at all. High = fix before wider rollout. Medium/Low = backlog, grouped by dimension. Give honest counts (e.g. "3 critical, 21 high, 29 medium, 27 low"). The point of the grading is the cut line: the verdict names the few things that block, so the team is not paralysed by the long tail.
4. **Write a one-paragraph verdict in plain English first.** Lead with the decision ("do NOT roll out today; here are the four reasons") before the evidence. The reader who only has 30 seconds gets the actionable truth; the reader who needs the file:line reads on.
5. **Order the fix work fast/cheap-and-high-impact first.** Two of the four blockers in the original run were hours of code; two were operational (backups, monitoring). Sequencing them by effort-vs-blast-radius turns "not safe" into "safe for a controlled group" in the shortest path.
6. **Pair the audit with a test plan that locks the fixes in.** Every blocker fixed should leave behind a test so it cannot regress, ordered most-valuable-first (see the test-plan section below). A fix with no test is a fix that silently comes undone.

## The recurring defect classes (what to look for, and the fix pattern)

These are the transferable findings: the *class* recurs across systems even though the file:line is specific. Look for each one in any new tool.

- **Self-provisioning perimeter.** An auth flow that creates an account on first sign-in (`shouldCreateUser: true`) gated only by an email-domain check is not invite-only, it is "anyone with a company mailbox." *Fix pattern:* create accounts ONLY through an explicit invite/admin path; the login flow looks up an existing profile and refuses (with a generic, non-enumerating message) if absent. Tighten the DB-trigger that mints the profile so it requires a pending invite, not just a domain match.
- **Unguarded code on the universal path.** Anything that runs on *every* request (middleware, an auth refresh) with no try/catch and no timeout is a single point of total outage: one upstream blip becomes an edge 500 for everyone at once, and route-level error boundaries do NOT catch middleware throws. *Fix pattern:* wrap it in try/catch and degrade (treat as logged-out, still emit security headers, redirect protected paths) rather than throw; add a 2-3s timeout (`Promise.race`/`withTimeout`) around any network call on that path.
- **Sign-in mistaken for authorisation.** Gating sensitive surfaces with "is logged in" (`requireUser`) instead of "has the right role" (`requireRole`) leaks data to lower-privilege accounts (e.g. an external partner reading the full pipeline). The role check usually already exists; it is just not applied. *Fix pattern:* put a deliberate per-surface role floor at the top of each sensitive page/action.
- **Backups that are not backups.** Dumps written to the same VM they protect, with the off-VM copy "still owed" and no restore ever run, are a total-data-loss exposure on a single failure. *Fix pattern:* automate an off-VM push as the last backup step with its own failure alert; add integrity verification (`gunzip -t`); and actually RUN a restore drill against the real stack (not a different stack's PITR) before rollout, verifying row counts and an app boot.
- **No detection.** Health/status endpoints that nothing polls, no disk alert, no restart-loop watch, `restart: unless-stopped` silently looping a wedged container. Mean-time-to-detect becomes "whenever a user complains," and it compounds the backup gap: you cannot react to failures you cannot see. *Fix pattern:* a ~20-line cron curling `/health` + `df` on the data volume + a restart-count watch, posting to a chat webhook; document the notification target.
- **Transport with no timeout / no abort.** External `fetch` calls with no `AbortSignal` leak sockets when an upstream connects but never responds; a "timeout" that only races a timer without aborting the request still holds the socket and (worse) a concurrency slot. *Fix pattern:* `AbortSignal.timeout(ms)` on every external call; ensure the timeout actually aborts.
- **Cache stampede (no request coalescing).** A get-miss-load cache with no in-flight tracking means N concurrent cold-cache viewers each fire the full upstream crawl, an N-times multiplier exactly at the worst moment (9am rollout, post-redeploy). *Fix pattern:* single-flight via a `Map<key, Promise<T>>` so concurrent misses await one load; delete on settle; optionally pre-warm on boot.
- **Non-atomic rate limit (TOCTOU).** Count-then-insert with no lock lets concurrent requests all read the same pre-insert count and all pass, over-running the cap. *Fix pattern:* take a transaction-scoped advisory lock on the bucket key at the top of the function; test with N concurrent calls asserting at most `limit` succeed.
- **Brand colour that fails contrast.** White text on a light brand accent (measured 2.50:1 vs WCAG AA 4.5:1) across every primary button is the most likely real a11y complaint and fails any automated axe run. *Fix pattern:* use a dark ink ON the accent fill for text-bearing surfaces (never white-on-light-accent); keep the accent for borders/accents. (This very report's in-platform viewer follows the fix: midnight ink on coral, never white.)
- **Untested security-critical glue with the safety net down.** The auth gate, the tenant-isolation RLS on new tables, and the middleware are the highest-value things to test and are the things most often shipped with zero coverage, especially when CI cannot run (e.g. an exhausted Actions budget). *Fix pattern:* prioritise these tests above feature tests; add an enforced local pre-push hook to substitute for CI while it is down.

## The pre-ship test plan ordering (most valuable first)

When CI is down or coverage is thin, order the catch-up by what protects the rollout, not by what is easy:
1. **Tenant-isolation tests (RLS/authorization) on every new data-bearing table** , positive AND negative (own-row allowed, cross-user denied, machine-write-only enforced). This is the proof that one user cannot read another's data.
2. **The universal-path integration tests** (middleware/auth gate): firewall reject/allow, auth redirects both directions, the crash-guard degrades to logged-out rather than 500.
3. **The sole auth-gate flow** (OTP/login): bad-domain rejection, rate-limit branches, generic non-enumerating errors, invalid/expired code, audit emission on success.
4. **Concurrency tests** for any limiter or lock (ties to the TOCTOU class).
5. **Reliability unit tests** for the batch/persist paths (mixed ok/error inputs complete; writes swallow errors; reads return null on error).
6. **Correctness regressions** for any bug that distorts a headline business number.
7. **Smoke + a minimal e2e happy path**, runnable locally.
8. **Automated a11y smoke** (axe over the key screens) , catches contrast/focus/role findings mechanically.
9. **Load/soak** on the hottest path to find the upstream rate-limit ceiling before the first busy morning.

## How to apply it in the pipeline

- The audit is a **verify-time gate artifact**: produce a `PRE-SHIP-HARDENING-REPORT.md` (verdict, blockers, highs, grouped medium/low, a fetch-speed/performance deep-dive on the hottest path, the test plan, the ordered work). The verifier soldier owns running it; the project-manager wires it into the per-tool output set, same as the code-quality review and quality dashboard.
- Surface it where the operator will see it. The original run also built an in-platform, super-admin-only **engineering-health viewer** that renders the report's verdict + top risks + per-dimension cards from a single JSON contract, so the audit is a living dashboard, not a one-off document. The viewer is gated by admin AND an explicit allowlist (because it exposes the attack surface), and it deliberately demonstrates the contrast fix it reports.
- Re-run on a cadence and before each rollout widening. The verdict is a point-in-time read; the dimensions are fixed, so re-running is cheap.

## Honest ceilings (record these, do not pretend)

- Some findings are correctly DOWNGRADED on verification (a worry a sibling path already mitigates). The audit's credibility comes from refuting as readily as confirming.
- An operational blocker (off-VM backup, monitoring) is often half-built; say which half is done and which is owed, with the file:line of the owed work.
- "Safe for a controlled group early next week" is a more honest verdict than "ship Friday" when blockers remain. Naming the realistic date is part of the deliverable.
