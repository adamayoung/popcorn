# Attributes

## When to use this reference

Use this file when customising how properties are persisted: uniqueness constraints, external storage, transformable values, property renaming for migration, and compound indices.

## @Attribute macro

Customises how a property is persisted:

```swift
@Attribute(_ options: Schema.Attribute.Option..., originalName: String? = nil)
```

## Options

### .unique — uniqueness constraint

Ensures the value is unique across all instances. On collision, SwiftData performs an **upsert** (updates the existing record):

```swift
@Model
final class MoviesMovieEntity {
    @Attribute(.unique) var movieID: Int = 0
    var title: String = ""
}
```

**Important:** `@Attribute(.unique)` is **not compatible with CloudKit**. CloudKit cannot enforce uniqueness due to concurrent sync. See `cloudkit.md`.

**For local-only stores** (`cloudKitDatabase: .none`), uniqueness constraints are safe and recommended for cache identity.

### .externalStorage — large binary data

Stores the value in a separate file adjacent to the SQLite store:

```swift
@Model
final class Document {
    var title: String = ""
    @Attribute(.externalStorage) var fileData: Data = Data()
}
```

Best for images, PDFs, or any large `Data` blobs. Prevents SQLite bloat.

### .transformable(by:) — custom serialisation

For types that need a `ValueTransformer`:

```swift
@Attribute(.transformable(by: NSColorTransformer.self))
var color: NSColor
```

Requires a registered `ValueTransformer` subclass. Rarely needed — prefer `Codable` conformance.

### .spotlight — Spotlight indexing

Indexes the value for Spotlight search:

```swift
@Attribute(.spotlight) var title: String = ""
```

### .preserveValueOnDeletion — history tracking

Preserves the value in persistent history when the model is deleted:

```swift
@Attribute(.preserveValueOnDeletion) var deletedTitle: String = ""
```

### .allowsCloudEncryption — encrypted CloudKit storage

Stores the value encrypted in CloudKit:

```swift
@Attribute(.allowsCloudEncryption) var sensitiveNote: String = ""
```

### .ephemeral — transient change tracking

Tracks changes but does **not** persist the value. Similar to `@Transient` but participates in change tracking.

## originalName — property renaming

Essential for **lightweight migration**. Tells SwiftData the previous column name:

```swift
@Attribute(originalName: "movieIdentifier")
var movieID: Int = 0
```

Without `originalName`, renaming a property creates a new column and **loses existing data**.

## #Unique — compound uniqueness (iOS 18+)

Specifies uniqueness constraints at the model level, supporting compound keys:

```swift
@Model
final class Person {
    #Unique<Person>([\.id], [\.givenName, \.familyName])

    var id: UUID = UUID()
    var givenName: String = ""
    var familyName: String = ""
}
```

This declares:
- `id` must be unique individually
- The combination of `givenName` + `familyName` must be unique

**Requires iOS 18+ / macOS 15+.** For iOS 17 compatibility, use `@Attribute(.unique)` on individual properties.

## #Index — query performance (iOS 18+)

Creates binary indices for faster queries:

```swift
@Model
final class Recipe {
    #Index<Recipe>([\.name], [\.createdAt, \.category])

    var name: String = ""
    var createdAt: Date = Date.now
    var category: String = ""
}
```

**Requires iOS 18+ / macOS 15+.**

## Do / Don't

- **Do** use `@Attribute(.unique)` for cache identity in local-only stores.
- **Do** use `@Attribute(originalName:)` when renaming properties.
- **Do** use `@Attribute(.externalStorage)` for data > 100KB.
- **Don't** use `@Attribute(.unique)` with CloudKit — it causes sync conflicts.
- **Don't** rename properties without `originalName` — data will be silently lost.
- **Don't** use `.transformable` when `Codable` conformance will work.
