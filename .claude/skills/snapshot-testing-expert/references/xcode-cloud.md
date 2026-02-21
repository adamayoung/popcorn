# Xcode Cloud CI Compatibility

## The Problem

Xcode Cloud separates build and test execution into different environments. Tests are compiled in one environment where `#filePath` resolves to `/Volumes/workspace/repository/...`, but execute in a different environment that **does not have access to the original source files**.

This means the `__Snapshots__` directory doesn't exist at the path `#filePath` pointed to during compilation. The test fails with:

> No reference was found on disk. Automatically recorded snapshot.

This happens despite the snapshot PNGs being committed to git and present in the repository.

See: [pointfreeco/swift-snapshot-testing#553](https://github.com/pointfreeco/swift-snapshot-testing/discussions/553)

## The Solution

Bundle snapshot images as SPM resources so they're included in the test bundle, then resolve the directory from `Bundle.module` when running in Xcode Cloud.

### Three Required Changes

#### 1. Package.swift — Bundle Snapshots as Resources

Add `.copy("Views/__Snapshots__")` to the snapshot test target's resources:

```swift
.testTarget(
    name: "MyFeatureSnapshotTests",
    dependencies: [
        "MyFeature",
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
        .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
    ],
    resources: [.copy("Views/__Snapshots__")]
)
```

This copies the `__Snapshots__` directory (with all PNGs) into the test bundle. The `.copy` directive preserves the directory structure — the bundle will contain `__Snapshots__/{TestTypeName}/{testName}.1.png`.

**Note**: `Bundle.module` is only available when the test target declares at least one resource. Without this line, `Bundle.module` won't compile.

#### 2. Test File — Use verifySnapshot with Conditional Directory

Use `verifySnapshot` (not `assertSnapshot`) because only `verifySnapshot` has the `snapshotDirectory` parameter:

```swift
let failure = verifySnapshot(
    of: view,
    as: .image(layout: .device(config: .iPhone13Pro)),
    snapshotDirectory: Self.snapshotDirectory
)
if let failure {
    Issue.record(Comment(rawValue: failure))
}
```

#### 3. Test File — Add snapshotDirectory Computed Property

```swift
// Must match the @Suite struct name — update if the struct is renamed
private static var snapshotDirectory: String? {
    guard ProcessInfo.processInfo.environment["CI_XCODE_CLOUD"] != nil else {
        return nil
    }
    return Bundle.module.resourceURL?
        .appendingPathComponent("__Snapshots__")
        .appendingPathComponent("MyViewSnapshotTests") // <- your @Suite struct name
        .path
}
```

**How it works:**

| Environment | `CI_XCODE_CLOUD` | `snapshotDirectory` | Behavior |
|-------------|-------------------|---------------------|----------|
| Local | Not set | `nil` | Falls back to `#filePath`-based resolution — recording and verification work normally |
| Xcode Cloud | Set | `Bundle.module` path | Resolves from bundled resources — verification works, recording writes to bundle (unused in CI) |

**Important**: Use optional chaining (`resourceURL?`) not force unwrap (`resourceURL!`) — SwiftLint enforces `force_unwrapping` rule.

## Environment Variable

Xcode Cloud automatically sets `CI_XCODE_CLOUD=TRUE` in all workflow environments. No manual configuration needed.

## Checklist for CI Compatibility

- [ ] Package.swift has `resources: [.copy("Views/__Snapshots__")]` on snapshot test target
- [ ] Test uses `verifySnapshot` with `snapshotDirectory: Self.snapshotDirectory`
- [ ] `snapshotDirectory` property returns `nil` locally, `Bundle.module` path in CI
- [ ] No force unwraps on `Bundle.module.resourceURL`
- [ ] Snapshot PNGs are committed to git (not in `.gitignore`)
- [ ] Snapshot test target is registered in `TestPlans/PopcornSnapshotTests.xctestplan`

## Reference Implementation

See `Features/ExploreFeature/Tests/ExploreFeatureSnapshotTests/Views/ExploreViewSnapshotTests.swift` for the canonical implementation of this pattern.
