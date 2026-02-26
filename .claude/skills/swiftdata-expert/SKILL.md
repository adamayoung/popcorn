---
name: swiftdata-expert
description: 'Expert guidance on SwiftData: @Model, ModelContainer, ModelContext, FetchDescriptor, relationships, @ModelActor concurrency, CloudKit sync, migrations (VersionedSchema, SchemaMigrationPlan), and caching strategies. Use when defining models, querying data, setting up persistence, debugging SwiftData issues, planning migrations, or reviewing SwiftData code.'
---

# SwiftData

## Overview

Use this skill for authoritative guidance on SwiftData (iOS 17+/macOS 14+). Covers model definition, container/context management, querying, relationships, concurrency with `@ModelActor`, CloudKit integration, schema migrations, and caching patterns. Assumes Swift 6.2 strict concurrency.

## Agent behavior contract (follow these rules)

1. Always use `@Model` on classes — never hand-write `PersistentModel` conformance.
2. Always use `@ModelActor` for background data access — never pass `ModelContext` across actor boundaries.
3. Pass `PersistentIdentifier` (not model instances) across actors — resolve on the target actor's context.
4. Check `cloudKitDatabase` configuration before applying constraints — `@Attribute(.unique)` and `.deny` delete rules are forbidden with CloudKit.
5. Use `static let` (not `static var`) for `VersionedSchema` and `SchemaMigrationPlan` protocol properties — the protocols require only `{ get }`.
6. For non-CloudKit cache stores, use the delete-and-recreate pattern on container failure — never migrate disposable cached data.
7. For CloudKit stores, always define `VersionedSchema` + `SchemaMigrationPlan` — user data must never be silently deleted.
8. Use `FetchDescriptor` with `#Predicate` for all queries — never use raw NSPredicate or string-based predicates.
9. Prefer `@Attribute(.externalStorage)` for large binary data — never store images or files inline in SQLite.
10. Consult `docs/SWIFTDATA.md` for project-specific patterns before writing any SwiftData code.

## First 60 seconds (triage template)

- Clarify the goal: new model, querying, relationships, migration, CloudKit, concurrency, or debugging.
- Collect minimal facts:
  - Is the store CloudKit-synced or local-only cache?
  - Which context module does this belong to?
  - Is this a new model or modification to an existing one?
- Branch quickly:
  - new model or properties -> `models.md` + `attributes.md`
  - querying or filtering -> `querying.md`
  - relationships or delete rules -> `relationships.md`
  - background work or concurrency -> `concurrency.md`
  - schema change or migration -> `migrations.md`
  - CloudKit sync issues -> `cloudkit.md`
  - container/context setup -> `containers.md`

## Common pitfalls -> next best move

- `ModelContext` passed across actors -> use `@ModelActor` with its own context.
- `@Attribute(.unique)` on a CloudKit model -> remove it; CloudKit cannot enforce uniqueness.
- `static var` on `VersionedSchema` triggers concurrency warning -> change to `static let`.
- `nonisolated(unsafe)` on schema properties -> unnecessary, use `static let` instead.
- Container creation crashes after schema change -> local-only stores should use delete-and-recreate pattern.
- Orphaned `-wal` and `-shm` files after database deletion -> clean up all three SQLite files.
- `@Transient` property without default value -> must provide default (SwiftData needs it for fetch materialisation).
- Relationship not optional in CloudKit model -> all CloudKit relationships must be optional.
- Missing `@Attribute(originalName:)` after rename -> data will be lost; use `originalName` for lightweight migration.

## Verification checklist

- Confirm `@Model` is applied to all persistence classes.
- Confirm CloudKit models have no `@Attribute(.unique)`, no `.deny` delete rules, and all-optional relationships.
- Confirm local-only models use `cloudKitDatabase: .none` in `ModelConfiguration`.
- Confirm `@ModelActor` is used for all background data access (not raw `ModelContext`).
- Confirm `VersionedSchema` and `SchemaMigrationPlan` use `static let` (not `static var`).
- Confirm non-CloudKit containers use `ModelContainerFactory.makeLocalModelContainer` (delete-and-recreate).
- Confirm CloudKit containers use `ModelContainerFactory.makeCloudKitModelContainer` with a migration plan.
- Confirm all `@Transient` non-optional properties have default values.
- Confirm `FetchDescriptor` uses typed `#Predicate` (not string-based predicates).

## References

- `references/_index.md` — navigation index with quick links by problem
- `references/models.md` — `@Model`, property types, `@Transient`, `PersistentModel`
- `references/attributes.md` — `@Attribute` options (`.unique`, `.externalStorage`, `.transformable`, `originalName`)
- `references/relationships.md` — `@Relationship`, delete rules, inverse relationships, cardinality
- `references/querying.md` — `FetchDescriptor`, `#Predicate`, `SortDescriptor`, `@Query`, batch operations
- `references/containers.md` — `ModelContainer`, `ModelConfiguration`, `ModelContext`, container factory patterns
- `references/concurrency.md` — `@ModelActor`, `PersistentIdentifier`, thread safety, Swift 6
- `references/cloudkit.md` — CloudKit sync, constraints, schema limitations, configuration
- `references/migrations.md` — `VersionedSchema`, `SchemaMigrationPlan`, `MigrationStage`, lightweight vs custom
