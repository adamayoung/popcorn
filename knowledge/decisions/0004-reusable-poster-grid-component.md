# ADR-0004: A reusable infinite-scroll poster grid lives in DesignSystem, configured by closures

- **Status:** Accepted
- **Date:** 2026-07-21
- **Deciders:** Adam Young

## Context

[ADR-0003](0003-infinite-scroll-paginated-lists.md) established the infinite-scroll
pattern in `TrendingMoviesFeature`: an adaptive `LazyVGrid` of poster buttons, each
a `matchedTransitionSource` zoom source, with a per-cell `.task` driving
`loadMoreIfNeeded(at:)` and a footer spinner. The Discover Movies screen needed the
*same* grid. That grid's `content(movies:)` was ~40 lines of cell chrome
(`PosterImage` + aspect ratio + corner radius + border overlay + accessibility +
zoom source + load-more trigger) living inside the feature — the second paginated
poster grid the app wanted, with more to come (trending TV series/people, watchlist,
search results all show poster/backdrop collections).

Constraints: feature packages are leaves ([ADR-0001](0001-feature-packages-are-leaves.md))
and each owns its **own** feature-local `MoviePreview` presentation model, computes
its **own** per-screen `TransitionID` context (the carousel-vs-grid collision
avoidance the trending/discover `TransitionID` types encode), and localizes its
**own** accessibility hint from its own bundle. DesignSystem has **no snapshot-test
target** — its components are visually covered by the snapshot baselines of the
features that adopt them.

## Decision

We will extract the grid into a generic
`public struct PosterGrid<Item: Identifiable & Equatable>: View` in `DesignSystem`,
**configured by per-item closures, not a protocol**:
`posterURL: (Item) -> URL?`, `transitionID: (Item) -> String`,
`accessibilityLabel: (Item) -> String`, `onSelect: (Item, String) -> Void`,
`loadMore: (Int) async -> Void`, plus scalar `isLoadingMore`, a
`transitionNamespace`, an `accessibilityHint: Text`, and a single
`accessibilityIDPrefix: String` (the grid builds `"\(prefix).movie.\(offset)"` and
`"\(prefix).loadingMore"` itself).

`PosterGrid` owns the adaptive `LazyVGrid` (`GridItem(.adaptive(minimum: 100))`),
the poster cell chrome, the per-cell `.task { await loadMore(offset) }` trigger, the
`matchedTransitionSource`, the reduce-motion-aware animation, and the footer
`ProgressView`. The **feature** keeps the surrounding `ScrollView`, the `ViewState`
switch (loading / empty / error), the `.padding()`, and — crucially — **all
pagination policy** (the load-more threshold, dedupe, `maxLoadMoreAttempts`) in its
view model; the grid only forwards the cell offset. The cell accessibility label is
applied **verbatim-safe** — `.accessibilityLabel(Text(verbatim: accessibilityLabel(item)))`,
never `Text(_ key:)` — so a movie title is never treated as a localization key.

## Consequences

- `TrendingMoviesFeature` and `DiscoverMoviesFeature` render through one component;
  the next paginated poster grid (trending TV/people, watchlist, search) should
  **adopt `PosterGrid`** rather than hand-rolling a `LazyVGrid`.
- Because DesignSystem has no snapshot target, `PosterGrid`'s rendering contract is
  enforced by its **adopters' snapshot baselines** — the trending baselines are the
  pixel-identity gate for any change to the grid (they must pass **unchanged** when
  `PosterGrid` is refactored); new adopters record their own baselines.
- The grid stays presentation-only: pagination state and policy remain sibling
  properties on each feature's `@Observable @MainActor` view model (per ADR-0003),
  so the shared component carries no feature logic.
- More closure parameters at the call site than a protocol conformance would need,
  but each is a one-liner and the set is small.

## Alternatives considered

- **A `PosterGridItem` protocol the feature model conforms to** — rejected: it buys
  no safety here and forces each feature to publicly conform its presentation model,
  while the per-item values the grid needs (poster URL, the per-screen transition
  id, the localized label) must come from the call site *anyway*. Closure
  configuration is the established DesignSystem idiom (the `Carousel` components take
  `didSelect…` closures).
- **Duplicate the grid per feature** — rejected: it was already a copy-paste of
  trending's cell tree, and at least three more paginated poster grids are expected;
  a shared component is the CRP ("reuse shows up") call.
- **Move the load-more threshold into the grid** — rejected: the threshold and the
  dedupe/`maxLoadMoreAttempts` policy are view-model concerns (ADR-0003); keeping
  them out of the grid leaves the component free of paging policy and testable
  purely via the adopting view models.
