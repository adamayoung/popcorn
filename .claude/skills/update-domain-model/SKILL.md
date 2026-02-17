---
name: update-domain-model
description: Add properties to an existing domain model from TMDb
---

# Update Domain Model

Guide for adding properties to an existing domain model from TMDb SDK types.

## Required Information

Ask the user for:
- **Context name** (e.g., PopcornMovies, PopcornTVSeries)
- **Domain model** to update (e.g., Movie, TVSeries)
- **Properties to add** (or "all missing" to compare against TMDb type reference)

## TMDb Documentation

DocC documentation: <https://adamayoung.github.io/TMDb/documentation/tmdb/>

Source code (in Xcode DerivedData after build):
```
.../SourcePackages/checkouts/TMDb/Sources/TMDb/Domain/Models/
```

## File Location Conventions

| Layer | Source Path Pattern | Test Path Pattern |
|-------|-------------------|-------------------|
| Domain Entity | `Contexts/Popcorn<X>/Sources/<X>Domain/Entities/<Name>.swift` | -- |
| Adapter Mapper | `Adapters/Contexts/Popcorn<X>Adapters/Sources/.../DataSources/Mappers/<Name>Mapper.swift` | `.../Tests/.../DataSources/Mappers/<Name>MapperTests.swift` |
| Infra Entity | `Contexts/Popcorn<X>/Sources/<X>Infrastructure/DataSources/Local/Models/<Context><Name>Entity.swift` | -- |
| Infra Mapper | `Contexts/Popcorn<X>/Sources/<X>Infrastructure/DataSources/Local/Mappers/<Name>Mapper.swift` | `.../Tests/<X>InfrastructureTests/Mappers/<Name>MapperTests.swift` |
| App Model | `Contexts/Popcorn<X>/Sources/<X>Application/Models/<Name>Details.swift` | -- |
| App Mapper | `Contexts/Popcorn<X>/Sources/<X>Application/Mappers/<Name>DetailsMapper.swift` | `.../Tests/<X>ApplicationTests/Mappers/<Name>DetailsMapperTests.swift` |
| Test Helpers | -- | `.../Tests/<X><Layer>Tests/Helpers/<Name>+Mocks.swift` |

## Steps

### 1. Identify Missing Properties

Compare the TMDb type reference (see [TMDB_MAPPING.md](../../../docs/TMDB_MAPPING.md)) with the current domain entity.

### 2. Domain Layer -- New Supporting Entities (if needed)

For new complex types (enums, structs), create domain entities:
- `Contexts/Popcorn<X>/Sources/<X>Domain/Entities/<NewType>.swift`

### 3. Domain Layer -- Update Main Entity

Add properties to the struct, init, and init defaults:
- `Contexts/Popcorn<X>/Sources/<X>Domain/Entities/<Name>.swift`

### 4. Adapter Layer -- New Sub-Mappers (TDD)

For each new complex type, write tests first then implement:
- Test: `Adapters/.../Tests/.../Mappers/<NewType>MapperTests.swift`
- Source: `Adapters/.../Sources/.../Mappers/<NewType>Mapper.swift`

### 5. Adapter Layer -- Update Main Mapper (TDD)

Update tests then implementation:
- Test: `Adapters/.../Tests/.../Mappers/<Name>MapperTests.swift`
- Source: `Adapters/.../Sources/.../Mappers/<Name>Mapper.swift`

### 6. Infrastructure Layer -- New SwiftData Entities (if needed)

For new complex types that need persistence:
- `Contexts/Popcorn<X>/Sources/<X>Infrastructure/DataSources/Local/Models/<Context><NewType>Entity.swift`

### 7. Infrastructure Layer -- Update Main Entity

Add properties and relationships:
- `Contexts/Popcorn<X>/Sources/<X>Infrastructure/DataSources/Local/Models/<Context><Name>Entity.swift`

### 8. Infrastructure Layer -- Update Mapper (TDD)

Update all 3 methods (entity->domain, domain->entity, update-in-place) with tests:
- Test: `Contexts/.../Tests/<X>InfrastructureTests/Mappers/<Name>MapperTests.swift`
- Source: `Contexts/.../Sources/<X>Infrastructure/DataSources/Local/Mappers/<Name>Mapper.swift`

### 9. Application Layer -- Update Model and Mapper

- Model: `Contexts/Popcorn<X>/Sources/<X>Application/Models/<Name>Details.swift`
- Mapper: `Contexts/Popcorn<X>/Sources/<X>Application/Mappers/<Name>DetailsMapper.swift`
- Test: `Contexts/.../Tests/<X>ApplicationTests/Mappers/<Name>DetailsMapperTests.swift`

### 10. Update Test Helpers

Update `<Name>+Mocks.swift` in all test targets that use it.

### 11. Verify

Run the full pre-PR checklist: `/format`, `/lint`, `/build`, `/test`

## Code Patterns

### Domain Entity

```swift
import Foundation

public struct <Name>: Identifiable, Equatable, Sendable {
    public let id: Int
    public let name: String
    public let optionalField: String?

    public init(
        id: Int,
        name: String,
        optionalField: String? = nil
    ) {
        self.id = id
        self.name = name
        self.optionalField = optionalField
    }
}
```

Rules:
- `public struct` with `Identifiable, Equatable, Sendable`
- All properties `public let` (immutable)
- Optional properties default to `nil` in init
- Image paths stored as raw `URL?` (NOT resolved)
- **No** external dependencies (only `Foundation`)

### Domain Enum

```swift
public enum MovieStatus: String, Equatable, Sendable {
    case rumoured
    case planned
    case inProduction
    case postProduction
    case released
    case cancelled
}
```

Rules:
- `String` raw value for SwiftData persistence
- `Equatable, Sendable` (NOT `Identifiable`)

### Adapter Mapper (TMDb -> Domain)

```swift
import Foundation
import <Context>Domain
import TMDb

struct <Name>Mapper {
    // Sub-mappers as private stored properties
    private let subMapper = SubMapper()

    func map(_ dto: TMDb.<Type>) -> <Context>Domain.<Type> {
        <Context>Domain.<Type>(
            // Direct pass-through for matching types:
            id: dto.id,

            // Nil-coalesce for required fields that are optional in TMDb:
            overview: dto.overview ?? "",

            // Optional arrays -- use ?. on the array, .map on elements:
            genres: dto.genres?.map(genreMapper.map),

            // Optional single value -- use .map (Optional.map):
            status: dto.status.map(statusMapper.map),
            belongsToCollection: dto.belongsToCollection.map(collectionMapper.map),

            // Simple pass-through for optional scalars:
            popularity: dto.popularity
        )
    }
}
```

Rules:
- `internal struct` (no access modifier)
- Primary method: `func map(_ dto: TMDb.X) -> Domain.X`
- When TMDb and domain type names collide, use fully-qualified names
- Sub-mappers for nested/complex types
- **Optional array**: `dto.array?.map(subMapper.map)` -- `?.` on array, `.map` on elements
- **Optional single**: `dto.value.map(subMapper.map)` -- `Optional.map`, NOT `?.`
- **Optional enum**: `dto.status.map(enumMapper.map)` -- same `Optional.map` pattern
- **Required from optional**: `dto.overview ?? ""` -- nil-coalesce

### SwiftData Entity

```swift
import Foundation
import SwiftData

@Model
final class <Context><Name>Entity: Equatable, ModelExpirable {
    @Attribute(.unique) var <name>ID: Int      // NOT "id"
    var title: String
    var optionalField: String?
    var enumField: String?                      // Enums stored as raw String
    var genderField: Int?                       // Gender stored as Int
    @Relationship(deleteRule: .cascade) var children: [ChildEntity]?
    @Relationship(deleteRule: .cascade) var child: ChildEntity?
    var cachedAt: Date

    init(
        <name>ID: Int,
        title: String,
        optionalField: String? = nil,
        children: [ChildEntity]? = nil,
        cachedAt: Date = Date.now
    ) { ... }
}
```

Rules:
- `@Model final class`, internal access
- Entity naming: `<Context><DomainName>Entity`
- Primary ID: `<entityName>ID` (e.g., `movieID`), **not** `id`, with `@Attribute(.unique)`
- All properties `var` (SwiftData requirement)
- Enums stored as raw `String?` -- convert with `MyEnum(rawValue:)`
- `Gender` stored as `Int`
- Relationships: `@Relationship(deleteRule: .cascade)`
- Always include `cachedAt: Date` for `ModelExpirable`
- **IMPORTANT**: `@Model` classes are NOT `Sendable` -- use `static func` factories in tests, NOT `static let`

### Infrastructure Mapper (Domain <-> SwiftData)

Three methods required:

```swift
struct <Name>Mapper {
    // 1. Entity -> Domain
    func map(_ entity: <Context><Name>Entity) -> <Name> {
        <Name>(
            id: entity.<name>ID,
            // Enum: entity.status.flatMap { MyEnum(rawValue: $0) }
            // Relationship array: entity.children.map { mapChildrenToDomain($0) }
            // Relationship single: entity.child.map { mapChildToDomain($0) }
        )
    }

    // 2. Domain -> Entity (create new)
    func map(_ domain: <Name>) -> <Context><Name>Entity {
        <Context><Name>Entity(
            <name>ID: domain.id,
            // Enum: domain.status?.rawValue
            // Relationship array: domain.children.map { mapChildrenToEntity($0) }
        )
    }

    // 3. Domain -> Entity (update existing in-place)
    func map(_ domain: <Name>, to entity: <Context><Name>Entity) {
        entity.title = domain.title
        // ... all fields ...
        entity.cachedAt = .now    // Always refresh
    }

    // Private helpers for relationship mapping
    private func mapChildrenToDomain(_ children: [ChildEntity]) -> [Child] { ... }
    private func mapChildrenToEntity(_ children: [Child]) -> [ChildEntity] { ... }
}
```

Key patterns:
- **Entity -> Domain enum**: `entity.status.flatMap { MyEnum(rawValue: $0) }`
- **Domain -> Entity enum**: `domain.status?.rawValue`
- **Entity -> Domain relationship (array)**: `entity.children.map { mapToDomain($0) }` -- `Optional.map` on the array, then `Array.map` inside the closure
- **Entity -> Domain relationship (single)**: `entity.child.map { mapToDomain($0) }` -- `Optional.map`
- Update method always sets `entity.cachedAt = .now`

### Application Model

```swift
import CoreDomain
import Foundation
import <Context>Domain

public struct <Name>Details: Identifiable, Equatable, Sendable {
    // Same as domain entity EXCEPT:
    // - Image paths become ImageURLSet?
    // - May add enriched fields (certification, isOnWatchlist)
    public let posterURLSet: ImageURLSet?
    public let backdropURLSet: ImageURLSet?
    public let logoURLSet: ImageURLSet?
    public let certification: String?
    public let isOnWatchlist: Bool
}
```

### Application Mapper

```swift
import CoreDomain
import Foundation
import <Context>Domain

struct <Name>DetailsMapper {
    func map(
        _ entity: <Name>,
        imageCollection: ImageCollection,
        certification: String?,
        isOnWatchlist: Bool = false,
        imagesConfiguration: ImagesConfiguration
    ) -> <Name>Details {
        let posterURLSet = imagesConfiguration.posterURLSet(for: entity.posterPath)
        let backdropURLSet = imagesConfiguration.posterURLSet(for: entity.backdropPath)
        let logoURLSet = imagesConfiguration.logoURLSet(for: imageCollection.logoPaths.first)

        return <Name>Details(
            // ... pass through all domain properties ...
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            logoURLSet: logoURLSet,
            certification: certification,
            isOnWatchlist: isOnWatchlist
        )
    }
}
```

### Test Mock Factory

```swift
// Tests/<Context><Layer>Tests/Helpers/<Name>+Mocks.swift
import Foundation
import <Context>Domain

extension <Name> {
    static func mock(
        id: Int = 1,
        title: String = "Test <Name>",
        optionalField: String? = "Default Value"
    ) -> <Name> {
        <Name>(
            id: id,
            title: title,
            optionalField: optionalField
        )
    }
}
```

Rules:
- Extension with `static func mock(...)` -- sensible defaults for all properties
- Optional properties have non-nil defaults (so callers only override what they test)
- For `@Model` types, use `static func` factories, NOT `static let` (concurrency safety)

## Common Pitfalls

- **`Optional.map` vs `?.`**: For mapping a single optional value through a mapper, use `.map(mapper.map)`, NOT `?.map`. The `?.` syntax is for optional chaining on arrays.
- **`@Model` in tests**: `@Model` classes aren't `Sendable`. Use `static func makeEntity()` factory methods, not `static let`.
- **SwiftLint limits**: `function_body_length` (50 lines), `file_length` (400 lines), `type_body_length` (350 lines). Split large test methods and use shared data helpers.
- **Enum persistence**: Domain enums need `String` raw values. SwiftData entities store them as `String?`. Convert with `.rawValue` / `init(rawValue:)`.
- **Image paths**: Domain stores raw `URL?` paths (e.g., `/poster.jpg`). Application layer resolves to full `ImageURLSet?` via `ImagesConfiguration`.

$ARGUMENTS
