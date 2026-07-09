# Popcorn

Popcorn is a modular SwiftUI application for browsing movies and TV series across iOS, macOS, and visionOS. It uses MVVM (`@Observable` view models) with domain-driven design to keep feature code cohesive while sharing foundations like styling, analytics, and configuration.

## Overview
- Browse curated and search-driven movie/TV content with feature-flag gated tabs.
- Unified design system components for posters, backdrops, and other media-driven layouts.
- Shared app services for configuration, feature flags, observability, caching, and data persistence.

## Architecture
- **Features**: Swift packages under `Features/` house `@Observable` view models, SwiftUI views, and per-feature dependency structs for vertical slices such as Explore, Search, Games, and Developer tools.
- **Contexts**: Domain, application, and infrastructure layers under `Contexts/` define contracts, use cases, repositories, and data sources for media data and supporting services.
- **Adapters**: Bridge code in `Adapters/` connects contexts to external APIs (TMDb, Sentry, Statsig).
- **Core**: Shared foundations in `Core/` — `CoreDomain` for shared domain primitives, `DesignSystem` for reusable UI components and theming, and `Presentation` for the shared `ViewState` utilities.
- **Platform**: Cross-cutting concerns in `Platform/` — `Caching` (in-memory with TTL), `Observability` (logging, analytics, error reporting), `FeatureAccess` (feature flag interfaces), and `DataPersistenceInfrastructure` (SwiftData persistence).
- **AppDependencies**: Central dependency injection hub that builds the shared service graph (`AppServices`) and exposes it to feature view models via constructor injection.
- **App shell**: The root app in `App/` sets up configuration and navigation scaffolding across platforms using SwiftUI scenes.

## Third-Party Libraries

| Dependency | Version | Purpose |
|------------|---------|---------|
| [TMDb](https://github.com/adamayoung/TMDb) | 18.2+ | Movie and TV metadata, imagery, and discovery endpoints |
| [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI) | 3.1+ | Asynchronous poster, backdrop, and profile image rendering |
| [sentry-cocoa](https://github.com/getsentry/sentry-cocoa) | 9.21+ | Observability and crash/error reporting |
| [statsig-kit](https://github.com/statsig-io/statsig-kit) | 1.62+ | Remote feature-flag evaluation |
| [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) | 1.19+ | Snapshot tests for UI components |
