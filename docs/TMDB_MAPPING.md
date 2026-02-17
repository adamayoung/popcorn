# TMDb Domain Model Mapping Guide

This guide documents how to create and update domain models from TMDb SDK types. It covers the complete mapping pipeline, TMDb type reference, and step-by-step workflows.

## TMDb Documentation

DocC documentation: <https://adamayoung.github.io/TMDb/documentation/tmdb/>

Source code (in Xcode DerivedData after build):
```
.../SourcePackages/checkouts/TMDb/Sources/TMDb/Domain/Models/
```

## TMDb Type Reference

### Movie (`TMDb.Movie`)

| Property | Type | Notes |
|----------|------|-------|
| `id` | `Int` | Required |
| `title` | `String` | Required |
| `tagline` | `String?` | |
| `originalTitle` | `String?` | |
| `originalLanguage` | `String?` | |
| `originCountry` | `[String]?` | |
| `overview` | `String?` | |
| `runtime` | `Int?` | Minutes |
| `genres` | `[Genre]?` | |
| `releaseDate` | `Date?` | |
| `posterPath` | `URL?` | |
| `backdropPath` | `URL?` | |
| `budget` | `Double?` | USD |
| `revenue` | `Double?` | USD |
| `homepageURL` | `URL?` | JSON key: `"homepage"` |
| `imdbID` | `String?` | JSON key: `"imdbId"` |
| `status` | `Status?` | Enum (see below) |
| `productionCompanies` | `[ProductionCompany]?` | |
| `productionCountries` | `[ProductionCountry]?` | |
| `spokenLanguages` | `[SpokenLanguage]?` | |
| `belongsToCollection` | `BelongsToCollection?` | |
| `popularity` | `Double?` | |
| `voteAverage` | `Double?` | |
| `voteCount` | `Int?` | |
| `hasVideo` | `Bool?` | JSON key: `"video"` |
| `isAdultOnly` | `Bool?` | JSON key: `"adult"` |

### TVSeries (`TMDb.TVSeries`)

| Property | Type | Notes |
|----------|------|-------|
| `id` | `Int` | Required |
| `name` | `String` | Required |
| `tagline` | `String?` | |
| `originalName` | `String?` | |
| `originalLanguage` | `String?` | |
| `overview` | `String?` | |
| `episodeRunTime` | `[Int]?` | Minutes |
| `numberOfSeasons` | `Int?` | |
| `numberOfEpisodes` | `Int?` | |
| `seasons` | `[TVSeason]?` | |
| `createdBy` | `[Creator]?` | |
| `genres` | `[Genre]?` | |
| `firstAirDate` | `Date?` | |
| `originCountry` | `[String]?` | |
| `posterPath` | `URL?` | |
| `backdropPath` | `URL?` | |
| `homepageURL` | `URL?` | JSON key: `"homepage"` |
| `isInProduction` | `Bool?` | JSON key: `"inProduction"` |
| `languages` | `[String]?` | |
| `lastAirDate` | `Date?` | |
| `lastEpisodeToAir` | `TVEpisodeAirDate?` | |
| `nextEpisodeToAir` | `TVEpisodeAirDate?` | |
| `networks` | `[Network]?` | |
| `productionCompanies` | `[ProductionCompany]?` | |
| `productionCountries` | `[ProductionCountry]?` | |
| `spokenLanguages` | `[SpokenLanguage]?` | |
| `status` | `String?` | Raw string, not enum |
| `type` | `String?` | |
| `popularity` | `Double?` | |
| `voteAverage` | `Double?` | |
| `voteCount` | `Int?` | |
| `isAdultOnly` | `Bool?` | JSON key: `"adult"` |

### TVSeason (`TMDb.TVSeason`)

| Property | Type | Notes |
|----------|------|-------|
| `id` | `Int` | Required |
| `name` | `String` | Required |
| `seasonNumber` | `Int` | Required |
| `overview` | `String?` | |
| `airDate` | `Date?` | |
| `posterPath` | `URL?` | |
| `voteAverage` | `Double?` | |
| `episodes` | `[TVEpisode]?` | |

### TVEpisode (`TMDb.TVEpisode`)

| Property | Type | Notes |
|----------|------|-------|
| `id` | `Int` | Required |
| `name` | `String` | Required |
| `episodeNumber` | `Int` | Required |
| `seasonNumber` | `Int` | Required |
| `overview` | `String?` | |
| `airDate` | `Date?` | |
| `episodeType` | `String?` | e.g., "finale", "standard" |
| `runtime` | `Int?` | Minutes |
| `showID` | `Int?` | JSON key: `"showId"` |
| `productionCode` | `String?` | |
| `stillPath` | `URL?` | |
| `crew` | `[CrewMember]?` | |
| `guestStars` | `[CastMember]?` | |
| `voteAverage` | `Double?` | |
| `voteCount` | `Int?` | |

### Person (`TMDb.Person`)

| Property | Type | Notes |
|----------|------|-------|
| `id` | `Int` | Required |
| `name` | `String` | Required |
| `alsoKnownAs` | `[String]?` | |
| `knownForDepartment` | `String?` | |
| `biography` | `String?` | |
| `birthday` | `Date?` | |
| `deathday` | `Date?` | |
| `gender` | `Gender` | Required, enum (Int raw) |
| `placeOfBirth` | `String?` | |
| `profilePath` | `URL?` | |
| `popularity` | `Double?` | |
| `imdbID` | `String?` | JSON key: `"imdbId"` |
| `homepageURL` | `URL?` | JSON key: `"homepage"` |

### Supporting Types

**`TMDb.Status`** (enum: String)
| Case | Raw Value |
|------|-----------|
| `.rumoured` | `"Rumored"` |
| `.planned` | `"Planned"` |
| `.inProduction` | `"In Production"` |
| `.postProduction` | `"Post Production"` |
| `.released` | `"Released"` |
| `.cancelled` | `"Canceled"` |

**`TMDb.Gender`** (enum: Int)
| Case | Raw Value |
|------|-----------|
| `.unknown` | `0` |
| `.female` | `1` |
| `.male` | `2` |
| `.other` | `3` |

**`TMDb.Genre`**: `id: Int`, `name: String`

**`TMDb.BelongsToCollection`**: `id: Int`, `name: String`, `posterPath: URL?`, `backdropPath: URL?`

**`TMDb.ProductionCompany`**: `id: Company.ID` (Int), `name: String`, `originCountry: String`, `logoPath: URL?`

**`TMDb.ProductionCountry`**: `countryCode: String` (iso31661), `name: String`

**`TMDb.SpokenLanguage`**: `languageCode: String` (iso6391), `name: String`

**`TMDb.Network`**: `id: Int`, `name: String`, `logoPath: URL?`, `originCountry: String?`, `headquarters: String?`, `homepage: URL?`

**`TMDb.Creator`**: `id: Int`, `creditID: String`, `name: String`, `originalName: String`, `gender: Gender`, `profilePath: URL?`

**`TMDb.CastMember`**: `id: Int`, `castID: Int?`, `creditID: String`, `name: String`, `character: String`, `gender: Gender`, `profilePath: URL?`, `order: Int`

**`TMDb.CrewMember`**: `id: Int`, `creditID: String`, `name: String`, `job: String`, `department: String`, `gender: Gender`, `profilePath: URL?`

## Mapping Pipeline

Data flows through 4 layers, each with its own model types and mappers:

```
TMDb SDK Types
    │
    │ Adapter Mapper (TMDb → Domain)
    ▼
Domain Entities (URL? paths, pure value types)
    │
    │ Infrastructure Mapper (Domain ↔ SwiftData, bidirectional)
    ▼
SwiftData Entities (@Model classes, rawValue enums, cachedAt)
    │
    │ Infrastructure Mapper (SwiftData → Domain, read back)
    ▼
Domain Entities
    │
    │ Application Mapper (Domain → Application, resolves images)
    ▼
Application Models (*Details, ImageURLSet?, enriched fields)
    │
    │ Feature Mapper (Application → Feature-local view models)
    ▼
Feature Models (specific image sizes for UI)
```

## File Location Conventions

| Layer | Source Path Pattern | Test Path Pattern |
|-------|-------------------|-------------------|
| Domain Entity | `Contexts/Popcorn<X>/Sources/<X>Domain/Entities/<Name>.swift` | — |
| Adapter Mapper | `Adapters/Contexts/Popcorn<X>Adapters/Sources/.../DataSources/Mappers/<Name>Mapper.swift` | `.../Tests/.../DataSources/Mappers/<Name>MapperTests.swift` |
| Infra Entity | `Contexts/Popcorn<X>/Sources/<X>Infrastructure/DataSources/Local/Models/<Context><Name>Entity.swift` | — |
| Infra Mapper | `Contexts/Popcorn<X>/Sources/<X>Infrastructure/DataSources/Local/Mappers/<Name>Mapper.swift` | `.../Tests/<X>InfrastructureTests/Mappers/<Name>MapperTests.swift` |
| App Model | `Contexts/Popcorn<X>/Sources/<X>Application/Models/<Name>Details.swift` | — |
| App Mapper | `Contexts/Popcorn<X>/Sources/<X>Application/Mappers/<Name>DetailsMapper.swift` | `.../Tests/<X>ApplicationTests/Mappers/<Name>DetailsMapperTests.swift` |
| Test Helpers | — | `.../Tests/<X><Layer>Tests/Helpers/<Name>+Mocks.swift` |

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

### Adapter Mapper (TMDb → Domain)

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

            // Optional arrays — use ?. on the array, .map on elements:
            genres: dto.genres?.map(genreMapper.map),

            // Optional single value — use .map (Optional.map):
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
- **Optional array**: `dto.array?.map(subMapper.map)` — `?.` on array, `.map` on elements
- **Optional single**: `dto.value.map(subMapper.map)` — `Optional.map`, NOT `?.`
- **Optional enum**: `dto.status.map(enumMapper.map)` — same `Optional.map` pattern
- **Required from optional**: `dto.overview ?? ""` — nil-coalesce

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
- Enums stored as raw `String?` — convert with `MyEnum(rawValue:)`
- `Gender` stored as `Int`
- Relationships: `@Relationship(deleteRule: .cascade)`
- Always include `cachedAt: Date` for `ModelExpirable`
- **IMPORTANT**: `@Model` classes are NOT `Sendable` — use `static func` factories in tests, NOT `static let`

### Infrastructure Mapper (Domain ↔ SwiftData)

Three methods required:

```swift
struct <Name>Mapper {
    // 1. Entity → Domain
    func map(_ entity: <Context><Name>Entity) -> <Name> {
        <Name>(
            id: entity.<name>ID,
            // Enum: entity.status.flatMap { MyEnum(rawValue: $0) }
            // Relationship array: entity.children.map { mapChildrenToDomain($0) }
            // Relationship single: entity.child.map { mapChildToDomain($0) }
        )
    }

    // 2. Domain → Entity (create new)
    func map(_ domain: <Name>) -> <Context><Name>Entity {
        <Context><Name>Entity(
            <name>ID: domain.id,
            // Enum: domain.status?.rawValue
            // Relationship array: domain.children.map { mapChildrenToEntity($0) }
        )
    }

    // 3. Domain → Entity (update existing in-place)
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
- **Entity → Domain enum**: `entity.status.flatMap { MyEnum(rawValue: $0) }`
- **Domain → Entity enum**: `domain.status?.rawValue`
- **Entity → Domain relationship (array)**: `entity.children.map { mapToDomain($0) }` — `Optional.map` on the array, then `Array.map` inside the closure
- **Entity → Domain relationship (single)**: `entity.child.map { mapToDomain($0) }` — `Optional.map`
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
- Extension with `static func mock(...)` — sensible defaults for all properties
- Optional properties have non-nil defaults (so callers only override what they test)
- For `@Model` types, use `static func` factories, NOT `static let` (concurrency safety)

## Workflow: Adding Properties to an Existing Domain Model

### Step 1: Identify missing properties

Compare the TMDb type reference (above) with the current domain entity.

### Step 2: Domain Layer — new supporting entities (if needed)

For new complex types (enums, structs), create domain entities:
- `Contexts/Popcorn<X>/Sources/<X>Domain/Entities/<NewType>.swift`

### Step 3: Domain Layer — update main entity

Add properties to the struct, init, and init defaults:
- `Contexts/Popcorn<X>/Sources/<X>Domain/Entities/<Name>.swift`

### Step 4: Adapter Layer — new sub-mappers (TDD)

For each new complex type, write tests first then implement:
- Test: `Adapters/.../Tests/.../Mappers/<NewType>MapperTests.swift`
- Source: `Adapters/.../Sources/.../Mappers/<NewType>Mapper.swift`

### Step 5: Adapter Layer — update main mapper (TDD)

Update tests then implementation:
- Test: `Adapters/.../Tests/.../Mappers/<Name>MapperTests.swift`
- Source: `Adapters/.../Sources/.../Mappers/<Name>Mapper.swift`

### Step 6: Infrastructure Layer — new SwiftData entities (if needed)

For new complex types that need persistence:
- `Contexts/Popcorn<X>/Sources/<X>Infrastructure/DataSources/Local/Models/<Context><NewType>Entity.swift`

### Step 7: Infrastructure Layer — update main entity

Add properties and relationships:
- `Contexts/Popcorn<X>/Sources/<X>Infrastructure/DataSources/Local/Models/<Context><Name>Entity.swift`

### Step 8: Infrastructure Layer — update mapper (TDD)

Update all 3 methods (entity→domain, domain→entity, update-in-place) with tests:
- Test: `Contexts/.../Tests/<X>InfrastructureTests/Mappers/<Name>MapperTests.swift`
- Source: `Contexts/.../Sources/<X>Infrastructure/DataSources/Local/Mappers/<Name>Mapper.swift`

### Step 9: Application Layer — update model and mapper

- Model: `Contexts/Popcorn<X>/Sources/<X>Application/Models/<Name>Details.swift`
- Mapper: `Contexts/Popcorn<X>/Sources/<X>Application/Mappers/<Name>DetailsMapper.swift`
- Test: `Contexts/.../Tests/<X>ApplicationTests/Mappers/<Name>DetailsMapperTests.swift`

### Step 10: Update test helpers

Update `<Name>+Mocks.swift` in all test targets that use it.

### Step 11: Verify

Run the full pre-PR checklist: `/format`, `/lint`, `/build`, `/test`

## Workflow: Creating a New Domain Model from TMDb

### Step 1: Create domain entity

- File: `Contexts/Popcorn<X>/Sources/<X>Domain/Entities/<Name>.swift`
- Conforms to: `Identifiable, Equatable, Sendable`

### Step 2: Create adapter mapper (TDD)

- Test: `Adapters/.../Tests/.../Mappers/<Name>MapperTests.swift`
- Source: `Adapters/.../Sources/.../Mappers/<Name>Mapper.swift`

### Step 3: Create SwiftData entity

- File: `Contexts/Popcorn<X>/Sources/<X>Infrastructure/DataSources/Local/Models/<Context><Name>Entity.swift`
- Conforms to: `Equatable, ModelExpirable`

### Step 4: Create infrastructure mapper (TDD)

- Test: `Contexts/.../Tests/<X>InfrastructureTests/Mappers/<Name>MapperTests.swift`
- Source: `Contexts/.../Sources/<X>Infrastructure/DataSources/Local/Mappers/<Name>Mapper.swift`
- Implement all 3 methods: entity→domain, domain→entity, update-in-place

### Step 5: Create application model

- File: `Contexts/Popcorn<X>/Sources/<X>Application/Models/<Name>Details.swift`
- Replace `URL?` paths with `ImageURLSet?`

### Step 6: Create application mapper (TDD)

- Test: `Contexts/.../Tests/<X>ApplicationTests/Mappers/<Name>DetailsMapperTests.swift`
- Source: `Contexts/.../Sources/<X>Application/Mappers/<Name>DetailsMapper.swift`

### Step 7: Create test helpers

- `<Name>+Mocks.swift` in each test target that needs it

### Step 8: Wire into data sources, repositories, use cases

Follow the workflows in [ARCHITECTURE.md](ARCHITECTURE.md).

### Step 9: Verify

Run the full pre-PR checklist: `/format`, `/lint`, `/build`, `/test`

## Common Pitfalls

- **`Optional.map` vs `?.`**: For mapping a single optional value through a mapper, use `.map(mapper.map)`, NOT `?.map`. The `?.` syntax is for optional chaining on arrays.
- **`@Model` in tests**: `@Model` classes aren't `Sendable`. Use `static func makeEntity()` factory methods, not `static let`.
- **SwiftLint limits**: `function_body_length` (50 lines), `file_length` (400 lines), `type_body_length` (350 lines). Split large test methods and use shared data helpers.
- **Enum persistence**: Domain enums need `String` raw values. SwiftData entities store them as `String?`. Convert with `.rawValue` / `init(rawValue:)`.
- **Image paths**: Domain stores raw `URL?` paths (e.g., `/poster.jpg`). Application layer resolves to full `ImageURLSet?` via `ImagesConfiguration`.
