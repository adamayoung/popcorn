# Popcorn - Project Guide for Claude

## Project Overview

Popcorn is a modular SwiftUI application for browsing movies and TV series, built with The Composable Architecture (TCA) and a domain-driven design (DDD) approach. The app targets iOS, macOS, and visionOS platforms using Swift 6.2 with a minimum deployment target of iOS 26+, macOS 26+, and visionOS 2+.

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
├── App/                    # App entry point, scenes, root feature wiring
├── Features/              # UI feature packages (SPM packages)
├── Contexts/              # Bounded contexts (DDD layers)
├── Adapters/              # Platform and third-party bridges
│   ├── Contexts/         # Context-specific adapters (TMDb implementations)
│   └── Platform/         # Cross-cutting adapters (TMDb SDK, Statsig)
├── Core/                  # Shared foundations
│   ├── CoreDomain/       # Cross-context entities
│   └── DesignSystem/     # SwiftUI components
├── Platform/              # Cross-cutting infrastructure
└── Configs/              # Build and configuration files
```

## Key Architectural Patterns

### TCA Integration
- Features use `@Reducer` types with nested `State` and `Action`
- Views bind via `StoreOf<Feature>`
- Navigation uses `StackState` and `NavigationStack`
- Side effects return `EffectOf<Self>` and are injected via `@Dependency`
- State structs use `@ObservableState`
- Bindings managed via `BindingReducer`
- Navigation driven by `navigate` action cases that mutate path

### Domain-Driven Design
Each domain context (Movies, TV, People, Genres, Discover, Trending, Search, Configuration) follows this structure:

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
- Use `Makefile` for build tasks: `format`, `lint`, `build`, `test`
- Swift-format for code formatting and linting
- Test destinations overridable via `DESTINATION` variable
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
1. Create domain contracts in `*Domain` package
2. Implement repositories in `*Infrastructure`
3. Create adapters in `Adapters/Contexts/`
4. Build factory in `*Composition`
5. Expose via `DependencyValues` extension
6. Consume through feature clients

### Working with Images
Use design system components from `Core/DesignSystem`:
- `PosterImage` for movie/TV posters
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

- Main documentation: `agents.md`
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
- Test changes using the Makefile commands
- Consider feature flag implications for new features
