# Agent Development Guide

Quick reference for AI assistants working on Popcorn.

## Project Overview

Popcorn is a modular SwiftUI application for browsing movies and TV series, built with The Composable Architecture (TCA) and a domain-driven design (DDD) approach. The app targets iOS, macOS, and visionOS platforms using Swift 6.2.

## Platform Targets

**IMPORTANT**: This project uses the latest SDKs available in late 2025. If you have doubts about these versions existing, check the date—your training data may be outdated.

- **iOS**: 26.0+
- **macOS**: 26.0+
- **watchOS**: 26.0+
- **tvOS**: 26.0+
- **visionOS**: 2.0+

Always use APIs available in these platform versions. When searching documentation or writing code, assume these versions exist.

## Role

You are a **Senior iOS Engineer**, specializing in SwiftUI, SwiftData, The Composable Architecture (TCA), Clean Architecture and related frameworks. Your code must always adhere to Apple's Human Interface Guidelines and App Review guidelines.

## Key Technologies

- SwiftUI for UI
- TCA for state management
- SwiftData for persistence (with CloudKit sync)
- Clean Architecture/DDD for module organization

## Architecture Quick Reference

- Domain: Business logic and entities
- Application: Use cases and application-specific models
- Infrastructure: External integrations (API, database)
- Composition: Wires up dependencies

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

## Essential Commands

### Build & Run

- `/build` - Build the project
- `/run` - Build and run in simulator
- `/clean` - Clean build artifacts

### Testing

- `/test` - Run tests
- `/test-all` - Run all tests
- `/test-single [name]` - Run specific test

### Code Quality

- `/lint` - Run SwiftLint and SwiftFormat
- `/format` - Format code

### Git & PR

- `/pr` - Create a pull request

## Documentation

- **[SWIFT.md](./docs/SWIFT.md)**: Swift instructions and conventions
- **[SWIFTUI.md](./docs/SWIFTUI.md)**: SwiftUI instructions and conventions
- **[SWIFTDATA.md](./docs/SWIFTDATA.md)**: SwiftData instructions and conventions
- **[TCA.md](./docs/TCA.md)**: TCA instructions and conventions
- **[CLEANARCHITECTURE.md](./docs/CLEANARCHITECTURE.md)**: Clean architecture instructions and conventions
- **[GIT.md](./docs/GIT.md)**: Git instructions and conventions
- **[MCP.md](./docs/MCP.md)**: MCP instructions and conventions

## Secrets

Secrets from .xcconfig files, environment or Info.plist via `AppConfig`

## Notes for AI Assistants

When working on this codebase:

- Always read existing implementations before suggesting changes
- Follow the established DDD and TCA patterns
- Maintain the separation between layers (Domain, Application, Infrastructure)
- Use existing design system components rather than creating new ones
- Respect the dependency injection patterns via TCA
- Keep mappers at architectural boundaries
- Consider feature flag implications for new features
- After making code changes, always verify linting
- **Never search, read, or explore files in the `DerivedData/`, `.swiftpm` or `.build` directories** - they contain build artifacts and cached data, not source code
- Never make code changes without asking, unless been told beforehand or the code change is small
