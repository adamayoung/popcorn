# PRD: TV Season Details

## Overview

Add a TV Season Details screen that displays when a user taps on a season in the TV Series Details screen. The screen shows a header with the season's poster and overview, followed by a list of episodes. Each episode row shows a still image, episode number, title, and description. Replaces the existing `TVSeasonDetailsPlaceholder` with a fully functional season details screen.

## Problem

The TV Series Seasons carousel (PR #28) allows users to see seasons but navigates to a placeholder view. Users cannot browse individual episodes within a season or see season details, which is a fundamental expectation when exploring TV series content.

## Goals

1. Display a season details screen with header (poster + overview) and episode list
2. Show episode still images, numbers, titles, and descriptions
3. Enable navigation from episodes to a placeholder episode detail view
4. Cache season and episode data with SwiftData for offline access and performance
5. Migrate the entire TVSeries context to SwiftData for consistent storage

## Non-Goals

- Full Episode Details screen (placeholder only — future feature)
- Episode crew/guest star information
- Episode ratings or vote counts
- Video playback
- Feature flag gating

---

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| Feature name: TVSeasonDetailsFeature | This is a season detail screen (header + episodes), not just an episode list |
| Extend `PopcornTVSeries` context | Episodes belong to TV series; a new context would be over-separation |
| Migrate entire context to SwiftData | Consistent storage strategy; user preference over mixed in-memory + SwiftData |
| `TVSeasonService` from TMDb SDK | Season details endpoint returns overview + episodes in one call |
| Repository name: `TVEpisodeRepository` | Repository names match the model they return (episodes), not the parent entity |
| Remote data source returns overview + episodes | TMDb season details endpoint returns both; avoids two API calls |
| Season name + posterPath from navigation state | Already known from parent screen; avoids refetching |
| Season overview from API | Not available in parent's `TVSeries.seasons` summary; fetched with episodes |
| Still widths: 92/185/300/max | Match TMDb still sizes: w92, w185, w300, original |
| StillImage: 16:9 aspect ratio | Episode frames are widescreen |
| Default `stillURLHandler` param | Backwards compatible — avoids breaking 6+ existing callers |
| Episode row: "1. Pilot" format | Number + title is standard UX for episode lists |

## Data Flow

```
TMDb API (tv_season_details)
  ↓
TVSeasonService.details(forSeason:inTVSeries:language:)
  ↓
TMDbTVEpisodeRemoteDataSource (Adapters) → TVEpisodeMapper
  ↓
(overview: String?, episodes: [TVEpisode]) (Domain)
  ↓
DefaultTVEpisodeRepository (Infrastructure)
  ├── SwiftDataTVEpisodeLocalDataSource (SwiftData, 24h TTL)
  └── TVEpisodeRemoteDataSource
  ↓
DefaultFetchTVSeasonDetailsUseCase (Application)
  └── TVEpisodeSummaryMapper (resolves stillPath → stillURLSet)
  ↓
TVSeasonDetailsSummary (Application)
  ├── overview: String?
  └── episodes: [TVEpisodeSummary]
  ↓
TVSeasonDetailsClient (Feature) → TVEpisodeRowMapper (picks .card URL)
  ↓
TVSeasonDetailsFeature → TVSeasonDetailsView
  ├── Header: PosterImage + overview
  └── List of TVEpisodeRowView
```

---

## User Stories

### US-1: Still Image URL Resolution — `S` ✅

> As a **developer**, I want still image URL support in `ImagesConfiguration` so that episode still images can be resolved from relative paths to full URLs like other image types.

**Status**: Complete

---

### US-2: StillImage DesignSystem Component — `S` ✅

> As a **developer**, I want a `StillImage` view component in the DesignSystem module so that episode still frames can be displayed with consistent styling across the app.

**Status**: Complete

---

### US-3: Episode Domain Model — `S` ✅

> As a **developer**, I want a `TVEpisode` domain entity and `TVEpisodeRepository` protocol so that episode data is properly modeled in the domain layer with clean contracts.

**Status**: Complete (repository named `TVEpisodeRepository` per naming convention)

---

### US-4: TVSeries Context SwiftData Migration — `L` ✅

> As a **developer**, I want the TV Series context migrated from in-memory caching to SwiftData so that TV series, image, and episode data is persisted consistently across app restarts.

**Status**: Complete (54 tests passing)

---

### US-5: Episode SwiftData Persistence — `M`

> As a **developer**, I want SwiftData persistence for episode data so that fetched episodes and season overview are cached locally and survive app restarts.

**Acceptance Criteria**:
- [ ] `TVSeasonEpisodesEntity` with composite key `"{tvSeriesID}-{seasonNumber}"`, overview, and cascade to episodes
- [ ] `TVEpisodeEntity` with unique id, all episode properties
- [ ] `SwiftDataTVEpisodeLocalDataSource` `@ModelActor` with 24h TTL
- [ ] `DefaultTVEpisodeRepository` with cache-first + remote fallback pattern
- [ ] `TVEpisodeRemoteDataSource` and `TVEpisodeLocalDataSource` protocols defined
- [ ] Remote data source returns overview + episodes together
- [ ] Local data source caches overview + episodes together
- [ ] Entities registered in shared `ModelContainer` (from US-4)
- [ ] Observability spans on all data source and repository operations

**Tech Elab**:
- `TVSeasonEpisodesEntity`: `@Attribute(.unique) var compositeKey: String`, `var overview: String?`, `@Relationship(deleteRule: .cascade) var episodes: [TVEpisodeEntity]`, `var cachedAt: Date`
- `TVEpisodeEntity`: `@Attribute(.unique) var id: Int`, name, episodeNumber, seasonNumber, overview?, stillPath?
- `TVEpisodeRemoteDataSource` protocol: `func seasonDetails(forSeason:inTVSeries:) async throws(TVEpisodeRemoteDataSourceError) -> (overview: String?, episodes: [TVEpisode])`
- `TVEpisodeLocalDataSource` protocol: get + set methods returning overview + episodes, actor-isolated
- `SwiftDataTVEpisodeLocalDataSource`: `FetchDescriptor` with `#Predicate { $0.compositeKey == key }`, fetchLimit 1
- `DefaultTVEpisodeRepository`: try local → on miss fetch remote → persist → return
- Add entities to Schema in `TVSeriesInfrastructureFactory`
- Files in `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/`

**Test Elab**:
- Entity mapper tests (3-method pattern) for SeasonEpisodes and Episode entities
- `SwiftDataTVEpisodeLocalDataSource`: miss, hit, expired, persist+retrieve
- `DefaultTVEpisodeRepository`: cached return, remote fallback on miss, error propagation (notFound, unauthorised, unknown)
- Edge case: updating episodes for same season replaces old ones (cascade delete)
- Edge case: empty episodes array from remote
- Edge case: compositeKey uniqueness across different series
- Edge case: nil overview cached and returned correctly

**Dependencies**: US-3, US-4

---

### US-6: Season Details Application Use Case — `M`

> As a **developer**, I want a `FetchTVSeasonDetailsUseCase` so that season overview and episode data can be fetched with resolved still image URLs in a single call.

**Acceptance Criteria**:
- [ ] `TVSeasonDetailsSummary` application model with `overview: String?` and `episodes: [TVEpisodeSummary]`
- [ ] `TVEpisodeSummary` application model with `stillURLSet: ImageURLSet?`
- [ ] `TVEpisodeSummaryMapper` resolves still paths via `ImagesConfiguration.stillURLSet(for:)`
- [ ] `FetchTVSeasonDetailsUseCase` protocol with `execute(tvSeriesID:seasonNumber:)` method
- [ ] `DefaultFetchTVSeasonDetailsUseCase` fetches from repository + config, maps results
- [ ] `TVSeriesApplicationFactory` updated with new use case factory method
- [ ] Observability spans on use case execution

**Tech Elab**:
- `TVSeasonDetailsSummary`: overview?, episodes: [TVEpisodeSummary]
- `TVEpisodeSummary`: id, name, episodeNumber, seasonNumber, overview?, airDate?, runtime?, stillURLSet?
- `TVEpisodeSummaryMapper.map(_:imagesConfiguration:)` — calls `imagesConfiguration.stillURLSet(for: episode.stillPath)`
- `DefaultFetchTVSeasonDetailsUseCase`: fetch episodes+overview from repo, fetch appConfiguration, map with imagesConfiguration
- `FetchTVSeasonDetailsError`: notFound, unauthorised, unknown — mapped from repo + config errors
- Update `TVSeriesApplicationFactory` init to accept `tvEpisodeRepository`, add `makeFetchTVSeasonDetailsUseCase()`
- Files in `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/`

**Test Elab**:
- `TVEpisodeSummaryMapper`: maps with still URL, maps with nil still path, maps all optional fields
- `DefaultFetchTVSeasonDetailsUseCase`: success path returns overview + episodes, notFound error, unauthorised error, config error
- Edge case: empty episodes list from repository
- Edge case: nil overview from repository
- Edge case: still path present but ImagesConfiguration returns nil URL

**Dependencies**: US-1, US-3, US-5

---

### US-7: TMDb Episode Adapter — `M`

> As a **developer**, I want TMDb adapter integration for season details so that episode data and season overview are fetched from the TMDb API and mapped to domain models.

**Acceptance Criteria**:
- [ ] `TVEpisodeMapper` maps `TMDb.TVEpisode` → `TVSeriesDomain.TVEpisode`
- [ ] `TMDbTVEpisodeRemoteDataSource` calls `TVSeasonService.details(forSeason:inTVSeries:language:"en")` and extracts overview + episodes
- [ ] `PopcornTVSeriesAdaptersFactory` accepts `tvSeasonService` and creates remote data source
- [ ] Nil episodes array from TMDb maps to empty array
- [ ] TMDb errors mapped to `TVEpisodeRemoteDataSourceError` (notFound, unauthorised, unknown)
- [ ] Observability spans on TMDb API calls and mapping

**Tech Elab**:
- `TVEpisodeMapper`: direct property mapping from `TMDb.TVEpisode` to domain `TVEpisode`
- `TMDbTVEpisodeRemoteDataSource`: calls `tvSeasonService.details(forSeason:seasonNumber, inTVSeries:tvSeriesID, language:"en")`, returns `(overview: response.overview, episodes: mapper.map(response.episodes ?? []))`
- Update `PopcornTVSeriesAdaptersFactory` init to accept `tvSeasonService: some TVSeasonService`
- Update `LivePopcornTVSeriesFactory` init to accept `tvEpisodeRemoteDataSource`
- Factory init chain (5 files must be updated atomically):
  1. `PopcornTVSeriesAdaptersFactory` → accepts tvSeasonService
  2. `LivePopcornTVSeriesFactory` → accepts tvEpisodeRemoteDataSource
  3. `TVSeriesInfrastructureFactory` → accepts tvEpisodeRemoteDataSource
  4. `TVSeriesApplicationFactory` → accepts tvEpisodeRepository
  5. `TVSeriesApplicationFactory+TCA.swift` → passes tvSeasonService
- Create `MockTVSeasonService` test helper

**Test Elab**:
- `TVEpisodeMapper`: maps all fields, handles nil optional fields, preserves exact values
- `TMDbTVEpisodeRemoteDataSource`: returns overview + mapped episodes, handles notFound, unauthorised, unknown errors, handles nil episodes, handles nil overview
- Edge case: TMDb returns episode with empty name
- Edge case: TMDb returns episode with nil stillPath

**Dependencies**: US-5, US-6

---

### US-8: TCA Dependency Wiring — `S`

> As a **developer**, I want TCA dependency keys for the TV season service and season details use case so that the TVSeasonDetailsFeature can access data through dependency injection.

**Acceptance Criteria**:
- [ ] `tvSeasonService` registered as `DependencyKey` from `tmdb.tvSeasons`
- [ ] `fetchTVSeasonDetails` registered as `DependencyKey` from `tvSeriesFactory`
- [ ] `TVSeriesApplicationFactory+TCA.swift` passes `tvSeasonService` to adapter factory
- [ ] `PopcornTVSeriesFactory` protocol includes `makeFetchTVSeasonDetailsUseCase()`

**Tech Elab**:
- Create `AppDependencies/Sources/AppDependencies/TMDb/TMDbTVSeasonService+TCA.swift` — follow `TMDbTVSeriesService+TCA.swift` pattern, `tmdb.tvSeasons`
- Create `AppDependencies/Sources/AppDependencies/TVSeries/FetchTVSeasonDetailsUseCase+TCA.swift` — follow existing use case key pattern
- Update `TVSeriesApplicationFactory+TCA.swift`: add `@Dependency(\.tvSeasonService)`, pass to factory
- Update `PopcornTVSeriesFactory` protocol + `LivePopcornTVSeriesFactory` (from US-7)

**Test Elab**:
- Verify dependency resolves without crash in test environment
- Verify `testValue` / `previewValue` are available (TCA requirement)
- Integration: dependency chain resolves from `fetchTVSeasonDetails` → factory → adapter → service

**Dependencies**: US-7

---

### US-9: TV Season Details Screen — `L`

> As a **user**, I want to see a season details screen with a header and list of episodes when I tap on a season so that I can learn about the season and browse its episodes.

**Acceptance Criteria**:
- [ ] Tapping a season in TVSeriesDetailsContentView navigates to the season details screen
- [ ] Screen title shows the season name (e.g., "Season 1")
- [ ] Header shows the season poster and overview text
- [ ] Episodes displayed in a `List` ordered by episode number below the header
- [ ] Each row shows: still image (16:9), "N. Title" (headline), and overview (secondary)
- [ ] Loading spinner shown while fetching
- [ ] Error state with retry button on failure
- [ ] Tapping an episode row navigates to a placeholder view
- [ ] Navigation works from both Explore and Search flows
- [ ] Accessibility identifiers on list and each row

**Screen Layout**:
```
┌─────────────────────────────────────────────────────────┐
│  ┌──────────┐                                           │
│  │          │  Season overview text describing the      │
│  │  Season  │  season's plot and themes. This can       │
│  │  Poster  │  span multiple lines and wraps            │
│  │          │  naturally with the available space.      │
│  └──────────┘                                           │
├─────────────────────────────────────────────────────────┤
│ ┌───────────────────┐                                   │
│ │   Still Image     │  1. Pilot                         │
│ │     (16:9)        │  When an old partner threatens... │
│ └───────────────────┘                                   │
├─────────────────────────────────────────────────────────┤
│ ┌───────────────────┐                                   │
│ │   Still Image     │  2. Blue Cat                      │
│ │     (16:9)        │  Marty's plan hits a snag...      │
│ └───────────────────┘                                   │
└─────────────────────────────────────────────────────────┘

Header: HStack(alignment: .top, spacing: 16)
├── PosterImage: posterPath from navigation state, ~120pt height
└── Text(overview) — .secondary, .subheadline

Episode Row: HStack(alignment: .top, spacing: 12)
├── StillImage: ~107pt wide × 60pt tall (16:9), clipped
└── VStack(alignment: .leading, spacing: 4)
    ├── "N. Name" — .headline
    └── overview — .subheadline, .secondary, lineLimit(3)
```

**Tech Elab**:
- New `Features/TVSeasonDetailsFeature/` package with: Package.swift, reducer, client, models, mappers, views
- `TVSeasonDetailsFeature` reducer: State(tvSeriesID, seasonNumber, seasonName, posterURL?, viewState), fetch/loaded/loadFailed/navigate actions
- `TVSeasonDetailsClient`: `@DependencyClient`, calls `fetchTVSeasonDetails` use case + mappers
- `TVSeasonDetailsSnapshot`: overview?, episodes: [TVEpisodeRow]
- `TVEpisodeRow` model: id, name, episodeNumber, overview?, stillURL? (picks `.card` from URLSet)
- Views: `TVSeasonDetailsView` (store-connected, .task fetch, navigationTitle), `TVSeasonDetailsContentView` (header + List + ForEach + callback), `TVSeasonDetailsHeaderView` (PosterImage + overview), `TVEpisodeRowView` (HStack: StillImage + VStack)
- StillImage height ~60pt in row (yields ~107pt width at 16:9)
- Navigation: `.navigate(.episodeDetails(tvSeriesID:seasonNumber:episodeNumber:))` — passthrough to coordinator
- Update `TVSeriesDetailsFeature.Navigation.seasonDetails` to add `seasonName: String` and `posterPath: URL?`
- Update `TVSeriesDetailsView`: look up season name + posterPath from `tvSeries.seasons` array
- Replace `TVSeasonDetailsPlaceholder` with `TVSeasonDetailsFeature` in ExploreRootFeature + SearchRootFeature
- Add `TVEpisodeDetailsPlaceholder` reducer for episode tap navigation
- Add Xcode project reference for new package

**Broken files from navigation parameter addition** (must update):
- `TVSeriesDetailsFeatureTests.swift`
- `ExploreRootFeatureTests.swift`
- `SearchRootFeatureTests.swift`

**Test Elab**:
- `TVEpisodeRowMapper`: maps summary with card URL, maps with nil still
- `TVSeasonDetailsFeature`: fetch sends loaded with overview + episodes, fetch sends loadFailed, navigate returns none
- Coordinator tests: season navigation creates TVSeasonDetailsFeature.State, episode navigation creates placeholder
- Edge case: season with 0 episodes (empty list)
- Edge case: nil overview (header hides overview text)
- Edge case: episode with nil overview (row shows title only)
- Edge case: episode with nil stillPath (placeholder image)

**Dependencies**: US-1, US-2, US-8

---

## Story Dependency Graph

```
US-1 (Still URLs) ✅ ───────────────────────────────────┐
US-2 (StillImage) ✅ ───────────────────────────────────┤
US-3 (Domain Model) ✅ ─ US-5 (Episode Persistence) ───┤
US-4 (SwiftData) ✅ ──── US-5 ─── US-6 (Use Case) ── US-7 (Adapter) ── US-8 (Wiring) ── US-9 (Feature)
```

**Next up**: US-5 (all dependencies met)

**Remaining merge points**:
- US-6 requires US-1 + US-5
- US-7 requires US-5 + US-6
- US-8 requires US-7
- US-9 requires US-1 + US-2 + US-8

## Verification

1. `/format` — no violations
2. `/lint` — no violations
3. `/build` — build succeeds (warnings are errors)
4. `/test` — all tests pass
5. Manual: Navigate to a TV series → tap a season → verify header with poster + overview
6. Manual: Verify episode list loads with still images below header
7. Manual: Tap an episode → verify placeholder view appears
8. Code review via `code-reviewer` agent with adversarial re-evaluation
