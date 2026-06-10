# Patterns to Follow

## When to use this reference

Read this file when writing Tech Elab sections in user stories or when implementing stories. These are the canonical code patterns used across the project.

## Domain Entity Pattern

- `public` structs in `*Domain` / `*Application` layers need `///` doc comments on the type and every public property (see `docs/SWIFT.md`)
- All properties are `let`, `Identifiable`, `Equatable`, `Sendable`

```swift
/// A movie.
public struct Movie: Identifiable, Equatable, Sendable {
    /// Movie identifier.
    public let id: Int
    /// Movie name.
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
```

## Mapper Pattern

Three layers of mappers, each with distinct responsibilities:

### Adapter Mapper (TMDb → Domain)

Maps TMDb SDK types to domain entities. No business logic.

```swift
struct {Name}Mapper {
    func map(_ dto: TMDb.X) -> Domain.X {
        Domain.X(
            id: dto.id,
            name: dto.name
        )
    }
}
```

### Application Mapper (Domain → Application)

Resolves images and enriches domain entities with configuration data.

```swift
struct {Name}Mapper {
    func map(_ entity: Domain.X, imagesConfiguration: ImagesConfiguration) -> App.X {
        App.X(
            id: entity.id,
            name: entity.name,
            posterURLSet: imagesConfiguration.posterURLSet(for: entity.posterPath)
        )
    }
}
```

### Feature Mapper (Application → Feature)

Picks specific URL sizes and shapes data for the view. These feature-local models
populate the view model's `ViewSnapshot`.

```swift
struct {Name}Mapper {
    func map(_ appModel: App.X) -> Feature.X {
        Feature.X(
            id: appModel.id,
            name: appModel.name,
            posterURL: appModel.posterURLSet?.card
        )
    }
}
```

## Feature (MVVM) Pattern

Each feature is an `@Observable @MainActor` view model driving a SwiftUI view, with
injected dependencies and navigation. The canonical reference is
`Features/MovieDetailsFeature`.

### View Model

```swift
import Observation
import Presentation

/// The data the view renders once loaded.
public struct {Feature}ViewSnapshot: Equatable, Sendable {
    public let item: Item
    public init(item: Item) { self.item = item }
}

@Observable
@MainActor
public final class {Feature}ViewModel {
    public typealias ViewSnapshot = {Feature}ViewSnapshot

    public private(set) var viewState: ViewState<ViewSnapshot>
    public private(set) var reloadID = 0   // drives `.task(id:)` reruns on retry

    private let dependencies: {Feature}Dependencies
    private let navigator: any {Feature}Navigating

    public init(
        itemID: Int,
        dependencies: {Feature}Dependencies,
        navigator: any {Feature}Navigating,
        viewState: ViewState<ViewSnapshot> = .initial
    ) { ... }

    /// Drive this from the view's `.task(id: viewModel.reloadID)`.
    public func load() async {
        guard !viewState.isReady, !viewState.isLoading else { return }
        viewState = .loading
        do {
            let item = try await dependencies.fetchItem(itemID)
            viewState = .ready(ViewSnapshot(item: item))
        } catch {
            viewState.applyLoadFailure(error)   // cancellation-aware; sets `.error` on real failures
        }
    }

    public func reload() { reloadID += 1 }              // retry after an error
    public func selectItem(id: Int) { navigator.openItem(id: id) }
}
```

Rules:
- `@Observable @MainActor final class`, `viewState` is `public private(set)`
- `viewState` is `ViewState<ViewSnapshot>` from the `Presentation` module — lifecycle is
  `.initial → .loading → .ready / .error`; guard against re-fetch when already ready/loading
- Use `viewState.applyLoadFailure(error)` in the `catch` so view-disappear cancellation
  doesn't flash a spurious error screen
- No view-model-owned long-lived `Task` — let the view's `.task(id:)` own the lifetime

### Dependencies

```swift
import AppDependencies

/// A `Sendable` struct of `@Sendable` closures — every closure is required, so a
/// missing dependency is a compile error.
public struct {Feature}Dependencies: Sendable {
    public var fetchItem: @Sendable (_ id: Int) async throws -> Item
    public var isSomeFlagEnabled: @Sendable () throws -> Bool

    public init( ... ) { ... }
}

public extension {Feature}Dependencies {
    /// Builds the production dependencies from the app's shared services.
    static func live(services: AppServices) -> {Feature}Dependencies {
        let useCase = services.{context}Factory.makeFetchItemUseCase()
        let featureFlags = services.featureFlags
        return {Feature}Dependencies(
            fetchItem: { id in {Name}Mapper().map(try await useCase.execute(id: id)) },
            isSomeFlagEnabled: { featureFlags.isEnabled(.someFlag) }
        )
    }
}
```

### Navigating

```swift
/// Navigation requests the view model can make. The App-layer router supplies a
/// concrete `RouterNavigator` implementation.
@MainActor
public protocol {Feature}Navigating {
    func openItem(id: Int)
}
```

### View

```swift
import Presentation
import SwiftUI

public struct {Feature}View: View {
    @State private var viewModel: {Feature}ViewModel

    public init(viewModel: {Feature}ViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        ZStack {
            switch viewModel.viewState {
            case .ready(let snapshot): content(snapshot)
            case .error(let error): errorBody(error)   // retry calls viewModel.reload()
            default: EmptyView()
            }
        }
        .overlay { if viewModel.viewState.isLoading { ProgressView() } }
        .task(id: viewModel.reloadID) { await viewModel.load() }
    }
}
```

Rules:
- The view owns the view model via `@State private var viewModel` + `init(viewModel:)`
- Load is driven from `.task(id: viewModel.reloadID)`
- The view never builds its own dependencies — the `ViewModelFactory` constructs the
  view model

### App Composition & Routing

```swift
// App/Composition/ViewModelFactory.swift
func make{Feature}(id: Int, navigator: some {Feature}Navigating) -> {Feature}ViewModel {
    {Feature}ViewModel(itemID: id, dependencies: .live(services: services), navigator: navigator)
}
```

```swift
// App/Features/{Tab}Root/{Tab}Router.swift
enum {Tab}Route: Hashable { case item(id: Int) }

@Observable @MainActor
final class {Tab}Router { var path: [{Tab}Route] = [] }

@MainActor
struct {Tab}RouterNavigator: {Feature}Navigating {
    let router: {Tab}Router
    func openItem(id: Int) { router.path.append(.item(id: id)) }
}
```

The root view hosts the home screen in `NavigationStack(path: $router.path)` and resolves
each destination via `.navigationDestination(for: {Tab}Route.self)`, building view models
through the `ViewModelFactory`. Each destination is rendered by a `private func` helper —
never inline in the `switch`. Both `ExploreRootView` and `SearchRootView` (and their
`RouterNavigator`s) must be updated consistently when navigation changes.

## Repository Pattern

Cache-first with remote fallback. Observability spans on all operations.

```swift
final class Default{Entity}Repository: {Entity}Repository, Sendable {
    private let remoteDataSource: any {Entity}RemoteDataSource
    private let localDataSource: any {Entity}LocalDataSource

    func {entity}(withID id: Int) async throws({Entity}RepositoryError) -> {Entity} {
        if let cached = try? await localDataSource.{entity}(withID: id) {
            return cached
        }
        do {
            let result = try await remoteDataSource.{entity}(withID: id)
            try? await localDataSource.save(result, withID: id)
            return result
        } catch let error as {Entity}RemoteDataSourceError {
            throw error.repositoryError
        }
    }
}
```

## SwiftData Entity Pattern

`@Model` classes with `@ModelActor` data sources. See `docs/SWIFTDATA.md`.

```swift
@Model
final class {Entity}Entity {
    @Attribute(.unique) var entityID: Int
    var name: String
    var cachedAt: Date

    init(entityID: Int, name: String, cachedAt: Date = .now) {
        self.entityID = entityID
        self.name = name
        self.cachedAt = cachedAt
    }
}
```

### Entity Mapper (3-method pattern)

```swift
struct {Entity}EntityMapper {
    func map(_ entity: {Entity}Entity) -> {Entity} { ... }
    func map(_ domain: {Entity}) -> {Entity}Entity { ... }
    func update(_ entity: {Entity}Entity, from domain: {Entity}) { ... }
}
```

## Localisation Pattern

- Every new `.xcstrings` key needs `"isCommentAutoGenerated" : true` alongside its comment
- Format-string keys (e.g. `"Value %lld"`) need an explicit `localizations` section with English translation — they won't get one automatically from Xcode
- Use `bundle: .module` for localised strings in packages

## Test Pattern

- Swift Testing framework (`@Suite`, `@Test`, `#expect`, `#require`)
- Mock factories: `static func mock(...defaults...) -> Entity`
- View model tests: drive the view model with a stub `*Dependencies` + a spy `*Navigating`, then assert on `viewModel.viewState`
- SwiftLint limits: `function_body_length` 50, `file_length` 400, `type_body_length` 350
- `@Model` classes aren't `Sendable` — use `static func makeEntity()` factory methods, NOT `static let`

### Required Test Coverage Per Layer

Every new feature MUST have tests at ALL of these layers. Missing any layer is a review blocker.

#### Adapter Mapper Tests

Every adapter mapper (TMDb → Domain) needs its own test file. Test all properties, nil/optional handling, and empty collections.

```swift
@Suite("{Name}Mapper Tests")
struct {Name}MapperTests {
    private let mapper = {Name}Mapper()

    @Test("map converts all properties correctly")
    func mapConvertsAllPropertiesCorrectly() { ... }

    @Test("map handles nil optional properties")
    func mapHandlesNilOptionalProperties() { ... }

    @Test("map handles empty collections")
    func mapHandlesEmptyCollections() { ... }
}
```

#### Use Case Tests

Every use case needs tests for: success, ID propagation, each error type (notFound, unauthorised, unknown), and upstream failures.

```swift
@Suite("DefaultFetch{Entity}UseCase Tests")
struct DefaultFetch{Entity}UseCaseTests {
    @Test("returns entity on success")
    func returnsEntityOnSuccess() async throws { ... }

    @Test("propagates correct ID to repository")
    func propagatesCorrectIDToRepository() async throws { ... }

    @Test("throws not found error")
    func throwsNotFoundError() async throws { ... }

    @Test("throws unauthorised error")
    func throwsUnauthorisedError() async throws { ... }

    @Test("throws unknown error")
    func throwsUnknownError() async throws { ... }
}
```

#### View Model Tests

Every view model needs tests. The suite (or each test) is `@MainActor`. Drive the view
model directly with a stub `*Dependencies` and a spy `*Navigating`, then assert on
`viewModel.viewState` and the spy's recorded calls. `ViewSnapshot` must be `Equatable` so
`viewState` comparisons work. Cover: fetch success → `.ready`, fetch failure → `.error`,
guard states (no-op when already ready/loading), and navigation calls.

```swift
@MainActor
@Suite("{Feature}ViewModel Tests")
struct {Feature}ViewModelTests {

    @Test("fetch success transitions to ready")
    func fetchSuccessTransitionsToReady() async {
        let viewModel = makeViewModel(dependencies: stubDependencies(fetchItem: { _ in .mock }))
        await viewModel.load()
        #expect(viewModel.viewState == .ready({Feature}ViewSnapshot(item: .mock)))
    }

    @Test("fetch failure transitions to error")
    func fetchFailureTransitionsToError() async {
        let viewModel = makeViewModel(
            dependencies: stubDependencies(fetchItem: { _ in throw TestError.generic })
        )
        await viewModel.load()
        #expect(viewModel.viewState == .error(ViewStateError(TestError.generic)))
    }

    @Test("fetch does nothing when already ready")
    func fetchDoesNothingWhenAlreadyReady() async { ... }

    @Test("navigation invokes the navigator with the correct id")
    func navigationInvokesNavigator() {
        let navigator = SpyNavigator()
        let viewModel = makeViewModel(navigator: navigator)
        viewModel.selectItem(id: 42)
        #expect(navigator.openedItemID == 42)
    }
}
```

## View Pattern

- A store-free content view (`{Feature}ContentView`), separate from the view-model-owning
  `{Feature}View` that supplies the chrome (toolbar / loading / error)
- The view owns its view model via `@State private var viewModel` + `init(viewModel:)`
- Navigation goes through view-model methods that call the injected navigator (not via the
  content view, which takes plain callbacks)
- `#Preview` blocks with mock data, built via a `static func preview(viewState:)` helper on
  the view model
- Accessibility identifiers and labels
- In root views (`ExploreRootView`, `SearchRootView`), each destination must be a
  `private func` helper — never inline in `switch` cases. Both root views (and their
  `RouterNavigator`s) must be updated consistently (see `docs/SWIFTUI.md`)

## Test Plan Registration

When adding new unit test targets, register them in `TestPlans/PopcornUnitTests.xctestplan` by adding an entry to the `testTargets` array. Without this, the tests won't run when executing the test plan. Do NOT add snapshot test targets here — those belong in `PopcornSnapshotTests.xctestplan`.

```json
{
  "target" : {
    "containerPath" : "container:{relative/path/to/package}",
    "identifier" : "{TestTargetName}",
    "name" : "{TestTargetName}"
  }
}
```

## Feature Flag Creation Pattern

When a story adds a new feature flag, two things must happen:

### 1. Code — Add to `FeatureFlag.swift`

Add a `static let` property and register it in `allFlags`. Update `FeatureFlagTests.swift` (count + ID list).

### 2. Statsig — Create the Gate via MCP

Create the corresponding Statsig gate using the Statsig MCP. Enable it for the **development environment only** (not a full public rollout):

```
1. mcp__statsig__Get_Gate_Details_by_ID — read a sibling gate to match config pattern
2. mcp__statsig__Create_Gate — create with:
   - id: matching FeatureFlag.id (snake_case)
   - name: Title Case version of the ID
   - rule: "Development only", passPercentage 100, condition type "public",
     environments: ["development"]
3. mcp__statsig__Update_Gate_Entirely — add description:
   "Controls access to <feature name>"
```

The gate ID in Statsig **must** match the `FeatureFlag.id` in code.

## Factory Chain Pattern

When adding a new data source or use case, the factory init chain must be updated atomically:

```
{Context}AdaptersFactory  (accepts new service/data source)
  → Live{Context}Factory  (accepts new remote data source)
    → {Context}InfrastructureFactory  (creates repository)
      → {Context}ApplicationFactory  (creates use case, exposes make{UseCase} method)
```

All 4 files must compile together — update them in the same story or ensure strict dependency ordering.

The new use case is then consumed by the feature's `{Feature}Dependencies.live(services:)`
via `services.{context}Factory.make{UseCase}UseCase()` — `AppServices` already exposes each
context factory, so no extra registration step is needed.
