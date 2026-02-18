# Architecture

Use `/add-context`, `/add-feature`, `/add-use-case`, or `/add-screen` for guided scaffolding of new architectural components.

Popcorn follows Clean Architecture with Domain-Driven Design, using The Composable Architecture (TCA) for state management.

## Directory Structure

```
popcorn/
├── App/                    # Application shell & platform scenes
├── Contexts/               # Business domains (Domain → Application → Infrastructure)
├── Features/               # TCA feature modules (UI vertical slices)
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
public final class TMDbMovieRemoteDataSource: MovieRemoteDataSource {
    private let movieService: any MovieService

    public func movie(withID id: Int) async throws(MovieRemoteDataSourceError) -> Movie {
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

Public API that wires everything together:

```swift
public struct PopcornMoviesFactory {
    public init(
        movieRemoteDataSource: some MovieRemoteDataSource,
        appConfigurationProvider: some AppConfigurationProviding
    ) {
        let infrastructure = MoviesInfrastructureFactory(movieRemoteDataSource: movieRemoteDataSource)
        self.applicationFactory = MoviesApplicationFactory(
            movieRepository: infrastructure.makeMovieRepository()
        )
    }

    public func makeFetchMovieDetailsUseCase() -> some FetchMovieDetailsUseCase {
        applicationFactory.makeFetchMovieDetailsUseCase()
    }
}
```

## Features: TCA UI Modules

Features are vertical slices containing TCA reducers, views, and clients.

### Structure

```
Features/MovieDetailsFeature/
├── Sources/MovieDetailsFeature/
│   ├── MovieDetailsFeature.swift   # TCA Reducer
│   ├── MovieDetailsClient.swift    # Dependency bridge
│   ├── Views/                      # SwiftUI views
│   ├── Models/                     # Feature-specific models
│   └── Mappers/                    # Transform application → feature models
└── Tests/
```

### TCA Reducer

```swift
@Reducer
public struct MovieDetailsFeature: Sendable {
    @Dependency(\.movieDetailsClient) private var client

    @ObservableState
    public struct State: Sendable {
        let movieID: Int
        var viewState: ViewState
    }

    public enum ViewState: Sendable {
        case initial
        case loading
        case ready(ViewSnapshot)
        case error(Error)
    }

    public enum Action {
        case didAppear
        case fetch
        case loaded(ViewSnapshot)
        case navigate(Navigation)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetch:
                return .run { [state] send in
                    let movie = try await client.fetchMovie(id: state.movieID)
                    await send(.loaded(ViewSnapshot(movie: movie)))
                }
            // ...
            }
        }
    }
}
```

### Feature Client

Bridges TCA dependencies to AppDependencies:

```swift
@DependencyClient
struct MovieDetailsClient: Sendable {
    var fetchMovie: @Sendable (_ id: Int) async throws -> Movie
    var toggleOnWatchlist: @Sendable (_ id: Int) async throws -> Void
}

extension MovieDetailsClient: DependencyKey {
    static var liveValue: MovieDetailsClient {
        @Dependency(\.fetchMovieDetails) var fetchMovieDetails

        return MovieDetailsClient(
            fetchMovie: { id in
                let details = try await fetchMovieDetails.execute(id: id)
                return MovieMapper().map(details)
            }
        )
    }
}
```

## AppDependencies: Dependency Injection Hub

Wires all contexts into TCA's dependency system.

```
AppDependencies/
├── Movies/
│   ├── FetchMovieDetailsUseCase+TCA.swift
│   └── MoviesFactory+TCA.swift
├── Configuration/
├── Observability/
└── ...
```

```swift
// FetchMovieDetailsUseCase+TCA.swift
enum FetchMovieDetailsUseCaseKey: DependencyKey {
    static var liveValue: any FetchMovieDetailsUseCase {
        @Dependency(\.moviesFactory) var moviesFactory
        return moviesFactory.makeFetchMovieDetailsUseCase()
    }
}

public extension DependencyValues {
    var fetchMovieDetails: any FetchMovieDetailsUseCase {
        get { self[FetchMovieDetailsUseCaseKey.self] }
        set { self[FetchMovieDetailsUseCaseKey.self] = newValue }
    }
}
```

## Adapters: External Service Bridges

Adapt external APIs to domain interfaces.

```swift
public final class PopcornMoviesAdaptersFactory {
    private let movieService: any MovieService  // TMDb SDK

    public func makeMoviesFactory() -> PopcornMoviesFactory {
        let remoteDataSource = TMDbMovieRemoteDataSource(movieService: movieService)
        return PopcornMoviesFactory(movieRemoteDataSource: remoteDataSource)
    }
}
```

## Dependency Flow

```
TCA Feature
    ↓
@Dependency(\.movieDetailsClient)     # Feature Client
    ↓
@Dependency(\.fetchMovieDetails)      # AppDependencies
    ↓
@Dependency(\.moviesFactory)          # AppDependencies
    ↓
PopcornMoviesAdaptersFactory          # Adapters
    ↓
PopcornMoviesFactory                  # Context Composition
    ↓
{Domain, Application, Infrastructure}
```

## Navigation Patterns

### Stack Navigation

```swift
@Reducer
struct ExploreRootFeature {
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        var explore = ExploreFeature.State()
    }

    @Reducer
    enum Path {
        case movieDetails(MovieDetailsFeature)
        case personDetails(PersonDetailsFeature)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .explore(.navigate(.movieDetails(let id))):
                state.path.append(.movieDetails(MovieDetailsFeature.State(movieID: id)))
                return .none
            // ...
            }
        }
        .forEach(\.path, action: \.path)
    }
}
```

### Modal Navigation

```swift
@Presents var movieIntelligence: MovieIntelligenceFeature.State?

// Present
state.movieIntelligence = MovieIntelligenceFeature.State(movieID: id)

// Reducer composition
.ifLet(\.$movieIntelligence, action: \.movieIntelligence) {
    MovieIntelligenceFeature()
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

Platform-specific scenes with shared root feature:

```swift
@main
struct PopcornApp: App {
    var body: some Scene {
        #if os(macOS)
            MacScene(store: store)
        #elseif os(visionOS)
            VisionScene(store: store)
        #else
            PhoneScene(store: store)
        #endif
    }
}
```

## Common Workflows

Use the corresponding skills for step-by-step guides:
- `/add-use-case` — Add a use case to an existing context
- `/add-screen` — Add a screen to an existing feature
- `/add-feature` — Create a new TCA feature package
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

3. Inject via AppDependencies:
   ```swift
   // AppDependencies/Chat/MoviesChatToolsProviding+TCA.swift
   extension DependencyValues {
       var moviesChatToolsProvider: any MoviesChatToolsProviding {
           @Dependency(\.moviesFactory) var moviesFactory
           return moviesFactory
       }
   }
   ```
