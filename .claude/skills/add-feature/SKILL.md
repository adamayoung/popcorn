---
name: add-feature
description: Create a new MVVM feature package
---

# Add a New Feature Package

Guide for creating a new MVVM feature module from scratch.

A feature is built around an `@Observable @MainActor final class` view model that
exposes a `ViewState<ViewSnapshot>`, a per-feature `Dependencies` struct of
`@Sendable` closures (injected via `init`), a per-feature `Navigating` protocol the
view model calls, and a SwiftUI `View` that owns the view model via
`@State` and drives loading from `.task(id:)`.

Use `Features/MovieDetailsFeature` as the canonical reference.

## Required Information

Ask the user for:
- **Feature name** (e.g., MovieCredits, PersonFilmography)
- **Purpose** of the feature
- **Required dependencies** (which use cases it needs)
- **Navigation** it triggers (which other screens it can open)

## Steps

### 1. Create Package Structure

The **primary** files — the view, view model, dependencies, navigating protocol, and
`Logger` — live at the **root** of `Sources/{FeatureName}Feature/`, not in `View/`
or `ViewModel/` subfolders. Only `Models/`, `Mappers/`, and (when present) the
main view's subviews under `Views/` are nested.

```
Features/{FeatureName}Feature/
├── Package.swift
├── Sources/{FeatureName}Feature/
│   ├── {FeatureName}View.swift               # Main view — owns the VM via @State, drives load via .task(id:)
│   ├── {FeatureName}ViewModel.swift          # @Observable @MainActor view model + ViewSnapshot
│   ├── {FeatureName}Dependencies.swift       # Sendable struct of @Sendable closures + live(services:)
│   ├── {FeatureName}Navigating.swift         # @MainActor navigation protocol
│   ├── Logger.swift                          # OSLog category
│   ├── Localizable.xcstrings
│   ├── Models/
│   │   └── {Model}.swift                     # View-specific models + Fetch{...}Error
│   ├── Mappers/
│   │   └── {FeatureName}Mapper.swift         # Domain → View mapping
│   └── Views/                                # Subviews the main view composes (content views, rows, sections, cards, carousels) — omit if none
│       └── {FeatureName}ContentView.swift    # Pure presentation of the ready snapshot
└── Tests/
    ├── {FeatureName}FeatureTests/
    │   ├── {FeatureName}ViewModelTests.swift # View model tests (at the target root)
    │   ├── Mappers/                          # One test per mapper
    │   │   └── {FeatureName}MapperTests.swift
    │   └── Mocks/                            # Mock use cases — only when the tests need them
    └── {FeatureName}FeatureSnapshotTests/
        └── {FeatureName}ViewSnapshotTests.swift   # Snapshot tests (at the target root, no Views/ subfolder)
```

**Structure rules:**
- The main `{FeatureName}View.swift` lives at the source root; `Views/` holds the
  **subviews and components** it composes — content views, rows, sections, cards,
  carousels, and any other presentation pieces. A feature whose main view needs no
  such subviews (e.g. `TrendingMoviesFeature`) has **no** `Views/` folder at all.
- **Multi-screen features** — when one feature presents several distinct screens,
  group each screen's views in a folder named after the screen, with that screen's
  main view at the folder root and a nested `Views/` for its components. These
  screen views are **stateless presentation views**: they take plain data and action
  closures from the parent and do **not** have their own view model, `Dependencies`,
  or `Navigating`. The feature keeps a **single** view model at the source root that
  drives them all. Example: `PlotRemixGameFeature` keeps one `PlotRemixGameViewModel`
  at the root and groups its screens into `PlotRemixGameStart/PlotRemixGameStartView.swift`
  and `PlotRemixGameQuestions/PlotRemixGameQuestionsView.swift`
  (+ `PlotRemixGameQuestions/Views/PlotRemixGameQuestionView.swift`).

### 2. Create Package.swift

Depend on `AppDependencies`, `Presentation`, `DesignSystem`, the relevant
`*Application` context, and `SnapshotTestHelpers` for the snapshot target. There is
**no** dependency on swift-composable-architecture.

```swift
// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "{FeatureName}Feature",

    defaultLocalization: "en",

    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .visionOS(.v26)
    ],

    products: [
        .library(name: "{FeatureName}Feature", targets: ["{FeatureName}Feature"])
    ],

    dependencies: [
        .package(path: "../../AppDependencies"),
        .package(path: "../../Core/CoreDomain"),
        .package(path: "../../Core/DesignSystem"),
        .package(path: "../../Core/Presentation"),
        .package(path: "../../Contexts/Popcorn{Context}"),
        .package(path: "../../Platform/FeatureAccess"),
        .package(path: "../../Core/SnapshotTestHelpers")
    ],

    targets: [
        .target(
            name: "{FeatureName}Feature",
            dependencies: [
                "AppDependencies",
                "DesignSystem",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "{Context}Application", package: "Popcorn{Context}")
            ],
            resources: [.process("Localizable.xcstrings")]
        ),
        .testTarget(
            name: "{FeatureName}FeatureTests",
            dependencies: [
                "AppDependencies",
                "{FeatureName}Feature",
                "Presentation",
                .product(name: "CoreDomain", package: "CoreDomain"),
                .product(name: "{Context}Application", package: "Popcorn{Context}"),
                .product(name: "{Context}Domain", package: "Popcorn{Context}")
            ]
        ),
        .testTarget(
            name: "{FeatureName}FeatureSnapshotTests",
            dependencies: [
                "{FeatureName}Feature",
                "SnapshotTestHelpers"
            ]
        )
    ]
)
```

### 3. Create the Dependencies

A plain `Sendable` struct of `@Sendable` closures. Constructing it requires every
closure, so a missing dependency is a compile error. Build the production instance
with `live(services:)`, which calls the context factory exposed on `AppServices`.

```swift
import AppDependencies
import Foundation
import {Context}Application

public struct {FeatureName}Dependencies: Sendable {

    public var fetch: @Sendable (_ id: Int) async throws -> {Model}

    public init(
        fetch: @escaping @Sendable (_ id: Int) async throws -> {Model}
    ) {
        self.fetch = fetch
    }

}

public extension {FeatureName}Dependencies {

    /// Builds the production dependencies from the app's shared services.
    static func live(services: AppServices) -> {FeatureName}Dependencies {
        let fetchUseCase = services.{context}Factory.makeFetch{Model}UseCase()

        return {FeatureName}Dependencies(
            fetch: { id in
                do {
                    let result = try await fetchUseCase.execute(id: id)
                    return {FeatureName}Mapper().map(result)
                } catch {
                    throw Fetch{Model}Error(error)
                }
            }
        )
    }

}

#if DEBUG
    public extension {FeatureName}Dependencies {

        /// Mock dependencies for previews and snapshot tests.
        static var preview: {FeatureName}Dependencies {
            {FeatureName}Dependencies(
                fetch: { _ in .mock }
            )
        }

    }
#endif
```

### 4. Create the Navigating Protocol

A `@MainActor` protocol describing the navigation a view model can request. The
App-layer router supplies a concrete implementation (a `RouterNavigator`). Provide
a `NoOp` implementation under `#if DEBUG` for previews and snapshot tests.

```swift
@MainActor
public protocol {FeatureName}Navigating {

    func openSomeDestination(id: Int)

}

#if DEBUG
    public struct NoOp{FeatureName}Navigator: {FeatureName}Navigating {
        public init() {}
        public func openSomeDestination(id: Int) {}
    }
#endif
```

### 5. Create the View Model

An `@Observable @MainActor final class` exposing `viewState`. Loading is driven by
the view through `load()` from a `.task(id:)`, so SwiftUI owns the work's lifetime
— there is no view-model-owned `Task`. Navigation methods call the injected
navigator. `reload()` bumps `reloadID` to retry after an error.

```swift
import Foundation
import Observation
import OSLog
import Presentation

/// The data shown by ``{FeatureName}View`` once loaded.
public struct {FeatureName}ViewSnapshot: Equatable, Sendable {

    public let item: {Model}

    public init(item: {Model}) {
        self.item = item
    }

}

@Observable
@MainActor
public final class {FeatureName}ViewModel {

    public typealias ViewSnapshot = {FeatureName}ViewSnapshot

    private static let logger = Logger.{featureName}

    public private(set) var viewState: ViewState<ViewSnapshot>

    /// Drives `.task(id:)` reruns. ``reload()`` bumps it to retry after an error.
    public private(set) var reloadID = 0

    public let id: Int

    private let dependencies: {FeatureName}Dependencies
    private let navigator: any {FeatureName}Navigating

    public init(
        id: Int,
        dependencies: {FeatureName}Dependencies,
        navigator: any {FeatureName}Navigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) {
        self.id = id
        self.dependencies = dependencies
        self.navigator = navigator
        self.viewState = viewState
    }

    /// Fetches the screen's data. Drive this from the view's `.task(id:)`; SwiftUI
    /// cancels it on disappear and reruns it on reappear / ``reload()``.
    public func load() async {
        guard !viewState.isReady, !viewState.isLoading else {
            return
        }

        viewState = .loading
        Self.logger.info("Fetching {featureName}")

        do {
            let item = try await dependencies.fetch(id)
            viewState = .ready(ViewSnapshot(item: item))
        } catch {
            Self.logger.error("Failed fetching {featureName}: \(error.localizedDescription, privacy: .public)")
            viewState.applyLoadFailure(error)
        }
    }

    /// Retries loading after an error by changing ``reloadID``, which reruns the
    /// view's `.task(id:)`.
    public func reload() {
        reloadID += 1
    }

    // MARK: - Navigation

    public func selectSomeDestination(id: Int) {
        navigator.openSomeDestination(id: id)
    }

}

#if DEBUG
    public extension {FeatureName}ViewModel {

        /// A view model pinned to a fixed view state with no-op dependencies and
        /// navigation, for previews and snapshot tests.
        static func preview(viewState: ViewState<ViewSnapshot>) -> {FeatureName}ViewModel {
            {FeatureName}ViewModel(
                id: 0,
                dependencies: .preview,
                navigator: NoOp{FeatureName}Navigator(),
                viewState: viewState
            )
        }

    }
#endif
```

### 6. Create the View

The view owns the view model via `@State` and an `init(viewModel:)`, switches on
`viewState`, and drives loading from `.task(id: viewModel.reloadID)`.

```swift
import DesignSystem
import Presentation
import SwiftUI

public struct {FeatureName}View: View {

    @State private var viewModel: {FeatureName}ViewModel

    public init(viewModel: {FeatureName}ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .ready(let snapshot):
                {FeatureName}ContentView(
                    item: snapshot.item,
                    didSelect: { id in viewModel.selectSomeDestination(id: id) }
                )
            case .error(let error):
                ContentLoadErrorView(
                    message: error.message,
                    systemImage: "exclamationmark.triangle",
                    reason: error.reason,
                    isRetryable: error.isRetryable,
                    retryAction: { viewModel.reload() }
                )
            default:
                EmptyView()
            }
        }
        .overlay {
            if viewModel.viewState.isLoading {
                ProgressView()
            }
        }
        .task(id: viewModel.reloadID) {
            await viewModel.load()
        }
    }

}

#if DEBUG
    #Preview("Ready") {
        NavigationStack {
            {FeatureName}View(viewModel: .preview(viewState: .ready(.init(item: .mock))))
        }
    }

    #Preview("Loading") {
        NavigationStack {
            {FeatureName}View(viewModel: .preview(viewState: .loading))
        }
    }
#endif
```

Add string keys to `Localizable.xcstrings` — see [SWIFTUI.md § Localization](docs/SWIFTUI.md).

### 7. Wire into the App's Composition

Add a `make{FeatureName}` method to `App/Composition/ViewModelFactory.swift` that
builds the view model from `Dependencies.live(services:)` and a navigator supplied
by the tab's router:

```swift
func make{FeatureName}(
    id: Int,
    navigator: some {FeatureName}Navigating
) -> {FeatureName}ViewModel {
    {FeatureName}ViewModel(
        id: id,
        dependencies: .live(services: services),
        navigator: navigator
    )
}
```

Then add the screen to a tab following the `add-screen` workflow (a route case, a
navigator method, and a `navigationDestination` entry).

### 8. Write Tests

Instantiate the view model directly with a stub `Dependencies`, drive `load()`,
and assert on `viewModel.viewState`. Use a spy implementing the `Navigating`
protocol to verify navigation. Use the Swift Testing framework with `@MainActor`
on the suite — no `TestStore`.

```swift
import Foundation
@testable import {FeatureName}Feature
import Presentation
import Testing

@Suite("{FeatureName}ViewModel Tests")
@MainActor
struct {FeatureName}ViewModelTests {

    @Test("load success sets viewState to ready")
    func loadSuccessSetsReady() async {
        let viewModel = {FeatureName}ViewModel(
            id: 1,
            dependencies: .preview,
            navigator: Spy{FeatureName}Navigator()
        )

        await viewModel.load()

        #expect(viewModel.viewState.isReady)
    }

    @Test("load failure sets viewState to error")
    func loadFailureSetsError() async {
        let viewModel = {FeatureName}ViewModel(
            id: 1,
            dependencies: {FeatureName}Dependencies(fetch: { _ in throw TestError.generic }),
            navigator: Spy{FeatureName}Navigator()
        )

        await viewModel.load()

        #expect(viewModel.viewState.isError)
    }

    @Test("selecting a destination invokes the navigator")
    func selectInvokesNavigator() {
        let navigator = Spy{FeatureName}Navigator()
        let viewModel = {FeatureName}ViewModel(id: 1, dependencies: .preview, navigator: navigator)

        viewModel.selectSomeDestination(id: 42)

        #expect(navigator.openedID == 42)
    }

}

@MainActor
private final class Spy{FeatureName}Navigator: {FeatureName}Navigating {
    var openedID: Int?
    func openSomeDestination(id: Int) { openedID = id }
}

private enum TestError: Error { case generic }
```

Also add a mapper test for each new mapper. See the
`MovieDetailsFeatureTests/Mappers` tests for the pattern.

### 9. Register Tests in Test Plan

Add the new unit test target to `TestPlans/PopcornUnitTests.xctestplan` so tests
run as part of the test plan. Add an entry to the `testTargets` array:

```json
{
  "target" : {
    "containerPath" : "container:Features\/{FeatureName}Feature",
    "identifier" : "{FeatureName}FeatureTests",
    "name" : "{FeatureName}FeatureTests"
  }
}
```

Do NOT add the snapshot test target here — that belongs in `PopcornSnapshotTests.xctestplan`.

$ARGUMENTS
