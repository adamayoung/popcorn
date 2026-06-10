# Architecture

Use `/add-context`, `/add-feature`, `/add-use-case`, or `/add-screen` for guided scaffolding of new architectural components.

Popcorn follows Clean Architecture with Domain-Driven Design, using MVVM (`@Observable` view models) for presentation and state management.

## Directory Structure

```
popcorn/
├── App/                    # Application shell & platform scenes
├── Contexts/               # Business domains (Domain → Application → Infrastructure)
├── Features/               # MVVM feature modules (UI vertical slices)
├── Adapters/               # Bridge contexts to external services
├── AppDependencies/        # Central dependency injection hub
├── Platform/               # Cross-cutting concerns (Caching, Observability, etc.)
├── Core/                   # Shared foundation (DesignSystem, CoreDomain)
└── Configs/                # Build configuration & secrets
```

## Contexts: Business Domains

A Context is a self-contained business domain. Each follows a 4-layer structure with strict dependency rules.

### Layer Structure

```
Contexts/PopcornMovies/
├── Sources/
│   ├── MoviesDomain/           # Layer 1: Pure business logic (NO dependencies)
│   ├── MoviesApplication/      # Layer 2: Use cases (depends on Domain)
│   ├── MoviesInfrastructure/   # Layer 3: Data sources (depends on Domain)
│   └── MoviesComposition/      # Layer 4: Wiring (depends on all above)
└── Tests/
```

### Domain Layer

Defines entities, repository protocols, and data source contracts.

```swift
// Entities/Movie.swift
public struct Movie: Identifiable, Equatable, Sendable {
    public let id: Int
    public let title: String
    public let overview: String
    public let releaseDate: Date?
}

// Repositories/MovieRepository.swift
public protocol MovieRepository: Sendable {
    func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie
    func movieStream(withID id: Int) async -> AsyncThrowingStream<Movie?, Error>
}
```

### Application Layer

Implements use cases. Each use case lives in its own directory:

```
MoviesApplication/UseCases/FetchMovieDetails/
├── FetchMovieDetailsUseCase.swift        # Protocol
├── DefaultFetchMovieDetailsUseCase.swift # Implementation
└── FetchMovieDetailsError.swift          # Errors
```

```swift
public protocol FetchMovieDetailsUseCase: Sendable {
    func execute(id: Movie.ID) async throws(FetchMovieDetailsError) -> MovieDetails
}

final class DefaultFetchMovieDetailsUseCase: FetchMovieDetailsUseCase {
    private let movieRepository: any MovieRepository

    func execute(id: Movie.ID) async throws(FetchMovieDetailsError) -> MovieDetails {
        let movie = try await movieRepository.movie(withID: id)
        return MovieDetailsMapper().map(movie)
    }
}
```

The `MoviesApplicationFactory` creates all use cases:

```swift
public final class MoviesApplicationFactory {
    func makeFetchMovieDetailsUseCase() -> some FetchMovieDetailsUseCase {
        DefaultFetchMovieDetailsUseCase(movieRepository: movieRepository)
    }
}
```

> **Note:** `*ApplicationFactory` classes use `package` visibility, consumed only by their sibling Composition targets within the same Swift package.

### Infrastructure Layer

Implements repositories and data sources using SwiftData and external APIs.

#### Directory Structure

```
MoviesInfrastructure/
├── DataSources/
│   ├── Local/
│   │   ├── SwiftDataMovieLocalDataSource.swift  # SwiftData implementation
│   │   ├── Models/
│   │   │   └── MovieEntity.swift                # SwiftData @Model
│   │   └── Mappers/
│   │       └── MovieEntityMapper.swift          # Entity ↔ Domain mapping
│   └── Protocols/
│       ├── Local/
│       │   └── MovieLocalDataSource.swift       # Local data source protocol
│       └── Remote/
│           └── MovieRemoteDataSource.swift      # Remote data source protocol
├── Repositories/
│   └── DefaultMovieRepository.swift
└── MoviesInfrastructureFactory.swift
```

#### Data Source Protocols

Data source protocols define contracts for data access. Place them in `Protocols/Local/` or `Protocols/Remote/`:

```swift
// Protocols/Remote/MovieRemoteDataSource.swift
public protocol MovieRemoteDataSource: Sendable {
    func movie(withID id: Int) async throws(MovieRemoteDataSourceError) -> Movie
    func credits(forMovie movieID: Int) async throws(MovieRemoteDataSourceError) -> Credits
}

public enum MovieRemoteDataSourceError: Error {
    case notFound
    case unauthorised
    case unknown(Error? = nil)
}
```

```swift
// Protocols/Local/MovieLocalDataSource.swift
public protocol MovieLocalDataSource: Actor {
    func movie(withID id: Int) async throws -> Movie?
    func setMovie(_ movie: Movie) async throws
}
```

**Key differences:**
- Remote protocols use `Sendable` conformance
- Local protocols use `Actor` for thread-safe SwiftData access
- Remote protocols have typed throws; local protocols use optional returns for cache misses

#### Local Data Source Implementation

Local data sources use SwiftData with actor isolation:

```swift
// DataSources/Local/SwiftDataMovieLocalDataSource.swift
@ModelActor
public actor SwiftDataMovieLocalDataSource: MovieLocalDataSource {

    public func movie(withID id: Int) async throws -> Movie? {
        let predicate = #Predicate<MovieEntity> { $0.movieID == id }
        let descriptor = FetchDescriptor(predicate: predicate)

        guard let entity = try modelContext.fetch(descriptor).first else {
            return nil
        }

        return MovieEntityMapper().mapToDomain(entity)
    }

    public func setMovie(_ movie: Movie) async throws {
        let entity = MovieEntityMapper().mapToEntity(movie)
        modelContext.insert(entity)
        try modelContext.save()
    }
}
```

#### Remote Data Source Implementation

Remote data sources are implemented in the Adapters layer, not Infrastructure:

```swift
// Adapters/Contexts/PopcornMoviesAdapters/DataSources/TMDbMovieRemoteDataSource.swift
// Concrete adapters stay `internal`; the factory exposes them only as `some Port`.
final class TMDbMovieRemoteDataSource: MovieRemoteDataSource {
    private let movieService: any TMDb.MovieService

    func movie(withID id: Int) async throws(MovieRemoteDataSourceError) -> Movie {
        do {
            let dto = try await movieService.details(forMovie: id)
            return MovieMapper().map(dto)
        } catch let error as TMDbError {
            throw error.toDataSourceError()
        }
    }
}
```

#### Repository Implementation

Repositories coordinate between local and remote data sources:

```swift
// Repositories/DefaultMovieRepository.swift
final class DefaultMovieRepository: MovieRepository {
    private let remoteDataSource: any MovieRemoteDataSource
    private let localDataSource: any MovieLocalDataSource

    func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie {
        // Try local cache first
        if let cached = try await localDataSource.movie(withID: id) {
            return cached
        }
        // Fetch from remote, cache result
        let movie = try await remoteDataSource.movie(withID: id)
        try await localDataSource.setMovie(movie)
        return movie
    }
}
```

#### Infrastructure Factory

Creates repositories with injected data sources:

```swift
// MoviesInfrastructureFactory.swift
package final class MoviesInfrastructureFactory {
    private let remoteDataSource: any MovieRemoteDataSource
    private let localDataSource: any MovieLocalDataSource

    package init(
        remoteDataSource: some MovieRemoteDataSource,
        modelContainer: ModelContainer
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = SwiftDataMovieLocalDataSource(modelContainer: modelContainer)
    }

    package func makeMovieRepository() -> some MovieRepository {
        DefaultMovieRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
    }
}
```

#### Adding a New Data Source

1. Create protocol in `Protocols/Local/` or `Protocols/Remote/`:
   ```swift
   // Protocols/Remote/MovieCreditsRemoteDataSource.swift
   public protocol MovieCreditsRemoteDataSource: Sendable {
       func credits(forMovie movieID: Int) async throws(MovieCreditsRemoteDataSourceError) -> Credits
   }
   ```

2. For local data sources, create SwiftData entity and mapper:
   ```
   DataSources/Local/Models/CreditsEntity.swift
   DataSources/Local/Mappers/CreditsEntityMapper.swift
   ```

3. Implement the data source (local in Infrastructure, remote in Adapters)

4. Update the Infrastructure factory to expose the new data source

SwiftData entities are internal to Infrastructure and mapped to domain entities at boundaries.

### Composition Layer

The public API: a concrete `Popcorn{Context}Factory` (a `Sendable` final class) that
wires the Infrastructure and Application factories together and vends the context's
use cases. There is **no** factory protocol — the concrete factory *is* the public
API (consistent with the adapter factories). Its initialiser takes the context's
**ports** (remote data sources, providers); the adapters that satisfy those ports are
built by the Adapters layer and supplied by the composition root (`AppServices`), so
this layer never references the TMDb SDK.

```swift
public final class PopcornMoviesFactory: Sendable {
    private let applicationFactory: MoviesApplicationFactory

    public init(
        movieRemoteDataSource: some MovieRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding,
        themeColorProvider: (any ThemeColorProviding)? = nil
    ) {
        let infrastructure = MoviesInfrastructureFactory(movieRemoteDataSource: movieRemoteDataSource)
        self.applicationFactory = MoviesApplicationFactory(
            movieRepository: infrastructure.makeMovieRepository()
        )
    }

    public func makeFetchMovieDetailsUseCase() -> FetchMovieDetailsUseCase {
        applicationFactory.makeFetchMovieDetailsUseCase()
    }
}
```

## Features: MVVM UI Modules

Features are vertical slices containing an `@Observable` view model, a per-feature dependencies struct, a navigation protocol, SwiftUI views, and feature-local models.

The canonical reference feature is `Features/MovieDetailsFeature` — model new features on it.

### Structure

The primary view, view model, dependencies, and navigation protocol live at the
**root** of the source folder — not in `View/` or `ViewModel/` subfolders. `Views/`
holds the subviews the main view composes (content views, rows, sections, cards,
carousels) and is omitted entirely when the feature has none.

```
Features/MovieDetailsFeature/
├── Sources/MovieDetailsFeature/
│   ├── MovieDetailsView.swift             # Main view — owns the VM via @State
│   ├── MovieDetailsViewModel.swift        # @Observable @MainActor view model
│   ├── MovieDetailsDependencies.swift     # Sendable struct of @Sendable closures
│   ├── MovieDetailsNavigating.swift       # @MainActor navigation protocol
│   ├── Logger.swift                       # OSLog category
│   ├── Models/                            # Feature-specific models
│   ├── Mappers/                           # Transform application → feature models
│   └── Views/                             # Subviews the main view composes
└── Tests/
```

A feature that presents several distinct screens groups each screen's views into
its own folder (the screen's main view at the folder root, a nested `Views/` for
its components), all driven by the single feature view model. For example,
`PlotRemixGameFeature` keeps one `PlotRemixGameViewModel` and groups screens into
`PlotRemixGameStart/` and `PlotRemixGameQuestions/`. These screen views are stateless
— they take plain data and action closures from the parent.

### View Model

A feature's view model is an `@Observable @MainActor final class` that exposes a single
`viewState` driving the view. `ViewState<Content>` lives in the `Presentation` module and
has four cases: `.initial`, `.loading`, `.ready(Content)`, `.error(ViewStateError)`.

```swift
@Observable
@MainActor
public final class MovieDetailsViewModel {

    public typealias ViewSnapshot = MovieDetailsViewSnapshot

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. `reload()` bumps it to retry after an error.
    public private(set) var reloadID = 0

    public let movieID: Int

    private let dependencies: MovieDetailsDependencies
    private let navigator: any MovieDetailsNavigating

    public init(
        movieID: Int,
        dependencies: MovieDetailsDependencies,
        navigator: any MovieDetailsNavigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.movieID = movieID
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
    }

    /// Driven by the view's `.task(id:)`; SwiftUI cancels it on disappear and
    /// reruns it on reappear / `reload()`.
    public func load() async {
        guard !viewState.isReady, !viewState.isLoading else { return }
        viewState = .loading
        do {
            let movie = try await dependencies.fetchMovie(movieID)
            viewState = .ready(ViewSnapshot(movie: movie))
        } catch {
            viewState.applyLoadFailure(error)
        }
    }

    public func reload() {
        reloadID += 1
    }

    // Navigation requests are delegated to the injected navigator.
    public func selectPerson(id: Int) {
        navigator.openPersonDetails(id: id)
    }
}
```

### Feature Dependencies

Each feature declares a `Sendable` struct of `@Sendable` closures — the dependency surface
the view model needs. Constructing it requires every closure, so a missing dependency is a
compile error. Build the production instance with `static func live(services:)`, which reads
use cases and feature flags from the shared `AppServices` graph.

```swift
public struct MovieDetailsDependencies: Sendable {

    public var fetchMovie: @Sendable (_ id: Int) async throws -> Movie
    public var toggleOnWatchlist: @Sendable (_ id: Int) async throws -> Void
    public var isWatchlistEnabled: @Sendable () throws -> Bool

    public init(/* ... */) { /* ... */ }
}

public extension MovieDetailsDependencies {

    /// Builds the production dependencies from the app's shared services.
    static func live(services: AppServices) -> MovieDetailsDependencies {
        let fetchMovieDetails = services.moviesFactory.makeFetchMovieDetailsUseCase()
        let toggleWatchlistMovie = services.moviesFactory.makeToggleWatchlistMovieUseCase()
        let featureFlags = services.featureFlags

        return MovieDetailsDependencies(
            fetchMovie: { id in
                let details = try await fetchMovieDetails.execute(id: id)
                return MovieMapper().map(details)
            },
            toggleOnWatchlist: { id in
                try await toggleWatchlistMovie.execute(id: id)
            },
            isWatchlistEnabled: { featureFlags.isEnabled(.watchlist) }
        )
    }
}
```

A `#if DEBUG` `static var preview` provides mock dependencies for previews and snapshot tests.

### Feature Navigation Protocol

Each feature declares a `@MainActor` `*Navigating` protocol describing the navigation actions
its view model can request. The App layer supplies a concrete implementation; the feature
package never knows about routes or other features.

```swift
@MainActor
public protocol MovieDetailsNavigating {
    func openPersonDetails(id: Int)
    func openMovieCastAndCrew(movieID: Int)
    func openMovieIntelligence(id: Int)
}
```

### View

The SwiftUI `*View` owns its view model via `@State private var viewModel` and an
`init(viewModel:)`, and drives loading from a `.task(id:)` keyed on `reloadID`:

```swift
public struct MovieDetailsView: View {

    @State private var viewModel: MovieDetailsViewModel

    public init(viewModel: MovieDetailsViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .ready(let snapshot): content(snapshot)
            case .error(let error): errorBody(error)
            default: EmptyView()
            }
        }
        .overlay { if viewModel.viewState.isLoading { ProgressView() } }
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }
}
```

## AppDependencies: Composition Root

`AppServices` (in `AppDependencies/Sources/AppDependencies/Composition/`) is the shared
composition root. It builds the app's service and context-factory graph exactly once, in
dependency order, with no global registry — plain sequential construction.

```
AppDependencies/
├── Composition/
│   ├── AppServices.swift             # Shared service + factory graph (built once)
│   ├── AppServices+Composition.swift # buildGraph(...) — constructs the graph in order
│   └── AppServices+Platform.swift    # Platform services (feature flags, observability)
└── TMDb/
    └── TMDbAPIKeyProvider.swift
```

```swift
// AppServices.swift
public final class AppServices: Sendable {

    public let moviesFactory: PopcornMoviesFactory
    public let tvSeriesFactory: PopcornTVSeriesFactory
    public let peopleFactory: PopcornPeopleFactory
    // ... other context factories ...

    public let featureFlags: any FeatureFlagging
    public let observability: any Observing

    public init(/* ... */) {
        let graph = Self.buildGraph(/* ... */)
        self.moviesFactory = graph.moviesFactory
        // ... assign the rest of the graph ...
    }
}
```

Each feature's `Dependencies.live(services:)` reads use cases and platform services off this
graph (e.g. `services.moviesFactory.makeFetchMovieDetailsUseCase()`,
`services.featureFlags`).

## Adapters: External Service Bridges

Adapters implement a context's **ports** (its `*RemoteDataSource` / provider
protocols) using external services (the TMDb SDK). A `Popcorn{Context}AdaptersFactory`
exposes those adapters through `make…() -> some Port` methods — it returns the
adapters, **not** the context factory, and does **not** depend on the context's
`Composition` module. That keeps the adapters package a leaf; the composition root
(`AppServices`) assembles the `Popcorn{Context}Factory` from these adapters.

```swift
public final class PopcornMoviesAdaptersFactory {
    private let movieService: any TMDb.MovieService  // TMDb SDK

    public func makeMovieRemoteDataSource() -> some MovieRemoteDataSource {
        TMDbMovieRemoteDataSource(movieService: movieService)
    }

    public func makeAppConfigurationProvider() -> some AppConfigurationProviding {
        AppConfigurationProviderAdapter(fetchUseCase: fetchAppConfigurationUseCase)
    }
}
```

Non-adapter concerns (`themeColorProvider`, `observability`, a `modelContainer`)
are **not** passed through this factory — the composition root supplies them
directly to the context factory.

## Dependency Flow

```
MovieDetailsView (@State viewModel)
    ↓
MovieDetailsViewModel                 # Feature view model
    ↓
MovieDetailsDependencies              # Per-feature Sendable struct of closures
    ↓  (.live(services:))
AppServices                           # Composition root — assembles each context factory:
    ├─ PopcornMoviesAdaptersFactory   #   builds the TMDb-backed adapters (ports)
    └─ PopcornMoviesFactory(…)        #   wired from those adapters (Composition layer)
           ↓
       {Application, Infrastructure, Domain}
```

`AppServices` is the single place that wires adapters into context factories: it
builds the `Popcorn{Context}AdaptersFactory`, calls its `make…()` methods to get the
port implementations, and passes them into `Popcorn{Context}Factory`.

## Navigation Patterns

Navigation lives in the App layer. Each tab has an `@Observable` `*Router` (owns a typed
`Route` stack and any modal items) and a `*RouterNavigator` value type that implements every
feature `*Navigating` protocol reachable from that tab, translating navigation requests into
router mutations. View models stay route-agnostic — they only call their `*Navigating`
protocol.

### Stack Navigation

```swift
/// A pushed destination on the Explore tab's navigation stack.
enum ExploreRoute: Hashable {
    case movieDetails(id: Int, transitionID: String?)
    case personDetails(id: Int, transitionID: String?)
    // ...
}

@Observable
@MainActor
final class ExploreRouter {
    /// Bound to the root's `NavigationStack(path:)`.
    var path: [ExploreRoute] = []
}

/// Translates leaf-feature navigation requests into `ExploreRouter` mutations.
@MainActor
struct ExploreRouterNavigator: MovieDetailsNavigating, PersonDetailsNavigating /* ... */ {
    let router: ExploreRouter

    func openMovieDetails(id: Int) {
        router.path.append(.movieDetails(id: id, transitionID: nil))
    }

    func openPersonDetails(id: Int) {
        router.path.append(.personDetails(id: id, transitionID: nil))
    }
}
```

The root view drives a `NavigationStack(path:)` bound to `router.path` and builds each
destination's view model via the `ViewModelFactory`, injecting a navigator bound to the router:

```swift
NavigationStack(path: $router.path) {
    ExploreView(viewModel: exploreViewModel, transitionNamespace: namespace)
        .navigationDestination(for: ExploreRoute.self) { route in
            destination(route)   // builds the screen's view model + navigator
        }
}
```

### Modal Navigation

Modals are an optional item on the router, presented with `.sheet(item:)` /
`.fullScreenCover(item:)` (the project wraps these as `.platformModal(item:)`):

```swift
@Observable
@MainActor
final class ExploreRouter {
    var presentedMovieIntelligence: PresentedMovieIntelligence?
}

// Navigator presents instead of pushing
func openMovieIntelligence(id: Int) {
    router.presentedMovieIntelligence = PresentedMovieIntelligence(movieID: id)
}

// Root view
.platformModal(item: $router.presentedMovieIntelligence) { intel in
    MovieIntelligenceView(viewModel: factory.makeMovieIntelligence(movieID: intel.movieID))
}
```

### ViewModelFactory

`ViewModelFactory` (in `App/Composition/`) is the App-layer seam that builds each feature's
view model from the shared `AppServices` graph, wiring `Dependencies.live(services:)` to a
navigator supplied by the tab's router:

```swift
@MainActor
final class ViewModelFactory {
    private let services: AppServices

    func makeMovieDetails(
        id: Int,
        navigator: some MovieDetailsNavigating
    ) -> MovieDetailsViewModel {
        MovieDetailsViewModel(
            movieID: id,
            dependencies: .live(services: services),
            navigator: navigator
        )
    }
}
```

## Platform Packages

### Caching

Actor-based in-memory cache with TTL:

```swift
public protocol Caching: Actor {
    func item<Item>(forKey key: CacheKey, ofType type: Item.Type) async -> Item?
    func setItem(_ item: some Any, forKey key: CacheKey, expiresIn: TimeInterval) async
}
```

### Observability

Transaction tracking and error capture:

```swift
public protocol Observing: Sendable {
    func startTransaction(name: String, operation: SpanOperation) -> Transaction
    func capture(error: any Error)
}
```

### FeatureAccess

Feature flag evaluation:

```swift
public protocol FeatureFlagging: Sendable {
    func isEnabled(_ flag: FeatureFlag) -> Bool
}
```

## App Shell

The app builds the shared `AppServices` graph and a `ViewModelFactory` once at launch, then
hands them to platform-specific scenes alongside the root `AppRootViewModel`:

```swift
@main
struct PopcornApp: App {
    @State private var viewModel: AppRootViewModel
    private let factory: ViewModelFactory

    init() {
        let services = AppServices()
        self.factory = ViewModelFactory(services: services)
        _viewModel = State(
            initialValue: AppRootViewModel(dependencies: .live(services: services))
        )
    }

    var body: some Scene {
        #if os(macOS)
            MacScene(viewModel: viewModel, factory: factory)
        #elseif os(visionOS)
            VisionScene(viewModel: viewModel, factory: factory)
        #else
            PhoneScene(viewModel: viewModel, factory: factory)
        #endif
    }
}
```

## Common Workflows

Use the corresponding skills for step-by-step guides:
- `/add-use-case` — Add a use case to an existing context
- `/add-screen` — Add a screen to an existing feature
- `/add-feature` — Create a new MVVM feature package
- `/add-context` — Create a new business domain context

For cross-context communication patterns, see the section below.

### Cross-Context Communication

When one context needs another's data:

1. Define provider protocol in consuming context's Domain:
   ```swift
   // ChatDomain/Providers/MoviesChatToolsProviding.swift
   public protocol MoviesChatToolsProviding: Sendable {
       func fetchMovie(id: Int) async throws -> Movie
   }
   ```

2. Implement in providing context's Composition:
   ```swift
   // MoviesComposition/ChatToolsAdapter.swift
   extension PopcornMoviesFactory: MoviesChatToolsProviding {
       public func fetchMovie(id: Int) async throws -> Movie {
           try await makeFetchMovieDetailsUseCase().execute(id: id)
       }
   }
   ```

3. Consume via the shared services graph — the consuming context's factory is built with the
   provider obtained from `AppServices`:
   ```swift
   // AppServices+Composition.swift (buildGraph)
   // The movies factory already conforms to MoviesChatToolsProviding, so it is passed
   // straight into the chat/intelligence factory as the provider.
   let intelligenceFactory = PopcornIntelligenceFactory(
       moviesChatToolsProvider: moviesFactory
   )
   ```
