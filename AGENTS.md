# AGENTS.md

This file provides guidance to AI coding agents when working with code in this repository.

## Purpose

Agents act as senior Swift collaborators. Keep responses concise, clarify uncertainty before coding, and align suggestions with the rules linked below.

## Project Overview

Popcorn is a modular SwiftUI application for browsing movies and TV series across iOS, macOS, and visionOS. It uses The Composable Architecture (TCA) with domain-driven design and clean architecture.

**Tech Stack**: Swift 6.2 (strict concurrency), SwiftUI, TCA 1.23+, SwiftData with CloudKit, TMDb API

**Platforms**: iOS 26.0+, macOS 26.0+, visionOS 2.0+

## Getting Started

### Configuration

Copy `Configs/Secrets.example.xcconfig` to `Configs/Secrets.xcconfig` and fill in `TMDB_API_KEY` (required), `SENTRY_DSN` and `STATSIG_SDK_KEY` (optional).

### Build & Test

The project uses a Makefile for all build, test, and lint commands:

| Task | Command |
|------|---------|
| Build app | `make build` |
| Build for testing | `make build-for-testing` |
| Run all tests | `make test` |
| Run snapshot tests | `make test-snapshots` |
| Run UI tests | `make test-ui` |
| Format code | `make format` |
| Lint code | `make lint` |

For single Swift packages, use `swift build` / `swift test` directly in the package directory — faster than building the entire app.

### Incremental vs Full Builds

When making an incremental change that is **localised to a single module** and the module's **public interface hasn't changed** (no new/modified `public` types, functions, or protocols), use package-level commands (`swift build` / `swift test` in the package directory) instead of full-app commands (`make build` / `make test`). This is significantly faster and sufficient to validate the change.

**Use package-level** (`swift build` / `swift test` in package directory):
- Internal implementation changes (private/internal types, bug fixes, new tests)
- Adding or modifying non-public code within a single package
- Changes that don't affect how other modules consume this package

**Use full-app** (`make build-for-testing` / `make test`):
- Changes to a module's public interface (new/modified `public` types, protocols, functions)
- Changes spanning multiple packages (e.g., coordinator wiring, factory chain updates)
- Final pre-PR verification (always use full-app for the last check before creating a PR)

### Formatting

**Always run `make format` and `make lint` after making code changes** to ensure consistent style before committing.

### Pre-PR Checklist

Before creating a pull request, **always** verify:

1. Run `make format` and `make lint` — no violations
2. Run `make build-for-testing` — build succeeds with no warnings (warnings are errors)
3. Run `make test` — all tests pass
4. PR title follows gitmoji format: `<gitmoji> <description>` (see [GIT.md](docs/GIT.md))

This prevents CI failures and ensures code quality before review.

## Key Entry Points

| File | Purpose |
|------|---------|
| `App/PopcornApp.swift` | App entry point, creates root store |
| `App/Features/AppRoot/AppRootFeature.swift` | Root TCA reducer, tab management |
| `App/Features/AppRoot/AppRootClient.swift` | App initialization (observability, feature flags) |
| `AppDependencies/` | Central DI hub — registers all use cases as TCA `DependencyKey`s, wires adapters to contexts |

## Architecture

The app follows domain-driven design with 4 layers: Domain, Infrastructure, Application, Composition. Business logic is organised into **Contexts** (e.g., `PopcornMovies`, `PopcornTVSeries`, `PopcornPeople`), UI into **Features** (e.g., `MovieDetailsFeature`, `TVSeriesDetailsFeature`), and external service bridges into **Adapters** (e.g., `PopcornMoviesAdapters`).

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for the full layer structure, module inventory, use case patterns, and step-by-step workflows.

## TMDb Domain Model Mapping

See [docs/TMDB_MAPPING.md](docs/TMDB_MAPPING.md) for the complete TMDb type reference and mapping pipeline.

## External Dependencies

| Dependency | Version | Used By |
|------------|---------|---------|
| swift-composable-architecture | 1.23+ | All Features, AppDependencies |
| TMDb | 16.0+ | Context Adapters |
| SDWebImageSwiftUI | 3.0+ | DesignSystem |
| sentry-cocoa | 8.57+ | ObservabilityAdapters |
| statsig-kit | 1.55+ | FeatureAccessAdapters |
| swift-snapshot-testing | 1.18+ | ExploreFeature (snapshot tests) |

## Code Style

Detailed guides: [SWIFT.md](docs/SWIFT.md) · [SWIFTUI.md](docs/SWIFTUI.md) · [SWIFTDATA.md](docs/SWIFTDATA.md) · [TCA.md](docs/TCA.md) · [GIT.md](docs/GIT.md) · [UITESTING.md](docs/UITESTING.md)

Localization: [SWIFTUI.md § Localization](docs/SWIFTUI.md) — SCREAMING_SNAKE_CASE keys, build-first workflow, `bundle: .module` in packages

### Project-Specific Rules

- When adding or removing feature flags in a Client/Reducer, always update the corresponding `*FeatureFlagsTests` (all existing tests and add new ones for the flag)
- **Test plan registration**: When adding new Swift test targets that contain unit tests (NOT snapshot tests), add the target to `TestPlans/PopcornUnitTests.xctestplan`. Without this, the tests won't run when executing the test plan. Each entry needs `containerPath` (relative path from workspace root prefixed with `container:`), `identifier` (test target name), and `name` (test target name)

### SwiftLint Attributes

```yaml
always_on_same_line: @Dependency, @Environment, @State, @Binding, @testable
always_on_line_above: @ViewBuilder
```
