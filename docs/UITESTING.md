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

### 1. Create a Test Case

Extend `PopcornUITestCase` for automatic app launch with `-uitest` flag:

```swift
import XCTest

@MainActor
final class MovieDetailsTests: PopcornUITestCase {

    func testMovieDetailsDisplaysTitle() throws {
        let explore = ExploreScreen(app: app)
        let movieDetails = explore.tapOnFirstDiscoverMovie()

        XCTAssertTrue(movieDetails.titleLabel.exists)
    }

}
```

### 2. Create Screen Objects

Screen objects encapsulate UI element queries and interactions:

```swift
import XCTest

@MainActor
final class MovieDetailsScreen: Screen {

    override var uniqueElement: XCUIElement {
        app.scrollViews["movieDetails.view"]
    }

    var titleLabel: XCUIElement {
        app.staticTexts["movieDetails.title"]
    }

    @discardableResult
    func tapOnCastMember(at index: Int) -> PersonDetailsScreen {
        let castSection = app.scrollViews["movieDetails.cast.carousel"]
        scrollTo(castSection)
        castSection.buttons.element(boundBy: index).tap()
        return PersonDetailsScreen(app: app)
    }

}
```

### 3. Add Accessibility Identifiers

Views must have accessibility identifiers for UI tests to find them:

```swift
ScrollView {
    // ...
}
.accessibilityIdentifier("movieDetails.view")

Text(movie.title)
    .accessibilityIdentifier("movieDetails.title")
```

Use a consistent naming convention: `<screen>.<element>` or `<screen>.<section>.<element>`.

## Creating Stub Data

### 1. Add a Stub Repository

Create stub repositories in `*AdaptersUITesting/Repositories/`:

```swift
// PopcornMoviesAdaptersUITesting/Repositories/StubMovieRepository.swift

import Foundation
import MoviesDomain

public final class StubMovieRepository: MovieRepository, Sendable {

    public init() {}

    public func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie {
        guard let movie = Self.movies[id] else {
            throw .notFound
        }
        return movie
    }

    public func movieStream(withID id: Int) async -> AsyncThrowingStream<Movie?, Error> {
        AsyncThrowingStream { continuation in
            if let movie = Self.movies[id] {
                continuation.yield(movie)
            }
            continuation.finish()
        }
    }

}

extension StubMovieRepository {

    static let movies: [Int: Movie] = [
        123: Movie(
            id: 123,
            title: "Test Movie",
            overview: "A test movie for UI testing.",
            releaseDate: DateComponents(calendar: .current, year: 2025, month: 1, day: 1).date,
            posterPath: URL(string: "/poster.jpg"),
            backdropPath: URL(string: "/backdrop.jpg")
        )
    ]

}
```

### 2. Create the UITest Factory

The factory wires stub repositories to the application layer:

```swift
// PopcornMoviesAdaptersUITesting/UITestPopcornMoviesFactory.swift

import Foundation
import MoviesApplication
import MoviesComposition
import MoviesDomain

public final class UITestPopcornMoviesFactory: PopcornMoviesFactory {

    private let applicationFactory: MoviesApplicationFactory

    public init() {
        self.applicationFactory = MoviesApplicationFactory(
            movieRepository: StubMovieRepository(),
            movieWatchlistRepository: StubMovieWatchlistRepository(),
            // ... other stub repositories
        )
    }

    public func makeFetchMovieDetailsUseCase() -> FetchMovieDetailsUseCase {
        applicationFactory.makeFetchMovieDetailsUseCase()
    }

    // ... other use case factory methods

}
```

### 3. Update Package.swift

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

### 4. Register in UITestDependencies

Add the factory to `AppDependencies/UITesting/UITestDependencies.swift`:

```swift
import PopcornMoviesAdaptersUITesting

public enum UITestDependencies {

    public static func configure(_ dependencies: inout DependencyValues) {
        dependencies.moviesFactory = UITestPopcornMoviesFactory()
        // ... other factories
    }

}
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
