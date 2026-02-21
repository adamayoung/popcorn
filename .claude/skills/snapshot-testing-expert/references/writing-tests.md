# Writing Snapshot Tests

## Step-by-Step: Adding Snapshots to a Feature

### 1. Add swift-snapshot-testing Dependency to Package.swift

If the feature package doesn't already depend on swift-snapshot-testing:

```swift
dependencies: [
    // ... existing dependencies
    .package(
        url: "https://github.com/pointfreeco/swift-snapshot-testing",
        from: "1.18.7"
    )
]
```

### 2. Create the Snapshot Test Target

Add a separate test target for snapshots (keep them isolated from unit tests):

```swift
.testTarget(
    name: "{FeatureName}SnapshotTests",
    dependencies: [
        "{FeatureName}",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
    ],
    resources: [.copy("Views/__Snapshots__")]
)
```

The `resources: [.copy("Views/__Snapshots__")]` is critical — it bundles snapshot PNGs into the test target for Xcode Cloud CI compatibility.

### 3. Register in Test Plan

Add the new target to `TestPlans/PopcornSnapshotTests.xctestplan`:

```json
{
    "target": {
        "containerPath": "container:Features/{FeatureName}",
        "identifier": "{FeatureName}SnapshotTests",
        "name": "{FeatureName}SnapshotTests"
    }
}
```

### 4. Create the Test File

Place test files under `Tests/{FeatureName}SnapshotTests/Views/`:

```swift
import ComposableArchitecture
@testable import {FeatureName}
import Foundation
import SnapshotTesting
import SwiftUI
import Testing

@Suite("{ViewName}SnapshotTests", .snapshots(record: .missing))
@MainActor
struct {ViewName}SnapshotTests {

    @Test
    func {viewName}() {
        let view = NavigationStack {
            {ViewName}(
                store: Store(
                    initialState: .init(
                        viewState: .ready(/* preview data */)
                    ),
                    reducer: { EmptyReducer() }
                )
            )
        }

        verify(view)
    }

    // MARK: - Helpers

    private func verify(
        _ view: some View,
        named name: String? = nil,
        file: StaticString = #filePath,
        testName: String = #function
    ) {
        let failure = verifySnapshot(
            of: view,
            as: .image(layout: .device(config: .iPhone13Pro)),
            named: name,
            snapshotDirectory: Self.snapshotDirectory,
            file: file,
            testName: testName
        )
        if let failure {
            Issue.record(Comment(rawValue: failure))
        }
    }

    // Must match the @Suite struct name — update if the struct is renamed
    private static var snapshotDirectory: String? {
        guard ProcessInfo.processInfo.environment["CI_XCODE_CLOUD"] != nil else {
            return nil
        }
        return Bundle.module.resourceURL?
            .appendingPathComponent("__Snapshots__")
            .appendingPathComponent("{ViewName}SnapshotTests") // <- your @Suite struct name
            .path
    }

}
```

### 5. Create Preview Data

Add extensions with static preview data below the test struct or in a separate file:

```swift
extension {ModelPreview} {

    static var snapshots: [{ModelPreview}] {
        [
            {ModelPreview}(
                id: 12345,          // Real TMDb ID
                title: "Real Title",
                posterURL: URL(string: "https://image.tmdb.org/t/p/w780/path.jpg"),
                backdropURL: URL(string: "https://image.tmdb.org/t/p/w1280/path.jpg")
            ),
            // ... more items
        ]
    }

}
```

Use real TMDb IDs and image URLs from the TMDb MCP tools for authentic rendering.

### 6. Record the Initial Snapshot

Run:

```bash
make test-snapshots
```

The first run will fail with "No reference was found on disk. Automatically recorded snapshot" — this is expected. The snapshot PNG is now saved in `__Snapshots__/{TestTypeName}/{testName}.1.png`.

### 7. Verify and Commit

Re-run to verify the snapshot matches:

```bash
make test-snapshots
```

Commit the snapshot PNG alongside the test code.

## Key Patterns

### TCA Store Setup for Snapshots

Always use `EmptyReducer()` — snapshot tests capture visual state, not behavior:

```swift
Store(
    initialState: .init(viewState: .ready(previewData)),
    reducer: { EmptyReducer() }
)
```

### Multiple Snapshots Per Test

Use the `named` parameter to distinguish variants:

```swift
let failure1 = verifySnapshot(
    of: view,
    as: .image(layout: .device(config: .iPhone13Pro)),
    named: "iPhone13Pro",
    snapshotDirectory: Self.snapshotDirectory
)

let failure2 = verifySnapshot(
    of: view,
    as: .image(layout: .device(config: .iPadPro12_9(.portrait))),
    named: "iPadPro",
    snapshotDirectory: Self.snapshotDirectory
)
```

### Testing Different States

Create separate test functions for each meaningful state:

```swift
@Test
func loadingState() {
    let view = MyView(
        store: Store(
            initialState: .init(viewState: .loading),
            reducer: { EmptyReducer() }
        )
    )
    // verifySnapshot...
}

@Test
func errorState() {
    let view = MyView(
        store: Store(
            initialState: .init(viewState: .error),
            reducer: { EmptyReducer() }
        )
    )
    // verifySnapshot...
}
```

## File Organization

```
Tests/{FeatureName}SnapshotTests/
└── Views/
    ├── {ViewName}SnapshotTests.swift
    ├── {AnotherView}SnapshotTests.swift
    └── __Snapshots__/
        ├── {ViewName}SnapshotTests/
        │   ├── {testName}.1.png
        │   └── {testName}.iPhone13Pro.png   (named variant)
        └── {AnotherView}SnapshotTests/
            └── {testName}.1.png
```

## SwiftLint Considerations

- `function_body_length`: 50 lines max — split large test methods
- `file_length`: 400 lines — split preview data into separate files if needed
- `force_unwrapping`: use optional chaining (`resourceURL?`), not force unwrap
