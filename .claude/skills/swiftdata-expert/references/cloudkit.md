# CloudKit Integration

## When to use this reference

Use this file when configuring CloudKit sync, understanding model constraints for CloudKit compatibility, troubleshooting sync issues, or deciding between local-only and CloudKit stores.

## Configuration

### Xcode capabilities

1. **iCloud** capability with CloudKit enabled
2. **Background Modes** capability with "Remote notifications" enabled

### ModelConfiguration

```swift
// Auto-discover container from entitlements
let config = ModelConfiguration(cloudKitDatabase: .automatic)

// Specific container
let config = ModelConfiguration(
    schema: schema,
    url: storeURL,
    cloudKitDatabase: .private("iCloud.uk.co.adam-young.Popcorn")
)

// Disable sync
let config = ModelConfiguration(cloudKitDatabase: .none)
```

## Schema constraints for CloudKit

CloudKit has strict requirements that differ from local-only stores:

| Feature | Local-Only | CloudKit |
|---------|-----------|----------|
| `@Attribute(.unique)` | Allowed | **Forbidden** — concurrent sync can't enforce uniqueness |
| Non-optional properties | Allowed | Must have default values |
| Non-optional relationships | Allowed | **Forbidden** — all relationships must be optional |
| `.deny` delete rule | Allowed | **Forbidden** — sync is not immediate |
| `.cascade` delete rule | Allowed | Allowed |
| `.nullify` delete rule | Allowed | Allowed |
| Property defaults | Recommended | **Required** for all properties |

### CloudKit-compatible model example

```swift
@Model
final class MoviesWatchlistMovieEntity: Equatable, Identifiable {
    // NO @Attribute(.unique) — CloudKit can't enforce it
    var movieID: Int?        // Optional — CloudKit requires it
    var createdAt: Date?     // Optional — CloudKit requires it

    init(movieID: Int, createdAt: Date) {
        self.movieID = movieID
        self.createdAt = createdAt
    }
}
```

### Local-only model example (for comparison)

```swift
@Model
final class MoviesMovieEntity {
    @Attribute(.unique) var movieID: Int = 0  // Unique is fine for local-only
    var title: String = ""                     // Non-optional with default is fine
    var overview: String = ""

    @Relationship(deleteRule: .cascade)
    var genres: [MoviesGenreEntity]? = []      // Relationships can be non-optional too
}
```

## Additive-only production schemas

**Critical:** After promoting a CloudKit schema to production:
- You **cannot** delete model types
- You **cannot** change existing attribute types
- You **can** add new model types
- You **can** add new optional attributes to existing types

This is why proper migration planning is essential before the first production release.

## How to check if a model uses CloudKit

Look at the Infrastructure factory for the context:

```swift
// CloudKit — requires migration plan
cloudKitDatabase: .private("iCloud.uk.co.adam-young.Popcorn")

// Local-only — can use delete-and-recreate
cloudKitDatabase: .none
```

**Project factories:**
- `MoviesInfrastructureFactory` — `modelContainer` (local) + `cloudKitModelContainer` (CloudKit)
- `TVSeriesInfrastructureFactory` — `modelContainer` (local only)
- `DiscoverInfrastructureFactory` — `modelContainer` (local only)
- `SearchInfrastructureFactory` — `cloudKitModelContainer` (CloudKit)

## Sync behavior

- CloudKit syncs user data across devices using the user's iCloud account
- Sync happens automatically in the background
- Local changes are pushed to CloudKit; remote changes are pulled
- If the local database is deleted, CloudKit will re-sync all data from the cloud
- `NSPersistentCloudKitContainer.eventChangedNotification` is posted when sync events occur

## Project strategy

| Data Type | Store | Rationale |
|-----------|-------|-----------|
| API cache (movies, TV, discover) | Local-only | Disposable — re-fetched from TMDb API |
| User watchlist | CloudKit | User-generated — must sync across devices |
| Search history | CloudKit | User-generated — must sync across devices |

## Disabling sync for existing CloudKit apps

If the app already uses CloudKit for other purposes, pass `.none` to prevent SwiftData from syncing specific stores:

```swift
let config = ModelConfiguration(cloudKitDatabase: .none)
```

## Do / Don't

- **Do** check `cloudKitDatabase` configuration before adding `@Attribute(.unique)`.
- **Do** make all properties optional (or have defaults) in CloudKit models.
- **Do** make all relationships optional in CloudKit models.
- **Do** plan migrations before the first production CloudKit schema promotion.
- **Don't** use `@Attribute(.unique)` with CloudKit stores.
- **Don't** use `.deny` delete rule with CloudKit stores.
- **Don't** assume sync order — inverse relationships must be set explicitly.
- **Don't** delete and recreate CloudKit stores on schema failure — user data would be lost.
