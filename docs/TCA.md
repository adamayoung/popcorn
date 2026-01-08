# Agent guide for TCA

Use TCA 1.23+.

## Feature Structure

- **State**: Immutable struct with `@ObservableState`
- **Action**: Enum of all possible user/system actions
- **Reducer**: Pure function transforming State via Actions
- **Dependencies**: Injected via `@Dependency`

## Reducer Definition

```swift
@Reducer
struct MovieDetailsFeature: Sendable {
    @Dependency(\.movieDetailsClient) private var client

    @ObservableState
    struct State: Sendable {
        let movieID: Int
        var movie: Movie?
        var isLoading = false
        var error: Error?
    }

    enum Action: Sendable {
        case didAppear
        case fetch
        case loaded(Movie)
        case failed(Error)
        case navigate(Navigation)
    }

    enum Navigation: Equatable, Hashable {
        case personDetails(id: Int)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                return .send(.fetch)

            case .fetch:
                state.isLoading = true
                return .run { [movieID = state.movieID] send in
                    let movie = try await client.fetchMovie(id: movieID)
                    await send(.loaded(movie))
                } catch: { error, send in
                    await send(.failed(error))
                }

            case .loaded(let movie):
                state.isLoading = false
                state.movie = movie
                return .none

            case .failed(let error):
                state.isLoading = false
                state.error = error
                return .none

            case .navigate:
                return .none  // Handled by parent
            }
        }
    }
}
```

## Dependency Client

```swift
@DependencyClient
struct MovieDetailsClient: Sendable {
    var fetchMovie: @Sendable (_ id: Int) async throws -> Movie
    var fetchCredits: @Sendable (_ movieID: Int) async throws -> Credits
    var toggleOnWatchlist: @Sendable (_ movieID: Int) async throws -> Void
    var isWatchlistEnabled: @Sendable () throws -> Bool
}

extension MovieDetailsClient: DependencyKey {
    static var liveValue: MovieDetailsClient {
        @Dependency(\.fetchMovieDetails) var fetchMovieDetails
        @Dependency(\.featureFlags) var featureFlags

        return MovieDetailsClient(
            fetchMovie: { id in
                let details = try await fetchMovieDetails.execute(id: id)
                return MovieMapper().map(details)
            },
            fetchCredits: { movieID in
                // ...
            },
            toggleOnWatchlist: { movieID in
                // ...
            },
            isWatchlistEnabled: {
                featureFlags.isEnabled(.watchlist)
            }
        )
    }

    static var previewValue: MovieDetailsClient {
        MovieDetailsClient(
            fetchMovie: { _ in .mock },
            fetchCredits: { _ in .mock },
            toggleOnWatchlist: { _ in },
            isWatchlistEnabled: { true }
        )
    }
}

extension DependencyValues {
    var movieDetailsClient: MovieDetailsClient {
        get { self[MovieDetailsClient.self] }
        set { self[MovieDetailsClient.self] = newValue }
    }
}
```

## Reducer Composition with Scope

```swift
@Reducer
struct ExploreRootFeature: Sendable {
    @ObservableState
    struct State: Sendable {
        var path = StackState<Path.State>()
        var explore = ExploreFeature.State()
        @Presents var movieIntelligence: MovieIntelligenceFeature.State?
    }

    enum Action: Sendable {
        case explore(ExploreFeature.Action)
        case path(StackActionOf<Path>)
        case movieIntelligence(PresentationAction<MovieIntelligenceFeature.Action>)
    }

    @Reducer
    enum Path {
        case movieDetails(MovieDetailsFeature)
        case personDetails(PersonDetailsFeature)
    }

    var body: some Reducer<State, Action> {
        // Scope child reducer to parent state/action
        Scope(state: \.explore, action: \.explore) {
            ExploreFeature()
        }

        Reduce { state, action in
            switch action {
            // Handle navigation from child
            case .explore(.navigate(.movieDetails(let id))):
                state.path.append(.movieDetails(MovieDetailsFeature.State(movieID: id)))
                return .none

            // Handle navigation within stack
            case .path(.element(_, .movieDetails(.navigate(.personDetails(let id))))):
                state.path.append(.personDetails(PersonDetailsFeature.State(personID: id)))
                return .none

            // Present modal
            case .path(.element(_, .movieDetails(.navigate(.intelligence(let id))))):
                state.movieIntelligence = MovieIntelligenceFeature.State(movieID: id)
                return .none

            default:
                return .none
            }
        }
        // Stack navigation
        .forEach(\.path, action: \.path)
        // Modal presentation
        .ifLet(\.$movieIntelligence, action: \.movieIntelligence) {
            MovieIntelligenceFeature()
        }
    }
}
```

## Navigation Patterns

### Stack Navigation

```swift
@ObservableState
struct State {
    var path = StackState<Path.State>()
}

// Push to stack
state.path.append(.movieDetails(MovieDetailsFeature.State(movieID: id)))

// Pop from stack
state.path.removeLast()
```

### Modal/Sheet Presentation

```swift
@ObservableState
struct State {
    @Presents var sheet: SheetFeature.State?
}

// Present
state.sheet = SheetFeature.State()

// Dismiss
state.sheet = nil
```

## View Integration

```swift
struct ExploreRootView: View {
    @Bindable var store: StoreOf<ExploreRootFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ExploreView(store: store.scope(state: \.explore, action: \.explore))
        } destination: { store in
            switch store.case {
            case .movieDetails(let store):
                MovieDetailsView(store: store)
            case .personDetails(let store):
                PersonDetailsView(store: store)
            }
        }
        .sheet(item: $store.scope(state: \.movieIntelligence, action: \.movieIntelligence)) { store in
            MovieIntelligenceView(store: store)
        }
    }
}
```

## Testing with TestStore

```swift
import Testing
import ComposableArchitecture

@Test
func fetchMovieDetails() async {
    let store = TestStore(
        initialState: MovieDetailsFeature.State(movieID: 123)
    ) {
        MovieDetailsFeature()
    } withDependencies: {
        $0.movieDetailsClient.fetchMovie = { id in
            #expect(id == 123)
            return Movie(id: 123, title: "Test Movie", overview: "Overview")
        }
    }

    await store.send(.fetch) {
        $0.isLoading = true
    }

    await store.receive(\.loaded) {
        $0.isLoading = false
        $0.movie = Movie(id: 123, title: "Test Movie", overview: "Overview")
    }
}

@Test
func fetchMovieDetailsFailure() async {
    struct TestError: Error, Equatable {}

    let store = TestStore(
        initialState: MovieDetailsFeature.State(movieID: 123)
    ) {
        MovieDetailsFeature()
    } withDependencies: {
        $0.movieDetailsClient.fetchMovie = { _ in
            throw TestError()
        }
    }

    await store.send(.fetch) {
        $0.isLoading = true
    }

    await store.receive(\.failed) {
        $0.isLoading = false
        $0.error = TestError()
    }
}

@Test
func navigationToPersonDetails() async {
    let store = TestStore(
        initialState: MovieDetailsFeature.State(movieID: 123)
    ) {
        MovieDetailsFeature()
    }

    await store.send(.navigate(.personDetails(id: 456)))
    // Parent handles navigation - no state change in this reducer
}
```

## State Management

- Use TCA stores for feature-level state
- Use `@State` for view-local, ephemeral state only
- Avoid `@StateObject` - TCA handles object lifecycle

## Resources

- [TCA Documentation](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture)
- [TCA SwiftUI Integration](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftui)
