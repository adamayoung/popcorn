# Testing

## When to use this reference

Use this file when writing TCA tests, debugging test failures, understanding exhaustive vs non-exhaustive testing, or testing navigation and shared state.

## TestStore basics

`TestStore` is the primary tool for testing TCA reducers. It asserts every state change and effect action.

```swift
import ComposableArchitecture
import Testing

@testable import MyFeature

@MainActor
struct FeatureTests {
    @Test func incrementAndDecrement() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }

        await store.send(.incrementButtonTapped) {
            $0.count = 1
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
    }
}
```

### State assertion rules

Inside `store.send(.action) { ... }`, mutate `$0` to match the expected state **after** the action. Use hard-coded values, not relative mutations:

```swift
// Correct — hard-coded expected value
await store.send(.incrementButtonTapped) {
    $0.count = 1
}

// Incorrect — relative mutation hides bugs
await store.send(.incrementButtonTapped) {
    $0.count += 1
}
```

### No state change

When an action doesn't change state, omit the trailing closure:

```swift
await store.send(.viewAppeared)
```

## Receiving effect actions

Use `store.receive` to assert actions produced by effects:

```swift
@Test func loadData() async {
    let store = TestStore(initialState: Feature.State()) {
        Feature()
    } withDependencies: {
        $0.apiClient.fetchItems = { [.mock] }
    }

    await store.send(.loadButtonTapped) {
        $0.isLoading = true
    }
    await store.receive(\.dataLoaded) {
        $0.isLoading = false
        $0.items = [.mock]
    }
}
```

Use `\.action` key path syntax (not full action value) for `receive` — this matches via case key paths.

### Receiving with timeout

```swift
await store.receive(\.dataLoaded, timeout: .seconds(1)) {
    $0.items = [.mock]
}
```

## Overriding dependencies

```swift
let store = TestStore(initialState: Feature.State()) {
    Feature()
} withDependencies: {
    $0.apiClient.fetchItems = { [.mock] }
    $0.continuousClock = ImmediateClock()
    $0.uuid = .incrementing
    $0.date.now = Date(timeIntervalSince1970: 0)
}
```

### ImmediateClock

Use `ImmediateClock()` to make clock-based delays resolve instantly in tests:

```swift
$0.continuousClock = ImmediateClock()
```

This eliminates real-time waits for debouncing, animation delays, etc.

## Exhaustive testing (default)

By default, `TestStore` is exhaustive — you must:

1. Assert every state change via `send` trailing closure.
2. Receive every action produced by effects.
3. Let all effects complete before the test ends.

Failing any of these causes a test failure with a clear diagnostic.

### Finishing long-lived effects

If a store has effects that outlive the test scope, call `finish()`:

```swift
await store.send(.viewAppeared)
// Effect starts a long-lived observation
await store.finish()
```

## Non-exhaustive testing

For integration tests or tests that focus on a subset of behavior:

```swift
let store = TestStore(initialState: Feature.State()) {
    Feature()
} withDependencies: {
    $0.apiClient = .previewValue
}
store.exhaustivity = .off

await store.send(.viewAppeared)
await store.receive(\.dataLoaded)
// No need to assert every state change
```

### Show skipped assertions (diagnostic mode)

```swift
store.exhaustivity = .off(showSkippedAssertions: true)
```

Prints all skipped state/action assertions as warnings — useful for understanding what's being skipped.

### Key difference in non-exhaustive mode

In non-exhaustive mode, `$0` in the trailing closure represents the state **after** the action has been applied. You assert the final state, not mutate from before:

```swift
store.exhaustivity = .off
await store.send(.loaded(items)) {
    // $0 is already the post-action state
    $0.items = items  // Assert it matches
}
```

## Testing navigation

### Stack navigation

```swift
await store.send(.itemTapped(id: 1)) {
    $0.path[id: 0] = .detail(DetailFeature.State(id: 1))
}

// Access nested state
await store.send(.path(.element(id: 0, action: .detail(.loadButtonTapped)))) {
    $0.path[id: 0, case: \.detail]?.isLoading = true
}

// Use XCTModify for nested state changes (XCTest)
// Or modify directly in trailing closure
```

### Tree navigation

```swift
await store.send(.showDetailTapped) {
    $0.destination = .detail(DetailFeature.State(id: 1))
}

await store.send(.destination(.presented(.detail(.closeButtonTapped)))) {
    $0.destination = nil
}
```

### Alerts

```swift
await store.send(.deleteButtonTapped) {
    $0.alert = AlertState {
        TextState("Delete?")
    } actions: {
        ButtonState(role: .destructive, action: .confirmDelete) {
            TextState("Delete")
        }
    }
}

await store.send(.alert(.presented(.confirmDelete))) {
    $0.alert = nil
    $0.items = []
}
```

## Testing effects that produce multiple actions

```swift
await store.send(.fetchAll) {
    $0.isLoading = true
}
await store.receive(\.moviesLoaded) {
    $0.movies = [.mock]
}
await store.receive(\.showsLoaded) {
    $0.shows = [.mock]
    $0.isLoading = false
}
```

Order matters in exhaustive mode — effects deliver actions in the order they complete.

## Testing cancellation

```swift
@Test func cancelSearch() async {
    let clock = TestClock()
    let store = TestStore(initialState: Feature.State()) {
        Feature()
    } withDependencies: {
        $0.continuousClock = clock
    }

    await store.send(.searchQueryChanged("abc")) {
        $0.query = "abc"
    }
    // Cancel before debounce completes
    await store.send(.searchQueryChanged("")) {
        $0.query = ""
    }
    // No receive needed — previous effect was cancelled
}
```

## Testing shared state

```swift
await store.send(.incrementSharedCount) {
    $0.$count.withLock { $0 = 1 }
}

// After effects, assert shared state
store.assert {
    $0.$count.withLock { $0 = expectedValue }
}
```

## Common test patterns

### Test initial load

```swift
@Test func initialLoad() async {
    let store = TestStore(initialState: Feature.State()) {
        Feature()
    } withDependencies: {
        $0.apiClient.fetch = { .mock }
    }

    await store.send(.viewAppeared) {
        $0.isLoading = true
    }
    await store.receive(\.loaded) {
        $0.isLoading = false
        $0.data = .mock
    }
}
```

### Test error handling

```swift
@Test func handlesFetchError() async {
    struct TestError: Error, Equatable {}
    let store = TestStore(initialState: Feature.State()) {
        Feature()
    } withDependencies: {
        $0.apiClient.fetch = { throw TestError() }
    }

    await store.send(.fetchButtonTapped) {
        $0.isLoading = true
    }
    await store.receive(\.fetchFailed) {
        $0.isLoading = false
        $0.errorMessage = "The operation couldn't be completed. (TestError error 1.)"
    }
}
```

## Avoiding test host app issues

Guard app entry point against test execution:

```swift
// In App struct
init() {
    guard !_XCTIsTesting else { return }
    // Real initialization
}
```

Or use `@Dependency(\.context)` to check if running in test context.

## Do / Don't

- Do use exhaustive testing by default.
- Do override all dependencies the feature uses.
- Do use `ImmediateClock()` for time-based effects.
- Do use `\.keyPath` syntax in `store.receive`.
- Do use hard-coded values in state assertions.
- Don't capture or reuse `TestStore` across tests.
- Don't use relative mutations (`+=`, `-=`) in state assertions.
- Don't forget to `receive` all effect-produced actions in exhaustive mode.
- Don't link TCA to both the app target and the test target (use `@testable import`).
