# Models

## When to use this reference

Use this file when defining new persistent models, choosing property types, excluding properties from persistence, or understanding the `PersistentModel` protocol.

## @Model macro

The `@Model` macro converts a Swift class into a persistent model. It generates conformance to `PersistentModel`, `Observable`, and `Sendable`.

```swift
@Model
final class MoviesMovieEntity {
    var movieID: Int = 0
    var title: String = ""
    var overview: String = ""
    var releaseDate: Date?
    var posterPath: URL?
    var cachedAt: Date = Date.now

    init(movieID: Int, title: String, overview: String) {
        self.movieID = movieID
        self.title = title
        self.overview = overview
    }
}
```

**Key rules:**
- Must be a `class` (not struct or enum)
- Must be `final` (best practice for SwiftData performance)
- All noncomputed stored properties are persisted by default
- Computed properties are automatically transient

## Supported property types

| Type | Notes |
|------|-------|
| `Bool`, `Int`, `Double`, `Float`, `String` | Primitive types, persisted directly |
| `Date`, `URL`, `UUID`, `Data` | Foundation types, persisted directly |
| `Optional<T>` | Any supported type wrapped in optional |
| `[T]` | Arrays of supported types |
| Codable structs/enums | Encoded as binary data in the store |
| Other `@Model` classes | Creates a relationship (see `relationships.md`) |

### Codable enums as properties

For static data (e.g., media types, status), use `Codable` enums directly — no `@Relationship` needed:

```swift
enum MediaType: String, Codable {
    case movie
    case tvSeries
    case person
}

@Model
final class SearchHistoryEntry {
    var mediaID: Int?
    var mediaType: MediaType?
}
```

## @Transient — excluding properties

Use `@Transient` to exclude a property from persistence:

```swift
@Model
final class RemoteImage {
    var sourceURL: URL
    var data: Data

    @Transient
    var isDownloading = false  // NOT persisted
}
```

**Rules:**
- Non-optional `@Transient` properties **must** have a default value — SwiftData needs it when materialising fetched instances
- Optional `@Transient` properties default to `nil`
- Computed properties are automatically transient (no macro needed)

## PersistentModel protocol

`@Model` generates conformance to `PersistentModel`. You rarely implement this directly.

**Key properties:**
- `persistentModelID` — the stable identity (`PersistentIdentifier`)
- `modelContext` — the context managing this instance (`nil` if unregistered)
- `hasChanges` — whether the model has unsaved modifications
- `isDeleted` — whether the model is marked for deletion

**Inherits from:** `Identifiable` — every `@Model` class automatically gets a unique `id`.

## Project pattern — entity naming

In this project, entity classes are prefixed with the context name to avoid collisions:

```
MoviesMovieEntity          (PopcornMovies context)
TVSeriesEntity             (PopcornTVSeries context)
DiscoverMovieItemEntity    (PopcornDiscover context)
SearchMediaSearchHistoryEntryEntity  (PopcornSearch context)
```

Entities live in `Sources/<Context>Infrastructure/DataSources/Local/Models/`.

## Do / Don't

- **Do** use `final class` for all `@Model` types.
- **Do** provide default values for all stored properties (required for CloudKit compatibility, good practice for all).
- **Do** use `Codable` enums for fixed sets of values.
- **Don't** use structs or enums with `@Model`.
- **Don't** expose `@Model` types outside the Infrastructure layer — map to domain entities at the repository boundary.
- **Don't** use `@Model` classes as `static let` in tests — they aren't `Sendable` safe. Use `static func` factories instead.
