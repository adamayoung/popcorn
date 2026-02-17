# Navigation

## When to use this reference

Use this file when implementing navigation in TCA: stack-based (push/pop), tree-based (sheets/covers/alerts), enum destinations, deep linking, or child dismissal.

## Choosing a navigation pattern

| Pattern | Use when | State type |
|---------|----------|------------|
| Stack-based | List-to-detail, linear flows, deep linking | `StackState<Path.State>` |
| Tree-based | Modals, sheets, alerts, confirmation dialogs | `@Presents var destination: State?` |

## Stack-based navigation

### Define the path reducer

```swift
@Reducer
struct ParentFeature: Sendable {
    // ...

    @Reducer
    enum Path {
        case detail(DetailFeature)
        case settings(SettingsFeature)
    }

    @ObservableState
    struct State: Sendable, Equatable {
        var path = StackState<Path.State>()
        // ...
    }

    enum Action: Sendable {
        case path(StackActionOf<Path>)
        // ...
    }
}
```

The `@Reducer enum Path` auto-generates `State` and `Action` enums via the macro.

### Wire in reducer body

```swift
var body: some ReducerOf<Self> {
    Reduce { state, action in
        switch action {
        case .path:
            return .none
        // ...
        }
    }
    .forEach(\.path, action: \.path)
    // No trailing closure needed — @Reducer enum Path infers it automatically
}
```

### Push and pop

```swift
// Push
case .itemTapped(let id):
    state.path.append(.detail(DetailFeature.State(id: id)))
    return .none

// Pop last
case .path(.element(id: _, action: .detail(.closeButtonTapped))):
    state.path.removeLast()
    return .none

// Pop to specific point
case .path(.popFrom(let id)):
    return .none  // Handled automatically by NavigationStack

// Pop all
state.path.removeAll()
```

### Intercept child actions from the stack

```swift
case .path(.element(id: let id, action: .detail(.delegate(.itemDeleted)))):
    state.items.remove(id: state.path[id: id, case: \.detail]?.itemID)
    return .none
```

### View integration

```swift
struct ParentView: View {
    @Bindable var store: StoreOf<ParentFeature>

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            RootContentView(store: store)
        } destination: { store in
            switch store.case {
            case .detail(let store):
                DetailView(store: store)
            case .settings(let store):
                SettingsView(store: store)
            }
        }
    }
}
```

### Deep linking

Initialize `StackState` with pre-built path:

```swift
State(
    path: StackState([
        .list(ListFeature.State()),
        .detail(DetailFeature.State(id: deepLinkID))
    ])
)
```

## Tree-based navigation

### Optional destination (single type)

```swift
@ObservableState
struct State: Sendable, Equatable {
    @Presents var detail: DetailFeature.State?
}

enum Action: Sendable {
    case detail(PresentationAction<DetailFeature.Action>)
    case showDetailTapped
}

var body: some ReducerOf<Self> {
    Reduce { state, action in
        switch action {
        case .showDetailTapped:
            state.detail = DetailFeature.State(id: 1)
            return .none
        case .detail:
            return .none
        }
    }
    .ifLet(\.$detail, action: \.detail) {
        DetailFeature()  // Trailing closure required for single-type @Presents
    }
}
```

### Enum destinations (multiple types)

```swift
@Reducer
enum Destination {
    case detail(DetailFeature)
    case edit(EditFeature)
    case alert(AlertState<Alert>)

    enum Alert: Sendable {
        case confirmDelete
    }
}

@ObservableState
struct State: Sendable, Equatable {
    @Presents var destination: Destination.State?
}

enum Action: Sendable {
    case destination(PresentationAction<Destination.Action>)
}

var body: some ReducerOf<Self> {
    Reduce { state, action in ... }
        .ifLet(\.$destination, action: \.destination)
        // No trailing closure — @Reducer enum Destination infers it automatically
}
```

### View integration (sheets, covers, popovers)

```swift
struct ParentView: View {
    @Bindable var store: StoreOf<ParentFeature>

    var body: some View {
        ContentView(store: store)
            .sheet(
                item: $store.scope(state: \.destination?.detail, action: \.destination.detail)
            ) { store in
                DetailView(store: store)
            }
            .fullScreenCover(
                item: $store.scope(state: \.destination?.edit, action: \.destination.edit)
            ) { store in
                EditView(store: store)
            }
    }
}
```

### Navigation destination (tree-based push)

```swift
.navigationDestination(
    item: $store.scope(state: \.destination?.detail, action: \.destination.detail)
) { store in
    DetailView(store: store)
}
```

## Alerts

### Define alert state

```swift
@ObservableState
struct State: Sendable, Equatable {
    @Presents var alert: AlertState<Action.Alert>?
}

enum Action: Sendable {
    case alert(PresentationAction<Alert>)
    case deleteButtonTapped

    enum Alert: Sendable {
        case confirmDelete
    }
}
```

### Present an alert

```swift
case .deleteButtonTapped:
    state.alert = AlertState {
        TextState("Delete Item?")
    } actions: {
        ButtonState(role: .destructive, action: .confirmDelete) {
            TextState("Delete")
        }
        ButtonState(role: .cancel) {
            TextState("Cancel")
        }
    } message: {
        TextState("This action cannot be undone.")
    }
    return .none

case .alert(.presented(.confirmDelete)):
    state.items.remove(id: state.selectedID)
    return .none

case .alert:
    return .none
```

### Wire in reducer body

```swift
.ifLet(\.$alert, action: \.alert)
```

### View integration

```swift
.alert($store.scope(state: \.alert, action: \.alert))
```

## Confirmation dialogs

Same pattern as alerts but with `ConfirmationDialogState`:

```swift
@Presents var confirmationDialog: ConfirmationDialogState<Action.ConfirmationDialog>?

// View
.confirmationDialog($store.scope(state: \.confirmationDialog, action: \.confirmationDialog))
```

## Dismissal from child

A child feature can dismiss itself using the built-in `dismiss` dependency:

```swift
@Reducer
struct ChildFeature: Sendable {
    @Dependency(\.dismiss) var dismiss

    // ...

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .saveCompleted:
                return .run { _ in
                    await dismiss()
                }
            // ...
            }
        }
    }
}
```

`dismiss()` must be called from a `.run` effect — it is async.

## Do / Don't

- Do use `@Reducer enum` for Path (stack) and Destination (tree) types.
- Do use `@Presents` for tree-based destination state.
- Do use `$store.scope(...)` for view bindings.
- Do use `.forEach(\.path, action: \.path)` for stack wiring.
- Do use `.ifLet(\.$destination, action: \.destination)` for tree wiring.
- Do call `dismiss()` from `.run` effects only.
- Don't mix stack and tree navigation for the same flow.
- Don't forget to handle `.path` or `.destination` actions in the switch (even if returning `.none`).
- Do consider `NavigationLink(state:)` for simple stack pushes in the view layer.
- Don't use SwiftUI's `NavigationLink(value:)` — use TCA's `NavigationLink(state:)` instead.
