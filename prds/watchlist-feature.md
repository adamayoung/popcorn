# PRD: Watchlist Feature

## Overview

Add a dedicated **Watchlist tab** to the Popcorn app that displays all movies the user has added to their watchlist in a poster image grid. Tapping a movie navigates to its detail screen. Also update the Movie Details toolbar icon for watchlist toggling with new icons and animation.

## Problem

Users can add movies to their watchlist from the Movie Details screen, but there is no way to view all watchlisted movies in one place. The watchlist data is stored locally via SwiftData with CloudKit sync but is only surfaced as an `isOnWatchlist` boolean on individual movie detail screens.

## Goals

1. Provide a dedicated Watchlist tab for browsing all watchlisted movies
2. Display movies as a poster image grid for visual browsing
3. Enable navigation from the watchlist to movie details
4. Improve the watchlist toolbar button with clearer iconography and animation

## Non-Goals

- TV series watchlist (movies only for this iteration)
- Watchlist sorting/filtering UI
- Watchlist sync with TMDb account (remains local + CloudKit)
- Reordering movies in the watchlist

---

## Requirements

### R1: Watchlist Tab

- A new tab item in the main app tab bar with the name **"Watchlist"** and SF Symbol **`eye`**
- Positioned between the Explore and Games tabs
- Gated behind the existing `.watchlist` feature flag
- Tab uses `.tabViewStyle(.sidebarAdaptable)` like other tabs

### R2: Fetch Watchlist Movies Use Case

- New `FetchWatchlistMovies` use case in the `PopcornMovies` context
- Fetches watchlist movie IDs from `MovieWatchlistRepository.movies()`
- Resolves each ID to full movie data via `MovieRepository.movie(withID:)` in parallel using `withThrowingTaskGroup`
- Maps results through `MoviePreviewDetailsMapper` to produce `[MoviePreviewDetails]` with full image URLs
- Results sorted by `createdAt` descending (most recently added first)
- Resilient: skips individual movies that fail to fetch rather than failing the entire request

### R3: Watchlist Screen

- Displays movies in a `LazyVGrid` with 3 flexible columns of poster images
- Each cell shows the movie poster using `PosterImage` from `DesignSystem`
- Supports `matchedTransitionSource` for zoom transitions to detail screens
- Loading state: `ProgressView` overlay
- Error state: `ContentUnavailableView` with retry button
- Empty state: `ContentUnavailableView` with appropriate messaging

### R4: Navigation to Movie Details

- Tapping a movie poster navigates to `MovieDetailsFeature`
- Uses delegate navigation pattern (feature emits `.navigate`, root feature intercepts)
- Supports deep navigation from movie details to other movies, people, etc.
- Zoom transition animation from poster to detail screen

### R5: Updated Toolbar Icons

- When movie is **not** on watchlist: SF Symbol **`plus`**
- When movie **is** on watchlist: SF Symbol **`eye`**
- Icon transition uses `.contentTransition(.symbolEffect(.replace))` for smooth morphing animation
- Existing `.sensoryFeedback(.selection)` retained

---

## Technical Design

### Architecture Layers

```
TMDb API / SwiftData+CloudKit
        |
MovieRepository / MovieWatchlistRepository (Infrastructure)
        |
FetchWatchlistMoviesUseCase (Application)
        |
TCA DependencyKey (AppDependencies)
        |
WatchlistClient (Feature)
        |
WatchlistFeature (TCA Reducer)
        |
WatchlistRootFeature (App - Navigation)
        |
AppRootFeature (App - Tab)
```

### Data Flow

1. `MovieWatchlistRepository.movies()` returns `Set<WatchlistMovie>` (id + createdAt) from SwiftData/CloudKit
2. For each watchlist movie ID, `MovieRepository.movie(withID:)` fetches full `Movie` data (cache-through: local SwiftData first, then TMDb API)
3. `Movie` is mapped to `MoviePreview` (lightweight subset: id, title, overview, releaseDate, posterPath, backdropPath)
4. Image collections fetched in parallel via `MovieImageRepository.imageCollection(forMovie:)`
5. `MoviePreviewDetailsMapper` converts poster/backdrop paths to full `ImageURLSet` URLs using `ImagesConfiguration`
6. `WatchlistClient` maps `MoviePreviewDetails` to feature-local `MoviePreview` (id, title, posterURL)
7. View displays poster grid

### Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| Parallel individual fetches via `TaskGroup` | TMDb has no batch endpoint for multiple movie IDs |
| Skip failed individual fetches | Watchlist should show available movies even if one is unavailable |
| Sort by `createdAt` descending | Most recently added movies shown first is the standard UX expectation |
| Reuse existing `.watchlist` feature flag | Avoids flag proliferation; watchlist tab and toolbar are conceptually linked |
| Feature-local `MoviePreview` model | Isolates the feature from domain changes, consistent with other features |

---

## Task List

### Task 1: `FetchWatchlistMovies` Use Case — [ ]

**Goal**: Create the use case in the `PopcornMovies` context package.

**TDD Tests** (`Contexts/PopcornMovies/Tests/MoviesApplicationTests/UseCases/FetchWatchlistMovies/DefaultFetchWatchlistMoviesUseCaseTests.swift`):
1. `execute returns movie preview details on success`
2. `execute returns empty array when watchlist is empty`
3. `execute sorts results by createdAt descending`
4. `execute throws unknown error when watchlist repository fails`
5. `execute skips movies that fail to fetch individually`

**Files to Create**:

| File | Purpose |
|------|---------|
| `.../MoviesApplication/UseCases/FetchWatchlistMovies/FetchWatchlistMoviesUseCase.swift` | Protocol: `func execute() async throws(FetchWatchlistMoviesError) -> [MoviePreviewDetails]` |
| `.../MoviesApplication/UseCases/FetchWatchlistMovies/FetchWatchlistMoviesError.swift` | Error enum: `.unauthorised`, `.unknown(Error?)` |
| `.../MoviesApplication/UseCases/FetchWatchlistMovies/DefaultFetchWatchlistMoviesUseCase.swift` | Implementation with `withThrowingTaskGroup` parallel fetching |
| `.../Tests/MoviesApplicationTests/UseCases/FetchWatchlistMovies/DefaultFetchWatchlistMoviesUseCaseTests.swift` | Unit tests |
| `.../Tests/MoviesApplicationTests/Mocks/MockMovieWatchlistRepository.swift` | Mock for `MovieWatchlistRepository` |
| `.../Tests/MoviesApplicationTests/Mocks/MockMovieRepository.swift` | Mock for `MovieRepository` |
| `.../Tests/MoviesApplicationTests/Mocks/MockMovieImageRepository.swift` | Mock for `MovieImageRepository` |
| `.../Tests/MoviesApplicationTests/Helpers/WatchlistMovie+Mocks.swift` | Test data helpers |

**Files to Modify**:

| File | Change |
|------|--------|
| `.../MoviesApplication/MoviesApplicationFactory.swift` | Add `makeFetchWatchlistMoviesUseCase()` |
| `.../MoviesComposition/PopcornMoviesFactory.swift` | Add protocol requirement |
| `.../MoviesComposition/LivePopcornMoviesFactory.swift` | Add implementation delegating to `applicationFactory` |

**Reference Patterns**:
- `DefaultFetchPopularMoviesUseCase` — parallel `TaskGroup` + `MoviePreviewDetailsMapper` usage
- `FetchPopularMoviesError` — error enum structure
- `DefaultFetchMovieCreditsUseCaseTests` — test structure with mock repositories

**Completion Checklist**:
- [ ] Tests written and passing
- [ ] Implementation complete
- [ ] Code reviewed
- [ ] Formatted and linted
- [ ] Committed (`feat: add FetchWatchlistMovies use case`)

---

### Task 2: Register TCA Dependency — [ ]

**Goal**: Wire `FetchWatchlistMoviesUseCase` into the TCA dependency system.

**Files to Create**:

| File | Purpose |
|------|---------|
| `AppDependencies/Sources/AppDependencies/Movies/FetchWatchlistMoviesUseCase+TCA.swift` | `DependencyKey` + `DependencyValues` extension for `fetchWatchlistMovies` |

**Reference Pattern**: `AppDependencies/Sources/AppDependencies/Movies/FetchPopularMoviesUseCase+TCA.swift`

**Completion Checklist**:
- [ ] Implementation complete
- [ ] Code reviewed
- [ ] Formatted and linted
- [ ] Committed (`feat: register FetchWatchlistMovies TCA dependency`)

---

### Task 3: `WatchlistFeature` SPM Package — [ ]

**Goal**: New TCA feature package showing watchlist movies in a poster grid.

**Package Structure**:
```
Features/WatchlistFeature/
  Package.swift
  .swiftformat
  Sources/WatchlistFeature/
    WatchlistFeature.swift            # TCA Reducer
    WatchlistClient.swift             # @DependencyClient
    Logger.swift                      # OSLog logger
    Localizable.xcstrings             # Localized strings
    Models/
      MoviePreview.swift              # Feature-local model (id, title, posterURL)
    Mappers/
      MoviePreviewMapper.swift        # MoviePreviewDetails -> MoviePreview
    Views/
      WatchlistView.swift             # LazyVGrid poster grid
  Tests/WatchlistFeatureTests/
    WatchlistFeatureFetchTests.swift
    WatchlistFeatureNavigationTests.swift
    WatchlistClientTests.swift
    Mappers/
      MoviePreviewMapperTests.swift
    Mocks/
      MockFetchWatchlistMoviesUseCase.swift
```

**TDD Tests**:

`WatchlistFeatureFetchTests.swift`:
1. `fetch sets loading state`
2. `moviesLoaded sets ready state with movies`
3. `loadFailed sets error state`

`WatchlistFeatureNavigationTests.swift`:
1. `navigate movieDetails does not change state` (parent handles)

`WatchlistClientTests.swift`:
1. `fetchWatchlistMovies maps use case result to movie previews`

`MoviePreviewMapperTests.swift`:
1. `maps MoviePreviewDetails to MoviePreview`
2. `maps MoviePreviewDetails with nil poster URL set`

**Reducer Design**:
- `@ObservableState` State with `viewState: ViewState<ViewSnapshot>`
- `ViewSnapshot` containing `movies: [MoviePreview]`
- Actions: `fetch`, `moviesLoaded`, `loadFailed`, `navigate(Navigation)`
- `Navigation` enum: `.movieDetails(id: Int, transitionID: String?)`

**View Design**:
- `ScrollView` with `LazyVGrid` (3 flexible columns)
- `PosterImage` from `DesignSystem` for each cell
- `matchedTransitionSource` for zoom transitions
- `ContentUnavailableView` for empty and error states
- `ProgressView` overlay for loading

**Client Design**:
- `@DependencyClient struct WatchlistClient`
- `liveValue` calls `fetchWatchlistMovies` use case, maps via `MoviePreviewMapper`
- `previewValue` returns mock data

**Reference Patterns**:
- `TrendingMoviesFeature` — Package.swift, reducer, client, model, mapper, view, tests
- `GamesCatalogView` — `LazyVGrid` layout
- `PosterImage` — poster display component
- `ViewState` from `TCAFoundation`

**Completion Checklist**:
- [ ] Tests written and passing
- [ ] Implementation complete
- [ ] Code reviewed
- [ ] Formatted and linted
- [ ] Committed (`feat: add WatchlistFeature package`)

---

### Task 4: `WatchlistRootFeature` (App Level) — [ ]

**Goal**: App-level root feature owning the `NavigationStack` and intercepting navigation actions.

**Files to Create**:

| File | Purpose |
|------|---------|
| `App/Features/WatchlistRoot/WatchlistRootFeature.swift` | Reducer with `StackState<Path.State>`, scopes `WatchlistFeature` |
| `App/Features/WatchlistRoot/Views/WatchlistRootView.swift` | `NavigationStack` with destination switching + `@Namespace` for zoom transitions |

**Design**:
- `Path` cases: `.movieDetails(MovieDetailsFeature)`, `.personDetails(PersonDetailsFeature)`
- Intercepts navigation actions from `WatchlistFeature` and nested detail features
- Pushes to `StackState` for drill-down navigation
- View wraps `WatchlistView` in `NavigationStack`

**Reference Patterns**:
- `App/Features/SearchRoot/SearchRootFeature.swift` — simplest root feature with stack navigation
- `App/Features/SearchRoot/Views/SearchRootView.swift` — root view with `NavigationStack`

**Completion Checklist**:
- [ ] Implementation complete
- [ ] Code reviewed
- [ ] Formatted and linted
- [ ] Committed (`feat: add WatchlistRootFeature`)

---

### Task 5: Integrate Watchlist Tab into `AppRootFeature` — [ ]

**Goal**: Add the Watchlist tab between Explore and Games, gated by the `.watchlist` feature flag.

**Files to Modify**:

| File | Change |
|------|--------|
| `App/Features/AppRoot/AppRootFeature.swift` | Add `.watchlist` case to `Tab` enum with `id: "popcorn.tab.watchlist"`. Add `var watchlist = WatchlistRootFeature.State()` and `var isWatchlistEnabled: Bool = false` to State. Add `case watchlist(WatchlistRootFeature.Action)` to Action. Add `Scope(state: \.watchlist, action: \.watchlist) { WatchlistRootFeature() }`. Read flag in `updateFeatureFlags`. |
| `App/Features/AppRoot/AppRootClient.swift` | Add `var isWatchlistEnabled: @Sendable () throws -> Bool`. Wire to `featureFlags.isEnabled(.watchlist)` in `liveValue`. |
| `App/Features/AppRoot/Views/AppRootView.swift` | Add `Tab("WATCHLIST", systemImage: "eye", value: .watchlist)` between Explore and Games tabs, gated by `store.isWatchlistEnabled`. Add `.customizationID(AppRootFeature.Tab.watchlist.id)`. |

**Xcode Project**:
- Add `WatchlistFeature` as a local SPM package dependency
- Link `WatchlistFeature` library to the app target

**Completion Checklist**:
- [ ] Implementation complete
- [ ] Code reviewed
- [ ] Formatted and linted
- [ ] Committed (`feat: integrate Watchlist tab into AppRoot`)

---

### Task 6: Update MovieDetailsFeature Toolbar Icons — [ ]

**Goal**: Change watchlist toolbar button icons and add symbol transition animation.

**Files to Modify**:

| File | Change |
|------|--------|
| `Features/MovieDetailsFeature/Sources/MovieDetailsFeature/Views/MovieDetailsView.swift` | Change `systemImage` from `"eye.square.fill"/"eye.square"` to `"eye"/"plus"`. Add `.contentTransition(.symbolEffect(.replace))`. |

**Before**:
```swift
Button(
    snapshot.movie.isOnWatchlist ? "REMOVE_FROM_WATCHLIST" : "ADD_TO_WATCHLIST",
    systemImage: snapshot.movie.isOnWatchlist ? "eye.square.fill" : "eye.square"
) {
    store.send(.toggleOnWatchlist)
}
.sensoryFeedback(.selection, trigger: snapshot.movie.isOnWatchlist)
```

**After**:
```swift
Button(
    snapshot.movie.isOnWatchlist ? "REMOVE_FROM_WATCHLIST" : "ADD_TO_WATCHLIST",
    systemImage: snapshot.movie.isOnWatchlist ? "eye" : "plus"
) {
    store.send(.toggleOnWatchlist)
}
.contentTransition(.symbolEffect(.replace))
.sensoryFeedback(.selection, trigger: snapshot.movie.isOnWatchlist)
```

**Completion Checklist**:
- [ ] Implementation complete
- [ ] Code reviewed
- [ ] Formatted and linted
- [ ] Committed (`feat: update watchlist toolbar icons with replace animation`)

---

### Task 7: Final Verification & PR — [ ]

**Goal**: Run full pre-PR checklist and create pull request.

**Steps**:
1. `/format` — auto-fix formatting
2. `/lint` — check style violations, fix any issues
3. `/build` — verify build succeeds with no warnings (warnings are errors)
4. `/test` — all tests pass
5. Fix any issues found, re-run checklist if code changes made
6. `/pr` — create pull request

**Completion Checklist**:
- [ ] Format passes
- [ ] Lint passes
- [ ] Build succeeds
- [ ] All tests pass
- [ ] PR created

---

## Task Dependency Order

```
Task 1 (Use Case)
  → Task 2 (TCA Dependency)
    → Task 3 (Feature Package)
      → Task 4 (Root Feature)
        → Task 5 (AppRoot Integration)
          → Task 6 (Toolbar Update)
            → Task 7 (Verification & PR)
```

---

## Acceptance Criteria

- [ ] Watchlist tab appears between Explore and Games when `.watchlist` feature flag is enabled
- [ ] Tab uses SF Symbol `eye` and label "Watchlist"
- [ ] Watchlist screen displays movies as a poster image grid (3 columns)
- [ ] Movies are sorted by most recently added first
- [ ] Loading, empty, and error states are handled
- [ ] Tapping a movie poster navigates to the Movie Details screen with zoom transition
- [ ] Movie Details toolbar shows `plus` icon when not on watchlist
- [ ] Movie Details toolbar shows `eye` icon when on watchlist
- [ ] Icon animates with `.contentTransition(.symbolEffect(.replace))` when toggled
- [ ] All new code has unit tests (TDD approach)
- [ ] `/format`, `/lint`, `/build`, `/test` all pass
