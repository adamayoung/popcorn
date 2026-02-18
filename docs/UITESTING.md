# UI Testing

For generic Swift Testing guidance (expectations, traits, parameterized tests), use the `swift-testing-expert` skill. This file covers **project-specific** patterns only.

This guide covers how to write and maintain UI tests in Popcorn.

## Architecture Overview

UI tests launch the app and interact with it through XCUITest. Feature flag overrides are passed as launch arguments and read via UserDefaults.

## Directory Structure

```
PopcornUITests/                           # XCUITest target
├── PopcornUITestCase.swift               # Base test case
├── Screens/                              # Screen objects
│   ├── Screen.swift                      # Base screen object
│   ├── AppScreen.swift
│   ├── ExploreScreen.swift
│   ├── GamesCatalogScreen.swift
│   ├── MediaSearchScreen.swift
│   ├── MovieDetailsScreen.swift
│   ├── PersonDetailsScreen.swift
│   ├── TVSeriesDetailsScreen.swift
│   └── WatchlistScreen.swift
└── UITests/                              # Test cases
    ├── Explore/
    │   └── ExploreTests.swift
    └── Watchlist/
        └── WatchlistTests.swift
```

## Running UI Tests

```bash
# Via slash command
/test-ui

# Via Xcode MCP
mcp__xcode__RunAllTests
```

## Best Practices

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
