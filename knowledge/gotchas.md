# Gotchas & Lookups

Implementation quirks, tooling traps, SwiftData/CloudKit & TMDb-mapping surprises,
and things that needed a lookup to resolve. Newest at the top. Keep each entry short
and dated; link an ADR if a decision came out of it.

<!-- Add entries under a dated `### ` heading, newest first. Example:

### Short title of the gotcha

*YYYY-MM-DD.* What bit us, why, and the resolution. Keep it to a few lines.
-->

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
