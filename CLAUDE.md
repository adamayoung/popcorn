# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Agents act as senior Swift collaborators. Keep responses concise, clarify uncertainty before coding, and align suggestions with the rules linked below.

## Project Overview

Popcorn is a modular SwiftUI application for browsing movies and TV series across iOS, macOS, and visionOS. It uses The Composable Architecture (TCA) with domain-driven design and clean architecture.

**Tech Stack**: Swift 6.2 (strict concurrency), SwiftUI, TCA 1.23+, SwiftData with CloudKit, TMDb API

**Platforms**: iOS 26.0+, macOS 26.0+, visionOS 2.0+

## Getting Started

### Configuration

Copy `Configs/Secrets.example.xcconfig` to `Configs/Secrets.xcconfig` and fill in `TMDB_API_KEY` (required), `SENTRY_DSN` and `STATSIG_SDK_KEY` (optional).

### MCP Servers

When available, prefer MCP tools over manual commands:
- **Xcode MCP** (`xcode`) — building, testing, file operations, diagnostics. All tools require a `tabIdentifier` from `mcp__xcode__XcodeListWindows`. File paths use Xcode project navigator format, not filesystem paths.
- **TMDb MCP** (`tmdb`) — authoritative source for movie, TV series, and person data. Prefer over web searches or training knowledge.
- **xcode-index-mcp** — locate call sites of functions, and function definitions from call sites. Use project name `Popcorn`. If you need a filepath to make a request, use `rg` to find the file and `rg -n` to find the line number. Use the absolute path when requesting symbols from a file.

### Build & Test

Use slash commands or Xcode MCP tools directly:

| Task | Slash Command | MCP Tool |
|------|---------------|----------|
| Build app | `/build` | `mcp__xcode__BuildProject` |
| Build for testing | `/build-for-testing` | — |
| Run all tests | `/test` | `mcp__xcode__RunAllTests` |
| Run specific tests | `/test-single <name>` | `mcp__xcode__RunSomeTests` with test specifiers |
| Build single package | `/build-package` | — |
| Build single package for testing | `/build-package-for-testing` | — |
| Test single package | `/test-package` | `mcp__xcode__RunSomeTests` with test specifiers |

Use the `-package` variants when working on a single Swift package — they run `swift build`/`swift test` directly in the package directory, which is faster than building the entire app.

### Incremental vs Full Builds

When making an incremental change that is **localised to a single module** and the module's **public interface hasn't changed** (no new/modified `public` types, functions, or protocols), use package-level commands (`/build-package`, `/test-package`) instead of full-app commands (`/build`, `/test`). This is significantly faster and sufficient to validate the change.

**Use package-level** (`/build-package`, `/test-package`):
- Internal implementation changes (private/internal types, bug fixes, new tests)
- Adding or modifying non-public code within a single package
- Changes that don't affect how other modules consume this package

**Use full-app** (`/build-for-testing`, `/test`):
- Changes to a module's public interface (new/modified `public` types, protocols, functions)
- Changes spanning multiple packages (e.g., coordinator wiring, factory chain updates)
- Final pre-PR verification (always use full-app for the last check before creating a PR)

### Build & Test Output Management

**Always delegate `make` commands and `swift build`/`swift test` to a subagent** using the Task tool (`subagent_type: "general-purpose"`). These commands produce large logs that fill the main conversation context. The subagent runs the command and reports back only:
- Pass/fail status
- Error count and specific error messages (if any)
- Do NOT include the full log — only actionable information

This applies to all build, test, lint, and format commands — both `make` targets and direct `swift` CLI invocations. Xcode MCP tool calls are exempt (they return structured results).

### Formatting

| Task | Slash Command |
|------|---------------|
| Auto-fix | `/format` |
| Check only | `/lint` |

**Always run `/format` and `/lint` after making code changes** to ensure consistent style before committing.

### Git Push

**Always use `git push`** (not `gh` CLI) when pushing to remote branches. The `gh` CLI bypasses GitHub webhooks and workflow triggers.

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
- **Statsig gate creation**: When adding a new feature flag in code, also create the corresponding Statsig gate using the Statsig MCP (`mcp__statsig__Create_Gate`). Enable it for the `development` environment only (not a full public rollout). Use `mcp__statsig__Get_Gate_Details_by_ID` on a sibling gate to match the naming/config pattern. The gate ID must match the `FeatureFlag.id` in code (snake_case).
- **Test plan registration**: When adding new Swift test targets that contain unit tests (NOT snapshot tests), add the target to `TestPlans/PopcornUnitTests.xctestplan`. Without this, the tests won't run when executing the test plan. Each entry needs `containerPath` (relative path from workspace root prefixed with `container:`), `identifier` (test target name), and `name` (test target name)
- **Test coverage for new features**: Every new feature must have tests at ALL layers — adapter mappers, use cases, and TCA reducers. Don't just test the happy path; include error paths and edge cases. Check sibling implementations for the test patterns to follow.

### SwiftLint Attributes

```yaml
always_on_same_line: @Dependency, @Environment, @State, @Binding, @testable
always_on_line_above: @ViewBuilder
```
