# Bindings

## When to use this reference

Use this file when connecting SwiftUI bindings to TCA stores: text fields, toggles, pickers, sliders, and other two-way binding controls.

## @Bindable store in views

Declare the store as `@Bindable` to enable `$store.property` syntax:

```swift
struct SettingsView: View {
    @Bindable var store: StoreOf<SettingsFeature>

    var body: some View {
        Form {
            TextField("Name", text: $store.name.sending(\.nameChanged))
            Toggle("Notifications", isOn: $store.notificationsEnabled.sending(\.notificationsToggled))
        }
    }
}
```

## .sending() — ad-hoc bindings

Use `.sending(\.action)` to create a binding that sends a specific action when the value changes:

```swift
$store.searchQuery.sending(\.searchQueryChanged)
```

This creates a `Binding<String>` that reads from `store.searchQuery` and sends `.searchQueryChanged(newValue)` on write.

### Action definition for .sending()

The action must accept the bound value as a parameter:

```swift
enum Action: Sendable {
    case searchQueryChanged(String)
    case notificationsToggled(Bool)
}

var body: some ReducerOf<Self> {
    Reduce { state, action in
        switch action {
        case .searchQueryChanged(let query):
            state.searchQuery = query
            return .none
        case .notificationsToggled(let isOn):
            state.notificationsEnabled = isOn
            return .none
        }
    }
}
```

## BindableAction + BindingReducer — many bindings

When a view has many bindable properties, use `BindableAction` to avoid one action per field:

### 1. Conform Action to BindableAction

```swift
@Reducer
struct FormFeature: Sendable {
    @ObservableState
    struct State: Sendable, Equatable {
        var name: String = ""
        var email: String = ""
        var age: Int = 0
        var notificationsEnabled: Bool = false
        var selectedTheme: Theme = .system
    }

    enum Action: BindableAction, Sendable {
        case binding(BindingAction<State>)
        case submitButtonTapped
    }
}
```

### 2. Add BindingReducer to body

```swift
var body: some ReducerOf<Self> {
    BindingReducer()

    Reduce { state, action in
        switch action {
        case .binding:
            return .none
        case .submitButtonTapped:
            return .run { [state] send in
                try await apiClient.submit(state)
            }
        }
    }
}
```

`BindingReducer()` must appear **before** `Reduce` so state is updated before your logic runs.

### 3. Use standard $store syntax in view

```swift
struct FormView: View {
    @Bindable var store: StoreOf<FormFeature>

    var body: some View {
        Form {
            TextField("Name", text: $store.name)
            TextField("Email", text: $store.email)
            Stepper("Age: \(store.age)", value: $store.age)
            Toggle("Notifications", isOn: $store.notificationsEnabled)
            Picker("Theme", selection: $store.selectedTheme) {
                ForEach(Theme.allCases, id: \.self) { theme in
                    Text(theme.rawValue).tag(theme)
                }
            }
        }
    }
}
```

No `.sending()` needed — `BindableAction` handles all bindings automatically.

## .onChange(of:) — reacting to binding changes

Attach `.onChange` to `BindingReducer` to run logic when a specific binding changes:

```swift
var body: some ReducerOf<Self> {
    BindingReducer()
        .onChange(of: \.searchQuery) { oldValue, newValue in
            Reduce { state, action in
                state.searchResults = []
                return .run { send in
                    let results = try await apiClient.search(newValue)
                    await send(.searchResults(results))
                }
            }
        }

    Reduce { state, action in
        switch action {
        case .binding:
            return .none
        // ...
        }
    }
}
```

## Testing bindings

### Testing BindableAction bindings

```swift
@Test func nameBinding() async {
    let store = TestStore(initialState: FormFeature.State()) {
        FormFeature()
    }

    await store.send(\.binding.name, "Alice") {
        $0.name = "Alice"
    }
}
```

Use `\.binding.propertyName` key path with the new value.

### Testing .sending() bindings

```swift
await store.send(.searchQueryChanged("hello")) {
    $0.searchQuery = "hello"
}
```

Standard action sending — nothing special needed.

## When to use which approach

| Scenario | Approach |
|----------|----------|
| 1-3 simple bindings | `.sending(\.action)` |
| Many form fields | `BindableAction` + `BindingReducer` |
| Need to react to changes | `BindingReducer` + `.onChange(of:)` |
| Read-only display | Direct `store.property` (no binding needed) |

## Do / Don't

- Do use `@Bindable var store` in all views that need bindings.
- Do place `BindingReducer()` before `Reduce` in the body.
- Do use `.onChange(of:)` for side effects triggered by binding changes.
- Do handle `.binding` case in the action switch (even if returning `.none`).
- Don't mix `.sending()` and `BindableAction` on the same property.
- Don't forget `BindableAction` conformance on Action when using `BindingReducer`.
- Don't put complex logic directly in binding handlers — dispatch effects instead.
