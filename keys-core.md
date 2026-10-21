# Framework Knowledge: Core Keys (the fast path)

> **This is the curated FAST PATH, not the full reference.** It lists only the load-bearing keys that almost every real tool needs, one line each, so a soldier can ground quickly. `keys.md` is the FULL reference (all ~258 keys, full mechanism, and the situational/long-tail keys this file deliberately omits). When a key here matters to your build, open its full entry in `keys.md` (same 27-item taxonomy, same item numbers) for the concrete threshold, tool, and source.

How to read this file: each line is `**key name** - one-line mechanism (keys.md item N)`. Items whose keys are situational for most tools are marked "situational" with a pointer, not padded. Pick up the full detail from `keys.md` before you plan or verify against a key.

---

## BUILD

### 1. Project structure & architecture
- **Build on an established framework** - use React/Next/Express/Flask etc. and follow its conventions, don't hand-roll the platform. (keys.md 1)
- **Separation of concerns (modular + layered)** - insulate business logic from the DB and the invocation mechanism. (keys.md 1)
- **Right-size component count / build for benefit not speculative reuse** - monolith for small/simple; every split adds failure and versioning modes. (keys.md 1)
- **Thin vertical slices / walking skeleton** - 2-5 items per increment, end-to-end early. (keys.md 1)

### 2. Tooling & environment
- **One consistent CLI command for the whole test suite** - same command locally and in CI (`make test` / `pnpm test`). (keys.md 2)
- **Identical environments + locked dependency versions** - Docker/IaC + a lockfile (package.json/requirements.txt) so it runs the same everywhere. (keys.md 2)
- **Self-installing git pre-commit hook** - format/lint/secret checks run before a commit lands, not after. (keys.md 2)

### 3. Testing strategy
- **Test pyramid + lowest-appropriate-level placement** - most tests at the cheapest level, no duplicate-level testing. (keys.md 3)
- **Tests pass before merge, written alongside/before code** - each test checks one condition. (keys.md 3)
- **Idempotent, repeatable tests** - same result in any environment, any order, no hidden state. (keys.md 3)
- **Coverage is a tool, not a target** - measure it and gate on it, but no no-value tests and 100% is not the goal. (keys.md 3)

### 6. Code-quality standards
- **EditorConfig baseline** - utf-8, lf, final newline, trim trailing, agreed indent. (keys.md 6)
- **Enforce formatting pre-commit + CI** - a chosen formatter blocks non-conforming merges. (keys.md 6)
- **Static analysis / lint suite** - bugs, dead code, complexity flagged automatically, IDE-integrated. (keys.md 6)
- **KISS / avoid over-abstraction** - a little duplication can beat a costly abstraction. (keys.md 6)
- **Choose a quality-gate profile: A (Sonar) or B (no Sonar)** - profile A = SonarQube "Clean as You Code"; profile B = lighter Biome + node:test/c8/vitest bar (measured-coverage floor + lint-clean + optional jscpd, no Sonar ratings). Record the choice in an ADR. Full definition of both under keys.md item 5. (keys.md 6, 5)

### 8. Documentation & spec/ADR discipline
- **Any Decision Record (ADR) for significant/irreversible decisions** - context, options, outcome, rationale, consequences. (keys.md 8)
- **Prefer expressive code over docs** - docs drift; expressive code stays accurate. (keys.md 8)

### 11. Developer workflow
- **Trunk-based, issue-first branch-and-PR** - short-lived branches, review + tests before merge, `Closes #123` auto-link. (keys.md 11)
- **Little and often / small squash merges** - many small changes, clean history. (keys.md 11)
- **Traceable commits (Conventional Commits style)** - commit ties to a requirement and drives versioning. (keys.md 11, 10)
- **Branch protection** - required review + passing checks, no force-push, admins included. (keys.md 11)

### 9. Dependency & supply-chain
- **Pin dependency versions and scan for vulnerabilities** - lockfile + a scanner (Dependabot/Snyk/grype). (keys.md 9)
- **Vulnerability scan with a severity fail-threshold** - build fails on CRITICAL, not just warns. (keys.md 9)
- **Use libraries for non-domain code (never roll your own crypto)** - dependency minimalism: avoid both micro-packages and whole-large-library extremes. (keys.md 9)
- **Licence discipline** - approved-licence list only, never unlicensed deps. (keys.md 9)

### 10. Versioning & release
- **Semantic versioning against a declared public API** - MAJOR/MINOR/PATCH by compatibility, not by effort. (keys.md 10)
- **Write Conventional Commits so the version bump is derivable** - `fix:`->PATCH, `feat:`->MINOR, `BREAKING CHANGE`->MAJOR. (keys.md 10)
- **Keep a human-curated CHANGELOG** - Added/Changed/Deprecated/Removed/Fixed/Security, Unreleased heading. (keys.md 10)
- **Deploy what you tested (immutable tagged artefact)** - one known-good artefact, never rebuilt for release. (keys.md 10, 17)

### 7. Error handling & observability (build-time)
- **Structured, leveled, aggregated logs** - agreed levels (DEBUG/INFO/ERROR), JSON, searchable. (keys.md 7)
- **Fail early and alert when automation assumptions break** - loud failure beats silent wrong behaviour. (keys.md 7)

### 5. CI/CD & quality gates
- **Protected mainline + mandatory gates** - reviews/tests/checks pass before merge, no force-push, admins included. (keys.md 5)
- **Automate quality gates in the pipeline, not by hand** - gates enable safe refactoring. (keys.md 5)
- **Quality-gate profile A (Sonar) OR profile B (no Sonar)** - Sonar "Clean as You Code" (coverage >= 80%, duplication <= 3%, ratings A) where SonarQube is in the stack; otherwise the lighter profile B: measured-coverage floor from node:test/c8/vitest + lint-clean via Biome/ESLint + jscpd duplication if adopted (else ADR-scoped-out), dropping the Sonar-only ratings/duplication-% metrics. A tool picks one and records it. (keys.md 5)
- **Build < 10 minutes** - parallelisation + caching keep the loop fast. (keys.md 5)

---

## OPERATE

### 12. Monitoring, alerting & SLOs
- **Active + passive monitoring with healthchecks** - a `/metrics` or health endpoint plus synthetic/LB checks. (keys.md 12)
- **Every alert is actioned** - high precision + recall; fix the issue or fix the alert. (keys.md 12)
- Fuller SLO/error-budget, golden-signals and DORA keys are situational by service class: see keys.md item 12.

### 13. Incident response
- **Secret-leak remediation runbook** - rotate, raise incident, purge history; history removal alone is not enough. (keys.md 13)
- **Blameless post-incident reviews** - improvements not blame, Five Whys. (keys.md 13)

### 14. Reliability & resilience
- **Design for failure + graceful degradation** - everything fails; degrade (read-only mode, fallback) rather than crash. (keys.md 14)
- **Non-destructive failure with safe defaults** - on error, fall back to a hardcoded safe state; never leave data half-written. (keys.md 14, 17)

### 15. Performance & scalability
- **Set an objective performance target** - an SLA/relative/weighted figure to gate against, even a simple one. (keys.md 15)
- Load/soak/stress modelling, APDEX and autoscale keys are situational by scale: see keys.md item 15.

### 16. Infra-as-code & environment parity
- **Everything as code (infra, config, DB migrations)** - declarative, in source control. (keys.md 16)
- **Promote one artefact through environments** - dev to prod is the same artefact, not a rebuild. (keys.md 16, 17)

### 17. Deployment & rollback
- **Idempotent, repeatable deployments** - re-running a deploy is safe. (keys.md 17)
- **Tested rollback strategy, or flag "High Risk" and justify** - know how to get back. (keys.md 17)
- **Build once, deploy the same artefact to every env.** (keys.md 17)

### 18. Backup & disaster recovery
- Situational: applies to any tool that holds state. If it does, the core two are **define RTO/RPO per workload** and **test restores regularly (a backup is worthless until restored)**. See keys.md item 18 for the full DR set.

---

## GOVERN

### 19. Data management & lifecycle
- **DB migrations with tooling** - versioned, ordered, tool-run migrations (not hand-applied SQL). (keys.md 19)
- **Data classification & minimisation** - classify what you hold, keep the minimum. (keys.md 19)

### 20. Privacy & compliance
- Situational: engages the moment personal data is involved. Core then: **pin a documented lawful basis per purpose** and **data protection by design and default**. Always-on regardless: **keep secrets/PII out of logs and telemetry**. See keys.md item 20.

### 21. Org access control & audit
- **Least-privilege access** - per-stage roles; a dev deploy cannot touch prod. (keys.md 21)
- **Automatic audit trail** - who/what/when across git, CI and infra, captured by the toolchain. (keys.md 21)
- **Minimise production access** - all changes via the pipeline; break-glass is audited and alerted. (keys.md 21)

### 22. Secure SDLC
- **Secret scanning local + server** - GitLeaks pre-commit hook + CI on every PR + full-history scan; treat found secrets as compromised. (keys.md 22)
- **Secure-by-design review (OWASP Top Ten)** - threat-model, least-privilege RBAC, no PII in logs. (keys.md 22)

### 4. Security (build/operate specifics)
- **Validate and encode input (OWASP Top Ten)** - input validation at the boundary; guard XSS/SQLi/CRLF. (keys.md 4)
- **Robust auth + authorization at the boundary** - MFA, `Secure`/`HttpOnly`/`SameSite`, secrets in a vault, no enumeration. (keys.md 4)
- **Encrypt at rest and in transit** - TLS 1.3 (1.2 min). (keys.md 4)
- **Prefer ambient CI/CD credentials over stored secrets; secrets in a vault.** (keys.md 4)

---

## COORDINATE

### 23. API/contract design
- **Components interact only via public APIs** - never a shared DB. (keys.md 23)
- **Design the interface before the implementation** - external + internal contract, coherent vocabulary. (keys.md 23)

### 24. Code ownership & review process
- **CODEOWNERS + branch-protection enforcement** - review is required, not optional. (keys.md 24)
- **Universal review, kept small** - anyone reviews anyone, every change reviewed. (keys.md 24)
- **Structured review checklist** - edge cases, clarity, testability, test placement, NFRs, OWASP. (keys.md 24)

### 25. Onboarding & knowledge transfer
- **CONTRIBUTING.md** - how the team and wider org contribute. (keys.md 25)
- **Record decisions via ADR + self-documenting code** - create/gather/share/record knowledge in that order. (keys.md 25)

---

## CROSS-CUTTING

### 26. Accessibility & i18n
- **Accessibility testing (WCAG) as an automatable check** - a universal gate for any UI. (keys.md 26)
- i18n keys (externalised strings, locale-aware formatting, UTF-8, bidi) are situational: engage them when more than one locale is in scope. See keys.md item 26.

### 27. Product analytics / telemetry
- Situational: engages only when the tool ships telemetry. Core then: **govern a tracking plan before instrumenting** and **keep PII out of event properties**. See keys.md item 27.
