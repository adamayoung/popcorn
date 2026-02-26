# Querying

## When to use this reference

Use this file when fetching models, building predicates, sorting results, using `@Query` in SwiftUI, or performing batch operations.

## FetchDescriptor

Describes criteria, sort order, and configuration for a fetch:

```swift
let descriptor = FetchDescriptor<MoviesMovieEntity>(
    predicate: #Predicate { $0.movieID == id },
    sortBy: [SortDescriptor(\.title)]
)

let movies = try modelContext.fetch(descriptor)
```

### Key properties

| Property | Type | Purpose |
|----------|------|---------|
| `predicate` | `Predicate<T>?` | Filter criteria |
| `sortBy` | `[SortDescriptor<T>]` | Sort order |
| `fetchLimit` | `Int?` | Max results |
| `fetchOffset` | `Int?` | Skip first N results |
| `includePendingChanges` | `Bool` | Include unsaved changes (default `true`) |
| `propertiesToFetch` | `[PartialKeyPath<T>]?` | Partial fetch (specific attributes only) |
| `relationshipKeyPathsForPrefetching` | `[PartialKeyPath<T>]?` | Prefetch related models |

### Fetch variants

```swift
// Full fetch
let results = try context.fetch(descriptor)

// Count only
let count = try context.fetchCount(descriptor)

// IDs only (lightweight)
let ids = try context.fetchIdentifiers(descriptor)

// Batched fetch (memory efficient)
let results = try context.fetch(descriptor, batchSize: 50)

// Enumeration (lowest memory footprint)
try context.enumerate(descriptor, batchSize: 100) { entity in
    // process one at a time
}
```

## #Predicate macro

Type-safe filtering using Foundation's `Predicate`:

```swift
// Simple equality
#Predicate<MoviesMovieEntity> { $0.movieID == 42 }

// String contains
#Predicate<MoviesMovieEntity> { $0.title.contains("Star") }

// Compound conditions
#Predicate<MoviesMovieEntity> {
    $0.releaseDate != nil && $0.popularity > 10.0
}

// Optional handling
#Predicate<MoviesMovieEntity> {
    $0.posterPath != nil
}
```

### Supported operations

- Comparisons: `==`, `!=`, `>`, `<`, `>=`, `<=`
- Logical: `&&`, `||`, `!`
- String: `.contains()`, `.localizedStandardContains()`, `.hasPrefix()`, `.hasSuffix()`
- Optional: `!= nil`, `== nil`
- Collections: `.contains()`, `.isEmpty`

### Limitations

- Cannot call custom methods on the model
- Cannot use complex closures or higher-order functions
- Cannot reference non-stored properties (computed, transient)

## SortDescriptor

```swift
// Ascending (default)
SortDescriptor(\.title)

// Descending
SortDescriptor(\.createdAt, order: .reverse)

// Multiple sort criteria
[SortDescriptor(\.category), SortDescriptor(\.name)]
```

## @Query in SwiftUI

For views that directly observe model data:

```swift
struct MoviesList: View {
    @Query(sort: \.title) private var movies: [MoviesMovieEntity]

    var body: some View {
        List(movies) { movie in
            Text(movie.title)
        }
    }
}
```

### Dynamic queries

Rebuild queries dynamically in the initialiser:

```swift
init(searchText: String) {
    _movies = Query(
        filter: #Predicate<MoviesMovieEntity> {
            searchText.isEmpty || $0.title.contains(searchText)
        },
        sort: \.title
    )
}
```

SwiftUI re-evaluates the initialiser when inputs change.

**Project note:** This project does NOT use `@Query` in views — TCA features fetch data through use cases and reducers. `@Query` is documented here for completeness.

## Batch operations

### Batch delete

```swift
try context.delete(
    model: MoviesMovieEntity.self,
    where: #Predicate { $0.cachedAt < cutoffDate }
)
```

### Delete all data

```swift
try container.deleteAllData()
```

## Change tracking

```swift
// Check before saving
if context.hasChanges {
    try context.save()
}

// Inspect pending changes
context.insertedModelsArray   // models pending insertion
context.changedModelsArray    // models with unsaved modifications
context.deletedModelsArray    // models pending deletion

// Discard all pending changes
context.rollback()
```

## Notifications

- `ModelContext.willSave` — posted before a save
- `ModelContext.didSave` — posted after a successful save (includes inserted/updated/deleted info)

Used in this project by `SwiftDataFetchStreaming` to provide reactive updates.

## Do / Don't

- **Do** use `fetchCount` when you only need the count.
- **Do** use `fetchIdentifiers` for lightweight ID-only queries.
- **Do** use `enumerate` with `batchSize` for large result sets.
- **Do** set `fetchLimit` when you only need the first result.
- **Don't** use string-based predicates — always use `#Predicate`.
- **Don't** fetch all entities and filter in memory — push filtering to the descriptor.
- **Don't** forget to call `context.save()` — autosave is disabled for manually created contexts.
