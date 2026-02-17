# Popcorn

Popcorn is a modular SwiftUI application for browsing movies and TV series across iOS, macOS, and visionOS. It combines The Composable Architecture (TCA) with domain-driven design to keep feature code cohesive while sharing foundations like styling, analytics, and configuration.

## Overview
- Browse curated and search-driven movie/TV content with feature-flag gated tabs.
- Unified design system components for posters, backdrops, and other media-driven layouts.
- Shared app services for configuration, feature flags, observability, caching, and data persistence.

## Architecture
- **Features**: Swift packages under `Features/` house TCA reducers, views, and clients for vertical slices such as Explore, Search, Games, and Developer tools.
- **Contexts**: Domain, application, and infrastructure layers under `Contexts/` define contracts, use cases, repositories, and data sources for media data and supporting services.
- **Adapters**: Bridge code in `Adapters/` connects contexts to external APIs (TMDb, Sentry, Statsig), with each context adapter exposing a `*UITesting` module with stubs.
- **Core**: Shared foundations in `Core/` — `CoreDomain` for shared domain primitives, `DesignSystem` for reusable UI components and theming, and `TCAFoundation` for shared TCA utilities.
- **Platform**: Cross-cutting concerns in `Platform/` — `Caching` (in-memory with TTL), `Observability` (logging, analytics, error reporting), `FeatureAccess` (feature flag interfaces), and `DataPersistenceInfrastructure` (SwiftData persistence).
- **AppDependencies**: Central dependency injection hub that registers all use cases as TCA `DependencyKey`s and wires adapters to contexts.
- **App shell**: The root app in `App/` sets up configuration and navigation scaffolding across platforms using SwiftUI scenes.

## Third-Party Libraries

| Dependency | Version | Purpose |
|------------|---------|---------|
| [swift-composable-architecture](https://github.com/pointfreeco/swift-composable-architecture) | 1.23+ | Reducer-driven state management and dependency injection |
| [TMDb](https://github.com/adamayoung/TMDb) | 16.0+ | Movie and TV metadata, imagery, and discovery endpoints |
| [SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI) | 3.0+ | Asynchronous poster, backdrop, and profile image rendering |
| [sentry-cocoa](https://github.com/getsentry/sentry-cocoa) | 8.57+ | Observability and crash/error reporting |
| [statsig-kit](https://github.com/nicktmro/statsig-kit) | 1.55+ | Remote feature-flag evaluation |
| [swift-snapshot-testing](https://github.com/pointfreeco/swift-snapshot-testing) | 1.18+ | Snapshot tests for UI components |
