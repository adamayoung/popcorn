---
description: Add a screen to an existing feature
---

# Add a Screen to Existing Feature

Guide for adding a new screen/view to an existing TCA feature with proper navigation.

## Required Information

Ask the user for:
- **Parent feature** (e.g., ExploreRootFeature, MovieDetailsFeature)
- **New screen name** (e.g., MovieCredits, PersonFilmography)
- **Navigation trigger** (what action leads to this screen)

## Steps

### 1. Create the New Feature Reducer

If the screen needs its own reducer, create it in the feature package:

```swift
@Reducer
public struct {ScreenName}Feature: Sendable {
    @Dependency(\.{screenName}Client) private var client

    @ObservableState
    public struct State: Sendable {
        let id: Int
        var viewState: ViewState = .initial

        public init(id: Int) {
            self.id = id
        }
    }

    public enum ViewState: Sendable {
        case initial
        case loading
        case ready(ViewSnapshot)
        case error(Error)
    }

    public enum Action: Sendable {
        case didAppear
        case fetch
        case loaded(ViewSnapshot)
        case failed(Error)
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable, Sendable {
        // Define navigation destinations
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            // Implementation
        }
    }
}
```

### 2. Add to Parent's Path Enum

In the parent feature's `Path` reducer enum:

```swift
@Reducer
enum Path {
    case existingScreen(ExistingFeature)
    case {screenName}({ScreenName}Feature)  // Add this
}
```

### 3. Add Navigation Action Handling

In the parent reducer's body:

```swift
case .existingScreen(.navigate(.{screenName}(let id))):
    state.path.append(.{screenName}({ScreenName}Feature.State(id: id)))
    return .none
```

Or if navigating from the root:

```swift
case .{rootFeature}(.navigate(.{screenName}(let id))):
    state.path.append(.{screenName}({ScreenName}Feature.State(id: id)))
    return .none
```

### 4. Wire View in NavigationStack

In the parent's view, add to the `destination` closure:

```swift
NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
    RootView(store: store.scope(state: \.root, action: \.root))
} destination: { store in
    switch store.case {
    case .existingScreen(let store):
        ExistingView(store: store)
    case .{screenName}(let store):
        {ScreenName}View(store: store)  // Add this
    }
}
```

### 5. Create the View

```swift
struct {ScreenName}View: View {
    @Bindable var store: StoreOf<{ScreenName}Feature>

    var body: some View {
        // View implementation
    }
}
```

### 6. Add Navigation Enum Case to Source Feature

In the feature that triggers navigation:

```swift
public enum Navigation: Equatable, Hashable, Sendable {
    case {screenName}(id: Int)
}
```

$ARGUMENTS
