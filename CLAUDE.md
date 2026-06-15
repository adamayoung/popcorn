# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

Agents act as senior Swift collaborators. Keep responses concise, clarify uncertainty before coding, and align suggestions with the rules linked below.

## Project Overview

Popcorn is a modular SwiftUI application for browsing movies and TV series across iOS, macOS, and visionOS. It uses MVVM — `@Observable @MainActor` view models with a `ViewState` property, native SwiftUI navigation, and compile-time DI via per-feature `Dependencies` structs — with domain-driven design and clean architecture.

**Tech Stack**: Swift 6.2 (strict concurrency), SwiftUI (MVVM, `@Observable`), SwiftData with CloudKit, TMDb API

**Platforms**: iOS 26.0+, macOS 26.0+, visionOS 2.0+

## Getting Started

### Configuration

Copy `Configs/Secrets.example.xcconfig` to `Configs/Secrets.xcconfig` and fill in `TMDB_API_KEY` (required), `SENTRY_DSN` and `STATSIG_SDK_KEY` (optional).

### MCP Servers

When available, prefer MCP tools over manual commands:
- **Xcode MCP** (`xcode`) — building, testing, and diagnostics when running inside Xcode. First get the workspace `tabIdentifier` from `mcp__xcode__XcodeListWindows`, then pass it to `mcp__xcode__BuildProject` (use `buildForTesting: true` to also build tests), `mcp__xcode__RunAllTests` / `mcp__xcode__RunSomeTests`, and `mcp__xcode__GetBuildLog` with `severity: "error"` on failure. These return small structured results, so call them directly. The `/build`, `/build-for-testing`, `/test`, and `/test-single` skills wrap this (MCP when inside Xcode; `make`/`swift` via a Haiku subagent otherwise).
- **TMDb MCP** (`tmdb`) — authoritative source for movie, TV series, and person data. Prefer over web searches or training knowledge.
- **xcode-index-mcp** — locate call sites of functions, and function definitions from call sites. Use project name `Popcorn`. If you need a filepath to make a request, use `rg` to find the file and `rg -n` to find the line number. Use the absolute path when requesting symbols from a file.

### Build & Test

Prefer the slash commands. When inside Xcode they call the `xcode` MCP directly
(getting the `tabIdentifier` from `mcp__xcode__XcodeListWindows` first; results are
small and structured); otherwise they delegate `make`/`swift` to a Haiku subagent
that reports back a concise summary, keeping the large build/test output out of context.

| Task | Slash Command | Xcode MCP (inside Xcode) |
|------|---------------|--------------------------|
| Build app | `/build` | `mcp__xcode__BuildProject` |
| Build for testing | `/build-for-testing` | `mcp__xcode__BuildProject` (`buildForTesting: true`) |
| Run all tests | `/test` | `mcp__xcode__RunAllTests` |
| Run specific tests | `/test-single <name>` | `mcp__xcode__RunSomeTests` |
| Build single package | `/build-package` | — (SwiftPM `swift build`) |
| Build single package for testing | `/build-package-for-testing` | — (SwiftPM) |
| Test single package | `/test-package` | — (SwiftPM `swift test`) |

Use the `-package` variants when working on a single Swift package — they run `swift build`/`swift test` directly in the package directory (faster than the whole app, and not served by the MCP, which builds the entire Xcode project).

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

**Always delegate `make` commands and `swift build`/`swift test` to a Haiku subagent** (Agent tool, `subagent_type: "general-purpose"`, `model: "haiku"`). These commands produce large logs that fill the main conversation context. The subagent runs the command (writing output to a log file) and reports back only:
- Pass/fail status
- Specific errors/failures as `file:line — message`
- Do NOT include the full log — only actionable information, plus the log path on failure

This applies to all build, test, lint, and format commands — both `make` targets and direct `swift` CLI invocations. The `/build`, `/build-for-testing`, `/test`, `/test-single`, `/*-package`, `/format`, and `/lint` skills already wrap this — invoke them rather than running the commands yourself. Xcode MCP (`xcode`) tool calls are exempt (they return structured results).

### Formatting

| Task | Slash Command |
|------|---------------|
| Auto-fix | `/format` |
| Check only | `/lint` |

**Always run `/format` and `/lint` after making code changes** to ensure consistent style before committing.

### Git Push

**Always use `git push`** (not `gh` CLI) when pushing to remote branches. The `gh` CLI bypasses GitHub webhooks and workflow triggers.

### Git Worktrees

**Always create git worktrees under `.claude/worktrees/`** (e.g. `git worktree add .claude/worktrees/<branch-name> -b <branch> <base>`), never in a sibling directory like `../popcorn-<name>`. This keeps worktrees scoped to the project and grouped in one predictable, git-ignored location.

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
| `App/PopcornApp.swift` | App entry point — builds `AppServices` + `ViewModelFactory` and the root view model |
| `App/Features/AppRoot/AppRootViewModel.swift` | Root view model — startup lifecycle, tab selection, feature-flag gating |
| `App/Composition/AppBootstrapper.swift` | App initialization (observability, feature flags) |
| `App/Composition/ViewModelFactory.swift` | Builds each feature's view model from `AppServices` + the tab's navigator |
| `AppDependencies/Sources/AppDependencies/Composition/AppServices.swift` | Composition root — builds the shared factory/use-case graph consumed by feature `Dependencies` |

## Architecture

**Read [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) first.** It is the authoritative
reference for how this project is structured — layer structure, module layout, factory/DI
wiring, navigation, and step-by-step workflows. You should not need to read the whole
codebase to understand the architecture; that document is the map.

In brief: Clean Architecture + Domain-Driven Design + MVVM. Business logic is organised into
**Contexts** (`PopcornMovies`, `PopcornTVSeries`, `PopcornPeople`, …), each a Swift package
with four layers — Domain → Application → Infrastructure → Composition. UI lives in
**Features** (`MovieDetailsFeature`, …), MVVM packages built around an `@Observable @MainActor`
view model exposing a `ViewState`. External services are bridged in **Adapters**
(`PopcornMoviesAdapters`, …). `AppServices` (in `AppDependencies`) is the single composition
root that wires adapters into context factories and exposes them to features.

Conventions worth knowing up front (detail in ARCHITECTURE.md):
- A feature's primary **view, view model, `Dependencies`, and `Navigating` protocol live at the
  root** of its source folder; `Views/` holds the subviews the main view composes (omit when none).
- Feature views own their view model via `@State` and drive loading from `.task(id:)`.
- A context's `Popcorn{Context}Factory` is a **concrete** `Sendable` final class (no factory
  protocol). Adapter factories return **port implementations** (`make… -> some Port`); the
  composition root assembles each context factory from them, and adapters never depend on a
  context's Composition layer.

## TMDb Domain Model Mapping

See [docs/TMDB_MAPPING.md](docs/TMDB_MAPPING.md) for the complete TMDb type reference and mapping pipeline.

## TV Listings EPG Data

The `PopcornTVListings` context consumes a partitioned, content-addressed EPG feed
produced by **[adamayoung/popcorn-epg](https://github.com/adamayoung/popcorn-epg)** (a
separate Swift CLI maintained by the project owner; regenerated every 12 hours). It is
the source of truth for the data format — consult its README before changing EPG DTOs,
domain models, or sync logic.

- **Base URL:** `https://epg.adam-young.co.uk` (hard-coded in `HTTPTVListingsRemoteDataSource`).
- **Sync:** fetch `/manifest.json` first (per-file SHA-256 hashes + the published `dates`),
  then download only the files whose hash changed: `/channels.json`, `/regions.json`, and
  `/schedules/<yyyyMMdd>.json` (one per day). Drop cached days no longer in the manifest.
- **Channels** reference regions via `channelNumbers[].regions` — `(bouquet, subBouquet)`
  pairs. Resolution (**HD vs SD**) is a property of the **region/bouquet** (`regions.json`
  has `isHD`), not the channel record (whose own `isHD` is unreliable). Join a channel's
  region pairs to `regions.json` to determine HD-ness and to label/filter by region.

## External Dependencies

| Dependency | Version | Used By |
|------------|---------|---------|
| TMDb | 18.0+ | Context Adapters |
| SDWebImageSwiftUI | 3.1+ | DesignSystem |
| sentry-cocoa | 9.17+ | ObservabilityAdapters |
| statsig-kit | 1.62+ | FeatureAccessAdapters |
| swift-snapshot-testing | 1.19+ | Feature snapshot tests |

## Code Style

Detailed guides: [SWIFT.md](docs/SWIFT.md) · [SWIFTUI.md](docs/SWIFTUI.md) · [SWIFTDATA.md](docs/SWIFTDATA.md) · [GIT.md](docs/GIT.md) · [UITESTING.md](docs/UITESTING.md)

Localization: [SWIFTUI.md § Localization](docs/SWIFTUI.md) — SCREAMING_SNAKE_CASE keys, build-first workflow, `bundle: .module` in packages

### Project-Specific Rules

- When adding or removing feature flags in a feature's `*Dependencies` / view model, always update the corresponding view-model tests for the flag-gated behavior (cover both enabled and disabled paths)
- **Statsig gate creation**: When adding a new feature flag in code, also create the corresponding Statsig gate using the Statsig MCP (`mcp__statsig__Create_Gate`). Enable it for the `development` environment only (not a full public rollout). Use `mcp__statsig__Get_Gate_Details_by_ID` on a sibling gate to match the naming/config pattern. The gate ID must match the `FeatureFlag.id` in code (snake_case).
- **Test plan registration**: When adding new Swift test targets that contain unit tests (NOT snapshot tests), add the target to `TestPlans/PopcornUnitTests.xctestplan`. Without this, the tests won't run when executing the test plan. Each entry needs `containerPath` (relative path from workspace root prefixed with `container:`), `identifier` (test target name), and `name` (test target name)
- **Test coverage for new features**: Every new feature must have tests at ALL layers — adapter mappers, use cases, and feature view models. Don't just test the happy path; include error paths and edge cases. Check sibling implementations for the test patterns to follow.

### SwiftLint Attributes

```yaml
always_on_same_line: @Environment, @State, @Binding, @testable
always_on_line_above: @ViewBuilder
```
