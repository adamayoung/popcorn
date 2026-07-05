# ADR-0001: Feature packages are leaves; `.live` builders live in the App layer

- **Status:** Accepted
- **Date:** 2026-07-05
- **Deciders:** Adam Young (project owner); implemented via `/deliver`

## Context

Every feature package (`MovieDetailsFeature`, `WatchlistFeature`, … — 20 of them)
depended on **`AppDependencies`**, the single composition root, which in turn depends on
*everything*: all 12 contexts, all context adapters, TMDb, Sentry, and Statsig. The only
thing in each feature that needed `AppDependencies` was one file — the feature's
`…Dependencies.swift` — solely for its `static func live(services: AppServices)` factory.
The feature's `Dependencies` struct (a `Sendable` bag of closures) and its `#if DEBUG`
`.preview` needed nothing from `AppDependencies`.

Two costs followed:

1. **Rebuild blast radius.** Because every feature sits downstream of the
   depends-on-everything node, touching *any* adapter invalidated `AppDependencies` and
   rebuilt *all* 20 features. This tax had already been paid twice (the `/build-package`
   workaround; the eager-DI CI launch crash).
2. **Leaky reach.** `.live(services:)` gave every feature compile-time reach into the
   entire object graph via `AppServices`.

This amends what `docs/ARCHITECTURE.md` previously codified (features own their
`.live(services:)` builder).

## Decision

Move each feature's `.live(services:)` builder **out of the feature package and into the
App target**, at `App/Composition/Live/<Feature>Dependencies+Live.swift`. A feature then
depends only on the modules it genuinely uses (its own context's `*Application`,
`Presentation`, `DesignSystem`, `CoreDomain`) — never on `AppDependencies` — becoming a
true leaf. The App layer, which already owns the composition root, does the wiring.

To let the App-layer builder construct the feature's closures, the feature-internal
**presentation mappers** (`MovieMapper`, …) and **`Fetch…Error` types** (with their
inits) that the builder references become **`public`**.

**No Xcode project (`.pbxproj`) change is required.** The App target already resolves
context `*Application`/`*Composition` modules **transitively** through `AppDependencies`
(it directly links only the feature packages + `FeatureAccess`, yet `PopcornApp` imports
`AppDependencies` and `AppRootDependencies` imports `TVListingsApplication`/`Composition`
today). An App-layer `+Live.swift` can therefore `import MoviesApplication` transitively
with no project-file surgery.

`AppRootDependencies.live` already lives in the App layer and is unchanged.

## Consequences

**Easier**
- Feature packages are leaves: editing an adapter rebuilds `AppDependencies` + the App
  target, but **not** the 20 feature packages.
- Features have no compile-time reach into the whole graph; each sees only its own context.

**Harder / accepted trade-offs**
- Feature **presentation mappers and `Fetch…Error` types become public API** of the
  feature module (previously internal). This is the load-bearing trade-off.
- The App target accumulates one `App/Composition/Live/<Feature>Dependencies+Live.swift`
  per feature — wiring is centralised there rather than distributed to features.
- Graph assembly is unchanged: `AppServices` still builds the whole graph eagerly at
  launch (see the eager-DI note in `gotchas.md`); this ADR only moves where the
  per-feature *builders* live.

**To watch**
- The `+Live.swift` files must be added as the sweep proceeds; a feature whose `.live`
  is removed without a matching App-layer builder fails to wire in `ViewModelFactory`.

## Alternatives considered

- **Parameterise `.live` in the feature by collaborators** (pass the use-case protocols +
  `featureFlags` instead of `AppServices`): keeps the mappers internal (no public
  leakage) and the feature a leaf, but keeps a builder in the feature that must name its
  context's factory/protocols. Rejected in favour of moving the builder wholesale to the
  App, which gives the feature *zero* graph knowledge and one consistent home for wiring.
- **Per-feature `*Live` shim packages**: 20 new micro-packages for finer incremental
  builds. Rejected as disproportionate ceremony.
- **Status quo**: rejected — the rebuild tax and leaky reach are the reason for this ADR.
