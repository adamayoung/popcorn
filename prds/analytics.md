# Analytics Platform Integration

## Overview

Add a generic analytics platform package (`Analytics`) and an Amplitude adapter package (`AnalyticsAdapters`) to the app, following the same architecture as Observability/Sentry and FeatureAccess/Statsig. The generic package defines protocols and models with no knowledge of Amplitude; the adapter provides the Amplitude implementation.

## Problem

The app currently has no analytics tracking. Adding analytics infrastructure enables data-driven product decisions, user behaviour understanding, and feature adoption measurement. The modular platform/adapter pattern ensures the analytics provider can be swapped without touching business logic.

## Goals

1. Create a generic `Analytics` platform package with protocols for event tracking, user identity, and initialization
2. Create an `AnalyticsAdapters` package that implements the generic protocols using the Amplitude Swift SDK (v1.17.3)
3. Wire analytics into the app's dependency injection system via `AppDependencies`
4. Initialize analytics on app startup alongside observability and feature flags
5. Configure Amplitude with sessions + app lifecycle autocapture
6. Add the Amplitude API key to `Secrets.xcconfig`

## Non-Goals

- Tracking specific analytics events in existing features (follow-up work)
- Revenue tracking or group analytics (can be added later)
- Feature flag gating of analytics
- Screen view autocapture (only sessions + app lifecycles)

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Package structure | Platform + Adapter (same as Observability/Sentry) | Proven pattern in codebase; keeps 3rd-party SDK isolated |
| Analytics SDK | Amplitude-Swift v1.17.3 | User requirement; latest stable version |
| API surface | Events + User Identity + Reset | Covers common analytics needs without over-engineering |
| Autocapture | Sessions + App Lifecycles | Low overhead, high value; user preference |
| Feature flag | None | Always enabled when configured (like Observability) |
| Initialization | Concurrent with observability + feature flags | Follows existing pattern in AppRootFeature |

## Data Flow

```
App Launch
  │
  ▼
AppRootFeature.handleSetup()
  │
  ├─── async let setupObservability (existing)
  ├─── async let setupFeatureFlags (existing)
  └─── async let setupAnalytics (NEW)
         │
         ▼
       AppRootClient.setupAnalytics
         │
         ▼
       AppConfig.Amplitude.apiKey / .environment
         │
         ▼
       AnalyticsConfiguration(apiKey:, environment:, userID:)
         │
         ▼
       analyticsInitialiser.start(config)
         │
         ▼
       AnalyticsService.start() → provider.start()
         │
         ▼
       AmplitudeAnalyticsProvider.start()
         │
         ▼
       Amplitude SDK initialized with Configuration(apiKey:, autocapture:)


Event Tracking Flow:
  Feature Reducer / Client
    │
    ▼
  @Dependency(\.analytics) var analytics
    │
    ▼
  analytics.track(event:, properties:)
    │
    ▼
  AnalyticsService → AmplitudeAnalyticsProvider
    │
    ▼
  Amplitude.track(eventType:, eventProperties:)
```

## User Stories

### Story 1: Analytics Platform Package [S]

**Description**: As a developer, I want a generic analytics platform package so that analytics capabilities are defined independently of any specific SDK.

**Acceptance Criteria**:
- [ ] `Platform/Analytics/Package.swift` defines `Analytics` and `AnalyticsTestHelpers` libraries
- [ ] `AnalyticsProviding` protocol defines `start`, `track`, `setUserId`, `setUserProperties`, `reset`
- [ ] `Analysing` protocol exposes the public API (track, setUserId, setUserProperties, reset)
- [ ] `AnalyticsInitialising` protocol exposes `start(_ config:)`
- [ ] `AnalyticsConfiguration` model holds `apiKey`, `environment`, `userID`
- [ ] `AnalyticsFactory` creates `AnalyticsService` from a provider
- [ ] `AnalyticsService` delegates to provider with isInitialised guard
- [ ] Test helpers include `MockAnalytics` and `MockAnalyticsProvider`
- [ ] `swift build` passes in `Platform/Analytics/`
- [ ] `swift test` passes in `Platform/Analytics/`

**Tech Elab**:

Files to create:
- `Platform/Analytics/Package.swift` — follow `Platform/Observability/Package.swift` pattern
- `Platform/Analytics/Sources/Analytics/Analysing.swift` — public protocol (like `Observing.swift`)
- `Platform/Analytics/Sources/Analytics/AnalyticsInitialising.swift` — init protocol (like `ObservabilityInitialising.swift`)
- `Platform/Analytics/Sources/Analytics/AnalyticsFactory.swift` — factory class (like `ObservabilityFactory.swift`)
- `Platform/Analytics/Sources/Analytics/AnalyticsService.swift` — service impl (like `ObservabilityService.swift`)
- `Platform/Analytics/Sources/Analytics/Logger.swift` — OSLog extension (like Observability `Logger.swift`)
- `Platform/Analytics/Sources/Analytics/Providers/AnalyticsProviding.swift` — provider protocol (like `ObservabilityProviding.swift`)
- `Platform/Analytics/Sources/Analytics/Models/AnalyticsConfiguration.swift` — config model (like `ObservabilityConfiguration.swift`)
- `Platform/Analytics/Sources/AnalyticsTestHelpers/Exports.swift` — `@_exported import Analytics`
- `Platform/Analytics/Sources/AnalyticsTestHelpers/MockAnalytics.swift` — mock of `Analysing` (like `MockObservability.swift`)
- `Platform/Analytics/Sources/AnalyticsTestHelpers/MockAnalyticsProvider.swift` — mock of `AnalyticsProviding` (like `MockObservabilityProvider.swift`)
- `Platform/Analytics/Tests/AnalyticsTests/AnalyticsServiceTests.swift` — service tests

**Test Elab**:
- `AnalyticsServiceTests`: start delegates to provider, track delegates to provider, track guards isInitialised, setUserId delegates, setUserProperties delegates, reset delegates
- `AnalyticsFactoryTests`: makeService returns conforming type

**Dependencies**: None

---

### Story 2: AnalyticsAdapters Package [S]

**Description**: As a developer, I want an Amplitude adapter package that implements the generic analytics protocols using the Amplitude Swift SDK.

**Acceptance Criteria**:
- [ ] `Adapters/Platform/AnalyticsAdapters/Package.swift` depends on `Analytics` and `Amplitude-Swift` v1.17.3+
- [ ] `AmplitudeAnalyticsProvider` conforms to `AnalyticsProviding`
- [ ] Provider initializes Amplitude with sessions + app lifecycle autocapture
- [ ] Provider maps `AnalyticsConfiguration.Environment` for Amplitude server URL selection
- [ ] `AnalyticsAdaptersFactory` creates `AnalyticsFactory` with `AmplitudeAnalyticsProvider`
- [ ] `swift build` passes in `Adapters/Platform/AnalyticsAdapters/`

**Tech Elab**:

Files to create:
- `Adapters/Platform/AnalyticsAdapters/Package.swift` — follow `ObservabilityAdapters/Package.swift` pattern, depend on Amplitude-Swift
- `Adapters/Platform/AnalyticsAdapters/Sources/AnalyticsAdapters/AnalyticsAdaptersFactory.swift` — factory (like `ObservabilityAdaptersFactory.swift`)
- `Adapters/Platform/AnalyticsAdapters/Sources/AnalyticsAdapters/Logger.swift` — OSLog extension
- `Adapters/Platform/AnalyticsAdapters/Sources/AnalyticsAdapters/Providers/AmplitudeAnalyticsProvider.swift` — Amplitude implementation (like `SentryObservabilityProvider.swift`)
- `Adapters/Platform/AnalyticsAdapters/Tests/AnalyticsAdaptersTests/AnalyticsAdaptersFactoryTests.swift` — factory tests
- `Adapters/Platform/AnalyticsAdapters/Tests/AnalyticsAdaptersTests/Providers/AmplitudeAnalyticsProviderTests.swift` — provider tests

**Test Elab**:
- `AnalyticsAdaptersFactoryTests`: factory creates valid AnalyticsFactory
- `AmplitudeAnalyticsProviderTests`: protocol conformance, Sendable conformance

**Dependencies**: Story 1

---

### Story 3: App Integration & Configuration [M]

**Description**: As a developer, I want analytics wired into the app's dependency injection and initialization system so that analytics is available throughout the app.

**Acceptance Criteria**:
- [ ] `AppDependencies/Package.swift` includes `Analytics` and `AnalyticsAdapters` dependencies
- [ ] TCA dependency keys registered for `analytics` (Analysing) and `analyticsInitialiser` (AnalyticsInitialising)
- [ ] `AppConfig.Amplitude` resolves API key and environment from Info.plist / env vars
- [ ] `AppRootClient.setupAnalytics` initializes analytics with configuration
- [ ] `AppRootFeature.handleSetup()` runs analytics setup concurrently with observability and feature flags
- [ ] `Configs/Secrets.example.xcconfig` includes `AMPLITUDE_API_KEY` and `AMPLITUDE_ENVIRONMENT` placeholders
- [ ] `Configs/Secrets.xcconfig` contains the actual Amplitude API key
- [ ] `Configs/Debug.xcconfig` and `Release.xcconfig` forward Amplitude build settings
- [ ] `App/Popcorn-Info.plist` includes Amplitude keys
- [ ] Full app builds successfully
- [ ] All tests pass

**Tech Elab**:

Files to create:
- `AppDependencies/Sources/AppDependencies/Analytics/Analytics+TCA.swift` — DependencyKey for `Analysing` (like `Observability+TCA.swift`)
- `AppDependencies/Sources/AppDependencies/Analytics/AnalyticsFactory+TCA.swift` — factory DependencyValues (like `ObservabilityFactory+TCA.swift`)
- `AppDependencies/Sources/AppDependencies/Analytics/AnalyticsInitialiser+TCA.swift` — DependencyKey for `AnalyticsInitialising` (like `ObservabilityInitialiser+TCA.swift`)

Files to modify:
- `AppDependencies/Package.swift` — add Analytics and AnalyticsAdapters dependencies
- `App/AppConfig.swift` — add `Amplitude` enum with `apiKey` and `environment`
- `App/Features/AppRoot/AppRootClient.swift` — add `setupAnalytics` closure, add `@Dependency(\.analyticsInitialiser)`, add `import Analytics`
- `App/Features/AppRoot/AppRootFeature.swift` — add `async let analytics` to `handleSetup()`
- `Configs/Secrets.example.xcconfig` — add `AMPLITUDE_API_KEY` and `AMPLITUDE_ENVIRONMENT` placeholders
- `Configs/Debug.xcconfig` — add Amplitude build setting forwarding
- `Configs/Release.xcconfig` — add Amplitude build setting forwarding
- `App/Popcorn-Info.plist` — add `AmplitudeAPIKey` and `AmplitudeEnvironment` keys
- `TestPlans/PopcornUnitTests.xctestplan` — register `AnalyticsTests` and `AnalyticsAdaptersTests` targets

**Test Elab**:
- Existing `AppRootClientTests` may need updating if they exist
- Full build and test verification

**Dependencies**: Story 1, Story 2

---

## Story Dependency Graph

```
Story 1 (Analytics Platform)
    │
    ▼
Story 2 (AnalyticsAdapters)
    │
    ▼
Story 3 (App Integration)
```

All stories are sequential — each depends on the previous.

## Verification

- [ ] `/format` and `/lint` pass with no violations
- [ ] `/build-for-testing` succeeds with no warnings
- [ ] `/test` passes — all tests green
- [ ] New test targets registered in `PopcornUnitTests.xctestplan`
- [ ] `Configs/Secrets.xcconfig` contains the Amplitude API key (not committed to git)
