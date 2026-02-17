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

### 5. Add TCA Dependency

Create `AppDependencies/{Context}/{UseCaseName}UseCase+TCA.swift`:
```swift
enum {UseCaseName}UseCaseKey: DependencyKey {
    static var liveValue: any {UseCaseName}UseCase {
        @Dependency(\.{context}Factory) var factory
        return factory.make{UseCaseName}UseCase()
    }
}

public extension DependencyValues {
    var {useCaseName}: any {UseCaseName}UseCase {
        get { self[{UseCaseName}UseCaseKey.self] }
        set { self[{UseCaseName}UseCaseKey.self] = newValue }
    }
}
```

### 6. Write Unit Tests

Create tests in `Contexts/{Context}/Tests/{Context}ApplicationTests/UseCases/{UseCaseName}/`:
- Create mock repository
- Test success and error cases
- Use Swift Testing framework

$ARGUMENTS
