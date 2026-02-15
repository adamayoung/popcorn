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

### Xcode MCP

When the Xcode MCP server (`xcode`) is available, prefer its tools for building, testing, file operations, and diagnostics. All Xcode MCP tools require a `tabIdentifier` — use `mcp__xcode__XcodeListWindows` to discover open workspaces. File paths use Xcode project navigator paths (e.g., `ProjectName/Sources/MyFile.swift`), not filesystem paths.

### Build & Test

Use slash commands or Xcode MCP tools directly:

| Task | Slash Command | MCP Tool |
|------|---------------|----------|
| Build app | `/build` | `mcp__xcode__BuildProject` |
| Build for testing | `make build-for-testing` | — |
| Run all tests | `/test` | `mcp__xcode__RunAllTests` |
| Run specific tests | `/test-single <name>` | `mcp__xcode__RunSomeTests` with test specifiers |
| Get build log | — | `mcp__xcode__GetBuildLog` (filter by severity, glob, pattern) |
| List available tests | — | `mcp__xcode__GetTestList` |

### Diagnostics & Issues

| Task | MCP Tool |
|------|----------|
| List navigator issues | `mcp__xcode__XcodeListNavigatorIssues` (filter by severity, glob, pattern) |
| Get file diagnostics | `mcp__xcode__XcodeRefreshCodeIssuesInFile` |

### File Operations (Xcode Project-Aware)

These operate on the Xcode project structure, automatically managing project membership:

| Task | MCP Tool |
|------|----------|
| Read file | `mcp__xcode__XcodeRead` |
| Write/create file | `mcp__xcode__XcodeWrite` (auto-adds to project) |
| Edit file | `mcp__xcode__XcodeUpdate` |
| List files | `mcp__xcode__XcodeLS` |
| Find files by pattern | `mcp__xcode__XcodeGlob` |
| Search file contents | `mcp__xcode__XcodeGrep` |
| Create directory/group | `mcp__xcode__XcodeMakeDir` |
| Move/rename/copy | `mcp__xcode__XcodeMV` |
| Remove file/directory | `mcp__xcode__XcodeRM` |

### Development Tools

| Task | MCP Tool |
|------|----------|
| Search Apple docs | `mcp__xcode__DocumentationSearch` |
| Execute code snippet | `mcp__xcode__ExecuteSnippet` (runs in context of a source file) |
| Render SwiftUI preview | `mcp__xcode__RenderPreview` |

### Finding function definitions and call sites

Use tool `xcode-index-mcp` if available. Use project name Popcorn. The tool can locate call sites of functions, and function definitions from call sites. If you need a filepath to make a request, use `rg` to find the file and `rg -n` to find the line number. Use the absolute path when requesting symbols from a file.

### Formatting

| Task | Slash Command |
|------|---------------|
| Auto-fix | `/format` |
| Check only | `/lint` |

**Always run `/format` and `/lint` after making code changes** to ensure consistent style before committing.

### Pre-PR Checklist

Before creating a pull request, **always** verify:

1. Run `/format` and `/lint` — no violations
2. Run `/build-for-testing` — build succeeds with no warnings (warnings are errors)
3. Run `/test` — all tests pass
4. PR title follows gitmoji format: `<gitmoji> <description>` (see [GIT.md](docs/GIT.md))

This prevents CI failures and ensures code quality before review.

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

**Swift**: `@Observable` needs `@MainActor` · **No force unwraps (`!`) anywhere, including tests** — use `try #require()` for unwrapping optionals in tests · `Task.sleep(for:)` · `localizedStandardContains()`

**SwiftUI**: `foregroundStyle()` · `clipShape(.rect(cornerRadius:))` · `Tab` API · `@Observable` · `NavigationStack`

**SwiftData**: No `@Attribute(.unique)` · Optional/defaulted properties · Optional relationships · Never expose `@Model` outside Infrastructure

**TCA**: `@Reducer` + `@ObservableState` · `StackState` navigation · `@Dependency` injection · When adding or removing feature flags in a Client/Reducer, always update the corresponding `*FeatureFlagsTests` (all existing tests and add new ones for the flag)

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
