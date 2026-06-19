# Code Review Spec

The single shared reference for reviewing Popcorn changes — followed by the local
`code-reviewer` agent (via `/review-changes`) **and** the GitHub `claude-code-review`
workflow, so local and CI review stay aligned.

This file is an **index + severity rubric**, not a rules dump. The **source of truth
for conventions is `docs/`** — reviewers must read the relevant docs, not rely on a
condensed copy here:

- [`docs/ARCHITECTURE.md`](../docs/ARCHITECTURE.md) — layering, contexts/features,
  factory/DI wiring, navigation.
- [`docs/SWIFT.md`](../docs/SWIFT.md) — Swift 6.2 strict concurrency, language rules.
- [`docs/SWIFTUI.md`](../docs/SWIFTUI.md) — view rules, spacing constants,
  localization (`bundle: .module`, SCREAMING_SNAKE_CASE).
- [`docs/SWIFTDATA.md`](../docs/SWIFTDATA.md) — `@Model`, CloudKit constraints,
  `VersionedSchema` migrations.
- [`docs/TMDB_MAPPING.md`](../docs/TMDB_MAPPING.md) — the 4-layer mapping pipeline.
- [`CLAUDE.md`](../CLAUDE.md) — project-specific rules (Statsig gates, test-plan
  registration, test-coverage-at-all-layers).

## When review runs

Review runs **only when the change touches Swift** (`*.swift` in the diff). A
docs-only / config-only change is not code-reviewed.

## Review dimensions

Cover each dimension; read full files and a sibling implementation, not just the diff.

- **Correctness & safety** — bugs, behavioural regressions, force-unwraps/`try!`
  outside test helpers, data validation at boundaries.
- **Concurrency** — Swift 6.2 strict concurrency; `@Observable` view models are
  `@MainActor`; no `DispatchQueue.*` / `Task.sleep(nanoseconds:)`; `Sendable`
  correctness.
- **Architecture** — layer boundaries (Domain has no deps; Application/Infrastructure
  depend on Domain; Composition wires); MVVM rules (`ViewState` lifecycle, per-feature
  `*Dependencies` struct, `*Navigating` protocol, view owns VM via `@State`); factory/
  router wiring consistency; cross-context provider protocols.
- **SwiftUI** — `foregroundStyle`/`clipShape`/`Tab`/`NavigationStack`; **no hard-coded
  spacing** (use `.spacing*`); no `ObservableObject`/`AnyView`/hard-coded fonts;
  localization `bundle: .module` + SCREAMING_SNAKE_CASE keys.
- **SwiftData/CloudKit** — no `@Attribute(.unique)` on CloudKit-synced models;
  optional/defaulted properties & relationships; `@Model` never escapes Infrastructure;
  `VersionedSchema` + `MigrationStage` added when CloudKit models change.
- **Testing** — Swift Testing; `try #require` not force-unwrap; **tests at all layers**
  (mappers, use cases, view models) incl. error/edge paths; feature-flag tests updated;
  new test targets registered in the right `.xctestplan`.
- **Project-specific** — TMDb mapping compliance (`docs/TMDB_MAPPING.md`); `language:
  nil` (not `"en"`) on remote calls; Statsig gate exists for any new `FeatureFlag`
  (ID = `FeatureFlag.id`, snake_case); no hard-coded locale/region/language.

## Severity rubric

Use these four tiers consistently (this is the canonical vocabulary across the local
agent and the CI workflow):

- **Critical** — bugs, data-loss risk, security issues, broken functionality.
- **High** — architecture violations, missing features, poor error handling, test
  gaps for new behaviour.
- **Medium** — concurrency concerns, missing docs on public declarations, suboptimal
  patterns, **documented-convention violations** (a pattern an explicit `docs/` rule
  prohibits is Medium-or-higher even if sibling code does the same — the sibling has
  the bug too).
- **Low** — minor style/optimization beyond what SwiftLint/SwiftFormat already handle.

Every finding includes a `file:line` reference, what's wrong, why it matters, and a
concrete fix. Don't mark nitpicks Critical. Style already handled by SwiftLint/
SwiftFormat is out of scope.
