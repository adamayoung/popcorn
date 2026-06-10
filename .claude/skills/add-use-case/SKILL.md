---
name: add-use-case
description: Add a use case to an existing context
---

# Add a Use Case to Existing Context

Guide for adding a new use case following clean architecture patterns.

## Required Information

Ask the user for:
- **Context name** (e.g., PopcornMovies, PopcornTVSeries)
- **Use case name** (e.g., FetchMovieCredits)
- **Purpose** of the use case

## Steps

### 1. Create Use Case Directory

```
Contexts/{Context}/Sources/{Context}Application/UseCases/{UseCaseName}/
```

### 2. Create Three Files

**{UseCaseName}UseCase.swift** - Protocol definition:
```swift
public protocol {UseCaseName}UseCase: Sendable {
    func execute(...) async throws({UseCaseName}Error) -> ResultType
}
```

**Default{UseCaseName}UseCase.swift** - Implementation:
```swift
final class Default{UseCaseName}UseCase: {UseCaseName}UseCase {
    private let repository: any SomeRepository

    init(repository: some SomeRepository) {
        self.repository = repository
    }

    func execute(...) async throws({UseCaseName}Error) -> ResultType {
        // Implementation
    }
}
```

**{UseCaseName}Error.swift** - Error type:
```swift
public enum {UseCaseName}Error: Error, Equatable, Sendable {
    case notFound
    case unknown(Error? = nil)
}
```

### 3. Add Factory Method

In `{Context}Application/{Context}ApplicationFactory.swift`:
```swift
func make{UseCaseName}UseCase() -> some {UseCaseName}UseCase {
    Default{UseCaseName}UseCase(repository: repository)
}
```

### 4. Expose in Composition Layer

In `{Context}Composition/Popcorn{Context}Factory.swift`:
```swift
public func make{UseCaseName}UseCase() -> some {UseCaseName}UseCase {
    applicationFactory.make{UseCaseName}UseCase()
}
```

This is all the wiring the use case needs: the context factory is already exposed
on `AppServices` (e.g. `services.{context}Factory`), so any feature can reach the
new use case through it.

### 5. Consume from a Feature

There is no per-use-case dependency registration. A feature reaches the use case
in its `{Feature}Dependencies.live(services:)` builder via the context factory on
`AppServices`, mapping the domain result to a view model:

```swift
public extension {Feature}Dependencies {

    static func live(services: AppServices) -> {Feature}Dependencies {
        let useCase = services.{context}Factory.make{UseCaseName}UseCase()

        return {Feature}Dependencies(
            fetch: { id in
                let result = try await useCase.execute(id: id)
                return {Feature}Mapper().map(result)
            }
        )
    }

}
```

### 6. Write Unit Tests

Create tests in `Contexts/{Context}/Tests/{Context}ApplicationTests/UseCases/{UseCaseName}/`:
- Create mock repository
- Test the happy path and the translation of each error type
- Use the Swift Testing framework

$ARGUMENTS
