# PRD: TV Series Details Cast & Crew Carousel

## Overview

Add a Cast & Crew carousel to the TV Series Details screen, showing the top 5 cast members and top 5 crew members with profile images. Follows the exact pattern established by the Movie Details feature.

## Problem

The TV Series Details screen shows series metadata, overview, and seasons but lacks information about who stars in and works on the show. Users visiting a TV series page expect to see cast and crew — a standard feature across media apps.

## Goals

1. Display a horizontally scrollable Cast & Crew carousel on the TV Series Details screen
2. Show up to 5 cast members and 5 crew members with profile images, names, and roles
3. Gate the feature behind a `tvSeriesDetailsCastAndCrew` feature flag
4. Add navigation to person details when tapping a cast/crew member
5. Cache credits data locally via SwiftData with 24h TTL
6. Follow the established Movie Details Cast & Crew pattern exactly

## Non-Goals

- Full "See All" Cast & Crew page (follow-up feature)
- Aggregate credits across all episodes (using series-level credits endpoint instead)
- Person details feature (already exists — just wire navigation)

---

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| Use `TVSeriesService.credits()` (returns `ShowCredits`) not `aggregateCredits()` | Returns series regulars — better for a top-5 carousel. Same TMDb type as movies, enabling identical mapper patterns. Aggregate credits include every guest star, making top-5 less meaningful. |
| Separate `FetchTVSeriesCreditsUseCase` (not embedded in details) | Matches movie pattern. Credits load independently without blocking the main details fetch. |
| Separate `TVSeriesCreditsRepository` (not extending `TVSeriesRepository`) | Matches movie pattern (`MovieCreditsRepository` is separate from `MovieRepository`). Keeps repository interfaces focused. |
| SwiftData caching with 24h TTL | Reduces API calls on repeat visits. TV series pages are revisited frequently when exploring seasons/episodes. Follows movie credits caching pattern. |
| Feature flag: `.tvSeriesDetailsCastAndCrew` | Matches `.movieDetailsCastAndCrew` naming convention. Allows independent rollout. |
| Add `.personDetails(id:)` to TVSeriesDetails Navigation | Enables tapping cast/crew to navigate to person details. Follows movie pattern. |

## Data Flow

```
TMDb API: tvSeriesService.credits(forTVSeries:)
  |
  v
TMDb.ShowCredits { id, cast: [CastMember], crew: [CrewMember] }
  |  [CreditsMapper, CastMemberMapper, CrewMemberMapper, GenderMapper]
  v
TVSeriesDomain.Credits { id, cast: [CastMember], crew: [CrewMember] }
  |
  v
DefaultTVSeriesCreditsRepository (local cache check -> remote fetch -> cache write)
  |
  v
TVSeriesDomain.Credits
  |  [DefaultFetchTVSeriesCreditsUseCase + CreditsDetailsMapper]
  |  [imagesConfiguration.profileURLSet() for URL resolution]
  v
TVSeriesApplication.CreditsDetails { id, cast: [CastMemberDetails], crew: [CrewMemberDetails] }
  |
  v
@Dependency(\.fetchTVSeriesCredits)  [AppDependencies TCA wiring]
  |
  v
TVSeriesDetailsClient.fetchCredits(tvSeriesID:)
  |  [CreditsMapper — .prefix(5) + .profileURLSet?.detail]
  v
TVSeriesDetailsFeature.Credits { id, castMembers: [CastMember], crewMembers: [CrewMember] }
  |
  v
TVSeriesDetailsFeature.ViewSnapshot { tvSeries, castMembers, crewMembers }
  |
  v
CastAndCrewCarousel -> ProfileCarouselCell (DesignSystem)
```

---

## User Stories

### US-1: Domain — TV Series Credits entities & repository protocol — `S`

> As a **developer**, I want TV series credits domain entities and a repository protocol so that upper layers can fetch and cache credits data.

**Acceptance Criteria**:
- [ ] `Credits` entity with `id: Int`, `cast: [CastMember]`, `crew: [CrewMember]` — conforms to `Identifiable`, `Equatable`, `Sendable`
- [ ] `CastMember` entity with `id: String`, `personID: Int`, `characterName: String`, `personName: String`, `profilePath: URL?`, `gender: Gender`, `order: Int`
- [ ] `CrewMember` entity with `id: String`, `personID: Int`, `personName: String`, `job: String`, `profilePath: URL?`, `gender: Gender`, `department: String`
- [ ] `TVSeriesCreditsRepository` protocol with `credits(forTVSeries:) async throws(TVSeriesCreditsRepositoryError) -> Credits`
- [ ] `TVSeriesCreditsRepositoryError` enum with `notFound`, `unauthorised`, `unknown(Error?)` cases
- [ ] All types have `public` access and `///` doc comments
- [ ] Package builds: `swift build` in PopcornTVSeries package

**Tech Elab**:
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesDomain/Entities/Credits.swift` — follow `Contexts/PopcornMovies/Sources/MoviesDomain/Entities/Credits.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesDomain/Entities/CastMember.swift` — follow `Contexts/PopcornMovies/Sources/MoviesDomain/Entities/CastMember.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesDomain/Entities/CrewMember.swift` — follow `Contexts/PopcornMovies/Sources/MoviesDomain/Entities/CrewMember.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesDomain/Repositories/TVSeriesCreditsRepository.swift` — follow `MovieCreditsRepository.swift` pattern
- `Gender` enum already exists in `CoreDomain` — import `CoreDomain` in the entity files (check if TVSeriesDomain already depends on CoreDomain)

**Test Elab**:
- Domain entities are simple value types with no logic — no unit tests needed
- Repository is a protocol — tested via implementation in US-2
- Edge case: ensure `Credits` uses `Int` id (TV series ID, not a credit ID)
- Edge case: `CastMember.id` is `String` (TMDb creditID), not personID

**Dependencies**: None

---

### US-2: Infrastructure — Credits data sources, SwiftData persistence, repository — `L`

> As a **developer**, I want credits persistence via SwiftData and a repository implementation so that TV series credits are cached locally with a 24h TTL.

**Acceptance Criteria**:
- [ ] `TVSeriesRemoteDataSource` protocol extended with `credits(forTVSeries:) async throws(TVSeriesRemoteDataSourceError) -> Credits`
- [ ] `TVSeriesCreditsLocalDataSource` protocol with `credits(forTVSeries:)` and `setCredits(_:forTVSeries:)` methods
- [ ] SwiftData `@Model` entities: `TVSeriesCreditsEntity`, `TVSeriesCastMemberEntity`, `TVSeriesCrewMemberEntity`
- [ ] `TVSeriesCreditsEntity` has `@Attribute(.unique) var tvSeriesID: Int`, cascade delete for cast/crew relationships, `cachedAt: Date`, conforms to `ModelExpirable`
- [ ] Bidirectional entity mappers: `CreditsEntityMapper`, `CastMemberEntityMapper`, `CrewMemberEntityMapper`, `GenderEntityMapper`
- [ ] `SwiftDataTVSeriesCreditsLocalDataSource` with 24h TTL, expires stale entries
- [ ] `DefaultTVSeriesCreditsRepository` tries local first, falls back to remote, caches result
- [ ] `TVSeriesInfrastructureFactory` updated: schema includes new entities, exposes `makeTVSeriesCreditsRepository()`
- [ ] Package builds and tests pass in PopcornTVSeries package

**Tech Elab**:
- Modify `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Protocols/Remote/TVSeriesRemoteDataSource.swift` — add `credits(forTVSeries:)` method
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Protocols/Local/TVSeriesCreditsLocalDataSource.swift` — follow `MovieCreditsLocalDataSource.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/Models/TVSeriesCreditsEntity.swift` — follow `CreditsEntity.swift` (use `tvSeriesID` instead of `movieID`)
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/Models/TVSeriesCastMemberEntity.swift` — follow `CastMemberEntity.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/Models/TVSeriesCrewMemberEntity.swift` — follow `CrewMemberEntity.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/Mappers/CreditsEntityMapper.swift` — follow movie pattern (sort cast by order)
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/Mappers/CastMemberEntityMapper.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/Mappers/CrewMemberEntityMapper.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/Mappers/GenderEntityMapper.swift` — maps `Gender` ↔ `Int`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/DataSources/Local/SwiftDataTVSeriesCreditsLocalDataSource.swift` — follow `SwiftDataMovieCreditsLocalDataSource.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/Repositories/DefaultTVSeriesCreditsRepository.swift` — follow `DefaultMovieCreditsRepository.swift`
- Modify `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/TVSeriesInfrastructureFactory.swift` — add entities to schema, add `makeTVSeriesCreditsRepository()` method, add static local data source

**Test Elab**:
- Test `CreditsEntityMapper` maps domain → entity and entity → domain correctly
- Test `CastMemberEntityMapper` bidirectional mapping (including gender int conversion)
- Test `CrewMemberEntityMapper` bidirectional mapping
- Test `GenderEntityMapper` maps all 4 gender cases correctly in both directions
- Test `DefaultTVSeriesCreditsRepository` returns cached data when available
- Test `DefaultTVSeriesCreditsRepository` fetches remote when cache miss, writes to cache
- Edge case: expired cache entry (>24h) returns nil and is deleted
- Edge case: cast sorted by `order` field when mapping from entity

**Dependencies**: US-1

---

### US-3: Application — Credits use case, models, mappers + Composition — `M`

> As a **developer**, I want a `FetchTVSeriesCreditsUseCase` that resolves profile image URLs so that the feature layer receives display-ready credits data.

**Acceptance Criteria**:
- [ ] `CreditsDetails` model with `id: Int`, `cast: [CastMemberDetails]`, `crew: [CrewMemberDetails]`
- [ ] `CastMemberDetails` model with `profileURLSet: ImageURLSet?` (resolved from path via `ImagesConfiguration`)
- [ ] `CrewMemberDetails` model with `profileURLSet: ImageURLSet?`
- [ ] `FetchTVSeriesCreditsUseCase` protocol with `execute(tvSeriesID:) async throws(FetchTVSeriesCreditsError) -> CreditsDetails`
- [ ] `DefaultFetchTVSeriesCreditsUseCase` fetches credits + app config in parallel, maps via `CreditsDetailsMapper`
- [ ] `FetchTVSeriesCreditsError` enum with `notFound`, `unauthorised`, `unknown(Error?)` cases
- [ ] `TVSeriesApplicationFactory` updated with `makeFetchTVSeriesCreditsUseCase()`
- [ ] `PopcornTVSeriesFactory` protocol updated with `makeFetchTVSeriesCreditsUseCase()`
- [ ] `LivePopcornTVSeriesFactory` delegates to application factory
- [ ] Package builds and tests pass in PopcornTVSeries package

**Tech Elab**:
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/Models/CreditsDetails.swift` — follow `Contexts/PopcornMovies/Sources/MoviesApplication/Models/CreditsDetails.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/Models/CastMemberDetails.swift` — follow movie pattern
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/Models/CrewMemberDetails.swift` — follow movie pattern
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/Mappers/CreditsDetailsMapper.swift` — orchestrates cast/crew mappers with `ImagesConfiguration`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/Mappers/CastMemberDetailsMapper.swift` — uses `imagesConfiguration.profileURLSet(for:)`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/Mappers/CrewMemberDetailsMapper.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/UseCases/FetchTVSeriesCredits/FetchTVSeriesCreditsUseCase.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/UseCases/FetchTVSeriesCredits/DefaultFetchTVSeriesCreditsUseCase.swift` — follow `DefaultFetchMovieCreditsUseCase.swift`
- Create `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/UseCases/FetchTVSeriesCredits/FetchTVSeriesCreditsError.swift`
- Modify `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/TVSeriesApplicationFactory.swift` — add `makeFetchTVSeriesCreditsUseCase()`
- Modify `Contexts/PopcornTVSeries/Sources/TVSeriesComposition/PopcornTVSeriesFactory.swift` — add protocol requirement
- Modify `Contexts/PopcornTVSeries/Sources/TVSeriesComposition/LivePopcornTVSeriesFactory.swift` — add delegation

**Test Elab**:
- Test `CreditsDetailsMapper` maps credits with resolved image URL sets
- Test `CastMemberDetailsMapper` converts `profilePath` → `ImageURLSet` via `ImagesConfiguration`
- Test `CrewMemberDetailsMapper` converts `profilePath` → `ImageURLSet`
- Test `DefaultFetchTVSeriesCreditsUseCase` calls repository + config provider, returns mapped result
- Edge case: nil `profilePath` maps to nil `profileURLSet`
- Edge case: `FetchTVSeriesCreditsError` correctly wraps repository errors

**Dependencies**: US-2

---

### US-4: Adapters — TMDb credits mappers + AppDependencies wiring — `M`

> As a **developer**, I want TMDb-to-domain credits mappers and TCA dependency wiring so that the feature layer can access TV series credits via `@Dependency`.

**Acceptance Criteria**:
- [ ] `CreditsMapper` maps `TMDb.ShowCredits` → `TVSeriesDomain.Credits`
- [ ] `CastMemberMapper` maps `TMDb.CastMember` → `TVSeriesDomain.CastMember` (using `creditID` as `id`, `id` as `personID`)
- [ ] `CrewMemberMapper` maps `TMDb.CrewMember` → `TVSeriesDomain.CrewMember`
- [ ] `GenderMapper` maps `TMDb.Gender` → `CoreDomain.Gender`
- [ ] `TMDbTVSeriesRemoteDataSource` updated with `credits(forTVSeries:)` calling `tvSeriesService.credits(forTVSeries:language:)`
- [ ] `FetchTVSeriesCreditsUseCaseKey` TCA dependency key in AppDependencies
- [ ] `DependencyValues.fetchTVSeriesCredits` extension
- [ ] Package builds in both PopcornTVSeriesAdapters and AppDependencies

**Tech Elab**:
- Create `Adapters/Contexts/PopcornTVSeriesAdapters/Sources/PopcornTVSeriesAdapters/DataSources/Mappers/CreditsMapper.swift` — follow `Adapters/Contexts/PopcornMoviesAdapters/Sources/PopcornMoviesAdapters/DataSources/Mappers/CreditsMapper.swift`
- Create `Adapters/Contexts/PopcornTVSeriesAdapters/Sources/PopcornTVSeriesAdapters/DataSources/Mappers/CastMemberMapper.swift` — follow movie pattern
- Create `Adapters/Contexts/PopcornTVSeriesAdapters/Sources/PopcornTVSeriesAdapters/DataSources/Mappers/CrewMemberMapper.swift`
- Create `Adapters/Contexts/PopcornTVSeriesAdapters/Sources/PopcornTVSeriesAdapters/DataSources/Mappers/GenderMapper.swift` — maps `TMDb.Gender` → `CoreDomain.Gender`
- Modify `Adapters/Contexts/PopcornTVSeriesAdapters/Sources/PopcornTVSeriesAdapters/DataSources/TMDbTVSeriesRemoteDataSource.swift` — add `credits(forTVSeries:)` with SpanContext tracing
- Create `AppDependencies/Sources/AppDependencies/TVSeries/FetchTVSeriesCreditsUseCase+TCA.swift` — follow `FetchMovieCreditsUseCase+TCA.swift`

**Test Elab**:
- Test `CreditsMapper` maps ShowCredits → Credits with correct cast/crew arrays
- Test `CastMemberMapper` maps all fields correctly (`creditID` → `id`, `id` → `personID`)
- Test `CrewMemberMapper` maps all fields including department
- Test `GenderMapper` maps all 4 gender cases + nil handling via `compactMap`
- Edge case: empty cast/crew arrays
- Edge case: nil `profilePath` and nil `gender` handling

**Dependencies**: US-3

---

### US-5: Feature — TV Series Details Cast & Crew UI — `L`

> As a **user**, I want to see the top cast and crew on the TV Series Details screen so that I can discover who stars in and works on the show.

**Acceptance Criteria**:
- [ ] `.tvSeriesDetailsCastAndCrew` feature flag defined and registered in `allFlags`
- [ ] Cast & Crew carousel displayed below the seasons carousel when credits are available
- [ ] Carousel shows up to 5 cast members + 5 crew members with circular profile images
- [ ] Each cell shows person name and character name (cast) or job title (crew)
- [ ] Tapping a person navigates to `.personDetails(id:)` via the Navigation enum
- [ ] Section header reads "CAST_AND_CREW" (localized)
- [ ] Carousel hidden when feature flag disabled or no credits available
- [ ] Credits fetched in parallel with TV series details (feature flag gated)
- [ ] Accessibility identifiers: `tv-series-details.cast-and-crew.carousel`, `.cast.{offset}`, `.crew.{offset}`
- [ ] All existing tests pass, new tests for mapper, feature flags, client, and navigation
- [ ] App builds with no warnings

**Tech Elab**:
- Modify `Platform/FeatureAccess/Sources/FeatureAccess/Models/FeatureFlag.swift` — add `.tvSeriesDetailsCastAndCrew` flag + register in `allFlags`
- Create `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Models/Credits.swift` — follow movie `Credits.swift` pattern
- Create `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Models/CastMember.swift` — follow movie pattern
- Create `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Models/CrewMember.swift` — follow movie pattern
- Create `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Mappers/CreditsMapper.swift` — maps `TVSeriesApplication.CreditsDetails` → feature `Credits`, `.prefix(5)` for both cast and crew, extract `.detail` from `profileURLSet`
- Create `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Views/Components/CastAndCrewCarousel.swift` — follow movie `CastAndCrewCarousel.swift` exactly, update accessibility IDs to `tv-series-details.*`
- Modify `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/TVSeriesDetailsClient.swift` — add `fetchCredits: @Sendable (Int) async throws -> Credits` and `isCastAndCrewEnabled: @Sendable () throws -> Bool`, wire live + preview values
- Modify `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/TVSeriesDetailsFeature.swift`:
  - Add `castMembers: [CastMember]` and `crewMembers: [CrewMember]` to `ViewSnapshot`
  - Add `isCastAndCrewEnabled: Bool` to `State` (default `false`)
  - Update `updateFeatureFlags` to set `isCastAndCrewEnabled`
  - Update `handleFetchTVSeries` to fetch credits in parallel (feature flag gated)
  - Add `.personDetails(id: Int)` to `Navigation` enum
- Modify `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Views/TVSeriesDetailsContentView.swift` — add `castMembers`, `crewMembers`, `didSelectPerson` params, render `CastAndCrewCarousel` below seasons
- Add localization key `CAST_AND_CREW` and `VIEW_PERSON_DETAILS_HINT` to TVSeriesDetailsFeature's `Localizable.xcstrings`
- Update TVSeriesDetailsFeature `Package.swift` if needed (should already have `TVSeriesApplication` dependency)

**Test Elab**:
- Test `CreditsMapper` maps all properties correctly
- Test `CreditsMapper` limits cast and crew to first 5
- Test `CreditsMapper` handles fewer than 5 members
- Test `CreditsMapper` handles empty arrays
- Test `CreditsMapper` handles nil `profileURLSet`
- Test `CreditsMapper` preserves order
- Test `isCastAndCrewEnabled` returns true/false based on feature flag
- Test `updateFeatureFlags` sets `isCastAndCrewEnabled` (enabled, disabled, error cases)
- Test navigation `.personDetails(id:)` returns `.none`
- Edge case: credits fetch disabled by feature flag returns empty cast/crew
- Edge case: credits fetch throws — TV series still loads (error isolated)

**Dependencies**: US-4

---

## Story Dependency Graph

```
US-1 (Domain - S)
  |
  v
US-2 (Infrastructure - L)
  |
  v
US-3 (Application + Composition - M)
  |
  v
US-4 (Adapters + AppDependencies - M)
  |
  v
US-5 (Feature - L)
```

**Parallel tracks**: None — strictly sequential due to layer dependencies (Domain → Infrastructure → Application → Adapters → Feature).

**Merge points**: Each story depends on the previous.

## Verification

1. `/format` — no violations
2. `/lint` — no violations
3. `/build` — build succeeds (warnings are errors)
4. `/test` — all tests pass
5. Manual: toggle `tvSeriesDetailsCastAndCrew` feature flag on/off, verify carousel appears/hides
6. Manual: tap a cast member, verify navigation to person details
7. Code review via `code-reviewer` agent with adversarial re-evaluation
