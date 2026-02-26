# Concurrency

## When to use this reference

Use this file when performing background data operations, understanding SwiftData's thread safety model, transferring model references across actors, or working with `@ModelActor` in Swift 6.

## Sendability rules

| Type | Sendable | Notes |
|------|----------|-------|
| `ModelContainer` | Yes | Safe to pass across actor boundaries |
| `ModelContext` | **No** | Must stay on its creating actor |
| `PersistentModel` instances | **No** | Access only from the context's actor |
| `PersistentIdentifier` | Yes | Use to transfer model references |
| `FetchDescriptor` | Yes | Safe to construct anywhere |
| `Schema` | Yes | Safe to pass anywhere |

## @ModelActor macro

Converts a Swift `actor` into a model actor with its own isolated `ModelContext`:

```swift
@ModelActor
actor SwiftDataMovieLocalDataSource: MovieLocalDataSource {
    private let ttl: TimeInterval = 60 * 60 * 24  // 1 day

    func movie(withID id: Int) async throws(MovieLocalDataSourceError) -> Movie? {
        let descriptor = FetchDescriptor<MoviesMovieEntity>(
            predicate: #Predicate { $0.movieID == id }
        )

        guard let entity = try modelContext.fetch(descriptor).first else {
            return nil
        }

        guard !isExpired(entity.cachedAt, ttl: ttl) else {
            return nil
        }

        return MovieMapper().map(entity)
    }

    func setMovie(_ movie: Movie) async throws(MovieLocalDataSourceError) {
        let entity = MovieMapper().map(movie)
        modelContext.insert(entity)
        try modelContext.save()
    }
}
```

### What the macro provides

- `modelContainer` — the container passed in `init(modelContainer:)`
- `modelContext` — an isolated context created from the container
- `modelExecutor` — the serial executor coordinating access
- `init(modelContainer:)` — the designated initialiser

### Creating a model actor

```swift
let dataSource = SwiftDataMovieLocalDataSource(
    modelContainer: modelContainer
)
```

## Transferring model references across actors

**Never** pass `PersistentModel` instances across actor boundaries. Use `PersistentIdentifier`:

```swift
// On background actor
let newEntity = MyEntity(name: "Test")
modelContext.insert(newEntity)
try modelContext.save()
let entityID = newEntity.persistentModelID  // PersistentIdentifier is Sendable

// On main actor
let entity = mainContext.model(for: entityID) as? MyEntity
// or type-safe:
let entity = mainContext.registeredModel(for: entityID) as MyEntity?
```

## @ModelActor subscript

`ModelActor` provides a subscript for safe model lookup by ID:

```swift
let entity = self[identifier, as: MyEntity.self]
```

## DefaultSerialModelExecutor

The default executor that serialises storage access:

```swift
let executor = DefaultSerialModelExecutor(modelContext: context)
```

You rarely create this manually — `@ModelActor` handles it automatically.

## Project pattern — local data sources

In this project, all local data sources are `@ModelActor` actors conforming to a domain protocol:

```swift
@ModelActor
actor SwiftDataMovieLocalDataSource: MovieLocalDataSource, SwiftDataFetchStreaming {
    // modelContainer and modelContext provided by @ModelActor
    // Conforms to domain protocol (MovieLocalDataSource)
    // Conforms to streaming protocol (SwiftDataFetchStreaming)
}
```

**Location:** `Sources/<Context>Infrastructure/DataSources/Local/`

### Reactive streaming

The `SwiftDataFetchStreaming` protocol (from `DataPersistenceInfrastructure`) provides reactive updates:

```swift
func stream<Entity, Output>(
    for descriptor: FetchDescriptor<Entity>,
    map: @escaping @Sendable ([Entity]) -> Output
) -> AsyncThrowingStream<Output, Error>
```

It listens to both:
- `ModelContext.didSave` — local changes
- `NSPersistentCloudKitContainer.eventChangedNotification` — CloudKit sync

## Swift 6 strict concurrency notes

- `@Model` classes get compiler-level `Sendable` conformance from the macro, but this does **not** mean they're safe to access off-actor. You must still only access properties from the context's actor.
- `VersionedSchema` and `SchemaMigrationPlan` protocol properties should use `static let` to avoid `nonisolated global shared mutable state` warnings.

## Do / Don't

- **Do** use `@ModelActor` for all background data access.
- **Do** pass `PersistentIdentifier` (not model instances) across actors.
- **Do** call `save()` explicitly — `@ModelActor` contexts don't autosave.
- **Don't** pass `ModelContext` across actor boundaries.
- **Don't** access `@Model` properties from a different actor than the one that fetched them.
- **Don't** hold references to `@Model` instances beyond the scope of the actor call.
