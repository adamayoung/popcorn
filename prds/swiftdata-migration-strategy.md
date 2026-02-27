# PRD: SwiftData Migration Strategy

## Overview

Implement a SwiftData migration strategy that handles schema changes differently based on container type: non-CloudKit containers (cache-only) delete and recreate the database on failure, while CloudKit containers use versioned schemas with migration plans.

## Problem

The app currently uses `fatalError` when a ModelContainer fails to create due to schema changes. This means any model change to a cached data container crashes the app on launch. For CloudKit containers, there's no migration infrastructure — a schema change would either crash or silently lose user data (watchlist, search history) that syncs across devices.

## Goals

1. Non-CloudKit containers gracefully recover from schema mismatches by deleting the old database and recreating it (cached data is re-fetched from the API)
2. CloudKit containers have VersionedSchema V1 defined so migration plans can be added when models change in the future
3. Reusable helper utilities in the shared `DataPersistenceInfrastructure` package
4. Consistent database naming convention (`popcorn-search-cloudkit.sqlite` instead of `searchkit-cloudkit.sqlite`)

## Non-Goals

- Migrating existing data in non-CloudKit containers (it's all cached API data)
- Defining V2 schemas (no model changes are happening yet)
- Changing the CloudKit container identifier
- Adding migration plans for non-CloudKit containers

---

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| Delete-and-retry for non-CloudKit containers | Cache data is disposable — re-fetched from TMDb API on next access. Migration complexity is not worth it. |
| VersionedSchema V1 for CloudKit containers only | CloudKit data is user-generated (watchlist, search history) and must be preserved. Defining V1 now means future schema changes just add V2 + a migration stage. |
| Helper in `DataPersistenceInfrastructure` | All 4 infrastructure packages already depend on this package. Centralises the logic. |
| Models stay in existing files (not nested in schema enums) | For V1 there's no naming conflict. When V2 comes, the new model version goes in the V2 enum and a typealias updates the current reference. |
| Clean up .sqlite, -wal, -shm files on delete | Prevents orphaned journal files from causing issues on recreate. |
| Rename search database to `popcorn-search-cloudkit.sqlite` | Consistent naming convention with other containers (`popcorn-movies`, `popcorn-tvseries`, `popcorn-discover`). CloudKit will re-sync data into the new file. |

## Data Flow

```
ModelContainer Creation (non-CloudKit):

  Factory.modelContainer
    └─▶ ModelContainerFactory.makeLocalModelContainer(schema, url, logger)
         ├─▶ try ModelContainer(for:configurations:)
         │    └─ Success ──▶ return container
         └─ Failure
              ├─▶ log warning
              ├─▶ removeSQLiteFiles(at: url)  // .sqlite + -wal + -shm
              └─▶ try ModelContainer(for:configurations:)
                   ├─ Success ──▶ return container
                   └─ Failure ──▶ fatalError (unrecoverable)

ModelContainer Creation (CloudKit):

  Factory.cloudKitModelContainer
    └─▶ ModelContainerFactory.makeCloudKitModelContainer(schema, url, cloudKitDatabase, migrationPlan, logger)
         └─▶ try ModelContainer(for:migrationPlan:configurations:)
              ├─ Success ──▶ return container
              └─ Failure ──▶ fatalError (user data must not be silently deleted)
```

---

## User Stories

### US-1: ModelContainer Factory Helper — `S`

> As a **developer**, I want a reusable helper for creating ModelContainers so that all infrastructure factories handle schema failures consistently.

**Acceptance Criteria**:
- [ ] `ModelContainerFactory.makeLocalModelContainer(schema:url:logger:)` creates a non-CloudKit container
- [ ] On initial failure, it logs a warning, deletes .sqlite/.sqlite-wal/.sqlite-shm files, and retries
- [ ] On second failure, it calls `fatalError` with a descriptive message
- [ ] `ModelContainerFactory.makeCloudKitModelContainer(schema:url:cloudKitDatabase:migrationPlan:logger:)` creates a CloudKit container with a migration plan
- [ ] On failure, the CloudKit helper calls `fatalError` (no silent data deletion)
- [ ] Both methods are `package` access level

**Tech Elab**:
- Create `Platform/DataPersistenceInfrastructure/Sources/DataPersistenceInfrastructure/ModelContainerFactory.swift`
- `package enum ModelContainerFactory` with two static methods
- `makeLocalModelContainer` — creates `ModelConfiguration(schema:url:cloudKitDatabase: .none)`, wraps in do-catch with retry
- `makeCloudKitModelContainer` — creates `ModelConfiguration(schema:url:cloudKitDatabase:)`, passes `migrationPlan` to `ModelContainer(for:migrationPlan:configurations:)`
- `private static func removeSQLiteFiles(at url: URL)` — iterates suffixes `["", "-wal", "-shm"]`, constructs file paths, calls `FileManager.default.removeItem`
- Import `Foundation`, `OSLog`, `SwiftData`

**Test Elab**:
- Happy path: `makeLocalModelContainer` creates a valid container with a simple test schema
- Happy path: `makeCloudKitModelContainer` creates a valid container with a migration plan
- Edge case: `removeSQLiteFiles` handles non-existent files without throwing (FileManager operations use `try?`)
- Edge case: SQLite journal files are cleaned up alongside the main database file

**Dependencies**: none

---

### US-2: VersionedSchema for CloudKit Containers — `M`

> As a **developer**, I want V1 versioned schemas and migration plans for CloudKit containers so that future model changes can be migrated without data loss.

**Acceptance Criteria**:
- [ ] `MoviesWatchlistSchemaV1` defines version `1.0.0` with `MoviesWatchlistMovieEntity` in its models array
- [ ] `MoviesWatchlistMigrationPlan` lists `[MoviesWatchlistSchemaV1.self]` in schemas and has empty stages
- [ ] `SearchHistorySchemaV1` defines version `1.0.0` with `SearchMediaSearchHistoryEntryEntity` in its models array
- [ ] `SearchHistoryMigrationPlan` lists `[SearchHistorySchemaV1.self]` in schemas and has empty stages
- [ ] `MoviesInfrastructureFactory.cloudKitModelContainer` uses `ModelContainerFactory.makeCloudKitModelContainer` with `MoviesWatchlistMigrationPlan`
- [ ] `SearchInfrastructureFactory.cloudKitModelContainer` uses `ModelContainerFactory.makeCloudKitModelContainer` with `SearchHistoryMigrationPlan`
- [ ] Search database renamed from `searchkit-cloudkit.sqlite` to `popcorn-search-cloudkit.sqlite`
- [ ] Old `searchkit-cloudkit.sqlite` files are cleaned up on first launch

**Tech Elab**:
- Create `Contexts/PopcornMovies/Sources/MoviesInfrastructure/DataSources/Local/Models/MoviesWatchlistSchemaV1.swift`
  - `package enum MoviesWatchlistSchemaV1: VersionedSchema` with `versionIdentifier = Schema.Version(1, 0, 0)` and `models = [MoviesWatchlistMovieEntity.self]`
- Create `Contexts/PopcornMovies/Sources/MoviesInfrastructure/DataSources/Local/Models/MoviesWatchlistMigrationPlan.swift`
  - `package enum MoviesWatchlistMigrationPlan: SchemaMigrationPlan` with `schemas = [MoviesWatchlistSchemaV1.self]` and `stages: [MigrationStage] = []`
- Create `Contexts/PopcornSearch/Sources/SearchInfrastructure/DataSources/Local/Models/SearchHistorySchemaV1.swift`
  - `package enum SearchHistorySchemaV1: VersionedSchema` with `versionIdentifier = Schema.Version(1, 0, 0)` and `models = [SearchMediaSearchHistoryEntryEntity.self]`
- Create `Contexts/PopcornSearch/Sources/SearchInfrastructure/DataSources/Local/Models/SearchHistoryMigrationPlan.swift`
  - `package enum SearchHistoryMigrationPlan: SchemaMigrationPlan` with `schemas = [SearchHistorySchemaV1.self]` and `stages: [MigrationStage] = []`
- Modify `Contexts/PopcornMovies/Sources/MoviesInfrastructure/MoviesInfrastructureFactory.swift`
  - Replace `cloudKitModelContainer` body with call to `ModelContainerFactory.makeCloudKitModelContainer(schema:url:cloudKitDatabase:migrationPlan:logger:)` passing `MoviesWatchlistMigrationPlan.self`
- Modify `Contexts/PopcornSearch/Sources/SearchInfrastructure/SearchInfrastructureFactory.swift`
  - Replace `cloudKitModelContainer` body with call to `ModelContainerFactory.makeCloudKitModelContainer`
  - Change database URL from `searchkit-cloudkit.sqlite` to `popcorn-search-cloudkit.sqlite`
  - Add one-time cleanup of old `searchkit-cloudkit.sqlite` files (call `ModelContainerFactory.removeSQLiteFiles` — make it `package` instead of `private`)

**Test Elab**:
- Happy path: VersionedSchema V1 lists correct model types
- Happy path: MigrationPlan lists correct schemas and empty stages
- Edge case: Migration plan with single schema (V1 only) doesn't crash when passed to ModelContainer
- Edge case: Old search database files are removed during rename (test `removeSQLiteFiles` with known file paths)

**Dependencies**: US-1

---

### US-3: Update Non-CloudKit Factories — `S`

> As a **developer**, I want non-CloudKit infrastructure factories to use the delete-and-retry helper so that schema changes in cached data don't crash the app.

**Acceptance Criteria**:
- [ ] `MoviesInfrastructureFactory.modelContainer` uses `ModelContainerFactory.makeLocalModelContainer`
- [ ] `TVSeriesInfrastructureFactory.modelContainer` uses `ModelContainerFactory.makeLocalModelContainer`
- [ ] `DiscoverInfrastructureFactory.modelContainer` uses `ModelContainerFactory.makeLocalModelContainer`
- [ ] All three factories no longer have inline do-catch/fatalError for the non-CloudKit container
- [ ] Each factory passes its own logger instance

**Tech Elab**:
- Modify `Contexts/PopcornMovies/Sources/MoviesInfrastructure/MoviesInfrastructureFactory.swift`
  - Replace `modelContainer` static property body with `ModelContainerFactory.makeLocalModelContainer(schema:url:logger:)`
  - Keep the same schema array and store URL
- Modify `Contexts/PopcornTVSeries/Sources/TVSeriesInfrastructure/TVSeriesInfrastructureFactory.swift`
  - Same pattern — replace inline container creation with factory call
- Modify `Contexts/PopcornDiscover/Sources/DiscoverInfrastructure/DiscoverInfrastructureFactory.swift`
  - Same pattern — replace inline container creation with factory call

**Test Elab**:
- Happy path: Each factory's `modelContainer` is created successfully (verified by repository construction not crashing)
- Edge case: After deleting the database file manually, the factory recreates it on next access
- Edge case: Factory works when no previous database exists (fresh install)
- Edge case: Logger receives the warning message when delete-and-retry triggers

**Dependencies**: US-1

---

## Story Dependency Graph

```
US-1 (ModelContainerFactory helper)
 ├──▶ US-2 (CloudKit VersionedSchema + factory updates)
 └──▶ US-3 (Non-CloudKit factory updates)
```

**Parallel tracks** (after US-1):
- Track A: US-2 (CloudKit schemas + migration plans)
- Track B: US-3 (Non-CloudKit delete-and-retry)

**No merge points** — US-2 and US-3 are independent after US-1.

## Verification

1. `/format` — no violations
2. `/lint` — no violations
3. `/build` — build succeeds (warnings are errors)
4. `/test` — all tests pass
5. Manual: Delete app from simulator, reinstall — containers created cleanly
6. Manual: Install old build, then new build — non-CloudKit caches recreated, CloudKit data preserved
