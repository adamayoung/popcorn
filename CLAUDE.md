# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Agents act as senior Swift collaborators. Keep responses concise, clarify uncertainty before coding, and align suggestions with the rules linked below.

## Agent Configuration

When spawning subagents using the Task tool, always use `model: "opus"` for all agent types.

## Project Overview

Popcorn is a modular SwiftUI application for browsing movies and TV series across iOS, macOS, and visionOS. It uses The Composable Architecture (TCA) with domain-driven design and clean architecture.

**Tech Stack**: Swift 6.2 (strict concurrency), SwiftUI, TCA 1.23+, SwiftData with CloudKit, TMDb API

**Platforms**: iOS 26.0+, macOS 26.0+, visionOS 2.0+

## Getting Started

### Configuration

Copy `Configs/Secrets.example.xcconfig` to `Configs/Secrets.xcconfig` and fill in:
```
TMDB_API_KEY = <your-tmdb-api-key>
SENTRY_DSN = <your-sentry-dsn>           # Optional
STATSIG_SDK_KEY = <your-statsig-key>     # Optional
```

### Build & Test (XcodeBuildMCP)

Use slash commands or XcodeBuildMCP tools directly:

| Task | Slash Command | MCP Tool |
|------|---------------|----------|
| Build app | `/build` | `mcp__XcodeBuildMCP__build_sim` |
| Build & run | `/run` | `mcp__XcodeBuildMCP__build_run_sim` |
| Run tests | `/test` | `mcp__XcodeBuildMCP__test_sim` |
| Run single test | `/test-single <name>` | `mcp__XcodeBuildMCP__swift_package_test` with filter |
| Clean | `/clean` | `mcp__XcodeBuildMCP__clean` |
| Build package | — | `mcp__XcodeBuildMCP__swift_package_build` |
| Test package | — | `mcp__XcodeBuildMCP__swift_package_test` |

### Formatting

| Task | Slash Command |
|------|---------------|
| Auto-fix | `/format` |
| Check only | `/lint` |

## Key Entry Points

| File | Purpose |
|------|---------|
| `App/PopcornApp.swift` | App entry point, creates root store |
| `App/Features/AppRoot/AppRootFeature.swift` | Root TCA reducer, tab management |
| `App/Features/AppRoot/AppRootClient.swift` | App initialization (observability, feature flags) |
| `AppDependencies/` | All dependency wiring for TCA |

## Contexts (Business Domains)

| Context | Purpose |
|---------|---------|
| `PopcornMovies` | Movie details, credits, watchlist, recommendations |
| `PopcornTVSeries` | TV series details, seasons, episodes |
| `PopcornPeople` | Person details, filmography |
| `PopcornSearch` | Media search functionality |
| `PopcornDiscover` | Discovery and browsing |
| `PopcornTrending` | Trending content |
| `PopcornIntelligence` | AI-powered movie/TV chat |
| `PopcornConfiguration` | TMDb API configuration |
| `PopcornGenres` | Genre data |
| `PopcornGamesCatalog` | Games catalog |
| `PopcornPlotRemixGame` | Plot remix game logic |

## Features (UI Modules)

| Feature | Purpose |
|---------|---------|
| `ExploreFeature` | Main browse/discover tab |
| `MovieDetailsFeature` | Movie detail screen |
| `TVSeriesDetailsFeature` | TV series detail screen |
| `PersonDetailsFeature` | Person detail screen |
| `MediaSearchFeature` | Search tab |
| `MovieIntelligenceFeature` | AI chat about movies |
| `TVSeriesIntelligenceFeature` | AI chat about TV series |
| `TrendingMoviesFeature` | Trending movies list |
| `TrendingTVSeriesFeature` | Trending TV series list |
| `TrendingPeopleFeature` | Trending people list |
| `MovieCastAndCrewFeature` | Full cast/crew list |
| `GamesCatalogFeature` | Games tab |
| `PlotRemixGameFeature` | Plot remix game UI |

## Architecture

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for detailed patterns, examples, and step-by-step workflows for adding use cases, screens, features, and contexts.

### Layer Structure

Each context in `Contexts/` has 4 layers:

```
PopcornMovies/Sources/
├── MoviesDomain/        # Entities, repository protocols (NO dependencies)
├── MoviesApplication/   # Use case implementations
├── MoviesInfrastructure/# SwiftData, API adapters
└── MoviesComposition/   # Factory that wires it together
```

### Use Case File Structure

```
MoviesApplication/UseCases/FetchMovieDetails/
├── FetchMovieDetailsUseCase.swift        # Protocol
├── DefaultFetchMovieDetailsUseCase.swift # Implementation
└── FetchMovieDetailsUseCaseError.swift   # Errors
```

## Code Style

Detailed guides: [SWIFT.md](docs/SWIFT.md) · [SWIFTUI.md](docs/SWIFTUI.md) · [SWIFTDATA.md](docs/SWIFTDATA.md) · [TCA.md](docs/TCA.md) · [GIT.md](docs/GIT.md) · [UITESTING.md](docs/UITESTING.md)

### Quick Reference

**Swift**: `@Observable` needs `@MainActor` · No force unwraps (`try #require()` in tests) · `Task.sleep(for:)` · `localizedStandardContains()`

**SwiftUI**: `foregroundStyle()` · `clipShape(.rect(cornerRadius:))` · `Tab` API · `@Observable` · `NavigationStack`

**SwiftData**: No `@Attribute(.unique)` · Optional/defaulted properties · Optional relationships · Never expose `@Model` outside Infrastructure

**TCA**: `@Reducer` + `@ObservableState` · `StackState` navigation · `@Dependency` injection

### SwiftLint Attributes

```yaml
always_on_same_line: @Dependency, @Environment, @State, @Binding, @testable
always_on_line_above: @ViewBuilder
```

## Directory Structure

```
App/                    # Root app, scenes, AppRootFeature
Features/               # TCA feature packages
Contexts/               # Business domain packages
Adapters/               # Bridges contexts to external APIs
Platform/               # Caching, DataPersistence, Observability, FeatureAccess
Core/                   # DesignSystem, CoreDomain
AppDependencies/        # Central TCA dependency composition
Configs/                # Build settings, secrets
```
