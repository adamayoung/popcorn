# PRD: TV Episode Details

**Implementation Plan**: `.claude/plans/plan.md`

## Overview

Add a TV Episode Details screen that displays when a user taps an episode in the TV Season Details screen. The screen shows a full-width still image header, episode name, overview, and air date. Replaces the existing `TVEpisodeDetailsPlaceholder` with a fully functional episode details screen.

## Problem

The TV Season Details screen (PR #31) allows users to browse episodes within a season, but tapping an episode navigates to a placeholder view that shows only "EPISODE N". Users cannot see episode details like the still image, description, or air date, which is a fundamental expectation when exploring TV series content.

## Goals

1. Display an episode details screen with a full-width still image header (gray placeholder shown when still image is unavailable)
2. Show the episode name and overview text below the header (overview section hidden when nil or empty)
3. Show the formatted air date (hidden when unavailable)
4. Show loading and error states with retry capability
5. Fetch episode data independently via the dedicated TMDb episode endpoint
6. Cache episode data locally using SwiftData with TTL-based expiry
7. Replace the `TVEpisodeDetailsPlaceholder` in both Explore and Search navigation flows
8. Provide VoiceOver accessibility for all content sections (decorative header hidden, episode metadata accessible)

## Non-Goals

- Episode crew/guest star display (data available from endpoint but deferred)
- Episode ratings or vote counts
- Video playback or trailer links
- Feature flag gating
- Episode-to-episode navigation (next/previous)
- Episode runtime display (data available in domain model but deferred)

---

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| Dedicated TMDb episode endpoint | Returns more data than the season endpoint (crew, guest stars); makes the feature independent of season details fetch; enables future expansion |
| Extend `PopcornTVSeries` context | Episodes belong to the TV series domain; a new context would be over-separation |
| SwiftData caching with 24h TTL | Cache-first + remote fallback follows existing repository pattern (`DefaultTVSeasonRepository`); reduces API calls on repeat visits |
| Separate `TVEpisodeDetailsCacheEntity` | Existing `TVEpisodeEntity` is a child of `TVSeasonEpisodesEntity` via `@Relationship(deleteRule: .cascade)` — season cache expiry would cascade-delete independently cached episodes. A standalone entity with composite key `"tvSeriesID-seasonNumber-episodeNumber"` and `cachedAt` avoids this conflict. Added to the existing `TVSeriesInfrastructureFactory` `ModelContainer` schema (additive change — SwiftData lightweight migration handles this automatically) |
| `StillImage` for full-width header | Reuses existing DesignSystem component; stills are 16:9 like backdrops. Full-width rendering: apply `.aspectRatio(16.0/9.0, contentMode: .fit)` on `StillImage` — inside a `ScrollView`/`VStack` the parent constrains width, `.aspectRatio` computes height, and the inner `GeometryReader` adopts the resulting frame. No outer `GeometryReader` needed. This is untested in the codebase — validate early on device |
| Reuse `TVEpisodeSummary` application model | Already has all fields needed (name, overview, airDate, stillURLSet); no new application model required |
| Reuse existing `TVEpisodeMapper` adapter mapper | Already maps `TMDb.TVEpisode` → `TVSeriesDomain.TVEpisode`; episode endpoint returns the same type |
| Navigation title = episode name | Follows existing pattern (TVSeriesDetails uses series name, TVSeasonDetails uses season name). During loading, the title is empty (episode name only known after fetch). Set via `.navigationTitle` bound to state |
| `TVEpisodeRepository` domain protocol | New repository for fetching individual episodes; keeps domain contracts clean and independent |
| Episode number displayed as subtitle | "Episode N" shown below the header, above the episode name — provides context without cluttering the title |
| Feature mapper picks `.full` from `ImageURLSet` | Full-width header needs highest resolution; `.full` maps to `original` (~1920px for stills). Follows the same pattern as `BackdropImage` detail headers. The new feature-layer `TVEpisodeMapper` in `TVEpisodeDetailsFeature` picks `.full` — distinct from the existing mapper in `TVSeasonDetailsFeature` which picks `.card` |
| Simple `ScrollView` for content | Episode details has limited content (header + subtitle + title + date + overview); no stretchy header or list needed. Simple `ScrollView` with `VStack` is sufficient |
| Factory chain wiring is atomic in US-4 | Adding `tvEpisodeService` requires coordinated changes across `PopcornTVSeriesAdaptersFactory`, `LivePopcornTVSeriesFactory`, `TVSeriesInfrastructureFactory`, `TVSeriesApplicationFactory+TCA` — all in one story to prevent compilation breaks |
| Co-locate error enums with protocols | Follows existing pattern in `TVSeasonRepository.swift` and `TVSeasonRemoteDataSource.swift` — error enum defined in the same file as its protocol |

## Data Flow

### Success Path (Cache Miss)

```
TMDb API (tv_episode_details)
  ↓
TVEpisodeService.details(forEpisode:inSeason:inTVSeries:language:)
  ↓
TMDbTVEpisodeRemoteDataSource (Adapters) → TVEpisodeMapper (reused)
  ↓
TVEpisode (Domain)
  ↓
DefaultTVEpisodeRepository (Infrastructure)
  ├── 1. Check local cache → MISS (nil or expired)
  ├── 2. Fetch from remote → TVEpisode
  └── 3. Cache result (try? await, errors suppressed) → SwiftDataTVEpisodeLocalDataSource
  ↓
DefaultFetchTVEpisodeDetailsUseCase (Application)
  └── TVEpisodeSummaryMapper (reused, resolves stillPath → stillURLSet)
  ↓
TVEpisodeSummary (Application)
  ↓
TVEpisodeDetailsClient (Feature) → TVEpisodeMapper (picks .full still URL)
  ↓
TVEpisodeDetailsFeature → TVEpisodeDetailsView
  ├── Header: StillImage (full-width via .aspectRatio, 16:9)
  ├── Episode N (subtitle)
  ├── Episode Name (title)
  ├── Air Date (formatted, hidden if nil)
  └── Overview (body text, hidden if nil or empty)
```

### Success Path (Cache Hit)

```
DefaultTVEpisodeRepository
  ├── 1. Check local cache → HIT (within 24h TTL)
  └── Return cached TVEpisode (remote NOT called)
  ↓
DefaultFetchTVEpisodeDetailsUseCase → TVEpisodeSummary → Feature
```

### Error Path

```
TMDb API error (TMDbError)
  ↓ TMDbTVEpisodeRemoteDataSource maps to:
TVEpisodeRemoteDataSourceError (.notFound | .unauthorised | .unknown)
  ↓ DefaultTVEpisodeRepository maps to:
TVEpisodeRepositoryError (.notFound | .unauthorised | .unknown)
  ↓ DefaultFetchTVEpisodeDetailsUseCase maps to:
FetchTVEpisodeDetailsError (.notFound | .unauthorised | .unknown)
  ↓ TVEpisodeDetailsClient throws generic Error
  ↓ TVEpisodeDetailsFeature wraps via:
ViewStateError(error) → .error(ViewStateError) state
  ↓
TVEpisodeDetailsView shows ContentUnavailableView with retry
```

---

## User Stories

### US-1: TVEpisodeRepository Domain Protocol — `S`

> As a **developer**, I want a `TVEpisodeRepository` protocol in the domain layer so that episode data can be fetched independently with clean contracts.

**Acceptance Criteria**:
- [ ] `TVEpisodeRepository` protocol with `episode(_:inSeason:inTVSeries:)` method
- [ ] `TVEpisodeRepositoryError` enum co-located in the same file with `notFound`, `unauthorised`, `unknown(Error?)` cases
- [ ] Protocol and error type are `public` and `Sendable`
- [ ] Uses typed throws: `async throws(TVEpisodeRepositoryError)`

**Tech Elab**:
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesDomain/Repositories/TVEpisodeRepository.swift`
  - Follow `TVSeasonRepository.swift` pattern exactly (protocol + error enum in same file)
  - Method: `func episode(_ episodeNumber: Int, inSeason seasonNumber: Int, inTVSeries tvSeriesID: Int) async throws(TVEpisodeRepositoryError) -> TVEpisode`
  - Error enum: `TVEpisodeRepositoryError` with `.notFound`, `.unauthorised`, `.unknown(Error? = nil)`

**Test Elab**:
- Domain protocols have no implementation to test; verification is compile-time (protocol compiles, error cases exist)
- Edge case: verify `TVEpisodeRepositoryError` conforms to `Error`
- Edge case: verify `TVEpisodeRepository` has `Sendable` conformance

**Dependencies**: none

---

### US-2: Episode Local Cache Infrastructure — `M`

> As a **developer**, I want a SwiftData-backed local data source for episode details so that episode data is cached locally with TTL-based expiry.

**Acceptance Criteria**:
- [ ] `TVEpisodeLocalDataSource` protocol with `episode(_:inSeason:inTVSeries:)` and `setEpisode(_:inSeason:inTVSeries:)` methods
- [ ] `TVEpisodeLocalDataSourceError` enum co-located with `persistence(Error)`, `unknown(Error?)` cases
- [ ] `TVEpisodeDetailsCacheEntity` SwiftData model with composite key, all episode fields, and `cachedAt`
- [ ] `TVEpisodeDetailsCacheEntity` conforms to `ModelExpirable` for TTL checking
- [ ] `TVEpisodeDetailsCacheEntityMapper` maps entity ↔ domain `TVEpisode`
- [ ] `SwiftDataTVEpisodeLocalDataSource` uses `@ModelActor`, 24h TTL, deletes expired entries
- [ ] `TVSeriesInfrastructureFactory` schema updated to include `TVEpisodeDetailsCacheEntity`
- [ ] Static `tvEpisodeLocalDataSource` property added to factory

**Tech Elab**:
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Protocols/Local/TVEpisodeLocalDataSource.swift`
  - Follow `TVSeasonLocalDataSource.swift` pattern (protocol + error enum in same file)
  - `episode(_:inSeason:inTVSeries:)` returns `TVEpisode?` (nil = cache miss)
  - `setEpisode(_:inSeason:inTVSeries:)` stores/updates cached episode
  - Protocol conforms to `Sendable, Actor`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/Models/TVEpisodeDetailsCacheEntity.swift`
  - **Important**: This is a new, standalone entity distinct from the existing `TVEpisodeEntity` (which is a child of `TVSeasonEpisodesEntity` via `@Relationship(deleteRule: .cascade)` and keyed by `@Attribute(.unique) var episodeID: Int`). Both coexist in the same SwiftData schema but serve different purposes: `TVEpisodeEntity` stores episodes as part of a season cache, while `TVEpisodeDetailsCacheEntity` independently caches individual episode details with TTL
  - `@Attribute(.unique) var compositeKey: String` — format: `"tvSeriesID-seasonNumber-episodeNumber"`
  - Properties: `tvSeriesID: Int`, `seasonNumber: Int`, `episodeID: Int`, `name: String`, `episodeNumber: Int`, `overview: String?`, `airDate: Date?`, `runtime: Int?`, `stillPath: URL?`, `cachedAt: Date`
  - Conform to `ModelExpirable`
  - `static func makeCompositeKey(tvSeriesID:seasonNumber:episodeNumber:) -> String`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/Mappers/TVEpisodeDetailsCacheEntityMapper.swift`
  - Follow `TVEpisodeEntityMapper.swift` pattern with 3 overloads: entity→domain, domain→entity (create), domain→entity (update)
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/SwiftDataTVEpisodeLocalDataSource.swift`
  - Follow `SwiftDataTVSeasonLocalDataSource.swift` pattern exactly
  - `@ModelActor actor` conforming to `TVEpisodeLocalDataSource`
  - TTL: `60 * 60 * 24` (1 day)
  - `episode()`: fetch by composite key → check expired → delete if stale → return nil or mapped domain object
  - `setEpisode()`: upsert — fetch existing, update or insert new, save
- Modify `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/TVSeriesInfrastructureFactory.swift`
  - Add `TVEpisodeDetailsCacheEntity.self` to `Schema` array
  - Add `private static let tvEpisodeLocalDataSource` property (follows `tvSeasonLocalDataSource` pattern)
- Create `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/DataSources/Local/SwiftDataTVEpisodeLocalDataSourceTests.swift`
  - Follow `SwiftDataTVSeasonLocalDataSourceTests.swift` pattern
  - Use in-memory `ModelContainer` with `Schema([TVEpisodeDetailsCacheEntity.self])`
- Create `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/DataSources/Local/Mappers/TVEpisodeDetailsCacheEntityMapperTests.swift`
  - Follow `TVEpisodeEntityMapperTests.swift` pattern
  - Test all 3 mapper overloads

**Test Elab**:
- `TVEpisodeDetailsCacheEntityMapper`: entity→domain maps all properties correctly
- `TVEpisodeDetailsCacheEntityMapper`: entity→domain preserves nil optionals
- `TVEpisodeDetailsCacheEntityMapper`: domain→entity (create) maps all properties
- `TVEpisodeDetailsCacheEntityMapper`: domain→entity (update) updates all properties
- `TVEpisodeDetailsCacheEntity`: `makeCompositeKey(tvSeriesID: 1396, seasonNumber: 2, episodeNumber: 3)` returns `"1396-2-3"`
- `SwiftDataTVEpisodeLocalDataSource`: returns nil when cache is empty
- `SwiftDataTVEpisodeLocalDataSource`: returns cached episode when available
- `SwiftDataTVEpisodeLocalDataSource`: returns nil when cached episode is expired (TTL exceeded)
- `SwiftDataTVEpisodeLocalDataSource`: deletes expired entry on read
- `SwiftDataTVEpisodeLocalDataSource`: setEpisode stores new episode
- `SwiftDataTVEpisodeLocalDataSource`: setEpisode updates existing episode (upsert)
- `SwiftDataTVEpisodeLocalDataSource`: setEpisode refreshes cachedAt on update
- Edge case: episode with all optional fields nil cached and retrieved correctly
- Edge case: episode with all optional fields populated cached and retrieved correctly

**Dependencies**: US-1

---

### US-3: Episode Remote Data Source & Repository — `M`

> As a **developer**, I want a remote data source protocol and cache-first repository implementation so that episode data is fetched from external APIs with local caching.

**Acceptance Criteria**:
- [ ] `TVEpisodeRemoteDataSource` protocol with `episode(_:inSeason:inTVSeries:)` method
- [ ] `TVEpisodeRemoteDataSourceError` enum co-located in the same file with `notFound`, `unauthorised`, `unknown(Error?)` cases
- [ ] `DefaultTVEpisodeRepository` implements cache-first + remote fallback pattern
- [ ] Cache hit returns local data without calling remote
- [ ] Cache miss fetches from remote and stores result locally (awaited with errors suppressed via `try? await`)
- [ ] Repository maps both remote and local data source errors to repository errors
- [ ] Observability spans with `cache.hit` tracking

**Tech Elab**:
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Protocols/Remote/TVEpisodeRemoteDataSource.swift`
  - Follow `TVSeasonRemoteDataSource.swift` pattern (protocol + error enum in same file)
  - Method: `func episode(_ episodeNumber: Int, inSeason seasonNumber: Int, inTVSeries tvSeriesID: Int) async throws(TVEpisodeRemoteDataSourceError) -> TVEpisode`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/Repositories/DefaultTVEpisodeRepository.swift`
  - Follow `DefaultTVSeasonRepository.swift` pattern (cache-first + remote fallback)
  - Accept `remoteDataSource: any TVEpisodeRemoteDataSource` + `localDataSource: any TVEpisodeLocalDataSource`
  - 1. Try local cache first → if hit, return early with `cache.hit = true`
  - 2. On miss, fetch from remote with `cache.hit = false`
  - 3. Cache write with error suppression: `try? await localDataSource.setEpisode(...)` (awaited, not fire-and-forget `Task` — matches `DefaultTVSeasonRepository` pattern)
  - Map errors via private convenience initializer extensions on `TVEpisodeRepositoryError` (follow `DefaultTVSeasonRepository` lines 78-108 pattern for `TVEpisodeRemoteDataSourceError` and `TVEpisodeLocalDataSourceError` → `TVEpisodeRepositoryError`)
  - Add observability spans
- Create `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/Repositories/DefaultTVEpisodeRepositoryTests.swift`
  - Follow `DefaultTVSeasonRepositoryTests.swift` pattern
- Create `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/Mocks/MockTVEpisodeRemoteDataSource.swift`
  - Follow `MockTVSeasonRemoteDataSource.swift` pattern (stub-based, `@unchecked Sendable`)
- Create `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/Mocks/MockTVEpisodeLocalDataSource.swift`
  - Follow `MockTVSeasonLocalDataSource.swift` pattern (actor-based, stub + call tracking)

**Test Elab**:
- `DefaultTVEpisodeRepository`: cache hit returns local episode without calling remote
- `DefaultTVEpisodeRepository`: cache miss fetches from remote
- `DefaultTVEpisodeRepository`: cache miss stores remote result locally
- `DefaultTVEpisodeRepository`: notFound error mapped from remote
- `DefaultTVEpisodeRepository`: unauthorised error mapped from remote
- `DefaultTVEpisodeRepository`: unknown error mapped from remote
- `DefaultTVEpisodeRepository`: local data source error mapped to repository error
- `DefaultTVEpisodeRepository`: observability span created and finished on success
- `DefaultTVEpisodeRepository`: observability span records error on failure
- `DefaultTVEpisodeRepository`: span records cache.hit = true on cache hit
- `DefaultTVEpisodeRepository`: span records cache.hit = false on cache miss
- `DefaultTVEpisodeRepository`: correct parameters passed to both data sources
- `DefaultTVEpisodeRepository`: remote fetch succeeds but local cache write fails — returns result without error
- Edge case: remote data source throws unknown error with nil wrapped error
- Edge case: remote data source throws unknown error with wrapped error preserved

**Dependencies**: US-2

---

### US-4: TMDb Episode Adapter & Factory Chain — `M`

> As a **developer**, I want a TMDb adapter for the episode endpoint so that episode data is fetched from the TMDb API and mapped to domain models, with the full factory chain and TCA service dependency wired up atomically.

**Acceptance Criteria**:
- [ ] `TMDbTVEpisodeRemoteDataSource` calls `tvEpisodeService.details(forEpisode:inSeason:inTVSeries:language:)` and maps result using existing `TVEpisodeMapper`
- [ ] TMDb errors mapped to `TVEpisodeRemoteDataSourceError` (notFound, unauthorised, unknown)
- [ ] Observability spans on TMDb API calls
- [ ] `TVSeriesInfrastructureFactory` updated with `tvEpisodeRemoteDataSource` param and `makeTVEpisodeRepository()` method (uses both remote + local data sources)
- [ ] Factory chain updated atomically: `PopcornTVSeriesAdaptersFactory` → `LivePopcornTVSeriesFactory` → `TVSeriesInfrastructureFactory`
- [ ] `PopcornTVSeriesAdaptersFactory` accepts `tvEpisodeService` parameter
- [ ] `tvEpisodeService` registered as TCA `DependencyKey` from `tmdb.tvEpisodes`
- [ ] `TVSeriesApplicationFactory+TCA.swift` updated to pass `tvEpisodeService` to adapter factory
- [ ] Code compiles after this story (no broken call sites)

**Tech Elab**:
- Create `Adapters/Contexts/PopcornTVSeriesAdapters/Sources/PopcornTVSeriesAdapters/DataSources/TMDbTVEpisodeRemoteDataSource.swift`
  - Follow `TMDbTVSeasonRemoteDataSource.swift` pattern
  - Reuse existing `TVEpisodeMapper` from `DataSources/Mappers/TVEpisodeMapper.swift`
  - Calls `tvEpisodeService.details(forEpisode: episodeNumber, inSeason: seasonNumber, inTVSeries: tvSeriesID, language: "en")`
  - Map TMDb errors: `.notFound` → `.notFound`, `.unauthorised` → `.unauthorised`, default → `.unknown`
- Factory chain updates (must be atomic — all in this story):
  1. Modify `Adapters/Contexts/PopcornTVSeriesAdapters/Sources/PopcornTVSeriesAdapters/PopcornTVSeriesAdaptersFactory.swift` — add `tvEpisodeService: any TVEpisodeService` param, create `TMDbTVEpisodeRemoteDataSource`, pass to `LivePopcornTVSeriesFactory`
  2. Modify `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/TVSeriesInfrastructureFactory.swift` — add `tvEpisodeRemoteDataSource` param to init, add `makeTVEpisodeRepository() -> some TVEpisodeRepository` method (passes both `tvEpisodeRemoteDataSource` + static `tvEpisodeLocalDataSource`)
  3. Modify `Contexts/PopcornTVSeries/Sources/TVSeriesComposition/LivePopcornTVSeriesFactory.swift` — accept `tvEpisodeRemoteDataSource`, pass to `TVSeriesInfrastructureFactory`
- TCA service wiring (must be in this story to prevent compilation break):
  4. Create `AppDependencies/Sources/AppDependencies/TMDb/TMDbTVEpisodeService+TCA.swift` — follow `TMDbTVSeasonService+TCA.swift` pattern, key: `TMDbTVEpisodeServiceKey`, value: `tmdb.tvEpisodes`
  5. Modify `AppDependencies/Sources/AppDependencies/TVSeries/TVSeriesApplicationFactory+TCA.swift` — add `@Dependency(\.tvEpisodeService) var tvEpisodeService`, pass to `PopcornTVSeriesAdaptersFactory` init

- Create `Adapters/Contexts/PopcornTVSeriesAdapters/Tests/PopcornTVSeriesAdaptersTests/DataSources/TMDbTVEpisodeRemoteDataSourceTests.swift`
  - Follow `TMDbTVSeasonRemoteDataSourceTests.swift` pattern
  - Span tests require `import ObservabilityTestHelpers` and `SpanContext.$localProvider.withValue()` setup
- Create `Adapters/Contexts/PopcornTVSeriesAdapters/Tests/PopcornTVSeriesAdaptersTests/Mocks/MockTVEpisodeService.swift`
  - Follow `MockTVSeasonService.swift` pattern (stub-based, `@unchecked Sendable`)
  - Note: `TVEpisodeService` protocol has many methods — only `details` needs a real stub, others can `fatalError("Not implemented")`

**Test Elab**:
- `TMDbTVEpisodeRemoteDataSource`: success returns mapped episode
- `TMDbTVEpisodeRemoteDataSource`: service called with correct parameters (episodeNumber, seasonNumber, tvSeriesID, language: "en")
- `TMDbTVEpisodeRemoteDataSource`: notFound error from TMDb mapped correctly
- `TMDbTVEpisodeRemoteDataSource`: unauthorised error from TMDb mapped correctly
- `TMDbTVEpisodeRemoteDataSource`: unknown/other error from TMDb mapped correctly
- `TMDbTVEpisodeRemoteDataSource`: observability span created and finished on success
- `TMDbTVEpisodeRemoteDataSource`: observability span records error on failure
- Edge case: TMDb returns episode with all optional fields nil
- Edge case: TMDb returns episode with all optional fields populated

**Dependencies**: US-3

---

### US-5: FetchTVEpisodeDetailsUseCase — `M`

> As a **developer**, I want a `FetchTVEpisodeDetailsUseCase` so that episode data can be fetched with resolved still image URLs in a single call.

**Acceptance Criteria**:
- [ ] `FetchTVEpisodeDetailsUseCase` protocol with `execute(tvSeriesID:seasonNumber:episodeNumber:)` method
- [ ] `DefaultFetchTVEpisodeDetailsUseCase` fetches from `TVEpisodeRepository` + `AppConfigurationProviding`, maps to `TVEpisodeSummary`
- [ ] Reuses existing `TVEpisodeSummaryMapper` for still URL resolution
- [ ] `FetchTVEpisodeDetailsError` enum with `notFound`, `unauthorised`, `unknown` cases
- [ ] `TVSeriesApplicationFactory` updated to accept `tvEpisodeRepository` and create the use case
- [ ] `PopcornTVSeriesFactory` protocol updated with `makeFetchTVEpisodeDetailsUseCase()` method
- [ ] `LivePopcornTVSeriesFactory` delegates to application factory
- [ ] Observability spans on use case execution

**Tech Elab**:
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/UseCases/FetchTVEpisodeDetails/FetchTVEpisodeDetailsUseCase.swift`
  - Follow `FetchTVSeasonDetailsUseCase.swift` pattern
  - Method: `func execute(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int) async throws(FetchTVEpisodeDetailsError) -> TVEpisodeSummary`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/UseCases/FetchTVEpisodeDetails/DefaultFetchTVEpisodeDetailsUseCase.swift`
  - Follow `DefaultFetchTVSeasonDetailsUseCase.swift` pattern
  - Inject `TVEpisodeRepository` + `AppConfigurationProviding`
  - Fetch episode + app config in parallel (`async let`)
  - Map using existing `TVEpisodeSummaryMapper`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/UseCases/FetchTVEpisodeDetails/FetchTVEpisodeDetailsError.swift`
  - Follow `FetchTVSeasonDetailsError.swift` pattern
  - Map from `TVEpisodeRepositoryError` (not `TVSeasonRepositoryError`) + `AppConfigurationProviderError`
- Modify `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/TVSeriesApplicationFactory.swift`
  - Add `tvEpisodeRepository` parameter to init
  - Add `makeFetchTVEpisodeDetailsUseCase()` method
- Modify `Contexts/PopcornTVSeries/Sources/TVSeriesComposition/PopcornTVSeriesFactory.swift`
  - Add `func makeFetchTVEpisodeDetailsUseCase() -> FetchTVEpisodeDetailsUseCase` to protocol
- Modify `Contexts/PopcornTVSeries/Sources/TVSeriesComposition/LivePopcornTVSeriesFactory.swift`
  - Implement `makeFetchTVEpisodeDetailsUseCase()` — delegate to application factory
  - Pass `tvEpisodeRepository` from infrastructure factory to application factory

- Create `Contexts/PopcornTVSeries/Tests/TVSeriesApplicationTests/UseCases/FetchTVEpisodeDetails/DefaultFetchTVEpisodeDetailsUseCaseTests.swift`
  - Follow `DefaultFetchTVSeasonDetailsUseCaseTests.swift` pattern
- Create `Contexts/PopcornTVSeries/Tests/TVSeriesApplicationTests/Mocks/MockTVEpisodeRepository.swift`
  - Follow `MockTVSeasonRepository.swift` pattern (stub-based, `@unchecked Sendable`)

**Test Elab**:
- `DefaultFetchTVEpisodeDetailsUseCase`: success returns mapped `TVEpisodeSummary` with resolved still URLs
- `DefaultFetchTVEpisodeDetailsUseCase`: correct parameters passed to repository
- `DefaultFetchTVEpisodeDetailsUseCase`: notFound error from repository
- `DefaultFetchTVEpisodeDetailsUseCase`: unauthorised error from repository
- `DefaultFetchTVEpisodeDetailsUseCase`: unknown error from repository
- `DefaultFetchTVEpisodeDetailsUseCase`: config provider unauthorised error
- `DefaultFetchTVEpisodeDetailsUseCase`: config provider unknown error
- `DefaultFetchTVEpisodeDetailsUseCase`: observability span created and finished on success
- `DefaultFetchTVEpisodeDetailsUseCase`: observability span records error on failure
- Edge case: episode with nil stillPath produces nil stillURLSet
- Edge case: episode with all optional fields nil maps correctly

**Dependencies**: US-4

---

### US-6: TCA Use Case Wiring — `S`

> As a **developer**, I want a TCA dependency key for the episode details use case so that the TVEpisodeDetailsFeature can access it through dependency injection.

**Acceptance Criteria**:
- [ ] `fetchTVEpisodeDetails` registered as `DependencyKey` from `tvSeriesFactory`
- [ ] Dependency chain resolves: `fetchTVEpisodeDetails` → factory → adapter → TMDb service

**Tech Elab**:
- Create `AppDependencies/Sources/AppDependencies/TVSeries/FetchTVEpisodeDetailsUseCase+TCA.swift`
  - Follow `FetchTVSeasonDetailsUseCase+TCA.swift` pattern exactly
  - Key: `FetchTVEpisodeDetailsUseCaseKey`, property: `fetchTVEpisodeDetails`
  - `liveValue`: `tvSeriesFactory.makeFetchTVEpisodeDetailsUseCase()`

**Test Elab**:
- No dedicated tests required; wiring is compilation-verified and integration-tested via US-7 feature tests (follows existing pattern — no TCA wiring files in the codebase have standalone tests)

**Dependencies**: US-5

---

### US-7: TVEpisodeDetailsFeature & Coordinator Integration — `L`

> As a **user**, I want to see an episode details screen with a still image header, episode name, overview, and air date when I tap an episode so that I can learn about individual episodes.

**Acceptance Criteria**:
- [ ] Tapping an episode row in TVSeasonDetailsView navigates to the episode details screen
- [ ] Screen shows a full-width still image (16:9) at the top (gray placeholder when image unavailable)
- [ ] Screen shows "Episode N" subtitle below the header
- [ ] Screen shows the episode name as a prominent title
- [ ] Screen shows the formatted air date (e.g., "January 20, 2008"), hidden when nil
- [ ] Screen shows the episode overview text, hidden when nil or empty
- [ ] Navigation title displays the episode name
- [ ] Loading spinner shown while fetching
- [ ] Error state with retry option on failure
- [ ] Navigation works from both Explore and Search flows
- [ ] `previewValue` provided on `TVEpisodeDetailsClient` for SwiftUI previews
- [ ] Accessibility: still image header hidden from VoiceOver (decorative), episode metadata accessible
- [ ] Accessibility identifiers on all major sections
- [ ] New test target registered in `PopcornUnitTests.xctestplan`

**Screen Layout**:
```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│         StillImage (full-width via .aspectRatio)         │
│         .aspectRatio(16.0/9.0, contentMode: .fit)       │
│                                                         │
├─────────────────────────────────────────────────────────┤
│                                                         │
│ Episode 1                     (caption, secondary)      │
│ Pilot                         (title, prominent)        │
│                                                         │
│ January 20, 2008              (subheadline, secondary)  │
│                                                         │
│ When an unassuming high school chemistry teacher        │
│ discovers he has a rare form of lung cancer, he         │
│ decides to team up with a former student...             │
│                                                         │
└─────────────────────────────────────────────────────────┘

Note: Overview and air date sections are conditionally hidden when nil (or empty for overview).
When stillPath is nil, StillImage renders its built-in gray placeholder.
```

**Tech Elab**:
- Create `Features/TVEpisodeDetailsFeature/` package:
  - `Package.swift` — dependencies: `AppDependencies`, `DesignSystem`, `TCAFoundation`, `PopcornTVSeries/TVSeriesApplication`, `Observability`, `swift-composable-architecture`. Resources: `.process("Localizable.xcstrings")`. Include `.testTarget` for `TVEpisodeDetailsFeatureTests` with dependencies: `TVEpisodeDetailsFeature`, `TVSeriesApplication` (for `TVEpisodeSummary` in mapper tests), `CoreDomain` (for `ImageURLSet`), `swift-composable-architecture`.
  - `Sources/TVEpisodeDetailsFeature/Localizable.xcstrings` — localized strings for "EPISODE_NUMBER" format, error messages, accessibility labels
  - `Sources/TVEpisodeDetailsFeature/TVEpisodeDetailsFeature.swift` — `@Reducer` with `@ObservableState` struct State containing `tvSeriesID: Int`, `seasonNumber: Int`, `episodeNumber: Int`, `viewState: ViewState<TVEpisode>`. State init must accept `(tvSeriesID:seasonNumber:episodeNumber:)` to match coordinator push sites. Actions: `fetch`, `loaded(TVEpisode)`, `loadFailed(Error)`
  - `Sources/TVEpisodeDetailsFeature/TVEpisodeDetailsClient.swift` — `@DependencyClient`, bridges to `fetchTVEpisodeDetails` use case. Must include `previewValue` with mock episode data.
  - `Sources/TVEpisodeDetailsFeature/Models/TVEpisode.swift` — feature-local model with properties: `id: Int`, `name: String`, `episodeNumber: Int`, `overview: String?`, `airDate: Date?`, `stillURL: URL?`. Note: differs from `TVSeasonDetailsFeature.TVEpisode` which lacks `airDate`. Include `static let mocks` for previews.
  - `Sources/TVEpisodeDetailsFeature/Mappers/TVEpisodeMapper.swift` — maps `TVEpisodeSummary` → feature `TVEpisode`, picks `stillURLSet?.full` for the `stillURL` property (NOT `.card` — `.full` is needed for the full-width detail header)
  - `Sources/TVEpisodeDetailsFeature/Views/TVEpisodeDetailsView.swift` — store-connected, `.task` fetch, `.navigationTitle`. No outer `GeometryReader` needed.
  - `Sources/TVEpisodeDetailsFeature/Views/TVEpisodeDetailsContentView.swift` — pure content view inside `ScrollView`: `StillImage` header (full-width via `.aspectRatio(16.0/9.0, contentMode: .fit)`) + VStack (episode number, name, air date, overview). Conditionally hides overview when nil or empty, air date when nil. Still image hidden from VoiceOver (already `.accessibilityHidden(true)` in `StillImage`).
  - `Sources/TVEpisodeDetailsFeature/Logger.swift` — module logger
- Add `TVEpisodeDetailsFeature` as a package dependency of the Popcorn app target in the Xcode project (required for `import TVEpisodeDetailsFeature` in coordinators)
- Replace placeholder in coordinators:
  - Modify `App/Features/ExploreRoot/ExploreRootFeature.swift` — add `import TVEpisodeDetailsFeature`, change `case tvEpisodeDetails(TVEpisodeDetailsPlaceholder)` to `case tvEpisodeDetails(TVEpisodeDetailsFeature)`, update state construction to `TVEpisodeDetailsFeature.State(tvSeriesID:seasonNumber:episodeNumber:)`
  - Modify `App/Features/ExploreRoot/Views/ExploreRootView.swift` — add `import TVEpisodeDetailsFeature`, replace placeholder text with `TVEpisodeDetailsView(store:)`
  - Modify `App/Features/SearchRoot/SearchRootFeature.swift` — add `import TVEpisodeDetailsFeature`, same Path enum + state changes as ExploreRoot
  - Modify `App/Features/SearchRoot/Views/SearchRootView.swift` — add `import TVEpisodeDetailsFeature`, same view changes as ExploreRoot
- Delete placeholder:
  - Delete `App/Features/TVEpisodeDetailsPlaceholder/TVEpisodeDetailsPlaceholder.swift`
- Tests:
  - `Tests/TVEpisodeDetailsFeatureTests/TVEpisodeDetailsFeatureTests.swift` — reducer tests
  - `Tests/TVEpisodeDetailsFeatureTests/Mappers/TVEpisodeMapperTests.swift` — mapper tests
- Register in `TestPlans/PopcornUnitTests.xctestplan` — add `TVEpisodeDetailsFeatureTests` entry

**Broken files from placeholder removal** (must update):
- `App/Features/ExploreRoot/ExploreRootFeature.swift` — Path enum + navigation case
- `App/Features/ExploreRoot/Views/ExploreRootView.swift` — destination view builder
- `App/Features/SearchRoot/SearchRootFeature.swift` — Path enum + navigation case
- `App/Features/SearchRoot/Views/SearchRootView.swift` — destination view builder
- `PopcornTests/ExploreRootFeatureTests.swift` — episode details state assertion type
- `PopcornTests/SearchRootFeatureTests.swift` — episode details state assertion type

**Test Elab**:
- `TVEpisodeDetailsFeature`: fetch sends loaded with episode snapshot
- `TVEpisodeDetailsFeature`: fetch sends loadFailed on error
- `TVEpisodeDetailsFeature`: fetch does not reload when already ready
- `TVEpisodeMapper`: maps all fields with still URL set (picks `.full`)
- `TVEpisodeMapper`: handles nil stillURLSet
- `TVEpisodeMapper`: handles nil overview
- `TVEpisodeMapper`: handles nil airDate
- Edge case: episode with empty name (still displays)
- Edge case: episode with nil overview (overview section hidden)
- Edge case: episode with empty string overview (overview section hidden)

**Dependencies**: US-6

---

## Story Dependency Graph

```
US-1 (Domain Protocol)
  ↓
US-2 (Local Cache Infrastructure)
  ↓
US-3 (Remote DS + Repository)
  ↓
US-4 (Adapter + Factory Chain + Service Wiring)
  ↓
US-5 (Application Use Case + Composition)
  ↓
US-6 (TCA Use Case Wiring)
  ↓
US-7 (Feature + Coordinators)
```

**Sequential track** (all stories are sequential due to layer dependencies):
- US-1 → US-2 → US-3 → US-4 → US-5 → US-6 → US-7

**No parallel tracks** — each story builds on the previous layer. The codebase compiles after each story.

## Verification

1. `/format` — no violations
2. `/lint` — no violations
3. `/build` — build succeeds (warnings are errors)
4. `/test` — all tests pass
5. Manual: Navigate to a TV series → tap a season → tap an episode → verify still image header, episode name, air date, overview
6. Manual: Verify episode details loads from Search flow as well
7. Manual: Verify loading and error states display correctly
8. Manual: Verify nil overview and nil air date hide their sections
9. Manual: Revisit same episode — verify cache hit (faster load, no network call)
10. Code review via `code-reviewer` agent with adversarial re-evaluation
