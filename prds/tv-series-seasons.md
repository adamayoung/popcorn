# PRD: TV Series Seasons Carousel

## Overview

Add a **seasons carousel** to the TV Series Details screen, displaying each season's poster image with its name underneath. The carousel uses `PosterCarouselCell` and appears below the series overview text. Tapping a season navigates to a placeholder view (to be replaced with a full Season Details screen later).

## Problem

The TV Series Details screen currently only displays the series overview text. Users have no way to see which seasons exist for a TV series, or navigate to individual season information. The TMDb API already returns season data as part of the TV series details response, but this data is currently discarded.

## Goals

1. Display TV series seasons in a horizontally scrolling carousel below the overview
2. Show season poster images with season names as labels
3. Enable navigation from a season to a placeholder detail view
4. Extend the existing `PopcornTVSeries` context pipeline to include season data
5. Follow existing carousel patterns established in `ExploreFeature` and `MovieDetailsFeature`

## Non-Goals

- Full Season Details screen (placeholder only for now)
- Episode listings within seasons
- Season-specific images beyond the poster
- Separate API call for season data (uses existing TV series details response)
- Feature flag gating (seasons always shown when available)

---

## Requirements

### R1: Domain Model — `TVSeason` Entity

- New `TVSeason` value type in `TVSeriesDomain` with: `id`, `name`, `seasonNumber`, `posterPath`
- `TVSeries` domain entity extended with `seasons: [TVSeason]`
- Backwards compatible — `seasons` defaults to `[]`

### R2: Adapter Mapper — TMDb to Domain

- New `TVSeasonMapper` maps `TMDb.TVSeason` → `TVSeriesDomain.TVSeason`
- Existing `TVSeriesMapper` updated to map `dto.seasons` using `TVSeasonMapper`
- Nil seasons from TMDb maps to empty array

### R3: Application Model — `TVSeasonSummary`

- New `TVSeasonSummary` in `TVSeriesApplication` with: `id`, `name`, `seasonNumber`, `posterURL` (resolved URL)
- New `TVSeasonSummaryMapper` resolves poster path to URL via `ImagesConfiguration.posterURLSet(for:)?.detail`
- `TVSeriesDetails` extended with `seasons: [TVSeasonSummary]`
- `TVSeriesDetailsMapper` updated to map and include seasons in output

### R4: Feature Model — `TVSeasonPreview`

- New `TVSeasonPreview` in `TVSeriesDetailsFeature` with: `id`, `seasonNumber`, `name`, `posterURL`
- Feature `TVSeries` model extended with `seasons: [TVSeasonPreview]`
- Feature `TVSeriesMapper` updated to map seasons

### R5: Seasons Carousel View

- Horizontal carousel using `Carousel` and `PosterCarouselCell` from `DesignSystem`
- Each cell shows season poster image with season name label underneath
- Section title "Seasons" (localised key `SEASONS`) displayed above the carousel
- Carousel only shown when `seasons` is non-empty
- Positioned below the overview text, following `MovieDetailsContentView` section pattern
- Accessibility: each cell has `.accessibilityIdentifier("tv-series-details.seasons.\(seasonNumber)")` and `.accessibilityLabel(season.name)`

### R6: Content View Extraction

- Extract content rendering from `TVSeriesDetailsView` into `TVSeriesDetailsContentView`
- Follows `MovieDetailsView` → `MovieDetailsContentView` delegation pattern
- Content view receives data as properties + callbacks (no store dependency)

### R7: Season Navigation

- New `Navigation.seasonDetails(tvSeriesID: Int, seasonNumber: Int)` action
- Tapping a carousel cell sends the navigation action
- App coordinators (`ExploreRootFeature`, `SearchRootFeature`) handle navigation
- Destination is a placeholder `TVSeasonDetailsPlaceholder` reducer with an empty view

---

## Technical Design

### Architecture Layers

```
TMDb API (seasons in TV Series details response)
  → TMDbTVSeriesRemoteDataSource (TVSeriesMapper + TVSeasonMapper)
    → TVSeriesDomain.TVSeries (with [TVSeason])
      → DefaultTVSeriesRepository (cache includes seasons)
        → DefaultFetchTVSeriesDetailsUseCase (TVSeriesDetailsMapper)
          → TVSeriesDetails (with [TVSeasonSummary])
            → TVSeriesDetailsClient (TVSeriesMapper)
              → Feature.TVSeries (with [TVSeasonPreview])
                → TVSeriesDetailsContentView → SeasonsCarousel (PosterCarouselCell)
```

### Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Extend `PopcornTVSeries` context, not new module | Seasons are a subdomain of TV series; TMDb returns them together |
| `PosterCarouselCell` not `BackdropCarouselCell` | TMDb seasons only have poster images (portrait, 2:3), not backdrops |
| TMDb `name` field for labels | Handles custom naming (e.g., "Stranger Things 2" instead of "Season 2") |
| Data from TV series details response | Seasons come with the TV series details endpoint — no extra API call |
| Seasons cached with TV series entity | No separate cache entry needed |
| Extract `TVSeriesDetailsContentView` | Follows Movie pattern, separates view logic from store wiring |
| Placeholder reducer for navigation | Minimal coordinator changes; replaced later with full feature |

---

## Task List

### Task 1: Domain Layer — `TVSeason` entity and `TVSeries` update — [ ]

**Goal**: Create the `TVSeason` domain entity and add seasons to `TVSeries`.

**TDD approach**: Write tests first, then implement.

**TDD Tests**:

*No dedicated domain entity tests needed — entities are simple value types. Tests are via mapper tests in Task 2 and Task 3.*

**Files to Create**:

| File | Purpose |
|------|---------|
| `Contexts/PopcornTVSeries/Sources/TVSeriesDomain/Entities/TVSeason.swift` | `TVSeason` entity: `id`, `name`, `seasonNumber`, `posterPath` |

**Files to Modify**:

| File | Change |
|------|--------|
| `Contexts/PopcornTVSeries/Sources/TVSeriesDomain/Entities/TVSeries.swift` | Add `public let seasons: [TVSeason]` with default `= []` |
| `Contexts/PopcornTVSeries/Tests/TVSeriesApplicationTests/Mocks/Models/TVSeries+Mocks.swift` | Add `seasons: [TVSeason] = []` param to `mock()` |
| `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/Mocks/Models/TVSeries+Mocks.swift` | Add `seasons: [TVSeason] = []` param to `mock()` |

**New Test Mock Files**:

| File | Purpose |
|------|---------|
| `Contexts/PopcornTVSeries/Tests/TVSeriesApplicationTests/Mocks/Models/TVSeason+Mocks.swift` | `TVSeason.mock()` factory |
| `Contexts/PopcornTVSeries/Tests/TVSeriesInfrastructureTests/Mocks/Models/TVSeason+Mocks.swift` | `TVSeason.mock()` factory |

**Verification**: Build the `PopcornTVSeries` package — all existing tests still pass.

---

### Task 2: Adapter Layer — `TVSeasonMapper` and `TVSeriesMapper` update — [ ]

**Goal**: Map `TMDb.TVSeason` to `TVSeriesDomain.TVSeason` and include seasons in TV series mapping.

**TDD Tests** (`PopcornTVSeriesAdapters/.../TVSeasonMapperTests.swift`):
1. `maps all properties from TMDb TV season to domain model`
2. `maps with nil posterPath`
3. `maps season with zero season number`
4. `preserves exact id, name, and seasonNumber values`

**TDD Tests** (update existing `PopcornTVSeriesAdapters/.../TVSeriesMapperTests.swift`):
5. `maps seasons array from TMDb TV series`
6. `maps nil seasons to empty array`
7. `maps empty seasons array to empty array`

**Files to Create**:

| File | Purpose |
|------|---------|
| `Adapters/Contexts/PopcornTVSeriesAdapters/Sources/PopcornTVSeriesAdapters/DataSources/Mappers/TVSeasonMapper.swift` | Mapper: `TMDb.TVSeason` → `TVSeriesDomain.TVSeason` |
| `Adapters/Contexts/PopcornTVSeriesAdapters/Tests/.../DataSources/Mappers/TVSeasonMapperTests.swift` | Unit tests |

**Files to Modify**:

| File | Change |
|------|--------|
| `Adapters/Contexts/PopcornTVSeriesAdapters/Sources/.../Mappers/TVSeriesMapper.swift` | Map `dto.seasons` via `TVSeasonMapper` |
| `Adapters/Contexts/PopcornTVSeriesAdapters/Tests/.../Mappers/TVSeriesMapperTests.swift` | Add seasons mapping tests |

**Verification**: `/test-package` for `PopcornTVSeriesAdapters` — all tests pass.

---

### Task 3: Application Layer — `TVSeasonSummary` model and mapper — [ ]

**Goal**: Create `TVSeasonSummary` application model with resolved poster URLs. Update `TVSeriesDetails` and its mapper.

**TDD Tests** (`TVSeriesApplicationTests/Mappers/TVSeasonSummaryMapperTests.swift`):
1. `maps TVSeason to TVSeasonSummary with resolved poster URL`
2. `maps TVSeason with nil posterPath to nil posterURL`
3. `preserves id, name, and seasonNumber`

**TDD Tests** (update existing `TVSeriesApplicationTests/Mappers/TVSeriesDetailsMapperTests.swift`):
4. `map includes seasons in TV series details`
5. `map returns empty seasons when TV series has no seasons`

**Files to Create**:

| File | Purpose |
|------|---------|
| `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/Models/TVSeasonSummary.swift` | Application model with resolved `posterURL` |
| `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/Mappers/TVSeasonSummaryMapper.swift` | Maps `TVSeason` + `ImagesConfiguration` → `TVSeasonSummary` |
| `Contexts/PopcornTVSeries/Tests/TVSeriesApplicationTests/Mappers/TVSeasonSummaryMapperTests.swift` | Unit tests |

**Files to Modify**:

| File | Change |
|------|--------|
| `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/Models/TVSeriesDetails.swift` | Add `seasons: [TVSeasonSummary]` with default `= []` |
| `Contexts/PopcornTVSeries/Sources/TVSeriesApplication/Mappers/TVSeriesDetailsMapper.swift` | Map seasons via `TVSeasonSummaryMapper`, include in return |
| `Contexts/PopcornTVSeries/Tests/TVSeriesApplicationTests/Mappers/TVSeriesDetailsMapperTests.swift` | Add tests for seasons in mapped output |

**Verification**: `/test-package` for `PopcornTVSeries` — all tests pass.

---

### Task 4: Feature Layer — Models, Mapper, and Reducer — [ ]

**Goal**: Add `TVSeasonPreview` feature model, update the feature mapper and reducer with season navigation.

**TDD Tests** (update existing `TVSeriesDetailsFeatureTests/Mappers/TVSeriesMapperTests.swift`):
1. `maps TVSeriesDetails with seasons to TVSeries with TVSeasonPreview array`
2. `maps TVSeriesDetails with empty seasons to empty array`
3. `maps season posterURL correctly`

**TDD Tests** (`TVSeriesDetailsFeatureTests/TVSeriesDetailsFeatureTests.swift`):
4. `fetch populates ViewSnapshot with seasons from client`
5. `navigate seasonDetails returns none` (passthrough to coordinator)

**Files to Create**:

| File | Purpose |
|------|---------|
| `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Models/TVSeasonPreview.swift` | Feature model: `id`, `seasonNumber`, `name`, `posterURL` |

**Files to Modify**:

| File | Change |
|------|--------|
| `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Models/TVSeries.swift` | Add `seasons: [TVSeasonPreview]` with default, update mock |
| `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Mappers/TVSeriesMapper.swift` | Map `tvSeriesDetails.seasons` → `[TVSeasonPreview]` |
| `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/TVSeriesDetailsFeature.swift` | Add `Navigation.seasonDetails(tvSeriesID:seasonNumber:)` |
| `Features/TVSeriesDetailsFeature/Tests/.../Mappers/TVSeriesMapperTests.swift` | Add seasons mapping tests |
| `Features/TVSeriesDetailsFeature/Tests/.../TVSeriesDetailsFeatureTests.swift` | Add fetch + navigation tests |
| `Features/TVSeriesDetailsFeature/Tests/.../TVSeriesDetailsFeatureFeatureFlagsTests.swift` | No changes needed (seasons not feature-flagged) |

**Verification**: `/test-package` for `TVSeriesDetailsFeature` — all tests pass.

---

### Task 5: Feature Layer — Views (Content View + Carousel) — [ ]

**Goal**: Extract `TVSeriesDetailsContentView`, create `SeasonsCarousel`, update `TVSeriesDetailsView`, add localisation.

**Files to Create**:

| File | Purpose |
|------|---------|
| `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Views/Components/SeasonsCarousel.swift` | Carousel using `PosterCarouselCell`, accessibility identifiers, `#Preview` |
| `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Views/TVSeriesDetailsContentView.swift` | Extracted content view with header, overlay, overview, seasons carousel, `#Preview` |

**Files to Modify**:

| File | Change |
|------|--------|
| `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Views/TVSeriesDetailsView.swift` | Remove content methods, delegate to `TVSeriesDetailsContentView` with `didSelectSeason` callback |
| `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Localizable.xcstrings` | Add `"SEASONS"` → `"Seasons"` |

**Reference Patterns**:
- `MovieDetailsContentView` — `Features/MovieDetailsFeature/Sources/MovieDetailsFeature/Views/MovieDetailsContentView.swift`
- `RecommendedCarousel` — `Features/MovieDetailsFeature/Sources/MovieDetailsFeature/Views/Components/RecommendedCarousel.swift`
- `TVSeriesCarousel` — `Features/ExploreFeature/Sources/ExploreFeature/Views/TVSeriesCarousel.swift`

**Verification**: `/build-package` for `TVSeriesDetailsFeature` — builds successfully. Visual preview in Xcode.

---

### Task 6: App Coordinator — Navigation Handling — [ ]

**Goal**: Handle season navigation in both `ExploreRootFeature` and `SearchRootFeature` with a placeholder destination.

**Files to Create**:

| File | Purpose |
|------|---------|
| `App/Features/TVSeasonDetailsPlaceholder/TVSeasonDetailsPlaceholder.swift` | Minimal `@Reducer` with `State(tvSeriesID:, seasonNumber:)` and `EmptyReducer` body |

**Files to Modify**:

| File | Change |
|------|--------|
| `App/Features/ExploreRoot/ExploreRootFeature.swift` | Add `tvSeasonDetails(TVSeasonDetailsPlaceholder)` to `Path`, handle `.seasonDetails` navigation |
| `App/Features/ExploreRoot/Views/ExploreRootView.swift` | Add destination view for `.tvSeasonDetails` |
| `App/Features/SearchRoot/SearchRootFeature.swift` | Same `Path` case and action handling |
| `App/Features/SearchRoot/Views/SearchRootView.swift` | Same destination rendering |

**Reference Pattern**: `ExploreRootFeature.swift` existing navigation handling (lines 72-93)

**Verification**: `/build` — full app builds with no warnings.

---

### Task 7: Final Verification, Code Review & PR — [ ]

**Goal**: Run full pre-PR checklist, perform adversarial code review, and create pull request.

**Steps**:
1. `/format` — auto-fix formatting
2. `/lint` — check style violations, fix any issues
3. `/build` — verify build succeeds (warnings are errors)
4. `/test` — all tests pass
5. Fix any issues found, re-run checklist if code changes were made
6. **Code Review** — Spawn the `code-reviewer` agent with the full git diff (`git diff main...HEAD`). The code reviewer performs an initial review, then an adversarial re-evaluation, and returns only the findings both passes agree on.
7. **Address findings**:
   - Fix all CRITICAL and HIGH issues
   - Discuss MEDIUM issues with the user
   - Note LOW issues for awareness
   - If code changes were made, re-run the pre-PR checklist (steps 1-5)
8. **Final summary** — Present the agreed-upon review to the user with:
   - Strengths of the implementation
   - Any remaining issues by severity
   - Assessment: Ready to merge / Needs fixes
9. `/pr` — create pull request with gitmoji title

**Verification**:
- [ ] Format passes
- [ ] Lint passes
- [ ] Build succeeds
- [ ] All tests pass (existing + new)
- [ ] Code review completed (adversarial review agreed)
- [ ] All CRITICAL and HIGH findings addressed
- [ ] PR created

---

## Task Dependency Order

```
Task 1 (Domain Entity)
  → Task 2 (Adapter Mapper)
    → Task 3 (Application Model + Mapper)
      → Task 4 (Feature Models + Mapper + Reducer)
        → Task 5 (Views + Localisation)
          → Task 6 (App Coordinator)
            → Task 7 (Verification & PR)
```

---

## Development Methodology

- **Strict TDD**: For each task, write failing tests FIRST, then implement the minimum code to make them pass
- **High code coverage**: Every new mapper, model, and reducer action has corresponding unit tests
- **Test-first order**: Tests → Implementation → Verify green → Refactor → Verify green
- **Package-level verification**: After each task, run `/test-package` for the affected package before moving on
- **Pre-PR full verification**: Run `/format`, `/lint`, `/build`, `/test` after final code change
- **Adversarial code review**: Spawn `code-reviewer` agent with full diff; initial review + adversarial re-evaluation; only present agreed findings

---

## Acceptance Criteria

- [ ] Seasons carousel appears below overview text on TV Series Details screen
- [ ] Carousel uses `PosterCarouselCell` with season poster images
- [ ] Season name displayed as label beneath each poster
- [ ] Section title "Seasons" shown above carousel
- [ ] Carousel hidden when TV series has 0 seasons
- [ ] Tapping a season navigates to a placeholder view
- [ ] Navigation works from both Explore and Search flows
- [ ] All new code has unit tests written via strict TDD
- [ ] All existing tests continue to pass
- [ ] `/format`, `/lint`, `/build`, `/test` all pass
- [ ] Adversarial code review completed — all CRITICAL and HIGH findings addressed
