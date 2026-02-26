# Agent guide for SwiftData

For comprehensive SwiftData guidance (models, attributes, querying, concurrency, CloudKit, migrations), use the `swiftdata-expert` skill. This document covers **project-specific patterns only**.

## Architecture Rules

- SwiftData is used exclusively in the **Infrastructure layer**
- `@Model` classes define persistence schema — never expose them outside Infrastructure
- Map to Domain entities at the repository boundary via mapper classes
- Each context owns its own `ModelContainer(s)` — never share between contexts

## Container Strategy

| Container | Database File | CloudKit | On Schema Failure |
|-----------|--------------|----------|-------------------|
| Movies (cache) | `popcorn-movies.sqlite` | `.none` | Delete and recreate |
| Movies (watchlist) | `popcorn-movies-cloudkit.sqlite` | `.private(...)` | Migration plan |
| TVSeries (cache) | `popcorn-tvseries.sqlite` | `.none` | Delete and recreate |
| Discover (cache) | `popcorn-discover.sqlite` | `.none` | Delete and recreate |
| Search (history) | `popcorn-search-cloudkit.sqlite` | `.private(...)` | Migration plan |

### Non-CloudKit containers (cache data)

Use `ModelContainerFactory.makeLocalModelContainer` — on failure it deletes the database files and retries:

```swift
let storeURL = URL.documentsDirectory.appending(path: "popcorn-movies.sqlite")

return ModelContainerFactory.makeLocalModelContainer(
    schema: schema,
    url: storeURL,
    logger: logger
)
```

### CloudKit containers (user data)

Use `ModelContainerFactory.makeCloudKitModelContainer` with a `SchemaMigrationPlan`:

```swift
let storeURL = URL.documentsDirectory.appending(path: "popcorn-movies-cloudkit.sqlite")

return ModelContainerFactory.makeCloudKitModelContainer(
    schema: schema,
    url: storeURL,
    cloudKitDatabase: .private("iCloud.uk.co.adam-young.Popcorn"),
    migrationPlan: MoviesWatchlistMigrationPlan.self,
    logger: logger
)
```

## CloudKit Model Constraints

Before applying constraints, check `cloudKitDatabase` in the Infrastructure factory:

- `cloudKitDatabase: .none` → local-only, `@Attribute(.unique)` is fine
- `cloudKitDatabase: .private(...)` → CloudKit rules apply:
  - No `@Attribute(.unique)` — causes sync conflicts
  - All properties must have default values or be optional
  - All relationships must be optional
  - No `.deny` delete rule

## Migration Strategy

- **Non-CloudKit stores:** Never migrate — delete and recreate (cached API data is re-fetched)
- **CloudKit stores:** Always use `VersionedSchema` + `SchemaMigrationPlan`

Current CloudKit schemas:

| Context | Schema V1 | Migration Plan | File Location |
|---------|-----------|----------------|---------------|
| PopcornMovies | `MoviesWatchlistSchemaV1` | `MoviesWatchlistMigrationPlan` | `MoviesInfrastructure/DataSources/Local/Models/` |
| PopcornSearch | `SearchHistorySchemaV1` | `SearchHistoryMigrationPlan` | `SearchInfrastructure/DataSources/Local/Models/` |

Use `static let` (not `static var`) for `VersionedSchema` and `SchemaMigrationPlan` properties to avoid Swift 6 concurrency warnings.

## Key File Locations

| Pattern | Path |
|---------|------|
| Entity models | `Sources/<Context>Infrastructure/DataSources/Local/Models/` |
| Entity mappers | `Sources/<Context>Infrastructure/DataSources/Local/Mappers/` |
| Local data sources | `Sources/<Context>Infrastructure/DataSources/Local/` |
| Repositories | `Sources/<Context>Infrastructure/Repositories/` |
| Infrastructure factory | `Sources/<Context>Infrastructure/<Context>InfrastructureFactory.swift` |
| Container factory | `Platform/DataPersistenceInfrastructure/Sources/.../ModelContainerFactory.swift` |
| Fetch streaming | `Platform/DataPersistenceInfrastructure/Sources/.../SwiftDataFetchStreaming.swift` |
