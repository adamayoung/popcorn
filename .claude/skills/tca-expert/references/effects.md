# Effects

## When to use this reference

Use this file when working with side effects in TCA: async operations, cancellation, debouncing, combining effects, or understanding the `Effect` type.

## Effect basics

Effects represent asynchronous work returned from a reducer. The reducer body is synchronous — all async work must go through effects.

### .none — no side effect

```swift
case .buttonTapped:
    state.count += 1
    return .none
```

### .run — primary async effect

```swift
case .fetchButtonTapped:
    state.isLoading = true
    return .run { send in
        let data = try await apiClient.fetch()
        await send(.dataLoaded(data))
    }
```

The closure receives a `Send<Action>` value. Call `await send(...)` to feed actions back into the reducer.

### .run with error handling

```swift
return .run { send in
    let data = try await apiClient.fetch()
    await send(.dataLoaded(data))
} catch: { error, send in
    await send(.fetchFailed(error.localizedDescription))
}
```

The `catch` closure handles any thrown error. Without it, thrown errors cause a runtime warning in debug and are silently ignored in release.

### .send — synchronous action dispatch

```swift
case .viewAppeared:
    return .send(.loadData)
```

Use sparingly. Prefer helper methods over `.send` for sharing logic (see `reducers.md`).

## Capturing state in effects

Never capture `state` directly — it's an `inout` parameter. Capture specific values:

```swift
case .fetchButtonTapped:
    return .run { [id = state.itemID, query = state.searchQuery] send in
        let result = try await apiClient.search(id: id, query: query)
        await send(.searchCompleted(result))
    }
```

## Cancellation

### Cancel IDs

Define cancel IDs as enum cases or static properties:

```swift
enum CancelID {
    case search
    case fetch
}
```

### Making an effect cancellable

```swift
return .run { send in
    let results = try await apiClient.search(query)
    await send(.searchResults(results))
}
.cancellable(id: CancelID.search)
```

### Cancel in flight

Cancel any previous in-flight effect with the same ID before starting a new one:

```swift
return .run { send in
    let results = try await apiClient.search(query)
    await send(.searchResults(results))
}
.cancellable(id: CancelID.search, cancelInFlight: true)
```

### Explicit cancellation

```swift
case .cancelButtonTapped:
    return .cancel(id: CancelID.search)
```

## Debouncing

Debounce an effect by combining cancellation with a clock delay:

```swift
@Dependency(\.continuousClock) var clock

case .searchQueryChanged:
    return .run { [query = state.searchQuery] send in
        try await clock.sleep(for: .milliseconds(300))
        let results = try await apiClient.search(query)
        await send(.searchResults(results))
    }
    .cancellable(id: CancelID.search, cancelInFlight: true)
```

Each keystroke cancels the previous effect. Only the last one survives past the 300ms delay.

## Combining effects

### .merge — concurrent execution

```swift
return .merge(
    .run { send in
        let movies = try await apiClient.fetchMovies()
        await send(.moviesLoaded(movies))
    },
    .run { send in
        let shows = try await apiClient.fetchShows()
        await send(.showsLoaded(shows))
    }
)
```

### .concatenate — sequential execution

```swift
return .concatenate(
    .send(.startLoading),
    .run { send in
        let data = try await apiClient.fetch()
        await send(.dataLoaded(data))
    }
)
```

### async let — concurrent fetching in a single .run

```swift
return .run { send in
    async let movies = apiClient.fetchMovies()
    async let shows = apiClient.fetchShows()
    let (m, s) = try await (movies, shows)
    await send(.loaded(movies: m, shows: s))
}
```

Prefer `async let` over `.merge` when results are needed together.

## Long-living effects

For effects that run for the lifetime of a feature (e.g., observing notifications):

```swift
case .viewAppeared:
    return .run { send in
        for await notification in NotificationCenter.default.notifications(named: .someEvent) {
            await send(.eventReceived(notification))
        }
    }
    .cancellable(id: CancelID.observation)
```

The effect lives until cancelled or the `for await` loop ends.

## Publisher-based effects

For Combine publisher interop:

```swift
return .publisher {
    NotificationCenter.default.publisher(for: .someEvent)
        .map { Action.eventReceived($0) }
}
.cancellable(id: CancelID.observation)
```

## CPU-intensive work

Offload heavy computation to effects to keep the reducer body responsive:

```swift
case .processData:
    return .run { [data = state.rawData] send in
        let processed = await Task.detached(priority: .userInitiated) {
            // Heavy processing
            data.map { transform($0) }
        }.value
        await send(.processingComplete(processed))
    }
```

For very long loops, yield periodically:

```swift
for (index, item) in items.enumerated() {
    process(item)
    if index.isMultiple(of: 100) {
        await Task.yield()
    }
}
```

## Do / Don't

- Do use `.run` as the primary effect pattern.
- Do capture specific state values, not `state` itself.
- Do use `cancelInFlight: true` for search/typeahead patterns.
- Do use `async let` for concurrent fetches needed together.
- Do handle errors with the `catch:` parameter on `.run`.
- Don't perform async work directly in the `Reduce` closure.
- Don't ignore thrown errors — always provide a `catch:` handler or handle in the closure.
- Don't use `.send` for async orchestration — use `.run` instead.
- Don't forget to make long-living effects cancellable.
