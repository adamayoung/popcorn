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
// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Popcorn{Context}",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
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

**Popcorn{Context}Factory.swift** — a concrete `Sendable` final class (there is **no**
factory protocol; the concrete factory is the public API, like the adapter factories):
```swift
public final class Popcorn{Context}Factory: Sendable {
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

The adapters package bridges external services (TMDb) to the context's **ports** —
the `*RemoteDataSource` and provider protocols defined in the Domain/Infrastructure
layers. Its factory exposes those adapters through `make…() -> some Port` methods.

It does **not** build `Popcorn{Context}Factory`, and it must **not** depend on
`{Context}Composition`. Assembling the context factory from these adapters is the
composition root's job (Step 8) — this keeps the adapters package a leaf in the
dependency graph rather than reaching across into the context's composition layer.

```
Adapters/Contexts/Popcorn{Context}Adapters/
├── Package.swift
├── Sources/
│   └── Popcorn{Context}Adapters/
│       ├── DataSources/
│       │   ├── TMDb{Entity}RemoteDataSource.swift   # conforms to {Entity}RemoteDataSource (internal)
│       │   └── Mappers/                              # TMDb DTO → Domain mappers
│       └── Popcorn{Context}AdaptersFactory.swift
└── Tests/
    └── Popcorn{Context}AdaptersTests/
```

**Package.swift** — depend on the context's **Domain** and **Infrastructure**
products (where the ports live) plus `TMDb`. Do **not** add `{Context}Composition`:

```swift
dependencies: [
    .product(name: "{Context}Domain", package: "Popcorn{Context}"),
    .product(name: "{Context}Infrastructure", package: "Popcorn{Context}"),
    "TMDb"
]
```

**Popcorn{Context}AdaptersFactory.swift** — return the port implementations, one
`make…()` per port. Keep the concrete adapter types `internal`; the `some Port`
return types hide them. Qualify the TMDb service type as `TMDb.{Entity}Service` to
avoid ambiguity once `{Context}Infrastructure` is imported:

```swift
import {Context}Infrastructure
import TMDb

public final class Popcorn{Context}AdaptersFactory {

    private let {entity}Service: any TMDb.{Entity}Service

    public init({entity}Service: some TMDb.{Entity}Service) {
        self.{entity}Service = {entity}Service
    }

    public func make{Entity}RemoteDataSource() -> some {Entity}RemoteDataSource {
        TMDb{Entity}RemoteDataSource({entity}Service: {entity}Service)
    }

}
```

> A provider adapter backed by another context's use case (e.g. an
> `AppConfigurationProviding`) takes that use case in the factory's `init` and is
> exposed via its own `make…()` method. Concerns that are **not** adapters —
> `themeColorProvider`, `observability`, a `modelContainer` — do not belong on this
> factory; the composition root passes them straight into the context factory (Step 8).

### 8. Wire in AppServices

`AppServices` (in `AppDependencies/Sources/AppDependencies/Composition/`) is the
app's composition root: it builds the shared service and factory graph once, in
dependency order. Add the new context factory there so features can reach its use
cases:

**`AppServices.swift`** — declare the factory as a stored property, and add a
matching field to the `Graph` struct + the `init` assignment:
```swift
public let {context}Factory: Popcorn{Context}Factory
// ...in Graph:
let {context}Factory: Popcorn{Context}Factory
// ...in init:
self.{context}Factory = graph.{context}Factory
```

**`AppServices+Composition.swift`** — in `buildGraph`, build the adapters factory
from the shared TMDb services, then assemble `Popcorn{Context}Factory` from the
adapters it produces (plus any non-adapter concerns like the model container or
theme-colour provider), and pass it into the returned `Graph`. The composition root
is the single place that assembles context factories from adapters:
```swift
let {context}Adapters = Popcorn{Context}AdaptersFactory(
    {entity}Service: domain.tmdb.{entities}
)
let {context}Factory = Popcorn{Context}Factory(
    {entity}RemoteDataSource: {context}Adapters.make{Entity}RemoteDataSource(),
    modelContainer: modelContainer
)
```

A feature then consumes these use cases in its `Dependencies.live(services:)`
builder via `services.{context}Factory.make{UseCaseName}UseCase()` — see the
`add-use-case` and `add-feature` workflows. There is no `*+TCA.swift` file and no
per-use-case dependency registration.

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
