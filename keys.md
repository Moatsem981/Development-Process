# Framework Knowledge: Keys Catalogue

> **This is the FULL reference (all keys).** For the essentials most tools need, read `keys-core.md` first, then come here for the full mechanism and the situational/long-tail keys.

Consolidated, deduped, organised by taxonomy item. Each key: practice (the repeatable how) + mechanism (the concrete file/config/command/tool/threshold) + why + pipeline stage + source file (paths relative to `seqf-repo/`). See `coverage-map.md` for the executive view.

---

## BUILD

### 1. Project structure & architecture
- **Architect for delivery flow** - optimise design choices primarily for rapid, reliable delivery/operations. (plan) `patterns/architect-for-flow.md`
- **Vertical bounded contexts, not horizontal layers** - each component owns its persistence/logic/presentation; no shared-DB integration. (plan) `patterns/architect-for-flow.md`
- **Right-size component count** - monolith for small/simple; avoid over-decomposition (each split adds failure/versioning/network modes). (plan) `patterns/architect-for-flow.md`
- **Strangler-fig for legacy** - apply flow decomposition incrementally to existing systems, no big-bang rewrite. (plan) `patterns/architect-for-flow.md`
- **Evolutionary architecture** - treat initial design as a first draft refined during delivery. (plan) `patterns/little-and-often.md`
- **Build on an established framework** - React/Vue/Express/ASP.NET/Flask/Spark; follow its conventions. (build) `practices/structured-code.md`
- **Separation of concerns (modular + layered)** - insulate business logic from DB and invocation mechanism (Lambda/Flask handler). (build) `practices/structured-code.md`
- **Thin vertical slices / steel thread / walking skeleton** - 2-5 items per increment, track RAID. (plan) `insights/review.md`
- **Containers vs cloud functions by fit** - greenfield/async/plumbing favours functions; framework fit/testability/runtime favours containers. (plan) `patterns/outsource-bottom-up.md`
- **Build components for benefit, not speculative reuse** - clear scope, not "generic". (plan) `patterns/architect-for-flow.md`

### 2. Tooling & environment
- **One consistent CLI command for the whole test suite** (`make test`), identical locally and in CI. (build) `practices/testing.md`
- **Identical environments via Docker/IaC; lock dependency versions** (requirements.txt / package.json). (build) `practices/testing.md`
- **Self-installing git pre-commit hook** - Make `config: githooks` target writes `scripts/markdown-check-format.sh` into `.git/hooks/pre-commit`. (build) `Makefile`
- **Review and automate every manual process** (risk-prioritised; pragmatic). (build) `patterns/automate-everything.md`
- **Redesign the process before automating it** - validate input at entry, expose programmatic APIs. (plan) `patterns/automate-everything.md`

### 3. Testing strategy
- **Test pyramid + lowest-appropriate-level placement**, no duplicate-level testing. (plan) `practices/testing.md`
- **Shift left and right** - pre-commit hooks/lint/static/unit locally; synthetic/health/canary/flags in prod. (build) `practices/testing.md`
- **Idempotent, repeatable tests** - same result in any env, no hidden state, any order. (verify) `practices/testing.md`
- **Test data as first-class** - factories/fixtures/synthetic at production-representative scale. (build) `practices/testing.md`
- **Tests pass before merge** - written alongside/before code (TDD/BDD), each checks one condition. (verify) `practices/testing.md`
- **Coverage is a tool, not a target** - no no-value tests; 100% is not the goal. (build) `practices/testing.md`
- **Consumer-driven contract tests** - Wiremock/Postman/Newman; enable safe tech swaps. (build) `practices/testing.md`
- **Risk-based, context-driven prioritisation** - whole-team risk profile incl. clinical-safety. (plan) `practices/testing.md`
- **Test toggled features in both states** - prefer testing behaviour (Strategy) directly; encode toggle state in test name. (verify) `practices/feature-toggling.md`
- **Test-first development** - minimise waste, increase cohesion. (build) `patterns/everything-as-code.md`

### 6. Code-quality standards
- **SonarQube Quality Profiles** - start from "Sonar Way"; rule types: smell/bug/vulnerability/hotspot; keep few profiles. (build) `tools/sonarqube.md`
- **Choose a quality-gate profile: A (Sonar) or B (no Sonar)** - the enforceable code-quality bar has two forms depending on the toolchain: profile A is the SonarQube "Clean as You Code" gate (coverage/duplication/ratings), profile B is the lighter Biome + node:test/c8/vitest bar (measured-coverage floor + lint-clean + optional jscpd, no Sonar ratings). Both are defined under item 5 (CI/CD & quality gates); a tool records its choice in an ADR. (build/verify) `tools/sonarqube.md`
- **EditorConfig baseline** - utf-8, lf, indent 2 spaces, final newline, trim trailing; tabs for Makefiles. (build) `.editorconfig`
- **Enforce formatting pre-commit + CI** - team-agreed tools (e.g. Black), block non-conforming merges. (build) `patterns/enforce-code-formatting.md`
- **Static analysis suite** - bugs, dead code, complexity, across CSS/HTML/JSON/YAML/SQL; IDE-integrated (SonarLint). (build) `practices/continuous-integration.md`, `tools/sonarqube.md`
- **KISS / avoid over-abstraction** - a little duplication can beat a costly abstraction. (build) `practices/structured-code.md`
- **Treat smells as signals** - investigate structure, do not blindly silence the tool. (build) `tools/sonarqube.md`

### 8. Documentation & spec/ADR discipline
- **Any Decision Record (ADR) template** - status lifecycle, context, options, outcome (reversible/irreversible), rationale (comparison + T-shirt sizing), consequences, compliance fitness-function, actions, tags; tactical decisions spawn a tech-debt record. (plan) `any-decision-record-template.md`
- **Record significant deviations in an ADR** - e.g. opting out of zero-downtime deploys must be ratified. (plan) `patterns/deployment.md`
- **Prefer expressive code over docs** - docs drift; expressive code stays accurate. (build) `patterns/everything-as-code.md`
- **Explicit tech-debt definition + backlog + automated collection** - in/out scope lists; reflected in metrics. (plan) `tech-debt.md`
- **Minimal up-front planning then incremental refinement** - defer anything not altering immediate actions. (plan) `patterns/little-and-often.md`
- **Vet third-party Actions, record decision in ADR** - check native/org-owned/approved first. (plan) `practices/actions-best-practices.md`

### 11. Developer workflow
- **Trunk-based development** - short-lived branches, review + tests before merge, lead time <= ~2 days, WIP limits. (build) `insights/review.md`
- **Little and often** - many small changes; apply rigorously to everything. (build) `patterns/little-and-often.md`
- **Small / squash merges** for clean history. (build) `patterns/everything-as-code.md`
- **Issue-first branch-and-PR** - raise issue, check duplicates, PR to main, `Closes #123` auto-link. (build) `CONTRIBUTING.md`
- **Traceable issue refs in commits** - enforced by commit hooks; ties code to requirement. (build) `patterns/governance-side-effect.md`
- **Commit signing (GPG, single method)** - Ed25519/Curve 25519, global `commit.gpgsign true`; CI bot identity for pipeline commits; retrospective signing via interactive rebase. (build) `practices/guides/commit-signing.md`, `practices/guides/retrospective-commit-signing.md`
- **Branch protection** - require code-owner review, signed commits, dismiss stale approvals, up-to-date status checks; no push to default branch for anyone incl. admins. (verify) `practices/securing-repositories.md`
- **WSJF prioritisation** - `(value + urgency)/effort`; tech-debt value = `criticality x (bugs+delays+uncertainty+unhappiness)`; reserve capacity (e.g. 70/30). (plan) `continuous-improvement.md`
- **Independent, collision-free changes** - any release safe to take at any time. (build) `practices/continuous-integration.md`

### 9. Dependency & supply-chain
- **SBOM per build artifact** - syft, CycloneDX or SPDX, stored with artifact, re-scan continually. (build) `tools/dependency-scan/README.md`
- **Vulnerability scan with severity fail-threshold** - grype `--fail-on CRITICAL`; Makefile/GitHub Action/Jenkins. (verify) `tools/dependency-scan/README.md`
- **Java CVE scan with CVSS threshold + dated suppressions** - OWASP dependency-check-maven, `<cvssBelow>6</cvssBelow>`, `<suppress until="...">` tied to a ticket. (verify) `tools/dependency-check-maven/README.md`
- **Dependabot alerts + SBOM** - respond appropriately; github-actions ecosystem with 7-day cooldown (security updates exempt). (verify/build) `practices/securing-repositories.md`, `practices/actions-best-practices.md`
- **Pin all GitHub Actions to full commit SHA + version comment** - tags/branches can move or be compromised. (build) `practices/actions-best-practices.md`
- **Pin dependency versions; scan for vulnerabilities** - OWASP Dependency Check / Snyk; scan running software (ZAP). (build) `practices/security.md`
- **Use libraries for non-domain code** - never roll your own crypto; avoid micro-package and whole-large-library extremes. (build) `practices/structured-code.md`
- **Licence discipline** - never use unlicensed deps; approved-licence list (MIT/Apache-2.0/BSD/...); copyleft obligations by deployment model; respond to licence changes (comply/stay/replace, never self-fork). (plan/operate) `practices/open-source.md`
- **Keep dependencies/tech current** - patch even inactive services; migrate off deprecated tech as priority. (operate) `practices/cloud-services.md`
- **Justify and test vendor lock-in** - unverified portability cannot be assumed. (plan) `patterns/outsource-bottom-up.md`

### 10. Versioning & release
- **Immutable, signed, tagged artefacts** - one known-good artefact after tests pass on main, stored where all envs can pull. (verify) `patterns/deployment.md`
- **Deploy what you tested** - never rebuild for final release; beware `:latest` / `apt update`. (verify) `practices/continuous-integration.md`
- **Semantic versioning for contracts; detect breaking changes via CDC tests.** (build) `insights/review.md`
- *(Current reference replacing the dead NHS `versioning-reference-template`. Canonical set: SemVer 2.0.0, Conventional Commits 1.0.0, Keep a Changelog 1.1.0, SLSA Provenance v1.0; CalVer where date-based.)*
- **Declare a public API before you version it (the contract premise)** - SemVer only has meaning once you publicly declare what counts as the API; version bumps describe compatibility against that surface, not internal churn. (spec) SemVer 2.0.0 (https://semver.org)
- **MAJOR/MINOR/PATCH by compatibility, not by effort** - PATCH for backward-compatible bug fixes, MINOR for backward-compatible additions, MAJOR for any backward-incompatible change; a one-line breaking fix is still a MAJOR. (plan) SemVer 2.0.0 (https://semver.org)
- **Treat 0.y.z as "no promises" and ship 1.0.0 deliberately** - under major version zero anything MAY change, so consumers can't rely on stability; cutting 1.0.0 is the explicit act of committing to the compatibility contract. (plan) SemVer 2.0.0
- **Encode pre-releases and build metadata correctly** - pre-release ids after a hyphen (`1.2.0-rc.1`, lower precedence than the release), build metadata after `+` (ignored for precedence). (build) SemVer 2.0.0
- **Write commits in Conventional Commits so versioning is derivable** - `<type>[scope]: <description>` with `feat`/`fix` types and `!`/`BREAKING CHANGE:` footers gives tools a deterministic history-to-bump mapping. (build) Conventional Commits 1.0.0 (https://www.conventionalcommits.org/en/v1.0.0/)
- **Map commit types to bumps mechanically** - `fix:`->PATCH, `feat:`->MINOR, any `BREAKING CHANGE`/`!`->MAJOR regardless of type; removes human guesswork, makes the next version a pure function of merged commits. (plan) Conventional Commits 1.0.0
- **Keep a human-curated CHANGELOG, not a git-log dump** - hand-edited because logs are noisy (merges, cryptic titles); changelogs are for humans and must communicate notable user-facing differences. (operate) Keep a Changelog 1.1.0 (https://keepachangelog.com/en/1.1.0/)
- **Use the six standard changelog sections** - Added / Changed / Deprecated / Removed / Fixed / Security so readers scan by impact type. (operate) Keep a Changelog 1.1.0
- **Stage notes under an Unreleased heading** - accumulate pending changes there so users see what's coming and the release step is just promoting that block to a dated, versioned entry. (build) Keep a Changelog 1.1.0
- **Pick CalVer when time, not API contract, drives releases** - date schemes (`YYYY.MM.MICRO`, `YY.MM`) for large evolving systems, time-boxed cadences, or security/regulatory cuts where SemVer compatibility semantics don't fit. (plan) CalVer (https://calver.org)
- **Automate the release from the commit history** - release-please / semantic-release parse Conventional Commits to compute the next version, regenerate the changelog, bump manifests, tag and publish; a standing "Release PR" lets the team choose when to ship while automation owns the mechanics. (build) release-please (https://github.com/googleapis/release-please)
- **Cut a release only on a green pipeline** - gate tag-and-publish behind passing CI so no version is published from an unverified build. (verify) release-please
- **Tag releases with annotated, signed tags** - `git tag -a`/`-s` so each tag carries tagger/date/message + GPG signature (a full Git object, not a bare pointer): an auditable, verifiable, immutable release marker. (build) Git Basics: Tagging (https://git-scm.com/book/en/v2/Git-Basics-Tagging)
- **Build once, then attach verifiable provenance** - generate a SLSA provenance attestation (builder identity, inputs, resolved deps, timestamps) so consumers verify where/when/how the artifact was built and that the promoted artifact is the one tested. (operate) SLSA Provenance v1.0 (https://slsa.dev/spec/v1.0/provenance)
- **Promote through pre-release channels to stable** - publish alpha/beta/rc (lower SemVer precedence) for early validation, then promote the identical artifact to stable rather than rebuilding, keeping "deploy what you tested" intact. (verify) SemVer 2.0.0 pre-release precedence
- **Define a deprecation and backward-compatibility window** - announce deprecations in the changelog `Deprecated` section ahead of removal, keep old behaviour working for a stated window, reserve actual removal for a MAJOR bump. (operate) Keep a Changelog 1.1.0 + SemVer 2.0.0

### 7. Error handling & observability (build-time aspects)
- **Three pillars: metrics, tracing, logs** - metrics/alerts detect, traces/logs diagnose. (operate) `practices/observability.md`
- **Structured, leveled, aggregated logs** - agreed levels (DEBUG/INFO/ERROR), JSON, searchable; X-Ray/OpenTelemetry tracing. (operate) `practices/observability.md`
- **Fail early and alert when automation assumptions break.** (operate) `patterns/automate-everything.md`
- **Clear, concise build-failure reporting** - chat (not email), reduce log noise. (verify) `practices/continuous-integration.md`

### 5. CI/CD & quality gates
- **Protected mainline + mandatory gates** - no force-push; reviews/tests/checks pass before merge; admins included. (verify) `patterns/everything-as-code.md`
- **Automate quality gates in the pipeline, not manually** - enables safe refactoring. (verify) `practices/continuous-integration.md`
- **Build < 10 minutes** - parallelisation + caching. (build) `practices/continuous-integration.md`
- **Short-and-wide pipelines** - shortest responsible path to done; fold in long checks (soak/stress) optionally. (build) `practices/continuous-integration.md`
- **Eliminate flaky/intermittent failures** - they destroy pipeline confidence. (verify) `practices/continuous-integration.md`
- **Run pipelines on a schedule even without changes** - catch drift in shared code/infra/deps. (verify) `practices/continuous-integration.md`
- **SonarQube "Clean as You Code" gates (quality-gate profile A: Sonar)** - new-code gate: coverage >= 80%, duplicated lines <= 3%, ratings A, hotspots reviewed 100%; build fails on breach; legacy gets a lower transitional gate. (verify) `tools/sonarqube.md`
- **Quality-gate profile B (no Sonar) - lighter enforceable tolerance** - for a small tool on a Biome + node:test (or c8 / vitest) toolchain that does NOT run SonarQube and so cannot produce Sonar's duplication/ratings metrics, enforce an equivalent bar with what the runtime already gives: (a) coverage as a measured percentage from the runtime's own coverage reporter (`node --test --experimental-test-coverage`, c8, or `vitest --coverage`) with a project-set floor that fails the build below it; (b) lint/format clean via the chosen linter (Biome or ESLint), any error fails the build; (c) duplication via jscpd against a threshold IF adopted, else explicitly scoped out in an ADR with the reason (small surface / cost not justified) rather than left implicit; (d) DROP the Sonar-specific ratings-A and duplicated-lines-<=3% requirements, since a non-Sonar toolchain cannot compute them. This gives a small tool a real, gated bar that does not assume a toolchain it is not using. Profile A (the Sonar gate above) remains the default wherever SonarQube is in the stack; a tool picks A or B, not both, and records which in its ADR. (verify) `tools/sonarqube.md` (contrast), Biome (https://biomejs.dev), node:test coverage (https://nodejs.org/api/test.html#collecting-code-coverage), c8 (https://github.com/bcoe/c8), jscpd (https://github.com/kucherenko/jscpd)
- **APDEX performance regression gate** - aggregate by scenario, compare to stored baseline (S3/Athena), fail if degraded > 5%. (verify) `practices/performance-testing.md`
- **Governance as a side effect** - automate preventative controls + compliance checks; create change records / architecture associations via API in CI/CD. (verify) `patterns/governance-side-effect.md`
- **Automation = orchestrators + runners, all in code** (Jenkins/Step Functions + bash/Python). (build) `patterns/automate-everything.md`
- **Feed scan reports into the central quality platform** - one dashboard/gate. (verify) `tools/dependency-check-maven/README.md`
- **CI cost-efficiency (Actions minute economics)** - per-job billing rounds UP to a whole minute, so consolidate sub-minute checks (lint/typecheck/licence/size/audit/SBOM) into one job off a single install; add `concurrency: cancel-in-progress` so superseded pushes don't run to completion; gate the slow DB/integration job on a path-filter `changes` job (needs `pull-requests: read`); cache compiler output (`.next/cache`, Storybook), not just the dep store; `paths-ignore` docs; gate dormant optional jobs to ZERO at the job level (`if: vars.FLAG`); tame Dependabot's rebase storm (`rebase-strategy: disabled` + low `open-pull-requests-limit` + weekly `groups`). HARD CAVEAT: `paths-ignore`/job-rename are only safe with NO required status checks (a skipped/renamed REQUIRED check blocks merges forever); otherwise use a reporting path-filter gate job and update the required-checks list in tandem. (plan/verify) `ci-cost-efficiency.md`

---

## OPERATE

### 12. Monitoring, alerting & SLOs
- **Four golden signals** - latency, traffic, errors, saturation; utilisation target essential. (operate) `practices/observability.md`
- **SLO / error-budget alert rules** - Prometheus example tied to "99% of GETs < 100ms". (operate) `practices/observability.md`
- **High precision + high recall alerting; every alert actioned** (fix issue or fix alert). (operate) `practices/observability.md`
- **Resilient, redundant alert channels** - >1 tool, >=1 independent of the service's infra. (operate) `practices/observability.md`
- **Layered dashboards** - <=10 graphs, <=5 metrics each, fixed axes, plot SLA lines, 95th centile; symptom vs cause. (operate) `practices/observability.md`
- **Active + passive monitoring with healthchecks**; clear-box (Prometheus /metrics) + opaque-box (synthetic, LB). (operate) `practices/observability.md`
- **Monitor dependencies + vendor status feeds** (AWS/Azure RSS). (operate) `practices/observability.md`
- **Certificate-expiry monitoring with tiered alerts** - ACM monitor Lambda, warn 45d / critical 15d, Slack webhook in Secrets Manager. (operate) `tools/acm-cert-monitor/README.md`
- **DORA-style monthly metrics** - deployment frequency, lead time, change-failure rate, incident rate, MTTR; on a dashboard, alongside maturity review + user satisfaction. (operate) `insights/metrics.md`
- **Define SLIs/SLOs from service-level class** (bronze/silver/gold/platinum); feed autoscaling. (spec) `practices/service-reliability.md`

### 13. Incident response
- **Blameless post-incident reviews** - identify improvements, not blame; Five Whys. (operate) `practices/service-reliability.md`
- **Game Days** - rehearse incident classification/resolution; cover release/deploy. (operate) `patterns/deployment.md`
- **Secret-leak remediation runbook** - rotate, raise incident, purge history, request cache purge; history removal alone insufficient. (operate) `practices/guides/commit-purge.md`
- **Near-miss reporting** for leaked secrets. (operate) `practices/guides/commit-purge.md`

### 14. Reliability & resilience
- **Design for failure** - "everything fails"; loose coupling, resilient infra. (plan) `practices/service-reliability.md`
- **Meaningful availability + graceful degradation** - read-only mode, load shedding, partial demand; don't over-engineer. (plan) `practices/service-reliability.md`
- **Load shedding + rate limiting** - protect your own service; don't assume callers throttle. (build) `patterns/outsource-bottom-up.md`
- **Self-healing infra** - prefer global/region-scoped services; redundancy for AZ-scoped; know failover/replacement times. (plan) `practices/cloud-services.md`
- **Chaos / fault-injection** - AWS FIS from Jenkins, JMeter load. (verify) `tools/aws-fis/README.md`
- **Safe toggle defaults** - hardcoded safe default, timeouts/fallback, never block startup. (build) `practices/feature-toggling.md`
- **Well-Architected reviews** (AWS/Azure). (plan) `practices/service-reliability.md`

### 15. Performance & scalability
- **Model realistic load** - user journeys, concurrency, journey share; JMeter thread groups. (plan) `practices/performance-testing.md`
- **Objective performance targets** - SLA-based / relative / weighted. (spec) `practices/performance-testing.md`
- **APDEX as objective figure** (0-1.0) against realistic target response time. (verify) `practices/performance-testing.md`
- **Load / soak / stress / volume test types.** (verify) `practices/performance-testing.md`
- **Autoscale on user-facing metrics + leading indicators; ~80% utilisation for inelastic infra; pre-warm.** (operate) `practices/cloud-services.md`
- **APDEX caveats** - relative/aggregated gates hide slow drift; add an absolute target. (verify) `practices/performance-testing.md`

### 16. Infra-as-code & environment parity
- **Everything as code (incl. infra, config, DB migrations)** - declarative YAML/HCL in source control. (build) `patterns/everything-as-code.md`, `practices/cloud-services.md`
- **Pipelines as code** - unit-test the deployment code; infra deployed through a pipeline. (build) `practices/continuous-integration.md`
- **Ephemeral + immutable infra** - replace, never patch; auto-scale up/down. (operate) `practices/service-reliability.md`
- **Promote one artefact through environments** (dev/integration/UAT/pre-prod live-like/prod); test deploys in live-like pre-prod. (operate) `patterns/deployment.md`
- **Account/subscription segregation + tagging** - prod vs non-prod, per-product; CostCenter/Owner tags; CloudTrail. (plan) `practices/cloud-services.md`
- **Prefer managed services (SaaS > PaaS > IaaS > VM)**; outsource cert management/alerting. (plan/operate) `patterns/outsource-bottom-up.md`
- **Control env cost** - shutdown controls, ephemeral env duration. (operate) `patterns/deployment.md`
- **Long-lived shared DB servers; split account vs application IaC** - DB servers slow to instantiate. (build) `practices/cloud-databases.md`

### 17. Deployment & rollback
- **Idempotent, repeatable deployments.** (operate) `patterns/deployment.md`
- **Blue-green zero-downtime** - deploy idle leg, smoke test, switch, soak, keep old as fallback. (operate) `patterns/deployment.md`
- **Monitored smoke + soak gates with automatic rollback.** (verify) `patterns/deployment.md`
- **Tested rollback strategy, or flag "High Risk" + justify.** (operate) `patterns/deployment.md`
- **Fix-forward preference over rollback scripts; phased blue-green/canary.** (operate) `practices/continuous-integration.md`
- **Feature toggles separate deploy from release** - static (env/config) or dynamic (flag service); match to scale; govern like code; short lifecycle with removal PR. (build/operate) `practices/feature-toggling.md`
- **Continuous delivery with approval gateways when full CD is blocked** - shrink batch size as confidence grows. (verify) `patterns/deployment.md`
- **Build once, deploy same artefact to every env.** (operate) `insights/review.md`

### 18. Backup & disaster recovery
- **Service-level recoverability classes** (bronze/silver/gold/platinum) imply availability + recoverability requirements. (spec) `practices/service-reliability.md`
- **Define RTO and RPO per workload before designing recovery** - RTO = max acceptable delay between interruption and restoration; RPO = max acceptable time since the last recovery point (so RPO sets tolerable data loss). Assign every workload a number, never "zero" by default. (spec) AWS Reliability Pillar REL13-BP01 (https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/rel_planning_for_recovery_objective_defined_recovery.html)
- **Derive recovery objectives from business-impact tiers, not gut feel** - matrix of criticality tiers (mission/business-critical/operational), each tier given an RTO/RPO from financial/reputational/operational/regulatory impact, then map workloads to tiers; too strict inflates cost, too lenient misses obligations. (spec) AWS REL13-BP01; Azure WAF RE:09 (https://learn.microsoft.com/en-us/azure/well-architected/reliability/disaster-recovery)
- **Reconcile objectives with up/downstream dependencies** - achievable RTO/RPO is no better than the services you depend on, and upstream consumers may force stricter targets; validate the chain so you don't promise an RPO a dependency can't honour. (spec) AWS REL13-BP01
- **Choose a DR strategy along the cost/RPO/RTO spectrum** - Backup & Restore (cheapest, hours), Pilot Light (data replicated + core infra off; RPO mins, RTO tens of mins), Warm Standby (scaled-down always-running; RPO secs, RTO mins), Multi-site Active/Active (costliest; RPO/RTO near zero). Pick the cheapest tier that meets the targets. (plan) AWS DR whitepaper (https://docs.aws.amazon.com/whitepapers/latest/disaster-recovery-workloads-on-aws/disaster-recovery-options-in-the-cloud.html)
- **Apply the 3-2-1 backup rule** - >=3 copies, on 2 different media, with 1 offsite, so no single localized incident destroys every copy. (build) NCSC offline-backups (https://www.ncsc.gov.uk/blog-post/offline-backups-in-an-online-world)
- **Set backup frequency from the RPO** - backup cadence is the floor on achievable recovery point; schedule automated backups at least as often as the RPO demands (continuous/point-in-time recovery for the smallest RPO). (build) AWS DR whitepaper; Azure Backup guidance (https://learn.microsoft.com/en-us/azure/backup/guidance-best-practices)
- **Keep one immutable or air-gapped copy (3-2-1-1-0)** - WORM/object-lock/retention-lock so backups can't be altered/deleted before expiry, plus a cold copy disconnected when idle and holding no live credentials, so ransomware on a live host can't reach it. (build) NCSC offline-backups; Azure immutable vaults (https://learn.microsoft.com/en-us/azure/reliability/reliability-backup)
- **Encrypt backups in transit and at rest** - so an offsite/cross-region copy doesn't become an exfiltration path. (build) Azure Backup guidance
- **Tiered retention and lifecycle** - fast local snapshots (hours apart, days retained) for quick restores against app bugs, plus cheaper full/incremental copies in nearline/offline storage retained longer; Google draws the line at 30-90 days by data-loss tolerance and corruption-detection speed. (build) Google SRE Data Integrity (https://sre.google/sre-book/data-integrity/)
- **Defend data in depth: soft delete + backups + early detection** - layer (1) soft deletion (recoverable window, Google 15-60d), (2) backup/restore, (3) out-of-band validators continuously scanning production for corruption, to catch slow data-mutation bugs backups would silently overwrite. (build) Google SRE Data Integrity
- **Back up the system, not just the data; order restores by dependency** - also back up IaC, config, code and images so the whole environment rebuilds, and define restore sequence (databases before the apps that depend on them). (build) AWS DR whitepaper; Azure WAF DR
- **Replicate cross-region and cross-account for blast-radius isolation** - separate region survives a regional disaster, separate account survives credential compromise/insider threat; replicate without propagating delete markers so a malicious delete doesn't erase the DR copy. (build) AWS DR whitepaper
- **Treat recovery, not backup, as the goal and test restores regularly** - "a backup is worthless until restored": periodically restore to a fresh location, validate (checksum/size/most-recent-record), confirm within RPO; verify integrity at least monthly. (verify) Google SRE Data Integrity; AWS REL09-BP04 (https://docs.aws.amazon.com/wellarchitected/latest/reliability-pillar/rel_backing_up_data_periodic_recovery_testing_data.html)
- **Measure actual RTO against target and run DR game days** - time the real restore and compare to RTO; run scheduled drills plus surprise game days (Google DiRT), non-prod first, since a production drill is the only proof RTO/RPO are met. (verify) AWS REL09-BP04; Azure WAF DR; Google SRE
- **Monitor backups and alert on failure - a silent backup failure is the classic trap** - automate restore-validation (scheduled trigger + function/state-machine) and alert whenever a backup/validation fails or restore exceeds RTO; never assume a backup succeeded. (operate) AWS REL09-BP04
- **Maintain runbooks for orchestrated failover plus a separate failback plan** - script one-button failover via resilient data-plane operations; keep DR docs/credentials/scripts/pipelines replicated and reachable during a regional outage; treat failback as its own documented process. (operate) AWS DR whitepaper; Azure WAF DR

---

## GOVERN

### 19. Data management & lifecycle
- **DB migrations with tooling** - Django/Rails built-in, alembic for concurrent schema work, sequential SQL for simple, serverless function called by Terraform. (build) `practices/cloud-databases.md`
- **Zero-downtime schema refactor** - several coupled migrations + code changes. (build) `practices/cloud-databases.md`
- **Data classification & minimisation** - classify (e.g. PCD), reduce to minimum, prefer managed services. (spec) `practices/security.md`
- **Pick data store by workload + payment model** - never NoSQL for a relational job. (plan) `patterns/outsource-bottom-up.md`
- **Test-data management** - factories/fixtures, production-representative, PII-free. (build) `practices/testing.md`

### 20. Privacy & compliance
- **Data sovereignty + IG lead** - aware of non-UK hosting incl. SaaS tools. (plan) `practices/cloud-services.md`
- **Keep secrets/PII out of observability** - same governance as source system. (operate) `practices/observability.md`
- **Code in the open by default** - MIT first choice; deviations via Technical Authority. (spec) `practices/open-source.md`
- **Compliance-as-code guardrails** - AWS Config/Control Tower: tags, WAF, CloudTrail, region/resource restrictions, MFA. (operate) `patterns/governance-side-effect.md`
- **Maintain a Record of Processing Activities (RoPA)** - Article 30 register: purposes, categories of individuals/data, recipients, retention periods, transfers, security measures (processors add controllers acted-for + processing categories). Required at 250+ staff; under 250 still required for non-occasional/risky/special-category processing (i.e. most production systems). It's the foundation every other obligation maps onto. (plan) ICO Documentation/Art.30 (https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/accountability-and-governance/documentation/what-do-we-need-to-document-under-article-30-of-the-gdpr/)
- **Run a DPIA screening before any new high-risk processing** - Article 35 gate at design time: mandatory for systematic extensive profiling with significant effects, large-scale special-category/criminal data, or large-scale systematic public monitoring, plus the ICO list; two-or-more red-flag criteria is a clear trigger. Surfaces and documents risk before you build. (spec) ICO When do we need a DPIA (https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/accountability-and-governance/data-protection-impact-assessments-dpias/when-do-we-need-to-do-a-dpia/)
- **Complete and act on the DPIA; consult the ICO if residual risk stays high** - describe processing + necessity, assess risks to rights/freedoms, record mitigations; if high risk remains you cannot reduce, you must consult the ICO and cannot start until you do (~8wk response). Turns risk assessment into a documented go/no-go. (plan) ICO How do we do a DPIA (https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/accountability-and-governance/data-protection-impact-assessments-dpias/how-do-we-do-a-dpia/)
- **Pin a documented lawful basis to every processing purpose** - choose one of the six Article 6 bases (consent, contract, legal obligation, vital interests, public task, legitimate interests) per purpose and record it; the basis is hard to change later, so decide before processing. No valid basis = unlawful. (spec) ICO Guide to lawful basis (https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/lawful-basis/a-guide-to-lawful-basis/)
- **Add an Article 9 condition for special-category data** - health/race/ethnicity/politics/religion/union/sex-life/genetics/biometrics needs both an Art.6 basis and one of ten Art.9 conditions (often + a DPA 2018 Schedule 1 condition and appropriate-policy document). Gates the most sensitive fields in the schema. (spec) ICO Special category data (https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/lawful-basis/a-guide-to-lawful-basis/special-category-data/)
- **Meet the consent standard and make withdrawal as easy as giving** - freely-given, specific, informed, unambiguous opt-in via clear affirmative action (no pre-ticked boxes), audit record of who/what/when, withdrawal at least as easy as opt-in. Engineered properly it's a per-purpose toggle, not a global flag. (build) ICO What is valid consent (https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/lawful-basis/consent/what-is-valid-consent/)
- **Build data protection by design and by default into the architecture** - Article 25: technical/organisational measures (pseudonymisation, minimisation, access controls) baked in from the start, default settings process only the data necessary per purpose. Shifts privacy from bolt-on to build-time default. (build) ICO Data protection by design and default (https://ico.org.uk/for-organisations/guide-to-data-protection/guide-to-the-general-data-protection-regulation-gdpr/accountability-and-governance/data-protection-by-design-and-default/)
- **Codify retention schedules and automate deletion (storage limitation)** - storage-limitation principle bars keeping identifiable data longer than necessary; map each data category to a justified period + trigger, then enforce with automated deletion/anonymisation jobs. The cleanup half of data minimisation. (operate) ICO Principle (e): Storage limitation (https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/data-protection-principles/a-guide-to-the-data-protection-principles/storage-limitation/)
- **Treat data-subject rights as engineering features with a one-month clock** - access (DSAR), erasure, rectification, restriction, portability answerable within one calendar month (extendable +2 months for complex/multiple, told why within month one). Design retrieval, export (structured, machine-readable) and cascading-delete paths so responses aren't manual archaeology. (build) ICO Time limits for rights requests (https://ico.org.uk/for-the-public/time-limits-for-responding-to-data-protection-rights-requests/)
- **Have a breach response runbook hitting the 72-hour ICO clock** - report a notifiable breach without undue delay and within 72h of becoming aware (clock starts at discovery; phased reporting allowed under Art.33(4)); notify only if likely to risk rights/freedoms. Detection-to-report speed is the binding constraint, so instrument and rehearse it. (operate) ICO Personal data breaches: a guide (https://ico.org.uk/for-organisations/report-a-breach/personal-data-breach/personal-data-breaches-a-guide/)
- **Notify affected individuals on high-risk breaches without undue delay** - duty excused if data was rendered unintelligible (strong encryption) or follow-up measures mean high risk is no longer likely. Encryption-at-rest is both a control and a notification off-ramp. (operate) ICO Personal data breaches: a guide
- **Put an Article 28 contract behind every processor (and sub-processor)** - cloud/SaaS/analytics processing on your behalf needs a written contract: process only on documented instructions, confidentiality, Art.32 security, sub-processor authorisation with flow-down, assistance with rights/breach/DPIA, delete-or-return at end, audit rights. The legal control over your supply chain's data access. (plan) ICO What needs to be in the contract (https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/accountability-and-governance/contracts-and-liabilities-between-controllers-and-processors-multi/what-needs-to-be-included-in-the-contract/)
- **Gate international (restricted) transfers behind adequacy or an Art.46 safeguard plus a TRA** - rely on adequacy regulations, or an Art.46 safeguard (UK IDTA, or EU SCCs + UK Addendum), and (post-Schrems II) a transfer risk assessment per transfer/group, reassessed periodically, covering onward transfers. Data-residency and vendor-region choices flow from this. (plan) ICO Guide to international transfers (https://ico.org.uk/for-organisations/uk-gdpr-guidance-and-resources/international-transfers/international-transfers-a-guide/)

### 21. Org access control & audit
- **Automatic audit trail across toolchain** - git review approvals, CI build/test/deploy records (who/what/when), CloudTrail. (operate) `patterns/governance-side-effect.md`
- **Least-privilege per-stage IAM roles** - a dev-targeted deploy cannot hit prod. (operate) `practices/security.md`
- **Minimise production access** - all changes via pipeline; break-glass with audit + alert; short-lived isolated prod-DB clones for data checks. (operate) `practices/security.md`
- **Secure route to infra** - hardened bastion via VPN + MFA, audited; IAM requires `aws:MultiFactorAuthPresent`. (operate) `practices/security.md`
- **Pull model; never push artefacts upward** from lower to higher env. (operate) `patterns/deployment.md`
- **Least-privilege monitored deployment/management accounts.** (operate) `patterns/deployment.md`
- **Repo access hardening** - MFA for all, baseline No Permission, private->public flip admins-only, disable forking on private, review outside collaborators. (operate) `practices/securing-repositories.md`, `practices/baseline-visibility.md`
- **GitHub Teams structure** - parent product team + child admin/code-owner teams, graduated permissions. (operate) `practices/securing-repositories.md`
- **Joiners/leavers process; password managers + MFA.** (operate) `practices/security.md`

### 22. Secure SDLC
- **NCSC 8 secure development & deployment principles** - secure the pipeline, continually test, plan for flaws. (plan) `practices/security.md`
- **Governance as a side effect** - permissions/workflows enforce the quality process consistently. (verify) `patterns/governance-side-effect.md`
- **Secret scanning local + server** - GitLeaks pre-commit hook + CI on every PR/default branch + full-history scan; same config both places; narrow reviewed allowlists; treat found secrets as compromised. (build) `tools/gitleaks.md`, `practices/guides/commit-purge.md`
- **Secure-by-design review area** - threat-model, OWASP Top Ten, encrypt in transit/at rest, no PII in logs, least-privilege RBAC, OIDC+MFA, break-glass. (build) `insights/review.md`
- **Automate security testing every build with PII-free test data.** (verify) `practices/security.md`

### 4. Security (build/operate specifics)
- **OWASP Top Ten + static analysis (defence in depth)** - encode/validate input; XSS/SQL/XML/CRLF; don't over-rely on tools. (build) `practices/security.md`
- **Robust auth + session security** - MFA, `Secure`/`HttpOnly`/`SameSite`, refresh on privilege escalation, secrets in a vault, 404/blanket-403 to avoid enumeration, WAF for timing. (build) `practices/security.md`
- **Avoid info leakage / clickjacking** - `X-Frame-Options`, no stack traces/headers, isolate non-prod domain. (build) `practices/security.md`
- **Encrypt at rest + in transit** - TLS 1.3 (1.2 min), PFS (ECDHE). (operate) `practices/security.md`
- **Network lockdown** - firewall rules, WAF, restrict egress. (operate) `practices/security.md`
- **Scan systems / container base images** - Prisma/Clair/ECR/Inspector; before deploy + periodically in live. (operate) `practices/security.md`
- **Enforce + validate infra security policy as code** - Azure Policy/AWS Config deny rules; ScoutSuite; separate accounts. (operate) `practices/security.md`
- **GitHub Actions security** - GitHub Secrets (unstructured, rotated), least-privilege `permissions:` block, OIDC over long-lived creds, secret scanner + push protection, secure/ephemeral runners (self-hosted private-only), safe fork-PR handling, CODEOWNERS on workflow files + audit logs. (build/verify) `practices/actions-best-practices.md`
- **Prefer ambient CI/CD credentials over stored secrets.** (operate) `practices/security.md`
- **Coordinated private vulnerability disclosure** - SECURITY.md, GitHub private reporting + advisories. (operate) `SECURITY.md`, `practices/securing-repositories.md`
- **Purge leaked secrets, treat as compromised; RBAC not permission-toggles for permanent access.** (operate/build) `practices/securing-repositories.md`, `practices/feature-toggling.md`

---

## COORDINATE

### 23. API/contract design
- **Components interact only via public APIs** (never shared DB). (plan) `patterns/architect-for-flow.md`
- **Design the interface before the implementation** - external (REST) + internal (class/method) + coherent vocabulary. (plan) `patterns/everything-as-code.md`
- **Consumer-driven contract tests + semantic versioning** - detect breaking changes. (build) `practices/testing.md`, `insights/review.md`
- **Adopt published API policies / best practice.** (spec) `practices/api-policies.md`
- **OpenAPI-driven web interface for exploratory testing + docs.** (verify) `practices/testing.md`

### 24. Code ownership & review process
- **CODEOWNERS + branch-protection enforcement** - default owner wildcard; no secret teams (must be identifiable). (build/verify) `.github/CODEOWNERS`, `practices/baseline-visibility.md`
- **Egalitarian, universal review** - anyone reviews anyone; everyone's code reviewed; pairing counts. (verify) `patterns/everything-as-code.md`
- **Keep reviews (and stories) small.** (verify) `patterns/everything-as-code.md`
- **Structured review checklist** - edge cases, clarity/simplicity, testability, test-pyramid placement, NFRs, OWASP Top Ten. (verify) `patterns/everything-as-code.md`
- **Tests as a first-class review concern** - present tests, missing tests, placement, CI triggering. (verify) `practices/testing.md`

### 25. Onboarding & knowledge transfer
- **CONTRIBUTING.md** - how team + wider org contribute. (spec) `practices/baseline-visibility.md`, `CONTRIBUTING.md`
- **Engineering maturity self-assessment** - 13 areas, 1-5 blind voting, 6-8 people, outside facilitator, top-3 actions; scores not cross-team comparable; open-source/PR-able. (plan) `insights/review.md`
- **Continuous improvement: Improvement Kata + PDCA** - hypothesis-framed, safely-scoped experiments re-evaluated at retro. (plan) `continuous-improvement.md`
- **Create / gather / share / record knowledge** (in that order: tests, self-documenting code, OpenAPI, docs); record decisions via ADR. (plan) `principles.md`
- **Quality is the whole team's responsibility** - pairing dev+tester, no-blame edge-case sessions. (plan) `practices/testing.md`
- **Continuous improvement of team process** - start simple, evolve ways-of-working / definition-of-done. (plan) `patterns/little-and-often.md`

---

## CROSS-CUTTING

### 26. Accessibility & i18n
- **Accessibility testing** (WCAG) as a universal automatable check; browser-compat + HTML-compliance checks; test only supported browsers. (verify) `quality-checks.md`, `practices/testing.md`, `practices/continuous-integration.md`
- **Design i18n in at the start, not as a retrofit** - choose Unicode, externalised strings, locale-as-data and direction-agnostic layout during spec/architecture, because retrofitting into an English-only code base is far more expensive. (spec) W3C i18n (https://www.w3.org/International/articles/language-tags/)
- **Externalise user-facing strings into resource catalogues** - no hardcoded UI text; mark strings (e.g. gettext `_("text")`) so a tool extracts them into catalogues (`.po`/`.pot`, ICU, `.resx`, JSON) translators edit independently of source. (build) GNU gettext (https://www.gnu.org/software/gettext/manual/gettext.html)
- **Translate whole sentences, never concatenate fragments** - assemble variable messages with ICU MessageFormat patterns, not string concatenation, because fragments can't be reordered for different word order and break grammatical agreement. (build) ICU User Guide (https://unicode-org.github.io/icu/userguide/format_parse/messages/)
- **Handle plurals with locale plural rules, not `if (n==1)`** - ICU MessageFormat `plural`/`select` (or `Intl.PluralRules`) keyed on CLDR categories (zero/one/two/few/many/other); plural forms differ per language so English-style branching is wrong elsewhere. (build) Unicode CLDR (https://cldr.unicode.org/index)
- **Use UTF-8 as the universal encoding default** - declare and store all content as UTF-8 so one encoding covers any language mix and stays ASCII-compatible; avoid legacy encodings that force per-language logic. (build) W3C i18n (https://www.w3.org/International/questions/qa-choosing-encodings)
- **Treat text as characters, not bytes** - one character may span multiple bytes, so length/truncation/indexing must operate on characters/code points, not byte counts. (build) W3C i18n (https://www.w3.org/International/questions/qa-choosing-encodings)
- **Normalise Unicode to NFC for storage and comparison** - identical-looking text can be precomposed or decomposed and won't compare equal; normalise to NFC consistently so identifiers/selectors/equality behave. (build) W3C i18n (https://www.w3.org/International/questions/qa-html-css-normalization)
- **Identify locale with BCP 47 tags as structured data** - `language-Script-Region` subtags (e.g. `zh-Hans`, `fr-CA`), kept as short as meaningful, matched hierarchically (`en` matches `en-GB`, not the reverse) to drive a fallback chain. (spec) W3C i18n (https://www.w3.org/International/articles/language-tags/)
- **Source all locale formatting data from CLDR/ICU, never hardcode** - pull date/time/number/currency/unit/collation conventions from CLDR via ICU/`Intl` rather than baking English formats (`26,254.39` vs `26.254,39`, date order vary by locale). (build) Unicode CLDR (https://cldr.unicode.org/index)
- **Format dates, numbers and currencies with a locale-aware API** - `Intl.NumberFormat`/`Intl.DateTimeFormat` (or ICU bindings) passing the negotiated locale, so output adapts automatically instead of via manual templates. (build) MDN Intl (https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Intl)
- **Sort and search with locale-aware collation** - compare via `Intl.Collator`/ICU collation (e.g. German phonebook ä->ae) because byte/code-point ordering is not alphabetical order in any language and is itself locale-dependent. (build) MDN Intl
- **Support bidirectional text via base direction, not manual reordering** - rely on the Unicode Bidi Algorithm and set base direction with the `dir` attribute (logical order in memory differs from visual order), with isolation for embedded opposite-direction runs. (build) W3C i18n (https://www.w3.org/International/articles/inline-bidi-markup/uba-basics)
- **Lay out with CSS logical properties instead of physical sides** - `margin-inline-start`, `inset-inline` etc. so layouts flip correctly for RTL (Arabic/Hebrew) and vertical writing modes without forking CSS per direction. (build) MDN CSS Logical Properties (https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_logical_properties_and_values)
- **Design flexible layouts for text expansion** - never bake widths to English; allow reflow since short English strings can expand 200-300% (German/Italian) and longer text ~30%. (plan) W3C i18n (https://www.w3.org/International/articles/article-text-size)
- **Pseudo-localise to test localisability before real translation** - a pseudo-locale that expands strings (~+40%) and substitutes accented/other-script characters with delimiters exposes truncation/concatenation/font/hardcoded-string bugs without a translator. (verify) Microsoft Globalization (https://learn.microsoft.com/en-us/globalization/methodology/pseudolocalization)
- **Store timestamps in UTC and render in local time** - time zone is distinct from locale: persist/exchange instants in UTC, keep IANA zone IDs (e.g. `America/Los_Angeles`) for future events, convert to local wall time only at display. (operate) W3C TR (https://www.w3.org/TR/timezone/)
- **Give translators context and a managed workflow** - supply `msgctxt`/extracted comments and screenshots to disambiguate strings, and coordinate hand-off through a TMS with a string freeze so source text is stable before translation. (operate) GNU gettext

### 27. Product analytics / telemetry
- **Continuously validate user needs** - explicit research + A/B testing + analytics. (spec) `patterns/fast-feedback.md`
- **Observability-driven testing** - use production telemetry to shape tests, catch regressions, reduce MTTD/MTTR. (operate) `practices/testing.md`
- **Fast feedback loops invested early** - requirements, quality, delivery progress, reliability. (verify) `patterns/fast-feedback.md`
- **Tracking plan as single source of truth (govern the schema before instrumenting)** - one documented, agreed spec of every event and its properties the whole team consults before adding instrumentation; ungoverned tracking produces inconsistent undefined events, breaking reports and definitions and making data unusable. (spec) Segment Protocols + Amplitude event taxonomy (https://www.twilio.com/docs/segment/protocols/tracking-plan/best-practices, https://amplitude.com/explore/data/event-taxonomy)
- **Object-Action event naming (Noun + past-tense Verb)** - name events `Object Action` (e.g. `Order Completed`) from a controlled vocabulary of objects and verbs; a fixed structure makes the same query return the same result everywhere and keeps events discoverable. (spec) Segment full-install + Avo naming (https://www.twilio.com/docs/segment/getting-started/04-full-install, https://www.avo.app/docs/data-design/best-practices/naming-conventions)
- **One casing convention, enforced for events and properties** - pick one casing and never mix it (event names are case-sensitive downstream: `sign_up_completed` != `Sign_Up_Completed` are two events); consistency across the whole plan is the dominant rule. (spec) Segment full-install + Mixpanel events (https://docs.mixpanel.com/docs/data-structure/events-and-properties)
- **Don't encode data in event names; use properties** - never bake dynamic values into the name (`User Signed Up (11-01-2019)`, one event per plan tier); add context as properties so events stay countable/comparable and the namespace doesn't explode. (spec) Segment tracking plan best practices (https://www.twilio.com/docs/segment/protocols/tracking-plan/best-practices)
- **Three standard call types: identify, track, page/screen** - separate `identify` (who + traits), `track` (a discrete action + properties), `page`/`screen` (a view with auto `url`/`path`/`referrer`); this fixed API shape is what every destination expects. (build) Segment Spec: Track/Page (https://segment.com/docs/spec/track)
- **Stable identity model: anonymousId then a durable userId** - SDK assigns a UUID `anonymousId` on first visit; on signup `identify` with a permanent non-PII `userId` (DB id/UUID, never email) alongside the `anonymousId` so pre-signup activity stitches; use `alias` only for destinations that require identity merging. (build) Segment identify best-practices (https://www.twilio.com/docs/segment/connections/spec/best-practices-identify)
- **Instrument backwards from the metric (north-star + a few input KPIs)** - define the north-star metric, decompose into a few input metrics (activation/retention/conversion), instrument exactly the events those need rather than tracking everything; guarantees the data answers the business questions. (spec) Mixpanel north-star/guardrails (https://mixpanel.com/blog/guardrail-metrics/)
- **Design events to feed funnel, retention and cohort analysis** - ensure events/properties support an ordered funnel, retention curves (events linked by a stable id) and cohorts (segmented by shared properties) up front; if the metric needs a property, the property must be on the event. (spec) Amplitude event taxonomy (https://amplitude.com/explore/data/event-taxonomy)
- **Single SDK / CDP abstraction (instrument once, fan out)** - send events through one collection SDK/API (a CDP such as Segment) that routes to all destinations, instead of per-vendor snippets sprinkled in code; add/remove tools without touching instrumentation. (build) Segment CDP overview (https://segment.com/resources/cdp/)
- **Keep PII out of event properties; pseudonymise identifiers** - never send names/emails/phones/precise location; use a pseudonymous app id, and remember GDPR treats IPs and cookie ids as personal data even when a vendor's narrower "PII" definition doesn't (ties to [[20]]). (build) Google Analytics avoid-PII (https://support.google.com/analytics/answer/6366371)
- **Honour consent and Do-Not-Track before collecting** - gate analytics loading/sending on consent state (and respect DNT) to satisfy GDPR/CCPA; tie the collection SDK to the consent manager so events are suppressed for non-consenting users. (build) Google Analytics GDPR guidance (https://support.google.com/analytics/answer/6366371)
- **Validate events against the plan at the boundary (typed/schema-enforced events)** - enforce the tracking plan programmatically (Segment Protocols validates payloads at ingestion; codegen like Avo generates type-safe tracking) so missing/wrong/unplanned events are flagged or quarantined before polluting destinations. (verify) Segment Protocols schema controls (https://segment.com/docs/protocols/enforce/schema-configuration/)
- **Version the tracking plan and deprecate events deliberately** - version per event/app, prefer adding new events over mutating existing ones, keep deprecated events for >=1 release cycle and stop populating removed fields rather than deleting, so historical analyses and in-flight clients don't break. (operate) Avo implementation status (https://www.avo.app/docs/data-design/avo-tracking-plan/implementation-status)
- **Deduplicate via a stable messageId / event id** - give every event a unique id and dedupe on that id, not payload contents, so retries and dual client+server sends count once (share one id across browser and server for the same logical event). (build) Segment common fields + duplicate data (https://segment.com/docs/connections/spec/common/)
- **Choose client- vs server-side tracking for reliability** - prefer server-side for revenue/conversion-critical events because ad-blockers/browser restrictions drop 20-40% of client-side events; run both with a shared event id for near-complete coverage while deduplicating. (build) Server-side tracking guidance (https://stape.io/helpdesk/knowledgebase/why-use-both-client-side-and-server-side-tracking)
- **Instrument experiments with exposure events and guardrail metrics** - for every A/B test or flag rollout emit a variant-exposure event and track the primary metric plus guardrail/counter-metrics (churn, support tickets, latency, NPS) so a win can't silently regress the wider product. (verify) Mixpanel guardrails + PostHog (https://posthog.com/product-engineers/guardrail-metrics)

---

## Completeness sweep additions (files missed in the first pass, read 2026-06-03)

### New keys
- **The 7 Lean principles (the why-layer)** - 1 Eliminate waste, 2 Build quality in, 3 Create knowledge, 4 Defer commitment (small/reversible decisions, decide at last responsible moment), 5 Deliver fast, 6 Respect for people (blameless, no-blame postmortems), 7 Optimise the whole. These underpin every pattern/practice. (all stages) `principles.md`
- **Inclusive naming** (item 6/docs) - avoid master/slave/whitelist/blacklist; use primary/replica, main, allowlist/denylist; documented master->main rename procedure. (build) `inclusive-language.md`
- **Recommend IDE extensions in-repo** (item 2) - `.vscode/extensions.json` lists markdownlint, editorconfig, spell-checker so every contributor's editor is set up consistently. (build) `.vscode/extensions.json`
- **Framework adoption cadence** (item 25) - update the metrics dashboard monthly, run the quality review quarterly ("technical retro"), browse `tools/` for cloneable scripts, embed principles+patterns team-wide. (plan) `quickstart.md`

### Reusable template exemplars (reinforce existing keys; copy-ready)
- **Markdown lint in CI, changed-files-only, Docker image SHA-pinned** - `scripts/markdown-check-format.sh` (markdownlint-cli pinned by `@sha256:...`, diff-only, `--disable MD013 MD033`) wired by `.github/workflows/markdown-check-format.yml`. Concrete instance of enforce-formatting (item 6). 
- **SBOM + vulnerability scan workflows** - `tools/dependency-scan/github-workflow-action-generate-sbom.yml` (anchore/sbom-action, cyclonedx-json, repo + image) and `...scan-vulnerabilities.yml` (anchore/scan-action, `fail-build: true`, `severity-cutoff: critical`). Copy-ready templates for keys under item 9.
- **grype ignore + syft config** - `tools/dependency-scan/config/.grype.yaml` (ignore by CVE/package with fix-state = the time-boxed accepted-vuln mechanism) and `.syft.yaml` (catalogers, secrets cataloger, SBOM attestation via cosign). Item 9.

### Still NOT pulled (separate sources, not in this repo)
- `blueprints.md` links **`nhs-england-tools/repository-template`** (full repo scaffold) - PULLED, see `reference-scaffold.md`. Its sibling **`nhs-england-tools/versioning-reference-template`** is 404/not-public; REPLACED 2026-06-04 by the canonical current reference set (SemVer 2.0.0, Conventional Commits 1.0.0, Keep a Changelog 1.1.0, SLSA Provenance v1.0, CalVer) - see item 10 above.
- Illustrative-only code the repo itself flags as incomplete: `tools/acm-cert-monitor/*.tf`, `tools/aws-fis/jenkins|jmeter/*`. Low value; READMEs already captured the practice.

---

## The gate table (ready-made verify-time spec)
`quality-checks.md` classifies checks (Functionality / Security / Resilience / Maintainability), each with what-it-means, why, tolerance-for-green, endorsed tool. RAG: Green = automated via CI/CD + output is a gate (not warning) + agreed tolerance. Checks: accessibility, API/contract, capacity, chaos, code review, code smells, code coverage, dead code, dependency scan, duplicate code, integration, performance, secret scan, security scan, security test, soak, stress, tech-radar, UI, unit. Plus "publishing code" minimum RAG levels for public repos.
