# Gotchas & Lookups

Implementation quirks, tooling traps, SwiftData/CloudKit & TMDb-mapping surprises,
and things that needed a lookup to resolve. Newest at the top. Keep each entry short
and dated; link an ADR if a decision came out of it.

<!-- Add entries under a dated `### ` heading, newest first. Example:

### Short title of the gotcha

*YYYY-MM-DD.* What bit us, why, and the resolution. Keep it to a few lines.
-->

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
