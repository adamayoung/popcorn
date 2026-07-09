# /deliver — review loops (reference)

Read on demand from `/deliver` **Phase 4** (code review) and **Phase 5**
(security review). The rules and caps live in `SKILL.md`; this file holds the
procedure detail and the incidents behind the rules.

## Why review once, after implementation settles (Phase 4)

Code review is an independent, adversarial lens — apply it once the design has
settled, not after every Canon TDD item. The test list is deliberately
emergent; early items are reshaped by later ones, so per-item review just
flags churn. The per-item quality gate already lives in the implement phase —
the passing test, the inline docs, the lint/format hook, and
refactor-on-green.

## The 4a reference-unit gate (template→replicate deliveries)

For one pattern applied across **N≥3 cohesive units** (e.g. a DI-shape change
swept across every feature package, one mapper convention mirrored across
sibling adapters, a `ViewState` pattern applied to N view models):

1. Add a `Phase 4a — reference-unit review @ <sha>` task to the ledger.
2. Have the implement phase commit the **first unit on its own**.
3. Run `/review-changes` scoped to that commit
   (`git diff origin/main...<sha>`) and converge its Critical/High findings
   per the standard loop.
4. Only then replicate the pattern across the remaining units. **Phase 9 must
   not start while the 4a task is open.**

A wrong foundational pattern caught here is one *not* baked into all N units —
on the sibling TMDb project, a reference-first review caught a cross-module
DocC break in the first mock before it replicated into 25 siblings. For
**full-otherwise** deliveries (multi-unit but not template-replicate), do
**not** interleave per-unit review — the units don't build on each other, so
per-unit review only adds churn; the single end-diff fan-out's per-dimension
adversarial pass already covers the whole diff.

## Why review fixes must be committed

`/review-changes` diffs **committed** history (`git diff origin/main...HEAD`),
so an uncommitted fix re-reviews as still-broken and the loop never converges.
Commit each fix before re-invoking.

## Enumerate-all-sites: the incident behind the rule

On the sibling TMDb project ("encode every path interpolation, validate every
public String input"), the plan grep, the security review, the code review,
and the review bot each found a *different* subset of sites; none enumerated
the class. Sweep by **type**, not by eyeballing — e.g. grep for the
constructor/modifier/protocol that defines the pattern, or scan the relevant
signatures across every feature/context package — confirm the full list in
the test list, then implement against it.

## Specialist skills: the incident behind the checkpoint

A TMDb delivery hand-rolled an `NSLock`/`@unchecked Sendable` mock design and
only consulted `swift-concurrency` when the user prompted — at which point the
skill both validated the choice *and* caught a gap the design had omitted. The
checkpoint is topic-triggered (the moment the domain appears), not
stuck-triggered, and applies to fanned-out subagents/Workflows too — give them
the same instruction.

## Security review (Phase 5) — what actually bites in this app

- **Secrets and keys**: `Configs/*.xcconfig` handling (`TMDB_API_KEY`,
  `SENTRY_DSN`, `STATSIG_SDK_KEY`), anything that could commit or log them.
- **The TMDb adapter layer** — API-key usage, URL/query construction.
- **The EPG sync path** (`HTTPTVListingsRemoteDataSource` and its DTOs) —
  HTTP fetch + `Decodable` over remote, untrusted JSON.
- **SwiftData/CloudKit** — user data persistence, schema/migration changes,
  entitlements.
- **Anything that logs** (OSLog, Sentry breadcrumbs) — PII or key leakage.
- **Dependency / permission changes** (`Package.swift` / `Package.resolved`
  across the packages, `.github/workflows/`, `.claude/settings*`).

`/security-review` grades **High / Medium / Low** (no "Critical" tier),
filters out findings below confidence 8, and excludes documentation files —
a docs-only diff returns nothing. It produces findings; it does **not** fix.
Fix test-first via `canon-tdd` where the defect is reproducible (input
validation at a boundary, a decoding guard), or by the minimal direct
change where it is not (removing a secret-leaking log line, tightening a
permission). Phase 9's pre-PR gate is a **correctness** gate with no SAST
step, so Phase 5 is the pipeline's **only** security gate.
