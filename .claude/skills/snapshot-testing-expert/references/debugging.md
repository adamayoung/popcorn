# Debugging Snapshot Failures

## Common Failure Types

### "No reference was found on disk"

**Cause**: No snapshot PNG exists for this test.

**Fix (local)**:
1. This is expected on first run — the snapshot is automatically recorded.
2. Re-run the test to verify it passes.
3. Commit the new PNG in `__Snapshots__/{TestTypeName}/{testName}.1.png`.

**Fix (Xcode Cloud)**:
See `references/xcode-cloud.md` — the CI environment can't access source files. Bundle snapshots as resources.

### Snapshot Mismatch (pixel difference)

**Cause**: The rendered UI differs from the stored reference image.

**Intentional change** (UI was updated):
1. Delete the old snapshot PNG from `__Snapshots__/{TestTypeName}/`.
2. Re-run the test to record a new snapshot.
3. Visually inspect the new PNG to confirm it looks correct.
4. Commit the updated PNG.

**Unintentional change** (regression):
1. Check what changed in the view code.
2. Look at the failure output — it includes the path to the actual (new) render.
3. Compare the reference and actual images visually.
4. Fix the regression and re-run.

### Snapshot Renders Blank or Partially Loaded

**Causes and fixes:**

| Cause | Fix |
|-------|-----|
| No preview data provided | Populate the TCA store state with preview data |
| Async image loading not completed | Images in snapshots won't load from remote URLs — this is expected; snapshot tests capture layout, not network-loaded images |
| View requires environment values | Inject required environment values into the view hierarchy |
| Missing `NavigationStack` wrapper | Wrap the view in `NavigationStack` if it expects navigation context |

### Different Results on Different Machines

**Cause**: Rendering differences between macOS versions, Xcode versions, or simulator runtimes.

**Fixes:**
- Always use a fixed device config (e.g., `.iPhone13Pro`) — never `.sizeThatFits` for screen-level tests.
- Use `precision: 0.99` if sub-pixel anti-aliasing causes flaky tests:
  ```swift
  .image(precision: 0.99, layout: .device(config: .iPhone13Pro))
  ```
- Ensure the team uses the same Xcode version for recording snapshots.

## Updating Snapshots After Intentional UI Changes

1. Delete the old PNG(s) from `__Snapshots__/`.
2. Run snapshot tests:
   ```bash
   make test-snapshots
   ```
3. First run records new snapshots (test "fails" with recording message).
4. Second run verifies they pass.
5. Visually inspect the new PNGs.
6. Commit the updated PNGs.

Alternatively, temporarily use `.all` recording mode to overwrite:

```swift
@Suite(.snapshots(record: .all))  // Temporarily set to .all
```

**Remember to revert back to `.missing` before committing.**

## Inspecting Snapshot Files

Snapshot images are stored at:

```
Tests/{FeatureName}SnapshotTests/Views/__Snapshots__/{TestTypeName}/{testName}.{variant}.png
```

- `{TestTypeName}` — the name of the `@Suite` struct (e.g., `ExploreViewSnapshotTests`)
- `{testName}` — the test function name (e.g., `exploreView`)
- `{variant}` — numbered starting at 1, or a named variant

Open the PNG directly to visually inspect:

```bash
open Features/ExploreFeature/Tests/ExploreFeatureSnapshotTests/Views/__Snapshots__/ExploreViewSnapshotTests/exploreView.1.png
```

## Running Specific Snapshot Tests

```bash
# All snapshot tests
make test-snapshots

# Specific test class
make test-snapshots TEST_CLASS=ExploreFeatureSnapshotTests/ExploreViewSnapshotTests

# Specific test method
make test-snapshots TEST_CLASS=ExploreFeatureSnapshotTests/ExploreViewSnapshotTests/exploreView
```
