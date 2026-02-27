# Snapshot Strategies and Device Configuration

## Image Strategy

The primary strategy for UI snapshot tests. Renders a SwiftUI view to a PNG image.

```swift
.image(layout: .device(config: .iPhone13Pro))
```

### Layout Options

| Layout | Usage | When to Use |
|--------|-------|-------------|
| `.device(config:)` | Fixed device dimensions with safe areas | Default for screen-level snapshots |
| `.fixed(width:height:)` | Custom dimensions | Component snapshots at specific sizes |
| `.sizeThatFits` | Fits to content | Small components, icons, badges |

### Device Configurations

**iPhone (most commonly used):**

| Config | Resolution | Use Case |
|--------|-----------|----------|
| `.iPhone13Pro` | 390x844 @3x | **Project default** — modern standard size |
| `.iPhoneSe` | 320x568 @2x | Smallest supported iPhone |
| `.iPhone8` | 375x667 @2x | Compact size |
| `.iPhoneX` | 375x812 @3x | Notch-era baseline |
| `.iPhoneXsMax` | 414x896 @3x | Large phone |
| `.iPhone12` | 390x844 @3x | Same as 13 Pro |
| `.iPhone13Mini` | 375x812 @3x | Compact notch |
| `.iPhone13ProMax` | 428x926 @3x | Max size |

**iPad:**

| Config | Resolution |
|--------|-----------|
| `.iPadMini` | 768x1024 |
| `.iPad10_2` | 810x1080 |
| `.iPadPro11` | 834x1194 |
| `.iPadPro12_9` | 1024x1366 |

**Orientation** (iPhone and iPad):

```swift
.image(layout: .device(config: .iPhone13Pro(.portrait)))   // Default
.image(layout: .device(config: .iPhone13Pro(.landscape)))
```

**iPad Split View:**

```swift
.image(layout: .device(config: .iPadPro11(.landscape(splitView: .oneHalf))))
// Options: .oneThird, .oneHalf, .twoThirds, .full
```

## Precision

Control how exact the pixel match must be:

```swift
// Exact match (default)
.image(precision: 1.0, layout: .device(config: .iPhone13Pro))

// Allow 1% pixel difference (handles anti-aliasing variations)
.image(precision: 0.99, layout: .device(config: .iPhone13Pro))

// Perceptual precision (human-eye-level)
.image(precision: 0.98, perceptualPrecision: 0.98, layout: .device(config: .iPhone13Pro))
```

Use `precision: 0.99` if tests are flaky due to sub-pixel rendering differences across machines.

## Recording Modes

Set on the `@Suite` trait or per-assertion:

| Mode | Behavior | Use Case |
|------|----------|----------|
| `.missing` | Records only if no reference exists | **Default for this project** |
| `.all` | Always records, overwriting existing | Re-recording after intentional UI changes |
| `.failed` | Records only when assertion fails | Debugging mismatches |
| `.never` | Never records, fails if missing | Strict CI mode |

```swift
// Suite-level (recommended)
@Suite(.snapshots(record: .missing))

// Per-assertion override
let failure = verifySnapshot(of: view, as: strategy, record: .all)
```

## Full Example with Multiple Strategies

```swift
@Test
func myView() {
    let view = NavigationStack {
        MyView(store: Store(
            initialState: .init(viewState: .ready(previewData)),
            reducer: { EmptyReducer() }
        ))
    }

    // Standard iPhone
    let failure = verifySnapshot(
        of: view,
        as: .image(layout: .device(config: .iPhone13Pro)),
        snapshotDirectory: Self.snapshotDirectory
    )
    if let failure {
        Issue.record(Comment(rawValue: failure))
    }
}
```
