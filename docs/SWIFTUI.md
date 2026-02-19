# Agent guide for SwiftUI

General SwiftUI best practices (modern APIs, state management, view composition, performance, animations, Liquid Glass) are provided by the `swiftui-expert` skill. This file contains **project-specific** rules only.

## Project Constraints

- **Platform Targets**: iOS 26.0+, macOS 26.0+, visionOS 2.0+
- Swift 6.2 or later, using modern Swift concurrency.
- Do not introduce third-party frameworks without asking first.
- Avoid UIKit unless requested.
- Avoid using UIKit colors in SwiftUI code.

## Project Conventions

- Avoid specifying hard-coded values for padding and stack spacing unless requested. Use spacing constants:

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

- Do not force specific font sizes; prefer using Dynamic Type instead.
- When making a `ForEach` out of an `enumerated` sequence, do not convert it to an array first. Prefer `ForEach(x.enumerated(), id: \.element.id)` instead of `ForEach(Array(x.enumerated()), id: \.element.id)`.
- In views inside Swift packages, always use `LocalizedStringResource("KEY", bundle: .module)` for localised strings instead of bare string literals. This ensures the correct bundle is used for string lookup at runtime.

```swift
// Bad — resolves against the main bundle, not the package bundle
ContentUnavailableView("NO_ITEMS", systemImage: "tray")
Label("UNABLE_TO_LOAD", systemImage: "exclamationmark.triangle")

// Good — explicitly targets the package's bundle
ContentUnavailableView {
    Label(
        LocalizedStringResource("NO_ITEMS", bundle: .module),
        systemImage: "tray"
    )
}
Label(
    LocalizedStringResource("UNABLE_TO_LOAD", bundle: .module),
    systemImage: "exclamationmark.triangle"
)
```

## Coordinator Views

Navigation destinations in coordinator views (`ExploreRootView`, `SearchRootView`) must be extracted to `private func` helpers — never rendered inline in `switch` cases. This keeps both coordinators consistent and simplifies each case arm.

```swift
// Good — extracted helper
destination: { store in
    switch store.case {
    case .tvSeasonDetails(let store):
        tvSeasonDetails(store: store)
    }
}

private func tvSeasonDetails(store: StoreOf<TVSeasonDetailsPlaceholder>) -> some View {
    Text("Season \(store.seasonNumber)")
        .navigationTitle("Season \(store.seasonNumber)")
}

// Bad — inline rendering
destination: { store in
    switch store.case {
    case .tvSeasonDetails(let store):
        Text("Season \(store.seasonNumber)")
            .navigationTitle("Season \(store.seasonNumber)")
    }
}
```

When adding a new navigation destination, always update **both** `ExploreRootView` and `SearchRootView` with the same helper pattern.

## Platform-Specific Modifiers

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
