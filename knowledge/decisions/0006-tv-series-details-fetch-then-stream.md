# ADR-0006: TV series details uses fetch-then-stream, like movies

- **Status:** Accepted
- **Date:** 2026-07-23
- **Deciders:** Adam Young

## Context

[ADR-0002](0002-progressive-details-rendering.md) established progressive detail
rendering and, for TV series specifically, had `FetchTVSeriesDetails` extract the
poster **theme colour** inline (overlapped with the image-collection await) —
*because TV series had no live stream to deliver it later*. The movie details screen
works differently: `FetchMovieDetails` paints instantly with **no** tint, then
`StreamMovieDetails` (backed by a SwiftData observation stream plus a fire-and-forget
background remote refresh) re-emits the movie enriched with its tint shortly after.

Two facts made the TV asymmetry worth removing:

- The streaming primitive (`SwiftDataFetchStreaming`) was already available on the TV
  side, and `themeColorProvider` already flowed into `PopcornTVSeriesFactory` — so a TV
  stream was buildable without new plumbing in the composition root.
- `DefaultTVSeriesRepository` was a pure read-through cache: on a cache hit it returned
  possibly-stale data and **never refreshed in-session**, unlike movies (whose stream's
  background task refreshes the cache after first paint).

TV series has **no watchlist**, so — unlike movies — a stream is not justified by live
watchlist updates; its value here is the theme colour after first paint plus the
in-session background refresh, with structural parity as a bonus.

## Decision

We will give TV series details the movie **fetch-then-stream** pattern:

- Add `tvSeriesStream(withID:)` end-to-end: `TVSeriesRepository` (domain) →
  `SwiftDataTVSeriesLocalDataSource` (conforms to `SwiftDataFetchStreaming`) →
  `DefaultTVSeriesRepository` (returns the local observation stream and fires a
  background remote refresh whose cache write triggers a re-emit) →
  `StreamTVSeriesDetailsUseCase`.
- **`FetchTVSeriesDetails` no longer extracts the theme colour** — it maps with
  `themeColor: nil`, keeping the fetch off the poster-thumbnail-download critical path.
  The stream delivers the tint after the hero has rendered.
- Establish the rule: **extract the theme colour in the fetch only when there is no
  stream to deliver it later.** Movies (fetch, no tint) and now TV series follow the
  stream path; a streamless consumer of a details fetch that needs the tint would
  extract it in the fetch instead.

This supersedes the TV-specific clause of ADR-0002 (that ADR otherwise stands).

## Consequences

- Time-to-first-render for the TV hero is bounded by the primary fetch alone; the tint
  fades in a beat later, matching the movie screen.
- TV series data is now refreshed in-session (the stream's background task), where the
  pure read-through fetch never was.
- The screen is watchlist-ready: adding a TV watchlist later means the same stream can
  carry live `isOnWatchlist` updates, exactly as movies do.
- On a **cold cache**, the tint only appears once the background refresh writes the
  poster path and the stream re-ticks; and a cold-cache visit makes up to **two** TMDb
  detail calls (the cache-first fetch, then the stream's unconditional refresh). Both are
  intended and match movies.
- More moving parts: a stream use case, local-DS observation conformance, and a Live
  remap closure now exist per the movie shape.
- The new TV stream use case **fixes a latent defect** carried by the movie sibling — see
  the gotcha in [`knowledge/gotchas.md`](../gotchas.md) on the per-tick `Task` that
  silently hangs the stream.

## Alternatives considered

- **Keep the theme colour on the `FetchTVSeriesDetails` critical path (status quo of
  ADR-0002)** — rejected: it keeps a poster-thumbnail download + CoreImage pass on the
  cold-cache hot path, and gives no in-session refresh. Once a stream exists, extracting
  the tint in the fetch is redundant work on the hot path.
- **A lighter view-model-only enrichment** (fetch returns `nil` tint, the view model runs
  a second task to compute just the colour and patch the view) — rejected: no structural
  parity with movies, no background refresh, and not watchlist-ready; the saving over the
  full stream is small because `SwiftDataFetchStreaming` yields its first snapshot
  synchronously anyway.
