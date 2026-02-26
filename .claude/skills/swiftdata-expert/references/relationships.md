# Relationships

## When to use this reference

Use this file when defining relationships between models, choosing delete rules, configuring inverse relationships, or understanding cardinality constraints.

## @Relationship macro

Configures how two `@Model` classes relate:

```swift
@Relationship(
    _ options: Schema.Relationship.Option...,
    deleteRule: Schema.Relationship.DeleteRule = .nullify,
    inverse: AnyKeyPath? = nil
)
```

## Basic patterns

### One-to-many with cascade

```swift
@Model
final class MoviesMovieEntity {
    @Attribute(.unique) var movieID: Int = 0
    var title: String = ""

    @Relationship(deleteRule: .cascade, inverse: \MoviesGenreEntity.movie)
    var genres: [MoviesGenreEntity]? = []
}

@Model
final class MoviesGenreEntity {
    var genreID: Int = 0
    var name: String = ""
    var movie: MoviesMovieEntity?
}
```

### One-to-one

```swift
@Model
final class MoviesMovieEntity {
    @Relationship(deleteRule: .cascade)
    var imageCollection: MoviesImageCollectionEntity?
}

@Model
final class MoviesImageCollectionEntity {
    var movie: MoviesMovieEntity?
}
```

### Many-to-many

Both sides use arrays:

```swift
@Model
final class Student {
    @Relationship(inverse: \Course.students)
    var courses: [Course] = []
}

@Model
final class Course {
    var students: [Student] = []
}
```

## Delete rules

| Rule | Behavior | CloudKit |
|------|----------|----------|
| `.nullify` | Sets the related model's reference to `nil`. **Default.** | Supported |
| `.cascade` | Deletes all related models recursively. | Supported |
| `.deny` | Prevents deletion if references exist. | **Not supported** |
| `.noAction` | Does nothing to related models (can leave orphans). | Supported |

### Choosing a delete rule

- Use `.cascade` when the child has no meaning without the parent (e.g., genres belonging to a movie entity).
- Use `.nullify` when the child can exist independently.
- Use `.deny` only in local-only stores when you need referential integrity enforcement.
- Avoid `.noAction` unless you have a specific cleanup strategy.

## Inverse relationships

SwiftData automatically discovers inverse relationships if it can reliably infer them. When ambiguous (e.g., multiple relationships to the same type), specify `inverse:` explicitly:

```swift
@Relationship(deleteRule: .cascade, inverse: \Child.parent)
var children: [Child] = []
```

**Best practice:** Always specify `inverse:` explicitly for clarity, even when SwiftData could infer it.

## Inserting relationship graphs

When inserting a graph of related models, you only need to insert the **root** — the context automatically discovers and inserts related models:

```swift
let movie = MoviesMovieEntity(movieID: 1, title: "Test")
let genre = MoviesGenreEntity(genreID: 1, name: "Action")
movie.genres = [genre]

modelContext.insert(movie)  // genre is automatically inserted too
```

## CloudKit constraints

When using CloudKit (`cloudKitDatabase` is not `.none`):

- All relationships **must be optional** — sync order is indeterminate
- `.deny` delete rule is **not supported** — sync is not immediate
- Inverse relationships should be explicitly set before saving

See `cloudkit.md` for full CloudKit constraints.

## Do / Don't

- **Do** specify `inverse:` explicitly on all relationships.
- **Do** use `.cascade` for owned children, `.nullify` for shared references.
- **Do** make all relationships optional in CloudKit models.
- **Don't** use `.deny` with CloudKit stores.
- **Don't** insert child models separately when they're part of a relationship graph — insert the root only.
- **Don't** create circular cascade deletes — this can cause infinite recursion.
