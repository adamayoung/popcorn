# Dependencies

## When to use this reference

Use this file when defining, registering, injecting, or overriding dependencies in TCA. Covers `@Dependency`, `@DependencyClient`, `DependencyKey`, and built-in dependencies.

## @Dependency — injecting dependencies

Use `@Dependency` in reducers to access registered dependencies:

```swift
@Reducer
struct Feature: Sendable {
    @Dependency(\.apiClient) var apiClient
    @Dependency(\.continuousClock) var clock

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            // use apiClient, clock...
        }
    }
}
```

`@Dependency` also works inside `liveValue` of other dependency keys.

## @DependencyClient — defining clients

The `@DependencyClient` macro auto-generates unimplemented defaults for test safety:

```swift
@DependencyClient
struct APIClient: Sendable {
    var fetchMovies: @Sendable () async throws -> [Movie]
    var fetchMovie: @Sendable (_ id: Movie.ID) async throws -> Movie
    var search: @Sendable (_ query: String) async throws -> [Movie]
}
```

### What the macro provides

- `testValue` that calls `XCTFail` for each endpoint (catches missing overrides in tests).
- Default closures that report unimplemented access.
- For endpoints returning `Void`, a no-op default.

### Closure requirements

All closures must be `@Sendable` for Swift 6 concurrency safety. Use labeled parameters for clarity:

```swift
var fetchDetails: @Sendable (_ id: Int, _ includeCredits: Bool) async throws -> Details
```

### Endpoints with default values

For endpoints returning a simple type, provide a default with a trailing comment:

```swift
@DependencyClient
struct SettingsClient: Sendable {
    var isFeatureEnabled: @Sendable () -> Bool = { false }
}
```

## DependencyKey — registering dependencies

Conform your client to `DependencyKey` and provide `liveValue`:

```swift
extension APIClient: DependencyKey {
    static let liveValue: APIClient = {
        APIClient(
            fetchMovies: {
                try await URLSession.shared.decode([Movie].self, from: moviesURL)
            },
            fetchMovie: { id in
                try await URLSession.shared.decode(Movie.self, from: movieURL(id))
            },
            search: { query in
                try await URLSession.shared.decode([Movie].self, from: searchURL(query))
            }
        )
    }()
}
```

### Using @Dependency inside liveValue

```swift
extension FeatureClient: DependencyKey {
    static var liveValue: FeatureClient {
        @Dependency(\.fetchMovieUseCase) var fetchMovieUseCase

        return FeatureClient(
            fetch: { id in
                let movie = try await fetchMovieUseCase.execute(id: id)
                return Mapper().map(movie)
            }
        )
    }
}
```

### Optional values: previewValue and testValue

```swift
extension APIClient: DependencyKey {
    static let liveValue = APIClient(/* real implementation */)

    // Used in SwiftUI previews
    static let previewValue = APIClient(
        fetchMovies: { [.mock] },
        fetchMovie: { _ in .mock },
        search: { _ in [.mock] }
    )

    // @DependencyClient generates this automatically
    // static var testValue: APIClient { ... }
}
```

## DependencyValues extension

Register the dependency in the global container:

```swift
extension DependencyValues {
    var apiClient: APIClient {
        get { self[APIClient.self] }
        set { self[APIClient.self] = newValue }
    }
}
```

## Built-in dependencies

TCA and swift-dependencies provide these out of the box:

| Dependency | Key path | Purpose |
|-----------|----------|---------|
| `ContinuousClock` | `\.continuousClock` | Controllable time (delays, debouncing) |
| `UUID` | `\.uuid` | Deterministic UUID generation |
| `Date` | `\.date` | Controllable current date |
| `DismissEffect` | `\.dismiss` | Dismiss presented feature |
| `Calendar` | `\.calendar` | Calendar operations |
| `Locale` | `\.locale` | Locale access |
| `TimeZone` | `\.timeZone` | Time zone access |
| `OpenURL` | `\.openURL` | Open URLs |
| `URLSession` | `\.urlSession` | Network requests |
| `UserDefaults` | `\.defaultAppStorage` | UserDefaults access |
| `Context` | `\.context` | Current execution context (live/test/preview) |

## Overriding dependencies

### In tests (withDependencies)

```swift
let store = TestStore(
    initialState: Feature.State()
) {
    Feature()
} withDependencies: {
    $0.apiClient.fetchMovies = { [.mock] }
    $0.continuousClock = ImmediateClock()
}
```

### On child reducers (.dependency)

```swift
Scope(state: \.child, action: \.child) {
    ChildFeature()
        .dependency(\.apiClient, .mock)
}
```

### In previews

```swift
#Preview {
    FeatureView(
        store: Store(initialState: Feature.State()) {
            Feature()
        } withDependencies: {
            $0.apiClient = .previewValue
        }
    )
}
```

## Do / Don't

- Do use `@DependencyClient` for all client definitions.
- Do use `@Sendable` on all closure properties.
- Do use labeled closure parameters for readability.
- Do use `@Dependency` inside `liveValue` to compose dependencies.
- Do override only the endpoints you need in tests.
- Don't access dependencies outside of reducers or `liveValue` (they won't resolve correctly).
- Don't use singletons or global state — always go through `@Dependency`.
- Don't forget to register in `DependencyValues` extension.
- Don't manually write `testValue` when using `@DependencyClient` — the macro handles it.
