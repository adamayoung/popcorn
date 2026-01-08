# Architecture

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
package final class MoviesApplicationFactory {
    func makeFetchMovieDetailsUseCase() -> some FetchMovieDetailsUseCase {
        DefaultFetchMovieDetailsUseCase(movieRepository: movieRepository)
    }
}
```

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
public actor SwiftDataMovieLocalDataSource: MovieLocalDataSource {
    private let modelContainer: ModelContainer

    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    public func movie(withID id: Int) async throws -> Movie? {
        let context = ModelContext(modelContainer)
        let predicate = #Predicate<MovieEntity> { $0.id == id }
        let descriptor = FetchDescriptor(predicate: predicate)

        guard let entity = try context.fetch(descriptor).first else {
            return nil
        }

        return MovieEntityMapper().mapToDomain(entity)
    }

    public func setMovie(_ movie: Movie) async throws {
        let context = ModelContext(modelContainer)
        let entity = MovieEntityMapper().mapToEntity(movie)
        context.insert(entity)
        try context.save()
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

### Add a Use Case to Existing Context

1. Create directory:
   ```
   Contexts/PopcornMovies/Sources/MoviesApplication/UseCases/NewUseCase/
   ```

2. Add three files:
   - `NewUseCase.swift` - Protocol definition
   - `DefaultNewUseCase.swift` - Implementation
   - `NewUseCaseError.swift` - Error type

3. Add factory method to `MoviesApplicationFactory`:
   ```swift
   func makeNewUseCase() -> some NewUseCase {
       DefaultNewUseCase(movieRepository: movieRepository)
   }
   ```

4. Expose in `MoviesComposition/PopcornMoviesFactory`:
   ```swift
   public func makeNewUseCase() -> some NewUseCase {
       applicationFactory.makeNewUseCase()
   }
   ```

5. Add TCA dependency in `AppDependencies/Movies/NewUseCase+TCA.swift`:
   ```swift
   enum NewUseCaseKey: DependencyKey {
       static var liveValue: any NewUseCase {
           @Dependency(\.moviesFactory) var moviesFactory
           return moviesFactory.makeNewUseCase()
       }
   }

   public extension DependencyValues {
       var newUseCase: any NewUseCase {
           get { self[NewUseCaseKey.self] }
           set { self[NewUseCaseKey.self] = newValue }
       }
   }
   ```

### Add a Screen to Existing Feature

1. Add state case to parent's `Path` enum:
   ```swift
   @Reducer
   enum Path {
       case existingScreen(ExistingFeature)
       case newScreen(NewScreenFeature)  // Add this
   }
   ```

2. Add navigation handling in parent reducer:
   ```swift
   case .existingScreen(.navigate(.newScreen(let id))):
       state.path.append(.newScreen(NewScreenFeature.State(id: id)))
       return .none
   ```

3. Wire view in `navigationDestination`:
   ```swift
   } destination: { store in
       switch store.case {
       case .existingScreen(let store):
           ExistingView(store: store)
       case .newScreen(let store):
           NewScreenView(store: store)
       }
   }
   ```

### Add a New Feature Package

1. Create package structure:
   ```
   Features/NewFeature/
   ├── Package.swift
   ├── Sources/NewFeature/
   │   ├── NewFeature.swift      # Reducer
   │   ├── NewFeatureClient.swift # Dependencies
   │   ├── Views/
   │   │   └── NewFeatureView.swift
   │   ├── Models/
   │   └── Mappers/
   └── Tests/NewFeatureTests/
   ```

2. Package.swift dependencies:
   ```swift
   dependencies: [
       .package(path: "../../AppDependencies"),
       .package(path: "../../Core/DesignSystem"),
   ]
   ```

3. Create reducer with `State`, `Action`, `body`

4. Create client bridging to AppDependencies

5. Add to parent feature's `Path` enum and wire navigation

### Add a New Context

1. Create context package:
   ```
   Contexts/PopcornNewContext/
   ├── Package.swift
   ├── Sources/
   │   ├── NewContextDomain/
   │   ├── NewContextApplication/
   │   ├── NewContextInfrastructure/
   │   └── NewContextComposition/
   └── Tests/
   ```

2. Create adapters:
   ```
   Adapters/Contexts/PopcornNewContextAdapters/
   ```

3. Wire in AppDependencies:
   - Add package dependency
   - Create `AppDependencies/NewContext/` with TCA dependency extensions

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
