# Performance

## When to use this reference

Use this file when optimizing TCA feature performance: reducing unnecessary view re-renders, handling high-frequency actions, offloading CPU work, or understanding observation mechanics.

## @ObservableState observation

`@ObservableState` enables fine-grained observation — views only re-render when properties they actually access change. This replaces the old `Equatable`-based diffing.

```swift
@ObservableState
struct State: Sendable, Equatable {
    var title: String = ""
    var items: IdentifiedArrayOf<Item> = []
    var isLoading: Bool = false
}
```

A view that only reads `title` won't re-render when `items` changes.

### Nested observation

Nested `@ObservableState` structs are observed independently:

```swift
@ObservableState
struct State: Sendable, Equatable {
    var header: HeaderState  // Must also be @ObservableState
    var list: ListState
}
```

Changes to `header` don't trigger re-renders in views only accessing `list`.

## Store scoping

### Prefer stored property scoping

When passing stores to child views, scope at the stored property level:

```swift
// Good — scoped to child's state/action boundary
ChildView(store: store.scope(state: \.child, action: \.child))
```

### Avoid computed property scoping

Don't scope to computed or transformed state — this defeats observation optimization:

```swift
// Avoid — computed transforms break observation tracking
store.scope(state: { State(filtered: $0.items.filter(\.isActive)) }, action: \.self)
```

Instead, compute derived values in the view or in the state as a computed property.

## High-frequency actions

For controls that fire rapidly (sliders, text fields with real-time validation, drag gestures):

### Use local @State for intermediate values

```swift
struct SliderView: View {
    @Bindable var store: StoreOf<Feature>
    @State private var localValue: Double = 0

    var body: some View {
        Slider(value: $localValue, in: 0...100)
            .onAppear { localValue = store.sliderValue }
            .onChange(of: localValue) { _, newValue in
                store.send(.sliderChanged(newValue))
            }
    }
}
```

This prevents the store from processing every intermediate value during a drag.

### Debounce in the reducer

For text field search, debounce the effect rather than every keystroke:

```swift
case .searchQueryChanged(let query):
    state.searchQuery = query
    return .run { send in
        try await clock.sleep(for: .milliseconds(300))
        let results = try await apiClient.search(query)
        await send(.searchResults(results))
    }
    .cancellable(id: CancelID.search, cancelInFlight: true)
```

State updates immediately (responsive UI), but the expensive effect is debounced.

## CPU-intensive work

### Keep Reduce body lightweight

Reducers run on the main thread. Move heavy work to effects:

```swift
// Bad — blocks main thread
case .processData:
    state.result = expensiveComputation(state.rawData)  // Blocks UI
    return .none

// Good — offloads to effect
case .processData:
    state.isProcessing = true
    return .run { [data = state.rawData] send in
        let result = await Task.detached {
            expensiveComputation(data)
        }.value
        await send(.processingComplete(result))
    }
```

### Yield periodically in long loops

```swift
return .run { send in
    var results: [ProcessedItem] = []
    for (index, item) in items.enumerated() {
        results.append(process(item))
        if index.isMultiple(of: 100) {
            await Task.yield()
        }
    }
    await send(.processingComplete(results))
}
```

## Sharing logic efficiently

### Helper methods over action ping-pong

Sending an action to share logic adds a full reducer cycle. Use helper methods instead:

```swift
// Bad — unnecessary round-trip
case .buttonATapped:
    return .send(.sharedLogic)
case .buttonBTapped:
    return .send(.sharedLogic)
case .sharedLogic:
    // actual work
    return .none

// Good — direct method call
case .buttonATapped:
    return performSharedWork(state: &state)
case .buttonBTapped:
    return performSharedWork(state: &state)

private func performSharedWork(state: inout State) -> Effect<Action> {
    state.isLoading = true
    return .run { send in ... }
}
```

## Observation tips

- Read only the properties you need in each view — don't destructure entire state.
- Use child views to isolate observation boundaries.
- Computed properties on State don't trigger extra observations — they derive from observed stored properties.
- `IdentifiedArray` observation is element-level: changing one element doesn't re-render views for other elements.

## Do / Don't

- Do use `@ObservableState` on all State types for fine-grained observation.
- Do scope stores at stored property boundaries.
- Do use local `@State` for high-frequency intermediate values (sliders, drags).
- Do offload CPU-intensive work to `.run` effects.
- Do use helper methods instead of action round-trips for shared logic.
- Don't perform heavy computation in the `Reduce` body.
- Don't scope stores with computed/transformed state.
- Don't read unnecessary state properties in views.
- Don't use `Equatable` diffing patterns — `@ObservableState` handles observation.
