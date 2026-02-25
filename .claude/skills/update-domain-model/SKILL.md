---
name: update-domain-model
description: Add properties to an existing domain model from TMDb
---

# Update Domain Model

Guide for adding properties to an existing domain model from TMDb SDK types. See `references/domain-model-patterns.md` (in the `create-domain-model` skill) for code patterns, file locations, and common pitfalls.

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

$ARGUMENTS
