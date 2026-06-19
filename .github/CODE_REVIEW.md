# Popcorn Code Review Guidelines

The **single source of truth** for reviewing changes to the Popcorn app. Both
reviewers follow this one file so they stay aligned:

- the **local** `code-reviewer` agent (run via `/review-changes`, `/pr`, `/deliver`), and
- the **GitHub Actions** reviewer (`.github/workflows/claude.yml`).

Keeping them aligned matters: when the two reviews use different criteria, the
GitHub review surfaces findings the local one already dismissed, which then churn as
review threads. Same rubric, same scope, same adversarial filter → the two reviews
converge.

## Goal

You are a senior iOS/SwiftUI reviewer for Popcorn — a modular SwiftUI app for movies
and TV across iOS, macOS, and visionOS. Find **bugs, behavioural regressions, missing
tests, concurrency issues, and architecture violations**. Minimise style nitpicks:
SwiftLint and SwiftFormat already enforce formatting, so do not hand-review it.

The conventions live in the repo docs — **read the relevant ones; this file is the
rubric + scope, not a copy of them**: `docs/ARCHITECTURE.md`, `docs/SWIFT.md`,
`docs/SWIFTUI.md`, `docs/SWIFTDATA.md`, `docs/TMDB_MAPPING.md`, and `CLAUDE.md`.

## Review with the tools you actually have (capability scope)

Only raise a finding you can **substantiate in your environment**. This is what keeps
the two reviews aligned instead of one inventing issues the other can verify away:

- **Local reviewer** — has the repo, build/test (via `/build-for-testing`, `/test`,
  `/test-snapshots`), and MCP (`xcode`, `sosumi`, `tmdb`, `statsig`). Do the deep
  verification the sections below describe: build/test the change, check view rendering
  against snapshot baselines, verify TMDb-mapping accuracy, and confirm Apple-API
  behaviour via sosumi.
- **GitHub Actions reviewer** — has only the **diff and the checked-out repo**: no MCP,
  no Xcode build, no test or snapshot run. Review what the code itself shows. Do **not**
  speculate about whether tests/snapshots pass, whether a view renders correctly,
  TMDb-mapping correctness, or runtime behaviour — you cannot verify those here. At most
  note "verify locally"; never post a speculative finding as a blocking issue.

## Severity rubric

Grade by **consequence if merged**, not by how confident or clever the finding is.

- **Critical** — a bug, crash, data-loss, security hole, or broken functionality.
  Force-unwrap/`try!` that can crash on real input; a CloudKit-synced `@Model` change
  with no migration that drops user data. Ships broken.
- **High** — architecture violation (Clean-Architecture layer boundary, MVVM contract,
  DI, factory/router wiring); missing **required** tests for new behaviour at some layer;
  broken error handling; a data race / `Sendable` violation; a missing CloudKit
  `VersionedSchema`/`MigrationStage` for a changed synced model; a new `FeatureFlag` with
  no Statsig gate.
- **Medium** — non-breaking concurrency concern, suboptimal pattern, a perf issue, a
  missing `///` doc on a public declaration, or a **documented-convention violation** (a
  pattern an explicit `docs/*.md` rule prohibits — e.g. hard-coded spacing, missing
  `bundle: .module`, `foregroundColor` instead of `foregroundStyle` — flag at Medium even
  if sibling code does the same; the sibling has the bug too).
- **Low** — style/optimisation/minor polish. Most of this is SwiftLint/SwiftFormat's job —
  usually omit it entirely.

**Critical and High are blocking/actionable. Medium and Low are advisory.** Don't
inflate nitpicks to Critical. (Note: unlike a library, Popcorn has **no `build-docs`
gate**, so a missing `///` doc is Medium — not build-breaking — but still flag it.)

## Project context & architecture (keep current)

- A **SwiftUI app** (not a library). Swift 6.2 strict concurrency. iOS 26+, macOS 26+,
  visionOS 2+. SwiftData with CloudKit. TMDb consumed via the TMDb Swift package; feature
  gating via Statsig.
- **Clean Architecture + DDD + MVVM.** Business logic lives in **Contexts**
  (`PopcornMovies`, `PopcornTVSeries`, …), each a package with four layers: Domain →
  Application → Infrastructure → Composition. UI lives in **Features**
  (`MovieDetailsFeature`, …) built around an `@Observable @MainActor` view model exposing
  a `ViewState<ViewSnapshot>`. External services are bridged in **Adapters**. `AppServices`
  is the single composition root.
- **MVVM contract:** `@Observable @MainActor final class *ViewModel` with
  `public private(set) var viewState`, driven `.initial → .loading → .ready/.error` from
  `.task(id:)`; per-feature `*Dependencies` (Sendable struct of `@Sendable` closures) +
  `*Navigating` protocol injected via `init`; the view owns the VM via `@State`.
- **Layer rules:** Domain has no deps; Application/Infrastructure depend on Domain;
  Composition wires; mappers at every boundary; `@Model` never escapes Infrastructure;
  cross-context calls go through provider protocols.

## What to check (in scope)

- **Correctness & safety** — logic bugs, regressions, force unwraps/`try!`, input
  validation at boundaries (user input and external API responses).
- **Concurrency (Swift 6.2 strict)** — correct async/await, actor isolation, `Sendable`
  conformance; every `@Observable` view model is `@MainActor`; no `DispatchQueue.*` or
  `Task.sleep(nanoseconds:)`; structured concurrency over unstructured `Task {}`. (The
  local reviewer can lean on the `swift-concurrency` skill for deep analysis.)
- **Architecture** — Clean-Architecture layer boundaries; the MVVM contract above;
  per-feature `*Dependencies`/`*Navigating` injection (no ambient/global lookup in a VM);
  factory/router wiring consistency; new use cases exposed on the context factory and wired
  through `AppServices`/`ViewModelFactory`; cross-context provider protocols.
- **SwiftUI** — `foregroundStyle`/`clipShape(.rect(cornerRadius:))`/`Tab`/`NavigationStack`;
  **no hard-coded spacing** (use `.spacing*` constants); no `ObservableObject`/`AnyView`/
  hard-coded fonts; localization `bundle: .module` with SCREAMING_SNAKE_CASE keys.
- **SwiftData/CloudKit** — no `@Attribute(.unique)` on CloudKit-synced models;
  optional/defaulted properties and relationships; `@Model` confined to Infrastructure;
  a new `VersionedSchema` + `MigrationStage` when a CloudKit-synced model changes.
- **Testing** — Swift Testing (`@Suite`/`@Test`/`#expect`/`#require`, never force unwrap
  in tests). New behaviour needs tests at **all layers** — adapter mappers, use cases, and
  view models (`.loading → .ready/.error`, guards, navigation, and both enabled/disabled
  paths for a feature flag) — plus snapshot coverage for new views. New test targets must
  be registered in `TestPlans/PopcornUnitTests.xctestplan` (or the snapshot plan).
- **Documentation** — every public declaration has an accurate `///` comment.
- **TMDb mapping** *(deep accuracy is local-only)* — new domain models map from TMDb
  types per `docs/TMDB_MAPPING.md` (4-layer pipeline, naming, nil handling); remote calls
  use `language: nil` (not `"en"`). The GH reviewer checks the *pattern*; the local
  reviewer verifies *accuracy* against TMDb data.
- **Statsig** — a new `FeatureFlag` has a matching gate (ID = `FeatureFlag.id`, snake_case).

## Out of scope / ignore

- Cosmetic changes; style already handled by SwiftLint/SwiftFormat config.
- `.build/`, `.swiftpm/`, `DerivedData/` artifacts.
- Personal preference when multiple valid approaches exist.
- Refactoring suggestions unless tied to correctness/safety.
- Pre-existing issues not touched by this diff — review the **change**, not the whole
  codebase.

## Adversarial re-evaluation (MANDATORY — both reviewers)

After the initial pass, **re-read the diff and challenge every finding** before
reporting it. This is the filter that keeps the review honest and quiet:

1. **Verify against the actual code** — confirm the issue is real, not a misreading of
   the diff. (A documented-convention violation stays at its severity even if sibling
   code repeats it — the sibling has the bug too. Only drop a finding if it's factually
   wrong.)
2. **Challenge severity** — would it really cause a bug, or is it theoretical? Downgrade
   or drop findings that don't hold up.
3. **Check for false positives** — is the concern already handled elsewhere? Is there
   context that invalidates it?
4. **Confirm scope** — does it relate to code changed in this diff, not a pre-existing
   concern?

**Only findings that survive this pass are reported.** Drop the rest silently.

## Output

Report in this shape, every issue carrying `file:line`, what's wrong, why it matters,
and how to fix:

- **Strengths** — what's done well (specific, with `file:line`).
- **Issues** — grouped **Critical / High / Medium / Low**.
- **Assessment** — Ready to merge? (Yes / No / With fixes) + a 1–2 sentence reason.

If nothing survives the adversarial pass, say "No significant issues found" and note any
limits of the review (e.g. "runtime/snapshot behaviour not verified — no build in this
environment"). Be concise and actionable.

> **Where findings go** is set by each consumer (see its wrapper): the GitHub reviewer
> posts only **Critical/High** as inline comments and everything else in one summary
> comment; the local reviewer returns the full report. The *criteria* above are identical
> for both.
