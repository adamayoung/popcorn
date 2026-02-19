---
name: add-feature
description: Create a new TCA feature package
---

# Add a New Feature Package

Guide for creating a new TCA feature module from scratch.

## Required Information

Ask the user for:
- **Feature name** (e.g., MovieCredits, PersonFilmography)
- **Purpose** of the feature
- **Required dependencies** (which use cases it needs)

## Steps

### 1. Create Package Structure

```
Features/{FeatureName}Feature/
├── Package.swift
├── Sources/{FeatureName}Feature/
│   ├── {FeatureName}Feature.swift      # TCA Reducer
│   ├── {FeatureName}Client.swift       # Dependency bridge
│   ├── Views/
│   │   └── {FeatureName}View.swift
│   ├── Models/
│   │   └── ViewSnapshot.swift          # View-specific models
│   └── Mappers/
│       └── {FeatureName}Mapper.swift   # Domain → View mapping
└── Tests/{FeatureName}FeatureTests/
    └── {FeatureName}FeatureTests.swift
```

### 2. Create Package.swift

```swift
// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "{FeatureName}Feature",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v2)
    ],
    products: [
        .library(name: "{FeatureName}Feature", targets: ["{FeatureName}Feature"])
    ],
    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/DesignSystem"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.23.0")
    ],
    targets: [
        .target(
            name: "{FeatureName}Feature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "{FeatureName}FeatureTests",
            dependencies: ["{FeatureName}Feature"]
        )
    ]
)
```

### 3. Create the Reducer

```swift
import ComposableArchitecture
import Foundation

@Reducer
public struct {FeatureName}Feature: Sendable {
    @Dependency(\.{featureName}Client) private var client

    @ObservableState
    public struct State: Sendable {
        let id: Int
        var viewState: ViewState = .initial

        public init(id: Int) {
            self.id = id
        }
    }

    public enum ViewState: Sendable, Equatable {
        case initial
        case loading
        case ready(ViewSnapshot)
        case error(ErrorMessage)
    }

    public struct ErrorMessage: Equatable, Sendable {
        public let message: String
    }

    public enum Action: Sendable {
        case didAppear
        case fetch
        case loaded(ViewSnapshot)
        case failed(ErrorMessage)
        case navigate(Navigation)
    }

    public enum Navigation: Equatable, Hashable, Sendable {
        // Define navigation destinations
    }

    public init() {}

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .didAppear:
                guard case .initial = state.viewState else { return .none }
                return .send(.fetch)

            case .fetch:
                state.viewState = .loading
                return .run { [id = state.id] send in
                    let result = try await client.fetch(id: id)
                    await send(.loaded(result))
                } catch: { error, send in
                    await send(.failed(ErrorMessage(message: error.localizedDescription)))
                }

            case .loaded(let snapshot):
                state.viewState = .ready(snapshot)
                return .none

            case .failed(let error):
                state.viewState = .error(error)
                return .none

            case .navigate:
                return .none  // Handled by parent
            }
        }
    }
}
```

### 4. Create the Client

```swift
import ComposableArchitecture
import AppDependencies

@DependencyClient
struct {FeatureName}Client: Sendable {
    var fetch: @Sendable (_ id: Int) async throws -> ViewSnapshot
}

extension {FeatureName}Client: DependencyKey {
    static var liveValue: {FeatureName}Client {
        @Dependency(\.someUseCase) var someUseCase

        return {FeatureName}Client(
            fetch: { id in
                let result = try await someUseCase.execute(id: id)
                return {FeatureName}Mapper().map(result)
            }
        )
    }

    static var previewValue: {FeatureName}Client {
        {FeatureName}Client(
            fetch: { _ in .mock }
        )
    }
}

extension DependencyValues {
    var {featureName}Client: {FeatureName}Client {
        get { self[{FeatureName}Client.self] }
        set { self[{FeatureName}Client.self] = newValue }
    }
}
```

### 5. Create the View

```swift
import ComposableArchitecture
import DesignSystem
import SwiftUI

public struct {FeatureName}View: View {
    @Bindable var store: StoreOf<{FeatureName}Feature>

    public init(store: StoreOf<{FeatureName}Feature>) {
        self.store = store
    }

    public var body: some View {
        content
            .onAppear { store.send(.didAppear) }
    }

    @ViewBuilder
    private var content: some View {
        switch store.viewState {
        case .initial, .loading:
            ProgressView()
        case .ready(let snapshot):
            ContentView(snapshot: snapshot)
        case .error(let error):
            ContentUnavailableView {
                Label(
                    LocalizedStringResource("UNABLE_TO_LOAD", bundle: .module),
                    systemImage: "exclamationmark.triangle"
                )
            } description: {
                Text(error.message)
            }
        }
    }
}
```

Add string keys to `Localizable.xcstrings` — see [SWIFTUI.md § Localization](docs/SWIFTUI.md).

### 6. Add to Parent Feature's Path

Wire into the parent feature following the `add-screen` workflow.

### 7. Write Tests

Use `TestStore` from TCA for reducer testing.

$ARGUMENTS
