# Agent guide for TCA

## Core instructions

Use TCA 1.23+.

### TCA Feature Structure

- State: Immutable struct with all feature state
- Action: Enum of all possible user/system actions
- Reducer: Pure function transforming State via Actions
- Dependencies: Injected via @Dependency

### TCA Integration

- Features use `@Reducer` types with nested `State` and `Action`
- Clients use `@DependencyClient` types
- Views bind via `StoreOf<Feature>` and use `Scope`/`NavigationStack`
- Navigation uses `StackState` and `NavigationStack`
- Side effects return `EffectOf<Self>` and are injected via `@Dependency`
- State structs use `@ObservableState`
- Bindings managed via `BindingReducer`
- Navigation driven by `navigate` action cases that mutate path

## State Management in TCA Context

- Use TCA stores for feature-level state
- Use @State for view-local, ephemeral state
- Avoid @StateObject - TCA handles object lifecycle

## Navigation Pattern

```swift
struct MovieListFeature: Reducer {
    @ObservableState
    struct State {
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
    }

    enum Action {
        case path(StackAction<Path.State, Path.Action>)
        case destination(PresentationAction<Destination.Action>)
    }

    @Reducer
    struct Path {
        enum State { case detail(MovieDetailFeature.State) }
        enum Action { case detail(MovieDetailFeature.Action) }
    }
}
```

## Resources

- [TCA SwiftUI Integration](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/swiftui)
