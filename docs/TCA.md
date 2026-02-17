# Project TCA Conventions

For generic TCA guidance, use the `tca-expert` skill. This file covers **project-specific** patterns only.

## Navigation Pattern

Features use a `Navigation` enum (not delegate actions) for child-to-parent navigation. The parent intercepts and handles navigation in its `Reduce`:

```swift
// Child feature
public enum Action: Sendable {
    case navigate(Navigation)
}

public enum Navigation: Equatable, Hashable, Sendable {
    case personDetails(id: Int)
    case intelligence(id: Int)
}

// .navigate actions return .none — parent handles them
case .navigate:
    return .none
```

## ViewState Pattern

Features use a `ViewState` enum for loading lifecycle:

```swift
public enum ViewState: Sendable, Equatable {
    case initial
    case loading
    case ready(ViewSnapshot)
    case error(ErrorMessage)
}
```

The `didAppear` action guards on `.initial` before triggering a fetch:

```swift
case .didAppear:
    guard case .initial = state.viewState else { return .none }
    return .send(.fetch)
```

## Client Wiring

Clients wire use cases from `AppDependencies` via `@Dependency` inside `liveValue`, using feature-specific mappers:

```swift
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

## Root Feature Composition

Root tab features compose stack navigation, child scopes, and modal presentation together:

```swift
var body: some Reducer<State, Action> {
    Scope(state: \.explore, action: \.explore) {
        ExploreFeature()
    }

    Reduce { state, action in
        // Handle navigation from children
    }
    .forEach(\.path, action: \.path)
    .ifLet(\.$modalFeature, action: \.modalFeature) {
        ModalFeature()
    }
}
```

## Visibility

- Features are `public struct` and `Sendable`.
- State, Action, ViewState, Navigation, and ErrorMessage are all `public`.
- Clients are `internal` (only used within the feature package).

## Resources

- [TCA Documentation](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture)
