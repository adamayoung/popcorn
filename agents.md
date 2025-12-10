# Popcorn Agents Guide

This repo is a modular SwiftUI app built with The Composable Architecture (TCA) and a domain-driven package layout. It targets iOS/macOS/visionOS (Swift 6.2, iOS 26+).

## Top-Level Layout
- `App/` – app entry (`PopcornApp`), platform scenes, root TCA feature wiring, Info.plist, assets, localization.
- `Features/` – UI feature packages (e.g., Explore, Trending*, Details, Search). Each is an SPM package with `Feature.swift`, `Client`/`Dependency` adapters, models/mappers, and SwiftUI views.
- `Contexts/` – bounded contexts split into `*Application` (use cases), `*Domain` (entities, repositories, protocols), and `*Infrastructure` (data sources, repositories, mappers, storage). `*Composition` factories wire the layers.
- `Adapters/Contexts/` – bridges from platform or third parties into contexts (e.g., TMDb-backed data sources, TCA dependency factories).
- `Adapters/Platform/` – adapters for cross-cutting platform concerns (e.g., TMDb SDK, Statsig feature flags).
- `Core/` – shared foundations: `CoreDomain` (small cross-context entities) and `DesignSystem` (SwiftUI components using SDWebImageSwiftUI).
- `Platform/` – cross-cutting infrastructure packages (caching, data persistence primitives, feature flag abstraction).
- `Configs/`, `ci_scripts/`, `TestPlans/`, `Makefile` – build/test config and tooling.

## Architecture & Data Flow
- **TCA-first UI:** Features declare `@Reducer` types with nested `State`/`Action`; views bind via `StoreOf<Feature>` and use `Scope`/`NavigationStack` with `StackState` for navigation. Side effects are in helper methods returning `EffectOf<Self>` and injected through `@Dependency`.
- **Clients over use cases:** Each feature defines a `*Client` as a `DependencyKey` that wraps application-layer use cases (pulled from `DependencyValues._current`). Clients map application/domain models to lightweight view models (e.g., `MoviePreviewMapper`).
- **DDD-style contexts:** For each domain (Movies, TV, People, Genres, Discover, Trending, Search, Configuration), the `Application` layer exposes use-case protocols and default implementations. Repositories are defined in `Domain` and implemented in `Infrastructure`, which wires local/remote data sources and mappers.
- **Adapters:** Context adapters implement `Domain` protocols using platform SDKs (TMDb) or services, translate errors, and assemble `ApplicationFactory` instances exposed to TCA via `DependencyValues` extensions (e.g., `discoverFactory`, `trendingMovies`, etc.).
- **Cross-cutting services:** `FeatureFlags` wraps a provider; Statsig is initialised in `PhoneScene` via `StatsigFeatureFlagInitialiser`, gating search/tab availability. `Caching` offers in-memory caches; `DataPersistenceInfrastructure` hosts persistence primitives (e.g., SwiftData-based local sources).
- **Design system:** Reusable SwiftUI components for carousels, media rows, and image rendering (`PosterImage`, `BackdropImage`, `ProfileImage`, etc.) using SDWebImageSwiftUI and transition namespaces for matched-geometry effects.

## Coding Standards & Conventions
- **Language/Targets:** Swift 6.2, iOS 26/macOS 26/visionOS 2 minimums. Prefer `Sendable` on models/clients and typed throws (`async throws(ErrorType)`).
- **State management:** Use `@ObservableState` for state structs; `BindingReducer` for bindings; navigation via `StackState`/`Path` reducers. Actions use `navigate` cases to drive path mutations.
- **Dependencies:** Inject everything through TCA `@Dependency` and `DependencyKey` clients. Live values usually reach into factories/use cases provided by adapters; preview values return stubbed async data with delays.
- **Mapping & errors:** Keep mappers near the boundary (e.g., TMDb ↔ domain, domain ↔ view). Convert third-party errors into domain-specific error enums before surfacing them.
- **UI style:** SwiftUI with dark theme preference, `Localizable.xcstrings` for copy, `@Namespace` for transitions, `LazyVStack` + custom carousels for lists. Prefer small private computed vars over repeated state access.
- **Tests/tooling:** `Makefile` targets `format`/`lint` (swift-format), `build`, and `test` with overridable `DESTINATION`. Secrets pulled from env or Info.plist via `AppConfig`.

## Typical Wiring Example
`ExploreView` → `ExploreFeature` → `ExploreClient` (`DependencyKey`) → Discover/Trending/Genres use cases (from adapters) → repositories → TMDb adapters + caches/persistence → mappers → view models displayed via `DesignSystem` carousels.

Keep new code consistent with this modular, DI-driven, TCA approach: add domain contracts first, implement in infrastructure, expose via adapters/factories, then consume through feature clients with preview stubs.
