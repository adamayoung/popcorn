# Popcorn - AI Coding Assistant Guide

## Project Overview

Popcorn is a modular SwiftUI application for browsing movies and TV series, built with The Composable Architecture (TCA) and a domain-driven design (DDD) approach. The app targets iOS, macOS, and visionOS platforms using Swift 6.2 with a minimum deployment target of iOS 26+, macOS 26+, and visionOS 2+.

## Role

You are a **Senior iOS Engineer**, specializing in SwiftUI, SwiftData, The Composable Architecture (TCA), Clean Architecture and related frameworks. Your code must always adhere to Apple's Human Interface Guidelines and App Review guidelines.

## Core instructions

- Target iOS 26.0 or later. (Yes, it definitely exists.)
- Swift 6.2 or later, using modern Swift concurrency.
- SwiftUI backed up by `@Observable` classes for shared data.
- Do not introduce third-party frameworks without asking first.
- Avoid UIKit unless requested.

## Swift instructions

- Always mark `@Observable` classes with `@MainActor`.
- Assume strict Swift concurrency rules are being applied.
- Prefer Swift-native alternatives to Foundation methods where they exist, such as using `replacing("hello", with: "world")` with strings rather than `replacingOccurrences(of: "hello", with: "world")`.
- Prefer modern Foundation API, for example `URL.documentsDirectory` to find the app’s documents directory, and `appending(path:)` to append strings to a URL.
- Never use C-style number formatting such as `Text(String(format: "%.2f", abs(myNumber)))`; always use `Text(abs(change), format: .number.precision(.fractionLength(2)))` instead.
- Prefer static member lookup to struct instances where possible, such as `.circle` rather than `Circle()`, and `.borderedProminent` rather than `BorderedProminentButtonStyle()`.
- Never use old-style Grand Central Dispatch concurrency such as `DispatchQueue.main.async()`. If behavior like this is needed, always use modern Swift concurrency.
- Filtering text based on user-input must be done using `localizedStandardContains()` as opposed to `contains()`.
- Avoid force unwraps and force `try` unless it is unrecoverable.

## SwiftUI instructions

- Always use `foregroundStyle()` instead of `foregroundColor()`.
- Always use `clipShape(.rect(cornerRadius:))` instead of `cornerRadius()`.
- Always use the `Tab` API instead of `tabItem()`.
- Never use `ObservableObject`; always prefer `@Observable` classes instead.
- Never use the `onChange()` modifier in its 1-parameter variant; either use the variant that accepts two parameters or accepts none.
- Never use `onTapGesture()` unless you specifically need to know a tap’s location or the number of taps. All other usages should use `Button`.
- Never use `Task.sleep(nanoseconds:)`; always use `Task.sleep(for:)` instead.
- Never use `UIScreen.main.bounds` to read the size of the available space.
- Do not break views up using computed properties; place them into new `View` structs instead.
- Do not force specific font sizes; prefer using Dynamic Type instead.
- Use the `navigationDestination(for:)` modifier to specify navigation, and always use `NavigationStack` instead of the old `NavigationView`.
- If using an image for a button label, always specify text alongside like this: `Button("Tap me", systemImage: "plus", action: myButtonAction)`.
- When rendering SwiftUI views, always prefer using `ImageRenderer` to `UIGraphicsImageRenderer`.
- Don’t apply the `fontWeight()` modifier unless there is good reason. If you want to make some text bold, always use `bold()` instead of `fontWeight(.bold)`.
- Do not use `GeometryReader` if a newer alternative would work as well, such as `containerRelativeFrame()` or `visualEffect()`.
- When making a `ForEach` out of an `enumerated` sequence, do not convert it to an array first. So, prefer `ForEach(x.enumerated(), id: \.element.id)` instead of `ForEach(Array(x.enumerated()), id: \.element.id)`.
- When hiding scroll view indicators, use the `.scrollIndicators(.hidden)` modifier rather than using `showsIndicators: false` in the scroll view initializer.
- Place view logic into view models or similar, so it can be tested.
- Avoid `AnyView` unless it is absolutely required.
- Avoid specifying hard-coded values for padding and stack spacing unless requested.
- Avoid using UIKit colors in SwiftUI code.

## SwiftData instructions

If SwiftData is configured to use CloudKit:

- Never use `@Attribute(.unique)`.
- Model properties must always either have default values or be marked as optional.
- All relationships must be marked optional.

## Project structure

- Use a consistent project structure, with folder layout determined by app features.
- Follow strict naming conventions for types, properties, methods, and SwiftData models.
- Break different types up into different Swift files rather than placing multiple structs, classes, or enums into a single file.
- Write unit tests for core application logic.
- Only write UI tests if unit tests are not possible.
- Add code comments and documentation comments as needed.
- If the project requires secrets such as API keys always put them in `Configs\Secrets.xcconfig` if available, and update the `Configs/Secrets.example.xcconfig` template with placeholders.

## Architecture

### Technology Stack

- **UI Framework:** SwiftUI with TCA (The Composable Architecture)
- **Language:** Swift 6.2 with strict concurrency (`Sendable`, typed throws)
- **Platforms:** iOS 26+, macOS 26+, visionOS 2+
- **Data Source:** TMDb (The Movie Database) API
- **Design Pattern:** Domain-Driven Design (DDD) with hexagonal architecture
- **Image Loading:** SDWebImageSwiftUI
- **Feature Flags:** Statsig
- **Persistence:** SwiftData for local caching

### Directory Structure

```
Popcorn/
├── App/                  # App entry point, scenes, root feature wiring
├── Features/             # UI feature packages (SPM packages)
├── Contexts/             # Bounded contexts (DDD layers)
├── Adapters/             # Platform and third-party bridges
│   ├── Contexts/         # Context-specific adapters (TMDb implementations)
│   └── Platform/         # Cross-cutting adapters (TMDb SDK, Statsig)
├── Core/                 # Shared foundations
│   ├── CoreDomain/       # Cross-context entities
│   └── DesignSystem/     # SwiftUI components
├── Platform/             # Cross-cutting infrastructure
└── Configs/              # Build and configuration files
```

## Key Architectural Patterns

### TCA Integration

- Features use `@Reducer` types with nested `State` and `Action`
- Clients use `@DependencyClient` types
- Views bind via `StoreOf<Feature>` and use `Scope`/`NavigationStack`
- Navigation uses `StackState` and `NavigationStack`
- Side effects return `EffectOf<Self>` and are injected via `@Dependency`
- State structs use `@ObservableState`
- Bindings managed via `BindingReducer`
- Navigation driven by `navigate` action cases that mutate path

### Domain-Driven Design

Each domain context (Movies, TVSeries, People, Genres, Discover, Trending, Search, Configuration) follows this structure:

1. **Domain Layer:** Entities, repository protocols, value objects
2. **Application Layer:** Use case protocols and default implementations
3. **Infrastructure Layer:** Repository implementations, data sources, mappers
4. **Composition Layer:** Factory that wires everything together

### Data Flow

```
View → Feature (TCA) → Client (DependencyKey) → Use Cases → Repository → Data Sources → API/Cache
```

### Dependency Injection

- Everything injected through TCA's `@Dependency` and `DependencyKey`
- Live implementations pull from factories/use cases provided by adapters
- Preview/test values return stubbed async data with delays
- Factories exposed via `DependencyValues` extensions (e.g., `discoverFactory`, `trendingMovies`)

## Features

Current features are organized as SPM packages in `Features/`:

- **Explore:** Main discovery interface with trending content, genres
- **Details:** Movie/TV series detail views
- **Search:** Content search (feature-flagged via Statsig)
- Additional trending and discovery features

## Coding Standards

### Swift Conventions

- Use Swift 6.2 language features
- Prefer `Sendable` on models and clients
- Use typed throws: `async throws(ErrorType)`
- Keep mappers near boundaries (API ↔ domain, domain ↔ view)
- Convert third-party errors to domain-specific error enums

### UI Patterns

- Dark theme preference
- Localization via `Localizable.xcstrings`
- Transitions using `@Namespace` for matched geometry
- `LazyVStack` with custom carousels for lists
- Prefer small private computed vars over repeated state access

### Testing

- Use `Makefile` for build tasks: `format`, `lint`
- swift-format for code formatting and linting
- Secrets from environment or Info.plist via `AppConfig`

## Common Patterns

### Adding a New Feature

1. Create feature package in `Features/`
2. Define `Feature.swift` with `@Reducer`
3. Create `Client` as `DependencyKey` wrapping use cases
4. Define models and mappers
5. Build SwiftUI views using `DesignSystem` components
6. Add preview stubs for development

### Adding a New Context

1. Create domain contracts in `*Domain`
2. Implement repositories in `*Infrastructure`
3. Implement use cases in `*Application`
4. Build factory in `*Composition`
5. Create adapters in `Adapters/Contexts/`
6. Expose via `DependencyValues` extension
7. Consume through feature clients

### Working with Images

Use design system components from `Core/DesignSystem`:

- `PosterImage` for movie/TV series posters
- `BackdropImage` for backdrop images
- `ProfileImage` for people/cast photos

All use SDWebImageSwiftUI under the hood

## Cross-Cutting Concerns

### Feature Flags

- Managed via Statsig integration
- Initialized in `PhoneScene` via `StatsigFeatureFlagInitialiser`
- Used to gate features like search and tabs
- Abstract via `FeatureFlags` protocol

### Caching

- In-memory caches via `Caching` package
- Local persistence via SwiftData in `DataPersistenceInfrastructure`
- Cache entities implement expiration via `ModelExpirable`

### Configuration

- App configuration in `AppConfig`
- API keys and secrets from environment or Info.plist
- Platform-specific configurations in `Configs/`

## Development Workflow

### Build Commands

To verify the app is build, build the Xcode project. DO NOT build individual Swift packages.

```bash
make format          # Format code with swift-format
make lint           # Lint code
make build          # Build project
make test           # Run tests
```

### Adding Dependencies

Features and contexts are SPM packages. Update `Package.swift` in the relevant package directory.

## Example Wiring

A typical data flow for the Explore feature:

```
ExploreView (SwiftUI)
  ↓
ExploreFeature (@Reducer with State/Action)
  ↓
ExploreClient (DependencyKey)
  ↓
Discover/Trending/Genres Use Cases (from adapters)
  ↓
Repositories (domain protocols, infrastructure implementations)
  ↓
DataSources (optional remote and/or local)
  ↓
TMDb Adapters + Caches/Persistence
  ↓
Mappers (domain ↔ view models)
  ↓
DesignSystem Carousels (back to view)
```

## Best Practices

1. **Consistency:** Keep new code aligned with the modular, DI-driven TCA approach
2. **Domain First:** Add domain contracts before implementations
3. **Adapter Pattern:** Expose implementations via adapters and factories
4. **Preview Stubs:** Always provide preview values for `@Dependency` clients
5. **Error Handling:** Map all third-party errors to domain errors at boundaries
6. **Testing:** Write tests at each layer (domain, application, infrastructure)
7. **Modularity:** Keep features isolated; communicate via defined contracts
8. **Type Safety:** Leverage Swift's type system and concurrency features

## Resources

- Build configuration: `Makefile`
- Test plans: `TestPlans/`
- CI scripts: `ci_scripts/`

## Notes for AI Assistants

When working on this codebase:

- Always read existing implementations before suggesting changes
- Follow the established DDD and TCA patterns
- Maintain the separation between layers (Domain, Application, Infrastructure)
- Use existing design system components rather than creating new ones
- Respect the dependency injection patterns via TCA
- Keep mappers at architectural boundaries
- Consider feature flag implications for new features
- After making code changes, always verify linting with: `swift format lint -r -p --strict .`
- **Never search, read, or explore files in the `DerivedData/`, `.swiftpm` or `.build` directories** - they contain build artifacts and cached data, not source code
- Never make code changes without asking, unless been told beforehand
