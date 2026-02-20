---
name: add-context
description: Create a new business domain context
---

# Add a New Context (Business Domain)

Guide for creating a new context following clean architecture with Domain-Driven Design.

## Required Information

Ask the user for:
- **Context name** (e.g., PopcornWatchlist, PopcornReviews)
- **Domain entities** needed
- **Core use cases** to implement

## Steps

### 1. Create Context Package Structure

```
Contexts/Popcorn{Context}/
├── Package.swift
├── Sources/
│   ├── {Context}Domain/           # Layer 1: Pure business logic
│   │   ├── Entities/
│   │   ├── Repositories/
│   │   └── DataSources/
│   ├── {Context}Application/      # Layer 2: Use cases
│   │   ├── UseCases/
│   │   └── {Context}ApplicationFactory.swift
│   ├── {Context}Infrastructure/   # Layer 3: Data sources
│   │   ├── DataSources/
│   │   │   ├── Local/
│   │   │   │   ├── Models/
│   │   │   │   └── Mappers/
│   │   │   └── Protocols/
│   │   ├── Repositories/
│   │   └── {Context}InfrastructureFactory.swift
│   └── {Context}Composition/      # Layer 4: Wiring
│       └── Popcorn{Context}Factory.swift
└── Tests/
    └── {Context}ApplicationTests/
```

### 2. Create Package.swift

```swift
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Popcorn{Context}",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],
    products: [
        .library(name: "{Context}Domain", targets: ["{Context}Domain"]),
        .library(name: "{Context}Application", targets: ["{Context}Application"]),
        .library(name: "{Context}Infrastructure", targets: ["{Context}Infrastructure"]),
        .library(name: "{Context}Composition", targets: ["{Context}Composition"])
    ],
    dependencies: [
        .package(path: "../../Core/CoreDomain")
    ],
    targets: [
        // Domain - NO dependencies (pure business logic)
        .target(name: "{Context}Domain"),

        // Application - depends on Domain only
        .target(
            name: "{Context}Application",
            dependencies: ["{Context}Domain"]
        ),

        // Infrastructure - depends on Domain only
        .target(
            name: "{Context}Infrastructure",
            dependencies: ["{Context}Domain"]
        ),

        // Composition - depends on all above
        .target(
            name: "{Context}Composition",
            dependencies: [
                "{Context}Domain",
                "{Context}Application",
                "{Context}Infrastructure"
            ]
        ),

        // Tests
        .testTarget(
            name: "{Context}ApplicationTests",
            dependencies: ["{Context}Application", "{Context}Domain"]
        )
    ]
)
```

### 3. Create Domain Layer

**Entities/{Entity}.swift**:
```swift
public struct {Entity}: Identifiable, Equatable, Sendable {
    public let id: Int
    public let name: String
    // Add properties

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
```

**Repositories/{Entity}Repository.swift**:
```swift
public protocol {Entity}Repository: Sendable {
    func {entity}(withID id: Int) async throws({Entity}RepositoryError) -> {Entity}
}

public enum {Entity}RepositoryError: Error, Equatable, Sendable {
    case notFound
    case unknown(Error? = nil)
}
```

### 4. Create Application Layer

Follow the `add-use-case` workflow for each use case.

**{Context}ApplicationFactory.swift**:
```swift
public final class {Context}ApplicationFactory: Sendable {
    private let {entity}Repository: any {Entity}Repository

    public init({entity}Repository: some {Entity}Repository) {
        self.{entity}Repository = {entity}Repository
    }

    public func makeFetch{Entity}UseCase() -> some Fetch{Entity}UseCase {
        DefaultFetch{Entity}UseCase({entity}Repository: {entity}Repository)
    }
}
```

### 5. Create Infrastructure Layer

**DataSources/Protocols/Remote/{Entity}RemoteDataSource.swift**:
```swift
public protocol {Entity}RemoteDataSource: Sendable {
    func {entity}(withID id: Int) async throws({Entity}RemoteDataSourceError) -> {Entity}
}

public enum {Entity}RemoteDataSourceError: Error {
    case notFound
    case unauthorised
    case unknown(Error? = nil)
}
```

**Repositories/Default{Entity}Repository.swift**:
```swift
final class Default{Entity}Repository: {Entity}Repository {
    private let remoteDataSource: any {Entity}RemoteDataSource
    private let localDataSource: any {Entity}LocalDataSource

    func {entity}(withID id: Int) async throws({Entity}RepositoryError) -> {Entity} {
        // Cache-first strategy
    }
}
```

### 6. Create Composition Layer

**Popcorn{Context}Factory.swift**:
```swift
public struct Popcorn{Context}Factory: Sendable {
    private let applicationFactory: {Context}ApplicationFactory

    public init({entity}RemoteDataSource: some {Entity}RemoteDataSource, modelContainer: ModelContainer) {
        let infrastructure = {Context}InfrastructureFactory(
            remoteDataSource: {entity}RemoteDataSource,
            modelContainer: modelContainer
        )
        self.applicationFactory = {Context}ApplicationFactory(
            {entity}Repository: infrastructure.make{Entity}Repository()
        )
    }

    public func makeFetch{Entity}UseCase() -> some Fetch{Entity}UseCase {
        applicationFactory.makeFetch{Entity}UseCase()
    }
}
```

### 7. Create Adapters

```
Adapters/Contexts/Popcorn{Context}Adapters/
├── Package.swift
├── Sources/
│   └── Popcorn{Context}Adapters/
│       ├── DataSources/
│       │   └── TMDb{Entity}RemoteDataSource.swift
│       └── Popcorn{Context}AdaptersFactory.swift
```

### 8. Wire in AppDependencies

Create `AppDependencies/{Context}/`:
- `{Context}Factory+TCA.swift`
- Use case TCA extensions

### 9. Add to Xcode Project

Add the new package to the main Xcode project's package dependencies.

### 10. Register Tests in Test Plan

Add all new unit test targets to `TestPlans/PopcornUnitTests.xctestplan` so tests run as part of the test plan. Add an entry to the `testTargets` array for each test target:

```json
{
  "target" : {
    "containerPath" : "container:Contexts\/Popcorn{Context}",
    "identifier" : "{Context}ApplicationTests",
    "name" : "{Context}ApplicationTests"
  }
}
```

Repeat for each test target (e.g., `{Context}DomainTests`, `{Context}InfrastructureTests`). Do NOT add snapshot test targets here — those belong in `PopcornSnapshotTests.xctestplan`.

$ARGUMENTS
