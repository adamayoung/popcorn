# Gotchas & Lookups

Implementation quirks, tooling traps, SwiftData/CloudKit & TMDb-mapping surprises,
and things that needed a lookup to resolve. Newest at the top. Keep each entry short
and dated; link an ADR if a decision came out of it.

<!-- Add entries under a dated `### ` heading, newest first. Example:

### Short title of the gotcha

*YYYY-MM-DD.* What bit us, why, and the resolution. Keep it to a few lines.
-->

### `#Preview` blocks compile in Release — guard any that touch DEBUG-only fixtures

*2026-07-22.* `#Preview` macro bodies are **not** stripped from Release builds, so a
preview referencing a fixture that only exists under `#if DEBUG` (the `.mocks` /
`.preview` helpers every feature ships) compiles fine in Debug — through the whole
local gate, which builds Debug only — and then breaks **only** CI's `Build (Release)`
job (`cannot find 'mocks' in scope`). Wrap such previews in `#if DEBUG … #endif`
(most sibling views already do; `CreditRow` on PR #88 didn't and cost a CI round
trip). Rule of thumb: a bare `#Preview` is fine only when it builds its own inline
data; the moment it touches a DEBUG-gated symbol, it needs the guard.

### A feature mapper used by its `Dependencies+Live` builder must be `public`

*2026-07-22.* The app-layer `App/Composition/Live/<Feature>Dependencies+Live.swift`
builder constructs the feature's context→presentation mapper (e.g.
`CreditItemMapper()` in `PersonCreditsDependencies+Live`), so that mapper needs
`public` visibility — a `public struct` with a `public init()` and `public func
map(...)` (see `MovieCastAndCrewFeature`'s `CreditsMapper` for the shape). Leaving
it `internal` compiles fine in the feature package **and** in its package tests;
the failure only surfaces later, at the **App-target** compile of the Live file
(`cannot find 'X' in scope`) — far from the file that's actually wrong. When
scaffolding a new feature, make the mapper public from the start.

### A mixed movie + TV series carousel must key `ForEach` on the offset, not the item id

*2026-07-22.* TMDb movie IDs and TV series IDs live in the **same integer namespace**,
so within one list that mixes both (a person's combined credits → the "Known For"
carousel), two different items can share an `id` (e.g. movie `1396` and series `1396`).
Keying `ForEach` on the item `id` there gives SwiftUI a **non-unique** identity —
duplicate-key rendering, broken diffing, and ambiguous `matchedTransitionSource` zoom
sources. `docs/SWIFTUI.md` recommends `ForEach(x.enumerated(), id: \.element.id)`, but
that advice assumes a single-media list; for a **mixed-media** list key on `\.offset`
instead (the list is loaded once and never reorders, so the index is a stable identity).
Still drop the `Array(...)` wrap per the doc — `ForEach(items.enumerated(), id: \.offset)`
compiles (an `EnumeratedSequence` over an `Array` is a valid `ForEach` source on the
iOS 26 SDK; `PosterGrid` already relies on this). Sibling of
[the per-screen zoom-id gotcha](#zoom-transition-ids-must-be-scoped-per-screen-not-per-item)
— both are identity-collision traps.

### swift-testing hangs on `async` methods that use typed throws — the suite gets `.disabled`

*2026-07-21.* `TMDbMovieRemoteDataSourceListsTests` (in `PopcornMoviesAdapters`) is
annotated `.disabled("Typed throws causes Swift Testing to hang")` — the
`TMDbMovieRemoteDataSource` methods use `throws(MovieRemoteDataSourceError)`, and
awaiting one from a `@Test` hangs the runner
([swiftlang/swift-testing#777](https://github.com/swiftlang/swift-testing/issues/777)).
Consequence: **tests you add to a `.disabled` suite compile but never execute.** The
popular-movies adapter paging tests (page/`totalPages` surfacing + the
`min(totalPages, 1000)` clamp) live in that suite, so that behaviour is validated by
*compilation + the full-app run* only, not by an executed adapter unit test. When you
add a test to a `PopcornMoviesAdapters` remote-data-source suite, check whether the
suite is `.disabled` before trusting it as coverage; cover the same behaviour at a
layer whose tests actually run (the context use-case/repository tests, or the
feature/app path).

### Popular-movies image enrichment is all-or-nothing, unlike recommendations

*2026-07-21.* `DefaultFetchPopularMoviesUseCase.imageCollections(for:)` fetches a
per-movie `ImageCollection` in a `withThrowingTaskGroup` iterated with
`for try await` — so **one movie's `imageCollection(forMovie:)` throwing fails the
whole page fetch** (`FetchPopularMoviesError`). `DefaultFetchMovieRecommendationsUseCase`
does the opposite: it *tolerates* a per-item image failure and keeps the movie without
its logo. This asymmetry is pre-existing and was preserved (not introduced) by the
paged-pipeline refactor. If popular-movies pages start failing wholesale when a single
TMDb image request 404s, this is why — a follow-up could align popular with the
tolerant recommendations pattern.

### Wiring a new local feature package into the app is a 5-part hand-edit of `project.pbxproj`

*2026-07-21.* `Popcorn.xcodeproj` uses Xcode-16 **`PBXFileSystemSynchronized`
folders**, and its `packageReferences = ()` is **empty** — there are **no
`XCLocalSwiftPackageReference` objects**. So adding a new `Features/<X>Feature`
package to the app target is not "add a package reference"; it is five hand-edits,
easiest done by mirroring an existing feature (e.g. `TrendingMoviesFeature`) and
generating two fresh unique 24-hex-char object IDs:

1. add the folder name to the **`Features` folder's
   `PBXFileSystemSynchronizedBuildFileExceptionSet` `membershipExceptions`** list
   (this is what makes the synced folder a *package* rather than loose sources);
2. a `PBXBuildFile` — `<id1> /* X in Frameworks */ = {isa = PBXBuildFile;
   productRef = <id2> /* X */; };`;
3. `<id1>` in the app target's **Frameworks** build-phase `files`;
4. `<id2> /* X */` in the app target's **`packageProductDependencies`**;
5. an `XCSwiftPackageProductDependency` object — `<id2> /* X */ = { isa =
   XCSwiftPackageProductDependency; productName = X; };`.

Miss step 1 and the package's product won't resolve. The `add-feature` skill
doesn't cover this. (The whole app build is what validates it — a wrong edit
surfaces as `no such module 'X'` in the App target.)

### A feature package can't be built or tested from the SwiftPM CLI at all

*2026-07-21.* Trying to `/test-package` `TrendingMoviesFeature` failed at the
package manifest, before any compile: `swift build` — even sources-only
(`swift build -Xswiftc -warnings-as-errors`) — errors with *"found 2 file(s)
which are unhandled; explicitly declare them as resources or exclude from the
target"*, naming the committed `__Snapshots__/….png` references in the snapshot
test target. The SwiftPM CLI treats stray files under a target directory as
undeclared resources; Xcode's build handles them fine. This compounds the sibling
gotcha below (`swift test` fails on the snapshot target's `import UIKit` on
macOS): net effect — a **feature** package (any with a snapshot-test target)
can't be built *or* tested via the SwiftPM CLI, so `/build-package` /
`/test-package` don't apply to it. Build and test features through the full-app
xcodebuild path (`/build-for-testing`, `/test`, `/test-snapshots`). **Context**
and **adapter** packages have no snapshot target and build/test fine via
`swift build --build-tests` / `swift test`.

### A full-view snapshot of a `StretchyHeaderScrollView` screen only captures the header

*2026-07-21.* A "sections loading" snapshot of `MovieDetailsView` rendered **identically**
to the all-ready snapshot — both were a near-blank page with just the toolbar. The
details screens are built on `StretchyHeaderScrollView` with a 600pt flexible header; at
scroll offset 0 the header (a `BackdropImage` from a remote URL that never loads in a
snapshot → blank) fills the viewport, so the overview, carousels, and their loading
placeholders all sit **below the fold** and are never in the captured frame. A loading-state
snapshot therefore validates nothing the ready-state one doesn't. Don't add snapshots for
below-the-fold states of these screens — cover placeholder/loading rendering in a
**view-model** test (assert the section `ViewState`) instead. Sibling of the seeded-`.error`
gotcha below: both are cases where a snapshot silently asserts the wrong thing.

The same blind spot applies to any **visual change** below the fold, not just loading
states. When the "Cast & Crew" header chevron was enlarged across the detail screens, the
`MovieDetailsView` and `TVSeriesDetailsView` snapshots stayed green (Cast & Crew sits below
the 600pt header) and only `TVEpisodeDetailsView` needed re-recording — it is a plain
`ScrollView` with a short 16:9 still, so its Cast & Crew section lands in-frame. Don't
assume an intentional detail-screen UI change will surface in these snapshots; it only does
for content in roughly the top viewport (~844pt at the pinned iPhone 13 Pro layout).

### `CIContext` is already `Sendable` — don't annotate a shared static with `nonisolated(unsafe)`

*2026-07-21.* Sharing one `CIContext` across calls in `ImageAverageColorExtractor`
(`private static let context = CIContext()`) is correct — it's expensive to build and
thread-safe. The reflex to write `nonisolated(unsafe) private static let` **fails the
build**: on the iOS 26 SDK `CIContext` already conforms to `Sendable`, so the compiler
emits *"'nonisolated(unsafe)' is unnecessary for a constant with 'Sendable' type
'CIContext'"* — a warning, and the build is warnings-as-errors. Use a plain
`private static let`. Reach for `nonisolated(unsafe)` only when the type is genuinely
non-`Sendable`; check whether the SDK already made it `Sendable` first.

### A seeded `.error` view state can't be snapshot-tested — `.task(id:)` retries it

*2026-07-20.* An error-state snapshot for `TrendingMoviesView` recorded a **spinner**, not
the error view. Constructing a view model at `.error` and rendering it does not hold: the
view's `.task(id:)` runs on first appearance and `load()` only short-circuits on `.ready` /
`.loading`, so a seeded `.error` is immediately retried into `.loading` before the image is
captured. The test would have passed forever while asserting the wrong thing. In production
the state is stable (reached by a failing `load()`; `.task` won't rerun until `reload()`
bumps `reloadID`) — the artefact is purely from seeding. Cover the `.error` transition in a
**view-model** test instead; that is why no feature here snapshot-tests an error state.
`.ready` states seed fine — the `!isReady` guard makes `load()` a no-op — which is how the
empty-state snapshot works.

### Zoom transition IDs must be scoped per screen, not per item

*2026-07-20.* Two screens that publish the **same** items as zoom sources into the same
`Namespace` need different `matchedTransitionSource` identifiers. The Explore carousel and
the pushed trending grid both list the same movies, and the carousel stays mounted
underneath while the grid is on top — reusing `"<id>"` would leave
`.navigationTransition(.zoom(sourceID:))` with two candidate sources for one movie. Hence
the per-screen context suffix (`42_trending-movies` vs `42_trending-movies-grid`). This is
what the per-feature `TransitionID` type's `context` is for; it is duplicated per feature
on purpose (feature packages are leaves — see
[0001](decisions/0001-feature-packages-are-leaves.md)).

### `.adaptive(minimum:)` grid columns: copying a sibling's number changes the column count

*2026-07-20.* `GridItem(.adaptive(minimum:))` fits `floor((width + spacing) / (minimum +
spacing))` columns, so the same literal yields different counts on different screens.
`WatchlistFeature`'s `minimum: 120` gives only **2** columns at iPhone widths (390pt −32pt
padding = 358 → `floor(374/136)` = 2); a 3-across iPhone grid needs `minimum: 100`
(375–440pt all yield 3). Derive the number from the target column count and content width
rather than copying it from a sibling grid.

### `swift test` can't build a feature package whose snapshot target imports UIKit

*2026-07-20.* Running `swift test` in a feature package directory builds **all** its
targets for macOS, so a package with a snapshot-test target fails at
`SnapshotTestHelpers` → `import UIKit` ("unable to resolve module dependency"), before any
test runs. Not a project error — use the full-app `/test` (or Xcode MCP `RunSomeTests`) for
those packages, or `swift build` sources only. Documented in the `/test-package` skill.

### Typed throws survive an existential — a second generic `catch` is unreachable

*2026-07-20.* `MovieIntelligenceViewModel.sendPrompt` had a `catch let error as LLMSessionError`
plus a generic `catch` wrapping anything else as `.unknown`, commented "typed throws are erased
when calling through an `any LLMSession` existential". That is wrong: `LLMSession.respond(to:)`
declares `throws(LLMSessionError)` with a **concrete** error type (not an associated type), so
the typed throw is preserved through `any LLMSession` and `catch let error` binds as
`LLMSessionError`. The generic block was dead code. The proof is that it compiles at all —
`self.error` is `LLMSessionError?`, so if erasure really happened the assignment wouldn't build.

### Bumping a third-party dependency can add enum cases that break exhaustive switches

*2026-07-09.* Updating **TMDb 18.0.0 → 18.2.0** (a *minor* bump) silently added a
`.unknown` resilience case to the public `TMDb.Status` enum — unrecognised API values now
decode to `.unknown` instead of throwing. That turned our exhaustive `switch` over
`TMDb.Status` in `MovieStatusMapper` into a **compile error**. Because the build stops at
the first non-exhaustive switch, don't chase these one build-error at a time: after any
dependency bump, sweep **every** exhaustive switch over that dependency's public
(non-frozen) enums up front with a type-driven grep (e.g. `rg 'case \.<distinctiveCase>'`).
The sweep here found three switches — `MovieStatusMapper` (`TMDb.Status`) plus the two
Intelligence `MovieMapper`s (over the domain `MovieStatus`). Fix followed the
`GenderMapper` convention: add a matching `.unknown` case to the domain enums
(`MoviesDomain.MovieStatus` + `IntelligenceDomain.MovieStatus`) and map it 1:1. A
`String`-backed enum case needs no SwiftData/CloudKit migration (stored as its rawValue).

### `Package.resolved`: only the workspace file is tracked, and resolvers disagree on transitives

*2026-07-09.* Only the **workspace** `Package.resolved`
(`Popcorn.xcodeproj/project.xcworkspace/xcshareddata/swiftpm/Package.resolved`) is
git-tracked; all 33 per-package `Package.resolved` are gitignored (`.gitignore`:
`**/Package.resolved`, with the workspace path force-added). So a dependency bump's
committed diff is just the touched `Package.swift` files + the single workspace
`Package.resolved` (+ any code the bump forced); running `swift package update` in the
per-package dirs rewrites gitignored files only and produces no committed diff. Two traps
when re-resolving:

- **Per-package and workspace resolves pick different transitive versions.**
  `swift package update` inside an isolated package resolves transitives to the newest
  allowed *there*, but the full-workspace `xcodebuild -resolvePackageDependencies` caps
  them lower because another package in the graph constrains them. Example: isolated
  `SnapshotTestHelpers` picked swift-custom-dump 1.6.1 / swift-syntax 603.0.2 /
  xctest-dynamic-overlay 1.11.0, while the workspace held them at 1.5.0 / 603.0.0 / 1.9.0.
  The **workspace** file is authoritative for the app build — trust it, not the
  per-package files.
- **`-resolvePackageDependencies` only moves pins that violate the new lower bound.** To
  force the tracked workspace file fully to latest, delete it and re-resolve.

### The App target got `AppDependencies` transitively through the feature packages

*2026-07-05.* The `Popcorn` app target's pbxproj directly links only the 20 feature
packages + `FeatureAccess`/`FeatureAccessAdapters` — **not** `AppDependencies`. Yet `PopcornApp` imports
`AppDependencies` and builds, because every feature package depended on `AppDependencies`,
so the App resolved it *transitively through them*. Consequence discovered during the
ADR-0001 leaf sweep: converting the **last** feature to a leaf (dropping its
`AppDependencies` edge) severs that transitive path and breaks the whole App with
`no such module 'AppDependencies'` in `PopcornApp.swift` and every
`App/Composition/Live/*+Live.swift`. Fix: add `AppDependencies` as a **direct** product
dependency of the app target in `Popcorn.xcodeproj`. General lesson: a target that only
links intermediate packages can be silently relying on a transitive module; removing the
last intermediate that provides it is what surfaces the missing direct edge.

### Mocks called concurrently must guard call-tracking with a `Mutex`

*2026-07-05.* The common sibling mock pattern (a plain `final class` that appends to a
call-log array / increments a counter) is only safe when the mock is invoked
**serially**. When a use case fans its dependency out across a `TaskGroup` (e.g.
`DefaultGeneratePlotRemixGameUseCase` calls `MovieProviding.randomSimilarMovies` /
`SynopsisRiddleGenerating.riddle` once per movie, concurrently), a naive mock crashes
`swift test` with **SIGTRAP** (concurrent `Array.append` corruption) — often on the very
first run. Fix: move the call-tracking state behind a `Synchronization.Mutex<State>` and
read/write it via `.withLock`. Stub *inputs* set before the exercise and only read during
it don't need the lock; only the mutated tracking state does.

Recurred 2026-07-22 in `DefaultFetchPersonKnownForUseCase`'s concurrent logo fan-out
(`MovieLogoImageProviding` / `TVSeriesLogoImageProviding` mocks), there as **signal 11**.
The crash can masquerade as the `Runner._applyScopingTraits` scoping-traits flake — but
it is **deterministic** (a real data race in your mock), not the flake: guard the mock,
don't just re-run.

### Injecting an observability provider in tests — use `$localProvider`, never a global

*2026-07-05.* `SpanContext`'s global provider is **bootstrap-only**: written once at
launch via the internal `SpanContext.configure(_:)` (from `ObservabilityService`) and
held in a `Mutex`. There is no public setter. Tests must inject a provider through the
`@TaskLocal` override — `SpanContext.$localProvider.withValue(mock) { … }` — which is
per-task and cannot leak across swift-testing's parallel suites. The old
`SpanContext.provider = …` global write from tests was a genuine cross-suite data race.
To assert the *no-span* path, inject nothing: the global stays nil in the test process,
so `provider` resolves to nil by default (don't reset it).

### `try await (a, b, c)` tuple awaits run serially, not concurrently

*2026-07-05.* Awaiting a *tuple* of async calls — `let (x, y) = try await (repo.a(),
provider.b())` — evaluates the elements **strictly left-to-right (serially)**. It looks
parallel but isn't, so independent fetches silently stack their latency. ~22 use cases
across the contexts had this shape (detail/list `execute` bodies). To actually run them
concurrently, bind each with `async let` and harvest the tuple from the bindings:

```swift
async let xTask = repo.a()
async let yTask = provider.b()
let (x, y) = try await (xTask, yTask)   // now concurrent
```

Two things to preserve when converting:

- **Harvest in the same order as the original tuple.** `try await (xTask, yTask)` awaits
  left-to-right and rethrows the first error in await order, so matching the original
  order keeps first-error-wins identity deterministic.
- **`async let` widens the static throw type to `any Error`** (it loses the call's typed
  throw). Existing `catch let e as SomeSpecificError` routing still works — catch routing
  is by the error's *dynamic* type — and a trailing catch-all keeps a typed-throws
  (`throws(SomeError)`) `do` block exhaustive. Verified by the build staying green.
