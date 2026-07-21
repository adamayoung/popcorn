# ADR-0003: Infinite-scroll paginated lists — concrete page types, per-cell trigger, sibling view-model state

- **Status:** Accepted
- **Date:** 2026-07-21
- **Deciders:** Adam Young

## Context

The Trending Movies grid fetched only the first TMDb page and stopped — the user
hit the bottom after ~20 posters. This is the **first infinite-scroll / paginated
list UI in the app**, so there was no in-repo pattern to copy. TMDb paginates its
trending endpoint (`page` / `totalPages`, up to 1000 pages). The `page:` parameter
already threaded through `FetchTrendingMoviesUseCase` → `TrendingRepository` →
`TMDbTrendingRemoteDataSource`, but the adapter discarded the response's page
metadata (took `.results` only), so nothing above it knew when the list ended.

Constraints in play: Clean Architecture layering with **concrete per-entity
models** (the codebase has no generic list wrappers by convention); MVVM with
`@Observable @MainActor` view models exposing the shared `ViewState<Content>` enum
(`initial` / `loading` / `ready` / `error`), which is consumed by ~20 features; and
the documented rule that a feature has **no view-model-owned `Task`** — loading is
driven by the view's `.task` so SwiftUI owns the lifetime (cancel on disappear).

## Decision

We will implement infinite scroll with:

- **Concrete per-entity paged wrapper types, not a generic `Page<T>`:**
  `MoviePreviewPage` (domain), `MoviePreviewDetailsPage` (application), and a
  feature-local `MoviePreviewPage` with `hasMore = page < totalPages`. The movies
  path only; the trending tvSeries/people paths keep their bare-array signatures
  until they actually need paging.
- **The adapter keeps the whole TMDb pageable response** and clamps
  `totalPages` to `min(_, 1000)` (TMDb's documented `page` precondition), so a
  caller can never be driven to request out of range. The TMDb-specific constant
  stays in the adapter.
- **Sibling view-model state, not a new `ViewState` case:** the view model keeps
  `currentPage` / `hasMore` / `isLoadingMore` alongside the existing `ViewState`.
  `.ready(snapshot)` stays the single source of grid content. We do **not** add a
  `.loadingMore` case to the shared `ViewState`.
- **A per-cell `.task` trigger with an index threshold, not a sentinel view:**
  each grid cell runs `.task { await viewModel.loadMoreIfNeeded(at: offset) }`
  inside the `LazyVGrid`. `loadMore()` guards on `.ready && hasMore &&
  !isLoadingMore`, setting `isLoadingMore` before the first `await` so sibling
  cells' concurrent calls bail (the `@MainActor` serialisation plus the flag also
  cover actor reentrancy across the `await`).
- **De-duplicate appended movies by id, and skip a fully-duplicate page:** TMDb's
  trending feed shifts between page requests, so pages overlap; duplicate ids would
  break `ForEach(id:)` identity and the `matchedTransitionSource` zoom sources. A
  page that dedupes to zero new movies is skipped, bounded by
  `maxLoadMoreAttempts`.
- **Load-more failure/cancellation is non-fatal:** keep the loaded grid, reset
  `isLoadingMore` via `defer`, and leave pagination unchanged so a later near-end
  cell retries. No error UI for load-more.

## Consequences

- The shape is **reusable** for future paginated lists (Watchlist, trending TV
  series/people, search): copy the paged-type + sibling-state + per-cell-trigger
  structure.
- The shared `ViewState` is untouched, so there is **no ripple** across the ~20
  features that switch on it.
- More view-model state to test — append, dedupe (cross-page and within-page),
  the no-op guards, the `loadMoreIfNeeded` threshold boundary, non-fatal failure,
  cancellation, pagination reset on reload, and the `maxLoadMoreAttempts`
  exhaustion branch — covered by dedicated view-model test suites. The load-more
  spinner sits below the fold, so it is covered by view-model tests, **not**
  snapshots (see [ADR-0002](0002-progressive-details-rendering.md) and
  `knowledge/gotchas.md`).
- Each context that paginates adds its own small page type; promote to a generic
  wrapper only if that duplication becomes painful.

## Alternatives considered

- **Generic `Page<Item>` wrapper** — rejected: no generic wrapper exists in the
  codebase (the convention is concrete per-entity models), and this change is
  movies-only. Promote later if several contexts paginate.
- **Add a `.loadingMore(Content)` case to the shared `ViewState`** — rejected: it
  breaks the `content` / `isReady` accessors, the `applyLoadFailure` semantics, and
  every exhaustive `switch` across ~20 features. A sibling `isLoadingMore` is
  strictly additive.
- **A bottom sentinel view as the trigger** — rejected: content placed after a
  `LazyVGrid` inside a `ScrollView` is instantiated eagerly, firing an immediate
  page-2 fetch on first render. A per-cell `.task` near the end is lazy and tied to
  the cell's lifetime, and it honours the no-view-model-owned-`Task` rule
  ([ADR-0001](0001-feature-packages-are-leaves.md) keeps the feature a leaf).
- **Stop paging on an empty page instead of `totalPages`** — rejected: it wastes a
  request at the true end and relies on TMDb's past-the-end behaviour; surfacing
  `totalPages` gives a real end-of-list signal.
