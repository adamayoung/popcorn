# UI Testing

This guide covers how to write and maintain UI tests in Popcorn.

## Architecture Overview

UI tests run against stub data instead of real API calls. This is achieved through:

1. **Launch argument detection**: The app checks for `-uitest` to switch to test dependencies
2. **Stub factories**: Each context has a `UITest*Factory` that uses stub repositories
3. **Stub repositories**: Return deterministic, hardcoded data for testing

```
┌─────────────────────┐     ┌──────────────────────────────┐
│   XCUITest          │────▶│  App (launched with -uitest) │
│   PopcornUITests/   │     └──────────────────────────────┘
└─────────────────────┘                   │
                                          ▼
                              ┌───────────────────────────┐
                              │ UITestDependencies        │
                              │ configures stub factories │
                              └───────────────────────────┘
                                          │
                                          ▼
                              ┌───────────────────────────┐
                              │ UITest*Factory            │
                              │ (in *AdaptersUITesting)   │
                              └───────────────────────────┘
                                          │
                                          ▼
                              ┌───────────────────────────┐
                              │ Stub*Repository           │
                              │ returns hardcoded data    │
                              └───────────────────────────┘
```

## Directory Structure

```
PopcornUITests/                           # XCUITest target
├── PopcornUITestCase.swift               # Base test case
├── Screen.swift                          # Base screen object
├── Explore/                              # Screen objects by feature
│   ├── ExploreScreen.swift
│   ├── MovieDetailsScreen.swift
│   └── ...
└── UITests/                              # Test cases
    └── Explore/
        └── ExploreDiscoverMoviesTests.swift

Adapters/Contexts/PopcornMoviesAdapters/
├── Sources/
│   ├── PopcornMoviesAdapters/            # Production adapters
│   └── PopcornMoviesAdaptersUITesting/   # UI test stubs
│       ├── UITestPopcornMoviesFactory.swift
│       ├── Repositories/
│       │   ├── StubMovieRepository.swift
│       │   └── ...
│       └── Providers/
│           └── StubAppConfigurationProvider.swift
└── Package.swift
```

## Running UI Tests

```bash
# Via slash command
/test

# Via Xcode MCP
mcp__xcode__RunAllTests
```

## Writing UI Tests

For a step-by-step guide to writing UI tests, use `/write-ui-test`.

## App Configuration

The app detects UI testing mode via launch arguments:

```swift
// App/PopcornApp.swift

@main
struct PopcornApp: App {

    init() {
        let isUITesting = CommandLine.arguments.contains("-uitest")

        if isUITesting {
            _store = StateObject(wrappedValue: Store(
                initialState: AppRootFeature.State()
            ) {
                AppRootFeature()
            } withDependencies: {
                UITestDependencies.configure(&$0)
            })
        } else {
            // Production store setup
        }
    }

}
```

## Best Practices

### Stub Data

- Use realistic but deterministic data
- Include edge cases (long titles, missing fields, etc.)
- Store static data in extensions on stub classes
- Use real TMDb IDs when possible for consistency

### Screen Objects

- One screen object per logical screen
- Override `uniqueElement` to identify the screen
- Return the next screen from navigation methods
- Use `@discardableResult` for chainable navigation

### Test Cases

- Test one behavior per test method
- Use descriptive test names: `testNavigateToFirstDiscoverMovie`
- Prefer waiting for elements over fixed delays
- Take screenshots on failure (handled by base class)

### Accessibility Identifiers

- Add identifiers to all interactive and assertable elements
- Use hierarchical naming: `screen.section.element`
- Keep identifiers stable across refactors

## Visibility Requirements

`*ApplicationFactory` classes in the Application layer are marked `public` (not `package`) to support UI testing. This allows the Adapters layer's `*AdaptersUITesting` modules to instantiate them with stub repositories.
