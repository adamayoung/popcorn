# Shared State

## When to use this reference

Use this file when sharing state between features, persisting state across app launches, or dealing with concurrent state mutations in TCA.

## @Shared — explicit state sharing

`@Shared` enables multiple features to read and write the same piece of state. Changes in one feature are automatically visible to all others.

### Basic usage

```swift
@Reducer
struct ParentFeature: Sendable {
    @ObservableState
    struct State: Sendable, Equatable {
        @Shared var count: Int
    }
}

@Reducer
struct ChildFeature: Sendable {
    @ObservableState
    struct State: Sendable, Equatable {
        @Shared var count: Int
    }
}
```

### Passing shared references

Pass shared state from parent to child using `$` prefix:

```swift
// In parent reducer
case .showChild:
    state.child = ChildFeature.State(count: state.$count)
    return .none
```

### Mutating shared state

Use `withLock` for thread-safe mutations:

```swift
case .incrementButtonTapped:
    state.$count.withLock { $0 += 1 }
    return .none
```

Direct assignment also works for simple sets:

```swift
state.count = 42
```

## Persisted shared state

### In-memory (app lifetime)

```swift
@Shared(.inMemory("userSettings")) var settings = UserSettings()
```

Shared across features for the app's lifetime. Lost on app termination.

### App storage (UserDefaults)

```swift
@Shared(.appStorage("hasSeenOnboarding")) var hasSeenOnboarding = false
```

Persisted to `UserDefaults`. Supports `Bool`, `Int`, `Double`, `String`, `URL`, `Data`, and `RawRepresentable` types.

### File storage (disk)

```swift
@Shared(.fileStorage(.documentsDirectory.appending(component: "todos.json")))
var todos: IdentifiedArrayOf<Todo> = []
```

Persisted to disk as JSON. The type must conform to `Codable`.

### Initialization patterns

For non-persisted `@Shared`, the source of truth is wherever it's first created:

```swift
// Parent creates the source of truth
struct ParentState {
    @Shared var count: Int = 0  // Default value, source of truth
}

// Child receives a reference
struct ChildState {
    @Shared var count: Int  // No default — must be passed in
}
```

For persisted `@Shared`, the source of truth is the persistence layer:

```swift
// Both can declare independently — they share via the persistence key
struct FeatureA {
    @Shared(.appStorage("theme")) var theme: Theme = .system
}
struct FeatureB {
    @Shared(.appStorage("theme")) var theme: Theme = .system
}
```

## Deriving shared state

Derive a shared reference to a sub-property:

```swift
@ObservableState
struct State: Sendable, Equatable {
    @Shared var user: User
}

// In child initialization — share just the name
ChildFeature.State(name: state.$user.name)
```

### IdentifiedArray element sharing

Share an element from an `IdentifiedArray`:

```swift
// Access a shared element by ID
if let sharedTodo = state.$todos[id: todoID] {
    state.editTodo = EditFeature.State(todo: sharedTodo)
}
```

## @SharedReader — read-only access

When a feature only needs to read shared state:

```swift
@ObservableState
struct State: Sendable, Equatable {
    @SharedReader var settings: AppSettings
}
```

Cannot mutate — attempting to set the value is a compile error.

## Observing changes

Subscribe to changes via publisher:

```swift
return .run { [countPublisher = state.$count.publisher] send in
    for await count in countPublisher.values {
        await send(.countChanged(count))
    }
}
```

## Type-safe keys

Define custom shared keys for reuse:

```swift
extension SharedReaderKey where Self == AppStorageKey<Bool>.Default {
    static var hasCompletedOnboarding: Self {
        Self[.appStorage("hasCompletedOnboarding"), default: false]
    }
}

// Usage
@Shared(.hasCompletedOnboarding) var hasCompletedOnboarding
```

## Testing shared state

### Shared state is automatically isolated in tests

Each `TestStore` gets its own copy of persisted shared state — tests don't leak into each other.

### Asserting shared state changes

```swift
await store.send(.incrementButtonTapped) {
    $0.$count.withLock { $0 = 1 }
}
```

### Asserting after effects

```swift
store.assert {
    $0.$count.withLock { $0 = expectedValue }
}
```

### Setting initial shared state in tests

```swift
let store = TestStore(
    initialState: Feature.State(count: Shared(0))
) {
    Feature()
}
```

## Gotchas and limitations

- `@Shared` values are not `Hashable` — avoid using in `Set` or as `Dictionary` keys.
- `@Shared` values are not conditionally `Codable` — the containing type needs manual conformance if needed.
- Always use `withLock` when mutating from effects or concurrent contexts.
- The default value in `@Shared(.appStorage("key")) var x = default` is only used if the key doesn't exist yet.

## Do / Don't

- Do pass shared references using `$` prefix (`state.$count`).
- Do use `withLock` for thread-safe mutations.
- Do use `@SharedReader` when only reading is needed.
- Do use type-safe keys for commonly accessed persistence keys.
- Do test that shared state changes propagate correctly.
- Don't create circular shared references.
- Don't assume `@Shared` properties are `Hashable` or `Codable`.
- Don't mutate shared state from multiple places without `withLock`.
- Don't use `@Shared` for state that's only used by one feature — use plain properties.
