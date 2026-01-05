# Agent guide for Swift

This repository uses Swift 6.2 with strict concurrency. Follow these guidelines for modern, safe API usage.

**Platform Targets**: iOS 26.0+, macOS 26.0+, visionOS 2.0+

## Concurrency

### Strict Concurrency Mode

All code must compile with Swift 6.2 strict concurrency enabled.

```swift
// Mark @Observable classes with @MainActor
@MainActor
@Observable
final class MovieViewModel {
    var movies: [Movie] = []
    var isLoading = false
}
```

### Async/Await

```swift
// Good: Modern async/await
func fetchMovies() async throws -> [Movie] {
    try await movieService.fetchAll()
}

// Bad: GCD
func fetchMovies(completion: @escaping ([Movie]) -> Void) {
    DispatchQueue.global().async {
        // ...
    }
}
```

### Task.sleep

```swift
// Good
try await Task.sleep(for: .seconds(1))
try await Task.sleep(for: .milliseconds(500))

// Bad
try await Task.sleep(nanoseconds: 1_000_000_000)
```

## Modern APIs

### String Operations

```swift
// Good: Swift-native
let result = text.replacing("hello", with: "world")

// Bad: Foundation
let result = text.replacingOccurrences(of: "hello", with: "world")
```

### URL Operations

```swift
// Good: Modern Foundation
let docs = URL.documentsDirectory
let file = docs.appending(path: "data.json")

// Bad: Legacy
let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let file = docs.appendingPathComponent("data.json")
```

### Number Formatting

```swift
// Good: Format style
Text(price, format: .currency(code: "USD"))
Text(rating, format: .number.precision(.fractionLength(1)))

// Bad: C-style
Text(String(format: "%.2f", price))
```

### Static Member Lookup

```swift
// Good: Static member
.clipShape(.circle)
.buttonStyle(.borderedProminent)

// Bad: Instance
.clipShape(Circle())
.buttonStyle(BorderedProminentButtonStyle())
```

## Text Filtering

```swift
// Good: Localized search (handles case, diacritics, locale)
movies.filter { $0.title.localizedStandardContains(searchText) }

// Bad: Simple contains (fails with accents, case)
movies.filter { $0.title.contains(searchText) }
```

## Error Handling

### No Force Unwraps

```swift
// Good: Safe unwrapping
guard let movie = movies.first else {
    return
}

if let posterURL = movie.posterPath {
    // use posterURL
}

// Bad: Force unwrap
let movie = movies.first!
let posterURL = movie.posterPath!
```

### No Force Try

```swift
// Good: Proper error handling
do {
    let data = try await fetchData()
} catch {
    logger.error("Fetch failed: \(error)")
}

// Bad: Force try
let data = try! await fetchData()
```

## Testing

### Use Swift Testing Framework

```swift
import Testing

@Test
func movieTitleIsCorrect() {
    let movie = Movie(id: 1, title: "Test", overview: "Overview")
    #expect(movie.title == "Test")
}
```

### Use try #require() for Optionals

```swift
// Good: Fails test with clear message if nil
@Test
func firstMovieHasCorrectTitle() throws {
    let movies = fetchMockMovies()
    let first = try #require(movies.first)
    #expect(first.title == "Expected Title")
}

// Bad: Force unwrap crashes without useful message
@Test
func firstMovieHasCorrectTitle() {
    let movies = fetchMockMovies()
    let first = movies.first!  // Crashes if empty
    #expect(first.title == "Expected Title")
}
```

### Decoding in Tests

```swift
@Test
func decodesMovieFromJSON() throws {
    let json = """
    {"id": 1, "title": "Test", "overview": "A test movie"}
    """
    let data = try #require(json.data(using: .utf8))
    let movie = try JSONDecoder().decode(Movie.self, from: data)
    #expect(movie.id == 1)
}
```

## Typed Throws (Swift 6)

```swift
// Define specific error types
enum MovieRepositoryError: Error {
    case notFound
    case unauthorized
    case unknown(Error?)
}

// Use typed throws
func movie(withID id: Int) async throws(MovieRepositoryError) -> Movie {
    guard let movie = try await fetchMovie(id) else {
        throw .notFound
    }
    return movie
}
```

## Sendable

All types crossing concurrency boundaries must be `Sendable`:

```swift
// Value types are implicitly Sendable
struct Movie: Sendable {
    let id: Int
    let title: String
}

// Classes need explicit conformance
final class MovieCache: Sendable {
    private let lock = NSLock()
    private var cache: [Int: Movie] = [:]
}

// Actors are implicitly Sendable
actor MovieStore {
    private var movies: [Movie] = []
}
```
