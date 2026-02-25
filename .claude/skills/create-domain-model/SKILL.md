---
name: create-domain-model
description: Create a new domain model from TMDb
---

# Create Domain Model

Guide for creating a new domain model from TMDb SDK types. See `references/domain-model-patterns.md` for code patterns, file locations, and common pitfalls.

## Required Information

Ask the user for:
- **Context name** (e.g., PopcornMovies, PopcornTVSeries)
- **TMDb type** to map from (e.g., TMDb.Movie, TMDb.Person)
- **Domain model name** (e.g., Movie, Person)
- **Properties to include** (or "all" for every TMDb property)

## TMDb Documentation

DocC documentation: <https://adamayoung.github.io/TMDb/documentation/tmdb/>

Source code (in Xcode DerivedData after build):
```
.../SourcePackages/checkouts/TMDb/Sources/TMDb/Domain/Models/
```

## Steps

### 1. Create Domain Entity

- File: `Contexts/Popcorn<X>/Sources/<X>Domain/Entities/<Name>.swift`
- Conforms to: `Identifiable, Equatable, Sendable`

### 2. Create Adapter Mapper (TDD)

- Test: `Adapters/.../Tests/.../Mappers/<Name>MapperTests.swift`
- Source: `Adapters/.../Sources/.../Mappers/<Name>Mapper.swift`

### 3. Create SwiftData Entity

- File: `Contexts/Popcorn<X>/Sources/<X>Infrastructure/DataSources/Local/Models/<Context><Name>Entity.swift`
- Conforms to: `Equatable, ModelExpirable`

### 4. Create Infrastructure Mapper (TDD)

- Test: `Contexts/.../Tests/<X>InfrastructureTests/Mappers/<Name>MapperTests.swift`
- Source: `Contexts/.../Sources/<X>Infrastructure/DataSources/Local/Mappers/<Name>Mapper.swift`
- Implement all 3 methods: entity->domain, domain->entity, update-in-place

### 5. Create Application Model

- File: `Contexts/Popcorn<X>/Sources/<X>Application/Models/<Name>Details.swift`
- Replace `URL?` paths with `ImageURLSet?`

### 6. Create Application Mapper (TDD)

- Test: `Contexts/.../Tests/<X>ApplicationTests/Mappers/<Name>DetailsMapperTests.swift`
- Source: `Contexts/.../Sources/<X>Application/Mappers/<Name>DetailsMapper.swift`

### 7. Create Test Helpers

- `<Name>+Mocks.swift` in each test target that needs it

### 8. Wire into Data Sources, Repositories, Use Cases

Follow the `/add-use-case` skill for wiring into the architecture.

### 9. Verify

Run the full pre-PR checklist: `/format`, `/lint`, `/build`, `/test`

$ARGUMENTS
