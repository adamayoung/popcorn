# Containers & Contexts

## When to use this reference

Use this file when creating `ModelContainer` or `ModelContext` instances, configuring storage, understanding the save lifecycle, or using this project's container factory patterns.

## ModelContainer

The central object managing schema and persistent storage:

```swift
// Simple — model types only
let container = try ModelContainer(for: Trip.self, Accommodation.self)

// With configuration
let config = ModelConfiguration(isStoredInMemoryOnly: true)
let container = try ModelContainer(for: Trip.self, configurations: config)

// With migration plan
let container = try ModelContainer(
    for: schema,
    migrationPlan: TripMigrationPlan.self,
    configurations: [config]
)
```

**Key properties:**
- `schema` — the active `Schema`
- `configurations` — array of `ModelConfiguration` instances
- `mainContext` — a `ModelContext` bound to the main actor
- `migrationPlan` — optional `SchemaMigrationPlan.Type`

**Key methods:**
- `deleteAllData()` — removes all persisted model data
- `erase()` — erases the container

**Thread safety:** `ModelContainer` is `Sendable` — safe to pass across actor boundaries.

## ModelConfiguration

Describes storage configuration for a container:

```swift
// Local-only with custom URL
let config = ModelConfiguration(
    schema: schema,
    url: storeURL,
    cloudKitDatabase: .none
)

// CloudKit sync
let config = ModelConfiguration(
    schema: schema,
    url: storeURL,
    cloudKitDatabase: .private("iCloud.uk.co.adam-young.Popcorn")
)

// In-memory (tests/previews)
let config = ModelConfiguration(isStoredInMemoryOnly: true)

// Read-only
let config = ModelConfiguration(allowsSave: false)
```

### CloudKitDatabase options

| Option | Behavior |
|--------|----------|
| `.automatic` | Uses primary ubiquity container from entitlements |
| `.private("container.id")` | Uses a specific iCloud container |
| `.none` | Disables CloudKit sync entirely |

## ModelContext

Manages the lifecycle of persistent models — insert, fetch, delete, save:

```swift
let context = ModelContext(container)
```

**Thread safety:** `ModelContext` is **NOT** `Sendable` — must stay on the actor that created it. Use `@ModelActor` for background work (see `concurrency.md`).

### Save behavior

| Context source | Autosave |
|---------------|----------|
| SwiftUI environment (`.modelContainer(...)`) | Enabled by default |
| Manual (`ModelContext(container)`) | **Disabled** — must call `save()` explicitly |
| `@ModelActor` (`modelContext`) | **Disabled** — must call `save()` explicitly |

### CRUD operations

```swift
// Insert
context.insert(entity)

// Fetch
let results = try context.fetch(descriptor)

// Delete one
context.delete(entity)

// Batch delete
try context.delete(model: MyEntity.self, where: predicate)

// Save
try context.save()

// Rollback (discard unsaved changes)
context.rollback()

// Transaction (auto-saves on completion)
try context.transaction {
    context.insert(entity)
    existingEntity.name = "Updated"
}
```

## Project patterns — ModelContainerFactory

This project uses `ModelContainerFactory` (in `DataPersistenceInfrastructure`) to create containers with consistent error handling.

### Non-CloudKit containers (cache data)

Uses delete-and-recreate on failure — cached data is disposable:

```swift
private static let modelContainer: ModelContainer = {
    let schema = Schema([
        MoviesMovieEntity.self,
        MoviesImageCollectionEntity.self,
        // ...
    ])

    let storeURL = URL.documentsDirectory.appending(path: "popcorn-movies.sqlite")

    return ModelContainerFactory.makeLocalModelContainer(
        schema: schema,
        url: storeURL,
        logger: logger
    )
}()
```

**Behavior:**
1. Try to create `ModelContainer`
2. On failure: log warning, delete `.sqlite` + `-wal` + `-shm` files, retry
3. On second failure: `fatalError` (unrecoverable)

### CloudKit containers (user data)

Uses migration plan — user data must never be silently deleted:

```swift
private static let cloudKitModelContainer: ModelContainer = {
    let schema = Schema([
        MoviesWatchlistMovieEntity.self
    ])

    let storeURL = URL.documentsDirectory.appending(path: "popcorn-movies-cloudkit.sqlite")

    return ModelContainerFactory.makeCloudKitModelContainer(
        schema: schema,
        url: storeURL,
        cloudKitDatabase: .private("iCloud.uk.co.adam-young.Popcorn"),
        migrationPlan: MoviesWatchlistMigrationPlan.self,
        logger: logger
    )
}()
```

**Behavior:**
1. Try to create `ModelContainer` with migration plan
2. On failure: `fatalError` (user data cannot be deleted)

### Database file naming convention

| Container | File |
|-----------|------|
| Movies (cache) | `popcorn-movies.sqlite` |
| Movies (CloudKit) | `popcorn-movies-cloudkit.sqlite` |
| TVSeries (cache) | `popcorn-tvseries.sqlite` |
| Discover (cache) | `popcorn-discover.sqlite` |
| Search (CloudKit) | `popcorn-search-cloudkit.sqlite` |

### SQLite file cleanup

When deleting a database, always clean up all three files:

```swift
ModelContainerFactory.removeSQLiteFiles(at: url)
// Removes: .sqlite, .sqlite-wal, .sqlite-shm
```

## Project pattern — separate containers per context

Each context owns its own `ModelContainer(s)` as `static` properties in the Infrastructure factory. Containers are never shared between contexts:

```
PopcornMovies     → modelContainer (cache) + cloudKitModelContainer (watchlist)
PopcornTVSeries   → modelContainer (cache)
PopcornDiscover   → modelContainer (cache)
PopcornSearch     → cloudKitModelContainer (search history)
```

## Do / Don't

- **Do** use `ModelContainerFactory` for all container creation.
- **Do** use separate containers for cache vs CloudKit data.
- **Do** call `save()` explicitly in `@ModelActor` contexts.
- **Do** clean up all SQLite files (`.sqlite`, `-wal`, `-shm`) when deleting a database.
- **Don't** pass `ModelContext` across actor boundaries — it's not `Sendable`.
- **Don't** migrate non-CloudKit cache stores — use delete-and-recreate.
- **Don't** share a `ModelContainer` between contexts — each context owns its own.
