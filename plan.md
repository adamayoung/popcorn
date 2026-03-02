# Analytics Feature Implementation Plan

## Context

Adding analytics infrastructure to Popcorn using the same platform/adapter pattern as Observability (Sentry) and FeatureAccess (Statsig). The generic `Analytics` platform package defines protocols and models. The `AnalyticsAdapters` package provides the Amplitude implementation.

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Architecture | Platform + Adapter pattern | Matches Observability/Sentry and FeatureAccess/Statsig |
| SDK | Amplitude-Swift v1.17.3 (`https://github.com/amplitude/Amplitude-Swift.git`) | Latest stable, user requirement |
| API scope | Events + User Identity + Reset | Covers common needs without over-engineering |
| Autocapture | `.sessions`, `.appLifecycles` | Sessions + app lifecycle tracking per user preference |
| Feature flag | None | Always enabled when API key configured (like Sentry) |
| Initialization | Concurrent with observability + feature flags in `handleSetup()` | Existing pattern |

## Development Methodology

- Strict TDD where possible
- Package-level verification (`swift build` / `swift test`) for Stories 1 & 2
- Full-app build verification for Story 3
- Run full pre-PR checklist after all stories complete

## Implementation Steps

### Story 1: Analytics Platform Package [S]

**New files:**
1. `Platform/Analytics/Package.swift`
2. `Platform/Analytics/Sources/Analytics/Analysing.swift` — public protocol: `track(event:properties:)`, `setUserId(_:)`, `setUserProperties(_:)`, `reset()`
3. `Platform/Analytics/Sources/Analytics/AnalyticsInitialising.swift` — `start(_ config:) async throws`
4. `Platform/Analytics/Sources/Analytics/AnalyticsFactory.swift` — `makeService() -> some Analysing & AnalyticsInitialising`
5. `Platform/Analytics/Sources/Analytics/AnalyticsService.swift` — delegates to provider, guards `isInitialised`
6. `Platform/Analytics/Sources/Analytics/Logger.swift` — OSLog for "Analytics" category
7. `Platform/Analytics/Sources/Analytics/Providers/AnalyticsProviding.swift` — provider protocol
8. `Platform/Analytics/Sources/Analytics/Models/AnalyticsConfiguration.swift` — apiKey, environment, userID
9. `Platform/Analytics/Sources/AnalyticsTestHelpers/Exports.swift`
10. `Platform/Analytics/Sources/AnalyticsTestHelpers/MockAnalytics.swift`
11. `Platform/Analytics/Sources/AnalyticsTestHelpers/MockAnalyticsProvider.swift`
12. `Platform/Analytics/Tests/AnalyticsTests/AnalyticsServiceTests.swift`
13. `Platform/Analytics/Tests/AnalyticsTests/AnalyticsFactoryTests.swift`

**Verify:** `swift build` and `swift test` in `Platform/Analytics/`

### Story 2: AnalyticsAdapters Package [S]

**New files:**
1. `Adapters/Platform/AnalyticsAdapters/Package.swift` — depends on Analytics + Amplitude-Swift 1.17.3
2. `Adapters/Platform/AnalyticsAdapters/Sources/AnalyticsAdapters/AnalyticsAdaptersFactory.swift`
3. `Adapters/Platform/AnalyticsAdapters/Sources/AnalyticsAdapters/Logger.swift`
4. `Adapters/Platform/AnalyticsAdapters/Sources/AnalyticsAdapters/Providers/AmplitudeAnalyticsProvider.swift`
5. `Adapters/Platform/AnalyticsAdapters/Tests/AnalyticsAdaptersTests/AnalyticsAdaptersFactoryTests.swift`
6. `Adapters/Platform/AnalyticsAdapters/Tests/AnalyticsAdaptersTests/Providers/AmplitudeAnalyticsProviderTests.swift`

**Verify:** `swift build` and `swift test` in `Adapters/Platform/AnalyticsAdapters/`

### Story 3: App Integration & Configuration [M]

**New files:**
1. `AppDependencies/Sources/AppDependencies/Analytics/Analytics+TCA.swift`
2. `AppDependencies/Sources/AppDependencies/Analytics/AnalyticsFactory+TCA.swift`
3. `AppDependencies/Sources/AppDependencies/Analytics/AnalyticsInitialiser+TCA.swift`

**Modified files:**
4. `AppDependencies/Package.swift` — add Analytics + AnalyticsAdapters dependencies
5. `App/AppConfig.swift` — add `Amplitude` enum (apiKey, environment)
6. `App/Features/AppRoot/AppRootClient.swift` — add `setupAnalytics`, import Analytics
7. `App/Features/AppRoot/AppRootFeature.swift` — add `async let analytics` to `handleSetup()`
8. `Configs/Secrets.example.xcconfig` — add Amplitude placeholders
9. `Configs/Debug.xcconfig` — forward Amplitude build settings
10. `Configs/Release.xcconfig` — forward Amplitude build settings
11. `App/Popcorn-Info.plist` — add AmplitudeAPIKey, AmplitudeEnvironment
12. `TestPlans/PopcornUnitTests.xctestplan` — register AnalyticsTests + AnalyticsAdaptersTests

**Verify:** Full `/build-for-testing` and `/test`

## Story Dependency Graph

```
Story 1 → Story 2 → Story 3
```

## Pre-PR Verification

1. `/format` + `/lint` — no violations
2. `/build-for-testing` — no warnings (warnings are errors)
3. `/test` — all tests pass
4. Verify `Secrets.xcconfig` has API key and is in `.gitignore`
