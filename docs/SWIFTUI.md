# Agent guide for SwiftUI

## Core instructions

- See **Platform Targets** section in AGENTS.md for deployment versions.
- Swift 6.2 or later, using modern Swift concurrency.
- SwiftUI backed up by `@Observable` classes for shared data.
- Do not introduce third-party frameworks without asking first.
- Avoid UIKit unless requested.

## SwiftUI instructions

- Always use `foregroundStyle()` instead of `foregroundColor()`.
- Always use `clipShape(.rect(cornerRadius:))` instead of `cornerRadius()`.
- Always use the `Tab` API instead of `tabItem()`.
- Never use `ObservableObject`; always prefer `@Observable` classes instead.
- Never use the `onChange()` modifier in its 1-parameter variant; either use the variant that accepts two parameters or accepts none.
- Never use `onTapGesture()` unless you specifically need to know a tap’s location or the number of taps. All other usages should use `Button`.
- Never use `Task.sleep(nanoseconds:)`; always use `Task.sleep(for:)` instead.
- Never use `UIScreen.main.bounds` to read the size of the available space.
- Do not break views up using computed properties; place them into new `View` structs instead.
- Do not force specific font sizes; prefer using Dynamic Type instead.
- Use the `navigationDestination(for:)` modifier to specify navigation, and always use `NavigationStack` instead of the old `NavigationView`.
- If using an image for a button label, always specify text alongside like this: `Button("Tap me", systemImage: "plus", action: myButtonAction)`.
- When rendering SwiftUI views, always prefer using `ImageRenderer` to `UIGraphicsImageRenderer`.
- Don’t apply the `fontWeight()` modifier unless there is good reason. If you want to make some text bold, always use `bold()` instead of `fontWeight(.bold)`.
- Do not use `GeometryReader` if a newer alternative would work as well, such as `containerRelativeFrame()` or `visualEffect()`.
- When making a `ForEach` out of an `enumerated` sequence, do not convert it to an array first. So, prefer `ForEach(x.enumerated(), id: \.element.id)` instead of `ForEach(Array(x.enumerated()), id: \.element.id)`.
- When hiding scroll view indicators, use the `.scrollIndicators(.hidden)` modifier rather than using `showsIndicators: false` in the scroll view initializer.
- Place view logic into view models or similar, so it can be tested.
- Avoid `AnyView` unless it is absolutely required.
- Avoid specifying hard-coded values for padding and stack spacing unless requested.
- Avoid using UIKit colors in SwiftUI code.

## View Architecture

### Prefer Composition Over Monoliths

Break views into small, focused components. Single Responsibility applies to views.

```swift
// Bad: Monolithic view
struct MovieDetailView: View {
    var body: some View {
        ScrollView {
            // 200 lines of UI code
        }
    }
}

// Good: Composed views
struct MovieDetailView: View {
    var body: some View {
        ScrollView {
            MovieHeaderView(movie: movie)
            MovieOverviewView(overview: overview)
            MovieActionsView(actions: actions)
        }
    }
}
```

## Layout Patterns

### Spacing & Padding

Use consistent spacing via constants or design tokens.

```swift
extension CGFloat {
    static let spacing4: CGFloat = 4
    static let spacing8: CGFloat = 8
    static let spacing16: CGFloat = 16
    static let spacing24: CGFloat = 24
}

VStack(spacing: .spacing16) {
    Text("Title")
    Text("Subtitle")
}
.padding(.spacing16)
```

### Conditional Layouts

Use `@ViewBuilder` for clean conditional rendering.

```swift
@ViewBuilder
private func contentView() -> some View {
    if isLoading {
        ProgressView()
    } else if let error = error {
        ErrorView(error: error)
    } else {
        ContentView(data: data)
    }
}
```

## Performance

### Avoid Heavy Computations in `body`

Extract computed properties or use `let` bindings.

```swift
// Bad
var body: some View {
    Text(movies.filter { $0.rating > 7 }.count.description)
}

// Good
var body: some View {
    let highRatedCount = movies.filter { $0.rating > 7 }.count
    Text(highRatedCount.description)
}
```

## Styling

### Prefer ViewModifiers Over Inline Styles
DRY principle: Extract reusable styles.
```swift
struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemBackground))
            .clipShape(.rect(cornerRadius: 12))
            .shadow(radius: 4)
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}

// Usage
Text("Movie Title")
    .cardStyle()
```

### Platform-Specific Modifiers

Use `#if` sparingly; prefer SwiftUI's built-in adaptivity.

```swift
// Bad
#if os(iOS)
    .navigationBarTitleDisplayMode(.large)
#endif

// Good (SwiftUI adapts automatically)
.navigationTitle("Movies")
```

Only use `#if` when API truly doesn't exist on platform:

```swift
#if os(visionOS)
    .ornament(attachmentAnchor: .scene(.bottom)) {
        ControlsView()
    }
#endif
```

## Navigation

### NavigationStack (iOS 16+)

Use `NavigationStack` with value-based navigation.

```swift
NavigationStack(path: viewStore.binding(\.$path)) {
    MovieListView()
        .navigationDestination(for: Movie.ID.self) { movieID in
            MovieDetailView(movieID: movieID)
        }
}
```

## Accessibility

### Always Provide Labels

Use `.accessibilityLabel()` for non-text elements.

```swift
Image(systemName: "star.fill")
    .accessibilityLabel("Favorite")
```

### Group Related Elements

Use `.accessibilityElement(children: .combine)` for composite views.

```swift
HStack {
    Image(systemName: "star.fill")
    Text("4.5")
}
.accessibilityElement(children: .combine)
.accessibilityLabel("Rating 4.5 stars")
```

## Common Mistakes

### Don't Force-Unwrap in Views

Always handle optionals gracefully.

```swift
// Bad
Text(movie!.title)

// Good
if let movie = movie {
    Text(movie.title)
}

// Better with optional chaining
Text(movie?.title ?? "Unknown")
```

## SwiftUI Previews

### Use #Preview macro for Rapid Iteration

```swift
#Preview {
    MovieDetailView()
}
```

## Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/)
