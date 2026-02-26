# Reference Index

Quick navigation for SwiftData topics.

## Model Definition

| File | Description |
|------|-------------|
| `models.md` | `@Model`, property types, computed/transient properties, `PersistentModel` protocol |
| `attributes.md` | `@Attribute` options: `.unique`, `.externalStorage`, `.transformable`, `originalName`, `#Unique`, `#Index` |
| `relationships.md` | `@Relationship`, delete rules (nullify/cascade/deny/noAction), inverse, cardinality |

## Querying & Persistence

| File | Description |
|------|-------------|
| `querying.md` | `FetchDescriptor`, `#Predicate`, `SortDescriptor`, `@Query`, batch operations, enumeration |
| `containers.md` | `ModelContainer`, `ModelConfiguration`, `ModelContext`, save/delete, undo, project factory patterns |

## Concurrency & CloudKit

| File | Description |
|------|-------------|
| `concurrency.md` | `@ModelActor`, `PersistentIdentifier` transfer, `DefaultSerialModelExecutor`, Swift 6 rules |
| `cloudkit.md` | CloudKit sync, `CloudKitDatabase` options, schema constraints, additive-only production schemas |

## Migrations

| File | Description |
|------|-------------|
| `migrations.md` | `VersionedSchema`, `SchemaMigrationPlan`, `MigrationStage`, lightweight vs custom, bridge versions |

---

## Quick Links by Problem

### I need to...

- **Define a new persistent model** -> `models.md` (@Model, property types)
- **Add unique constraints** -> `attributes.md` (@Attribute(.unique), #Unique)
- **Store large binary data** -> `attributes.md` (@Attribute(.externalStorage))
- **Rename a property without losing data** -> `attributes.md` (@Attribute(originalName:))
- **Set up relationships between models** -> `relationships.md` (@Relationship, delete rules)
- **Query models with filtering** -> `querying.md` (FetchDescriptor, #Predicate)
- **Create a ModelContainer** -> `containers.md` (ModelContainer, ModelConfiguration)
- **Do background data work** -> `concurrency.md` (@ModelActor)
- **Sync data with CloudKit** -> `cloudkit.md` (CloudKitDatabase, constraints)
- **Plan a schema migration** -> `migrations.md` (VersionedSchema, SchemaMigrationPlan)
- **Handle schema changes in cache stores** -> `containers.md` (delete-and-recreate pattern)

### I'm getting an error about...

- **Concurrency-unsafe static var on VersionedSchema** -> `migrations.md` — use `static let` instead
- **@Attribute(.unique) with CloudKit** -> `cloudkit.md` — CloudKit cannot enforce uniqueness
- **ModelContext crossing actor boundaries** -> `concurrency.md` — use @ModelActor
- **Container creation crash after schema change** -> `containers.md` — use delete-and-recreate for caches
- **Missing data after property rename** -> `attributes.md` — add @Attribute(originalName:)
- **Relationship must be optional** -> `cloudkit.md` — CloudKit requires optional relationships
- **@Transient property nil after fetch** -> `models.md` — non-optional @Transient needs a default value

---

## File Statistics

| File | Lines | Primary Topics |
|------|-------|---------------|
| `models.md` | ~120 | @Model, property types, @Transient, PersistentModel |
| `attributes.md` | ~160 | @Attribute options, #Unique, #Index |
| `relationships.md` | ~130 | @Relationship, delete rules, inverse |
| `querying.md` | ~170 | FetchDescriptor, #Predicate, @Query, batch |
| `containers.md` | ~200 | ModelContainer, ModelContext, factory patterns |
| `concurrency.md` | ~140 | @ModelActor, PersistentIdentifier, Swift 6 |
| `cloudkit.md` | ~150 | CloudKit sync, constraints, configuration |
| `migrations.md` | ~250 | VersionedSchema, MigrationStage, custom migrations |
