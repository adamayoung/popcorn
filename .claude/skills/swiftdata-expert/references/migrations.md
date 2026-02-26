# Migrations

## When to use this reference

Use this file when planning schema migrations, defining versioned schemas, creating migration plans, choosing between lightweight and custom migrations, or handling complex data transformations.

## When to migrate

- **Non-CloudKit stores (cache data):** Don't migrate — use the delete-and-recreate pattern (see `containers.md`).
- **CloudKit stores (user data):** Always migrate — user data must be preserved across schema changes.

## VersionedSchema protocol

Describes a specific version of a schema:

```swift
protocol VersionedSchema : SendableMetatype {
    static var versionIdentifier: Schema.Version { get }
    static var models: [any PersistentModel.Type] { get }
}
```

### Defining V1 (current schema)

Use `static let` (not `static var`) — the protocol only requires `{ get }`:

```swift
package enum MoviesWatchlistSchemaV1: VersionedSchema {

    package static let versionIdentifier = Schema.Version(1, 0, 0)

    package static let models: [any PersistentModel.Type] = [
        MoviesWatchlistMovieEntity.self
    ]

}
```

**Why `static let`?** `static var` triggers Swift 6 concurrency warnings about nonisolated global shared mutable state. `static let` is safe because it's immutable.

### Defining V2 (after a model change)

When a model changes, create a V2 schema with the model definition **nested inside**:

```swift
package enum MoviesWatchlistSchemaV2: VersionedSchema {

    package static let versionIdentifier = Schema.Version(2, 0, 0)

    package static let models: [any PersistentModel.Type] = [
        WatchlistMovieEntity.self
    ]

    @Model
    final class WatchlistMovieEntity {
        var movieID: Int?
        var createdAt: Date?
        var addedFrom: String?  // new property

        init(movieID: Int, createdAt: Date, addedFrom: String? = nil) {
            self.movieID = movieID
            self.createdAt = createdAt
            self.addedFrom = addedFrom
        }
    }

}

// Typealias so the rest of the code uses the latest version
typealias MoviesWatchlistMovieEntity = MoviesWatchlistSchemaV2.WatchlistMovieEntity
```

**Key principle:** For V1 (before any migration exists), models can live in their own files. When V2 arrives, copy the V1 model definition, modify it, nest it in V2, and add a typealias.

## SchemaMigrationPlan protocol

Describes how to migrate between schema versions:

```swift
protocol SchemaMigrationPlan : SendableMetatype {
    static var schemas: [any VersionedSchema.Type] { get }
    static var stages: [MigrationStage] { get }
}
```

### Empty plan (V1 only — no migrations yet)

```swift
package enum MoviesWatchlistMigrationPlan: SchemaMigrationPlan {

    package static let schemas: [any VersionedSchema.Type] = [
        MoviesWatchlistSchemaV1.self
    ]

    package static let stages: [MigrationStage] = []

}
```

### Plan with migration stages

```swift
package enum MoviesWatchlistMigrationPlan: SchemaMigrationPlan {

    package static let schemas: [any VersionedSchema.Type] = [
        MoviesWatchlistSchemaV1.self,
        MoviesWatchlistSchemaV2.self
    ]

    package static let stages: [MigrationStage] = [
        migrateV1toV2
    ]

    static let migrateV1toV2 = MigrationStage.lightweight(
        fromVersion: MoviesWatchlistSchemaV1.self,
        toVersion: MoviesWatchlistSchemaV2.self
    )

}
```

## MigrationStage

### Lightweight migration

For changes SwiftData can handle automatically:

```swift
MigrationStage.lightweight(
    fromVersion: SchemaV1.self,
    toVersion: SchemaV2.self
)
```

**Supports:**
- Adding new optional properties
- Adding properties with default values
- Removing properties
- Renaming properties (with `@Attribute(originalName:)`)

### Custom migration

For changes requiring code:

```swift
MigrationStage.custom(
    fromVersion: SchemaV1.self,
    toVersion: SchemaV2.self,
    willMigrate: { context in
        // Runs BEFORE the new schema is applied
        // Access OLD model types here
        // Use for: cleaning up old data, pre-processing
    },
    didMigrate: { context in
        // Runs AFTER the new schema is applied
        // Access NEW model types here
        // Use for: populating new required fields, data transformation
        let entities = try context.fetch(FetchDescriptor<SchemaV2.MyEntity>())
        for entity in entities {
            entity.newField = computeDefault(entity)
        }
        try context.save()
    }
)
```

**When to use custom:**
- Adding a non-optional property without a default value
- Changing a property's type
- Splitting one model into multiple
- Merging multiple models into one
- Complex data transformations

### willMigrate vs didMigrate

| Callback | Schema State | Use For |
|----------|-------------|---------|
| `willMigrate` | Old schema still active | Data cleanup, pre-processing |
| `didMigrate` | New schema applied | Populating new fields, transformations |

**Important:** Default values in Swift initialisers do **not** guarantee existing rows receive values during migration. Use `didMigrate` for explicit backfilling.

## Bridge version pattern

For complex data reshaping (e.g., splitting one model into two), use a bridge version:

### Step 1: V2 (bridge) — keep legacy fields + add new structure

```swift
enum SchemaV2: VersionedSchema {
    static let versionIdentifier = Schema.Version(2, 0, 0)
    static let models: [any PersistentModel.Type] = [Parent.self, Child.self]

    @Model
    final class Parent {
        @Attribute(originalName: "legacyData")
        var legacyData: String?  // keep old field temporarily

        @Relationship(deleteRule: .cascade)
        var children: [Child] = []
    }

    @Model
    final class Child {
        var value: String
        var parent: Parent?
    }
}
```

### Step 2: Custom migration to populate new structure

```swift
static let migrateV1toV2 = MigrationStage.custom(
    fromVersion: SchemaV1.self,
    toVersion: SchemaV2.self,
    willMigrate: nil,
    didMigrate: { context in
        let parents = try context.fetch(FetchDescriptor<SchemaV2.Parent>())
        for parent in parents {
            if let legacyData = parent.legacyData {
                let child = SchemaV2.Child(value: legacyData)
                parent.children.append(child)
            }
        }
        try context.save()
    }
)
```

### Step 3: V3 (cleanup) — remove legacy fields

```swift
enum SchemaV3: VersionedSchema {
    static let versionIdentifier = Schema.Version(3, 0, 0)
    static let models: [any PersistentModel.Type] = [Parent.self, Child.self]

    @Model
    final class Parent {
        // legacyData removed — lightweight migration handles column removal
        @Relationship(deleteRule: .cascade)
        var children: [Child] = []
    }
}

// V2 -> V3 is lightweight (just removing the legacy column)
static let migrateV2toV3 = MigrationStage.lightweight(
    fromVersion: SchemaV2.self,
    toVersion: SchemaV3.self
)
```

## Applying migration plans to ModelContainer

```swift
let container = ModelContainerFactory.makeCloudKitModelContainer(
    schema: schema,
    url: storeURL,
    cloudKitDatabase: .private("iCloud.uk.co.adam-young.Popcorn"),
    migrationPlan: MoviesWatchlistMigrationPlan.self,
    logger: logger
)
```

Or directly:

```swift
let container = try ModelContainer(
    for: schema,
    migrationPlan: MyMigrationPlan.self,
    configurations: [config]
)
```

## Version skipping

Users may skip app versions — your migration plan must handle jumping from V1 directly to V3. SwiftData applies stages sequentially (V1->V2, V2->V3), so each stage must be correct independently.

## Project migration infrastructure

| Context | CloudKit Container | Schema V1 | Migration Plan |
|---------|-------------------|-----------|----------------|
| PopcornMovies | `popcorn-movies-cloudkit.sqlite` | `MoviesWatchlistSchemaV1` | `MoviesWatchlistMigrationPlan` |
| PopcornSearch | `popcorn-search-cloudkit.sqlite` | `SearchHistorySchemaV1` | `SearchHistoryMigrationPlan` |

**File locations:**
- Schema: `Sources/<Context>Infrastructure/DataSources/Local/Models/<Name>SchemaV1.swift`
- Plan: `Sources/<Context>Infrastructure/DataSources/Local/Models/<Name>MigrationPlan.swift`

## When to introduce a new VersionedSchema

Only when shipping model changes to users — not during development. During development, delete and recreate the database (or use `isStoredInMemoryOnly` for tests).

## Testing migrations

- Test from real on-disk stores, not pristine simulator databases
- Test version skipping (V1 -> V3)
- Test that `didMigrate` correctly backfills new fields
- Use in-memory stores for unit tests of migration logic

## Do / Don't

- **Do** use `static let` for all `VersionedSchema` and `SchemaMigrationPlan` properties.
- **Do** define V1 schemas upfront for CloudKit stores so you're ready for V2.
- **Do** test migrations from every possible previous version.
- **Do** use bridge versions for complex data reshaping.
- **Don't** use `static var` — triggers Swift 6 concurrency warnings.
- **Don't** rely on Swift initialiser defaults for migration backfilling — use `didMigrate`.
- **Don't** introduce `VersionedSchema` during development — only when shipping to users.
- **Don't** migrate non-CloudKit cache stores — use delete-and-recreate instead.
