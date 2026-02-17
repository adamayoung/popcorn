---
name: write-ui-test
description: Write UI tests with stub data
---

# Write UI Tests

Guide for writing UI tests following the project's screen object pattern with stub data.

## Required Information

Ask the user for:
- **Feature/screen to test**
- **Test scenarios** to cover
- **Stub data requirements**

## Architecture Overview

UI tests run against stub data instead of real API calls. This is achieved through:

1. **Launch argument detection**: The app checks for `-uitest` to switch to test dependencies
2. **Stub factories**: Each context has a `UITest*Factory` that uses stub repositories
3. **Stub repositories**: Return deterministic, hardcoded data for testing

```
+-----------------------+     +--------------------------------+
|   XCUITest            |---->|  App (launched with -uitest)   |
|   PopcornUITests/     |     +--------------------------------+
+-----------------------+                   |
                                            v
                              +-----------------------------+
                              | UITestDependencies          |
                              | configures stub factories   |
                              +-----------------------------+
                                            |
                                            v
                              +-----------------------------+
                              | UITest*Factory              |
                              | (in *AdaptersUITesting)     |
                              +-----------------------------+
                                            |
                                            v
                              +-----------------------------+
                              | Stub*Repository             |
                              | returns hardcoded data      |
                              +-----------------------------+
```

## Directory Structure

```
PopcornUITests/                           # XCUITest target
+-- PopcornUITestCase.swift               # Base test case
+-- Screen.swift                          # Base screen object
+-- Explore/                              # Screen objects by feature
|   +-- ExploreScreen.swift
|   +-- MovieDetailsScreen.swift
|   +-- ...
+-- UITests/                              # Test cases
    +-- Explore/
        +-- ExploreDiscoverMoviesTests.swift

Adapters/Contexts/PopcornMoviesAdapters/
+-- Sources/
|   +-- PopcornMoviesAdapters/            # Production adapters
|   +-- PopcornMoviesAdaptersUITesting/   # UI test stubs
|       +-- UITestPopcornMoviesFactory.swift
|       +-- Repositories/
|       |   +-- StubMovieRepository.swift
|       |   +-- ...
|       +-- Providers/
|           +-- StubAppConfigurationProvider.swift
+-- Package.swift
```

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

## Steps

### 1. Create Screen Object (if needed)

In `PopcornUITests/{Feature}/`:

```swift
import XCTest

@MainActor
final class {Screen}Screen: Screen {

    // Unique element that identifies this screen
    override var uniqueElement: XCUIElement {
        app.scrollViews["{screen}.view"]
    }

    // Element accessors
    var titleLabel: XCUIElement {
        app.staticTexts["{screen}.title"]
    }

    var loadingIndicator: XCUIElement {
        app.activityIndicators["{screen}.loading"]
    }

    // Navigation methods return the destination screen
    @discardableResult
    func tapOn{Element}(at index: Int = 0) -> {Destination}Screen {
        let element = app.buttons["{screen}.{element}"].element(boundBy: index)
        scrollTo(element)
        element.tap()
        return {Destination}Screen(app: app)
    }

}
```

### 2. Add Accessibility Identifiers to Views

```swift
ScrollView {
    // Content
}
.accessibilityIdentifier("{screen}.view")

Text(title)
    .accessibilityIdentifier("{screen}.title")

Button(action: { }) {
    // ...
}
.accessibilityIdentifier("{screen}.{action}Button")
```

Naming convention: `<screen>.<element>` or `<screen>.<section>.<element>`

### 3. Create Test Case

In `PopcornUITests/UITests/{Feature}/`:

```swift
import XCTest

@MainActor
final class {Feature}Tests: PopcornUITestCase {

    func test{Scenario}() throws {
        // Arrange - navigate to screen
        let screen = ExploreScreen(app: app)
            .tapOnFirstDiscoverMovie()

        // Act - perform action if needed
        screen.tapOnSomeButton()

        // Assert
        XCTAssertTrue(screen.expectedElement.exists)
    }

    func testNavigateTo{Destination}() throws {
        let origin = OriginScreen(app: app)
        let destination = origin.tapOn{Trigger}()

        // Verify destination loaded
        XCTAssertTrue(destination.uniqueElement.waitForExistence(timeout: 5))
        XCTAssertTrue(destination.titleLabel.exists)
    }

}
```

### 4. Create Stub Repository (if new data needed)

In `Adapters/Contexts/Popcorn{Context}Adapters/Sources/Popcorn{Context}AdaptersUITesting/Repositories/`:

```swift
import Foundation
import {Context}Domain

public final class Stub{Entity}Repository: {Entity}Repository, Sendable {

    public init() {}

    public func {entity}(withID id: Int) async throws({Entity}RepositoryError) -> {Entity} {
        guard let entity = Self.{entities}[id] else {
            throw .notFound
        }
        return entity
    }

}

extension Stub{Entity}Repository {

    static let {entities}: [Int: {Entity}] = [
        123: {Entity}(
            id: 123,
            name: "Test {Entity}",
            // Realistic but deterministic data
        ),
        456: {Entity}(
            id: 456,
            name: "Another {Entity}",
        )
    ]

}
```

### 5. Create UITest Factory (if new stubs)

In `UITestPopcorn{Context}Factory.swift`:

```swift
public final class UITestPopcorn{Context}Factory: Popcorn{Context}Factory {

    public init() {
        let applicationFactory = {Context}ApplicationFactory(
            {entity}Repository: Stub{Entity}Repository(),
            // Other stub repositories
        )
        super.init(applicationFactory: applicationFactory)
    }

}
```

### 6. Update Package.swift (if new UITesting target)

Add the UITesting target to the adapter's Package.swift:

```swift
products: [
    .library(name: "PopcornMoviesAdapters", targets: ["PopcornMoviesAdapters"]),
    .library(name: "PopcornMoviesAdaptersUITesting", targets: ["PopcornMoviesAdaptersUITesting"])
],

targets: [
    .target(
        name: "PopcornMoviesAdaptersUITesting",
        dependencies: [
            .product(name: "MoviesComposition", package: "PopcornMovies"),
            .product(name: "MoviesApplication", package: "PopcornMovies"),
            .product(name: "MoviesDomain", package: "PopcornMovies"),
            "CoreDomain"
        ]
    )
]
```

### 7. Register in UITestDependencies (if new factory)

In `AppDependencies/UITesting/UITestDependencies.swift`:

```swift
import PopcornMoviesAdaptersUITesting

public enum UITestDependencies {

    public static func configure(_ dependencies: inout DependencyValues) {
        dependencies.moviesFactory = UITestPopcornMoviesFactory()
        // Other factories
    }

}
```

## Visibility Requirements

`*ApplicationFactory` classes in the Application layer are marked `public` (not `package`) to support UI testing. This allows the Adapters layer's `*AdaptersUITesting` modules to instantiate them with stub repositories.

## Best Practices

### Stub Data
- Use realistic but deterministic values
- Include edge cases (long text, missing fields)
- Store static data in extensions on stub classes
- Use real TMDb IDs when possible for consistency
- Use consistent IDs across related stubs

### Screen Objects
- One screen object per logical screen
- Override `uniqueElement` for screen identification
- Return destination screen from navigation methods
- Use `@discardableResult` for chainable navigation

### Test Cases
- One behavior per test method
- Descriptive names: `testMovieDetailsDisplaysOverview`
- Wait for elements: `element.waitForExistence(timeout: 5)`
- Use `scrollTo()` before tapping off-screen elements
- Take screenshots on failure (handled by base class)

### Accessibility Identifiers
- Add to all interactive and assertable elements
- Hierarchical naming: `screen.section.element`
- Keep stable across refactors

## Running Tests

```
/test
```

Or run specific test:
```
/test-single {TestClassName}
```

$ARGUMENTS
