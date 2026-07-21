# ADR-0002: Render detail screens progressively, with per-section view state

- **Status:** Accepted
- **Date:** 2026-07-21
- **Deciders:** Adam Young

## Context

The movie and TV series details screens gated their first pixel on **every** piece
of content loading. `MovieDetailsViewModel.fetch()` awaited the movie, the recommended
movies, and the credits together (via `async let`) and only then set
`viewState = .ready`; `TVSeriesDetailsViewModel` fetched the series then the credits
serially before rendering. The recommended-movies path is expensive on a cold cache
(a page fetch, then a per-movie image-collection fan-out, then a poster-thumbnail
download + CoreImage pass per movie for theme colours), so the whole screen waited
seconds on work that only fills two below-the-fold carousels. A failure in any one of
those fetches put the **entire** screen into `.error`.

The detail views are built on `StretchyHeaderScrollView`: the hero (backdrop, logo,
title, overview) is above the fold; the recommended and cast-and-crew carousels are
below it.

## Decision

We will render the detail screens **progressively**:

- `viewState` carries only the **primary** model (`ViewState<Movie>` /
  `ViewState<TVSeries>`) and becomes `.ready` as soon as that model loads. The
  `ViewSnapshot` aggregate structs are removed.
- Each below-the-fold carousel gets its **own** `ViewState` property on the view model
  (`recommendedMoviesState`, `castAndCrewState`), loaded **after** the primary is ready,
  concurrently, under the view's `.task` (structured `async let`, so cancellation
  propagates).
- A section loader: resets to `.initial` when its feature flag is off; skips when
  already `.ready`/`.loading` (keeps seeded snapshot/test states stable and cancellation
  re-entrant); otherwise `.loading` → `.ready(value)` / `applyLoadFailure`. A section
  failure degrades that section to a hidden carousel — it **never** fails the screen.
- Expensive enrichment is kept **off the first-render critical path**: `FetchMovieDetails`
  no longer extracts a theme colour at all (the movie-details live stream re-emits with
  the tint shortly after render, so the hero just fades the background in); the movie
  recommendations use case trims to the display count **before** its image/theme-colour
  fan-out and runs the colour extraction concurrently; `FetchTVSeriesDetails` (which has
  no stream) overlaps its theme-colour extraction with the image-collection await.

## Consequences

- Time-to-first-render is bounded by the primary fetch alone; carousels stream in behind
  a `CarouselPlaceholder` and a slow or failed carousel no longer blocks or breaks the
  screen. This realises the "auxiliary failures must never break the primary operation"
  principle at the screen level.
- Section state now lives **outside** `viewState`, so the movie stream patch simply
  replaces the movie (`applyMovieUpdate` = `viewState = .ready(movie)`) and can no longer
  clobber a freshly-loaded section — the old snapshot had to copy sections forward.
- More moving parts per screen: each section needs its own load/guard/flag/cancellation
  handling and view-model tests for success, degraded failure, flag-off, and re-entry.
- TV credits failure changed from "silently empty forever" to a hidden-but-retryable
  section (retries on the next `.task` run), a small behavioural upgrade.
- Loading/placeholder states are **not** snapshot-tested — on a `StretchyHeaderScrollView`
  screen they sit below the fold and render identically to the ready snapshot (see
  `knowledge/gotchas.md`); they are covered by view-model tests instead.

## Alternatives considered

- **Keep the single aggregate `ViewState` but load sections lazily into it** — rejected:
  mutating one shared snapshot from several concurrent loaders (and the stream) reintroduces
  the clobbering problem and needs careful copy-forward on every partial update. Separate
  per-section states make the concurrency trivially correct.
- **Keep theme colour on the `FetchMovieDetails` critical path but parallelise it** — still
  appends a thumbnail download + CoreImage pass before first render. Since the stream already
  re-derives and delivers the tint, extracting it in the fetch was redundant work on the
  hot path; removing it is strictly faster with no loss.
