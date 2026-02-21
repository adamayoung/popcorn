# Plan: TV Episode Details Feature

## Context

The TV Season Details screen (PR #31) navigates to a `TVEpisodeDetailsPlaceholder` when an episode is tapped. This plan replaces the placeholder with a fully functional TV Episode Details screen showing still image header, episode name, overview, and air date. Uses a dedicated TMDb episode endpoint with SwiftData caching for data independence.

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| Dedicated TMDb episode endpoint | Independent from season fetch; returns more data (crew, guest stars) for future expansion |
| Extend `PopcornTVSeries` context | Episodes belong to the TV series domain |
| SwiftData caching with 24h TTL | Cache-first + remote fallback; reduces API calls on repeat visits |
| Separate `TVEpisodeDetailsCacheEntity` | Existing `TVEpisodeEntity` is cascade-deleted by `TVSeasonEpisodesEntity`; independent entity with composite key `"tvSeriesID-seasonNumber-episodeNumber"` avoids conflict |
| `StillImage` with `.aspectRatio(16/9)` | Reuses DesignSystem component; `.aspectRatio(16.0/9.0, contentMode: .fit)` inside ScrollView/VStack — no outer GeometryReader needed |
| Feature mapper picks `.full` URL | Full-width header needs highest resolution; new feature-layer mapper distinct from season feature's `.card` mapper |
| Reuse `TVEpisodeSummary` + `TVEpisodeSummaryMapper` | All required fields already exist |
| Simple ScrollView for content | Limited content; no stretchy header or list needed |
| Factory chain wiring atomic in US-4 | All factory init changes in one story to prevent compilation breaks |

## Development Methodology

- Strict TDD — write tests before implementation for each story
- Package-level verification after each story (`swift build` / `swift test`)
- Full pre-PR checklist after final story

## Data Flow

```
TMDb API → TVEpisodeService.details() → TMDbTVEpisodeRemoteDataSource → TVEpisodeMapper (reused)
  → TVEpisode (Domain) → DefaultTVEpisodeRepository (cache-first + remote)
    ├── 1. Check SwiftDataTVEpisodeLocalDataSource → HIT: return cached
    ├── 2. MISS: fetch from remote
    └── 3. Cache result (try? await, errors suppressed)
  → DefaultFetchTVEpisodeDetailsUseCase + TVEpisodeSummaryMapper (reused)
  → TVEpisodeSummary → TVEpisodeDetailsClient → TVEpisodeMapper (picks .full)
  → TVEpisodeDetailsFeature → TVEpisodeDetailsView
```

## Implementation Steps

### Story 1: TVEpisodeRepository Domain Protocol — `S`
**Create:**
- `Contexts/PopcornTVSeries/Sources/TVSeriesDomain/Repositories/TVEpisodeRepository.swift`

### Story 2: Episode Local Cache Infrastructure — `M`
**Create:**
- `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Protocols/Local/TVEpisodeLocalDataSource.swift`
- `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/Models/TVEpisodeDetailsCacheEntity.swift`
- `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/Mappers/TVEpisodeDetailsCacheEntityMapper.swift`
- `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/SwiftDataTVEpisodeLocalDataSource.swift`
- `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/DataSources/Local/SwiftDataTVEpisodeLocalDataSourceTests.swift`
- `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/DataSources/Local/Mappers/TVEpisodeDetailsCacheEntityMapperTests.swift`

**Modify:**
- `TVSeriesInfrastructureFactory.swift` — add entity to schema + static local data source property

### Story 3: Episode Remote Data Source & Repository — `M`
**Create:**
- `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Protocols/Remote/TVEpisodeRemoteDataSource.swift`
- `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/Repositories/DefaultTVEpisodeRepository.swift`
- `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/Repositories/DefaultTVEpisodeRepositoryTests.swift`
- `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/Mocks/MockTVEpisodeRemoteDataSource.swift`
- `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/Mocks/MockTVEpisodeLocalDataSource.swift`

### Story 4: TMDb Episode Adapter & Factory Chain — `M`
**Create:**
- `Adapters/Contexts/PopcornTVSeriesAdapters/Sources/PopcornTVSeriesAdapters/DataSources/TMDbTVEpisodeRemoteDataSource.swift`
- `AppDependencies/Sources/AppDependencies/TMDb/TMDbTVEpisodeService+TCA.swift`
- `Adapters/Contexts/PopcornTVSeriesAdapters/Tests/PopcornTVSeriesAdaptersTests/DataSources/TMDbTVEpisodeRemoteDataSourceTests.swift`
- `Adapters/Contexts/PopcornTVSeriesAdapters/Tests/PopcornTVSeriesAdaptersTests/Mocks/MockTVEpisodeService.swift`

**Modify (atomic factory chain):**
- `PopcornTVSeriesAdaptersFactory.swift` — add `tvEpisodeService` param
- `TVSeriesInfrastructureFactory.swift` — add `tvEpisodeRemoteDataSource` param + `makeTVEpisodeRepository()` (uses both remote + local)
- `LivePopcornTVSeriesFactory.swift` — pass `tvEpisodeRemoteDataSource` through
- `TVSeriesApplicationFactory+TCA.swift` — add `tvEpisodeService` dependency

### Story 5: FetchTVEpisodeDetailsUseCase — `M`
**Create:**
- `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/UseCases/FetchTVEpisodeDetails/FetchTVEpisodeDetailsUseCase.swift`
- `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/UseCases/FetchTVEpisodeDetails/DefaultFetchTVEpisodeDetailsUseCase.swift`
- `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/UseCases/FetchTVEpisodeDetails/FetchTVEpisodeDetailsError.swift`
- `Contexts/PopcornTVSeries/Tests/TVSeriesApplicationTests/UseCases/FetchTVEpisodeDetails/DefaultFetchTVEpisodeDetailsUseCaseTests.swift`
- `Contexts/PopcornTVSeries/Tests/TVSeriesApplicationTests/Mocks/MockTVEpisodeRepository.swift`

**Modify:**
- `TVSeriesApplicationFactory.swift` — add `tvEpisodeRepository` param + `makeFetchTVEpisodeDetailsUseCase()`
- `PopcornTVSeriesFactory.swift` — add protocol requirement
- `LivePopcornTVSeriesFactory.swift` — implement delegation

### Story 6: TCA Use Case Wiring — `S`
**Create:**
- `AppDependencies/Sources/AppDependencies/TVSeries/FetchTVEpisodeDetailsUseCase+TCA.swift`

### Story 7: TVEpisodeDetailsFeature & Coordinator Integration — `L`
**Create:**
- `Features/TVEpisodeDetailsFeature/` package (Package.swift, sources, views, models, mappers, logger, localizable strings)
- `Features/TVEpisodeDetailsFeature/Tests/TVEpisodeDetailsFeatureTests/TVEpisodeDetailsFeatureTests.swift`
- `Features/TVEpisodeDetailsFeature/Tests/TVEpisodeDetailsFeatureTests/Mappers/TVEpisodeMapperTests.swift`

**Modify:**
- Xcode project — add `TVEpisodeDetailsFeature` as app target package dependency
- `ExploreRootFeature.swift` — `import TVEpisodeDetailsFeature`, replace placeholder with `TVEpisodeDetailsFeature`
- `ExploreRootView.swift` — `import TVEpisodeDetailsFeature`, replace placeholder with `TVEpisodeDetailsView`
- `SearchRootFeature.swift` — `import TVEpisodeDetailsFeature`, replace placeholder with `TVEpisodeDetailsFeature`
- `SearchRootView.swift` — `import TVEpisodeDetailsFeature`, replace placeholder with `TVEpisodeDetailsView`
- `ExploreRootFeatureTests.swift` — update `TVEpisodeDetailsPlaceholder.State` → `TVEpisodeDetailsFeature.State`
- `SearchRootFeatureTests.swift` — update `TVEpisodeDetailsPlaceholder.State` → `TVEpisodeDetailsFeature.State`
- `PopcornUnitTests.xctestplan` — register `TVEpisodeDetailsFeatureTests`

**Delete:**
- `App/Features/TVEpisodeDetailsPlaceholder/TVEpisodeDetailsPlaceholder.swift`

## Story Dependency Graph

```
US-1 → US-2 → US-3 → US-4 → US-5 → US-6 → US-7
```

All stories are sequential (layer dependencies). Codebase compiles after each story.

## Verification

1. `/format` — no violations
2. `/lint` — no violations
3. `/build` — build succeeds (warnings are errors)
4. `/test` — all tests pass
5. Code review via `code-reviewer` agent
