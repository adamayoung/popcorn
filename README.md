# Popcorn

Popcorn is a modular SwiftUI application for browsing movies and TV series across iOS, macOS, and visionOS. It combines The Composable Architecture (TCA) with domain-driven design to keep feature code cohesive while sharing foundations like styling, analytics, and configuration.

## Overview
- Browse curated and search-driven movie/TV content with feature-flag gated tabs.
- Unified design system components for posters, backdrops, and other media-driven layouts.
- Shared app services for configuration, feature flags, observability, caching, and data persistence.

## Architecture
- **Features**: Swift packages under `Features/` house TCA reducers, views, and clients for vertical slices such as Explore, Search, and Games.
- **Contexts**: Domain, application, and infrastructure layers under `Contexts/` define contracts, use cases, repositories, and data sources for media data and supporting services.
- **Adapters**: Glue code in `Adapters/` wires contexts into feature dependencies, exposing concrete implementations to TCA reducers.
- **App shell**: The root app in `App/` sets up configuration, dependency injection, and navigation scaffolding across platforms using SwiftUI scenes.
- **Design system**: Reusable UI components live in `Core/DesignSystem`, providing consistent visuals for images, carousels, typography, and theming.

## Third-Party Libraries
- **The Composable Architecture (TCA)** for reducer-driven state management and dependency injection.
- **SDWebImageSwiftUI** powering asynchronous poster, backdrop, and profile image rendering.
- **TMDb Swift SDK** supplying movie and TV metadata, imagery, and discovery endpoints.
- **Statsig** for remote feature-flag evaluation that gates tabs and experiences.
- **Sentry** for observability and crash/error reporting.
- **SwiftData** for local caching and persistence through the data persistence infrastructure.
