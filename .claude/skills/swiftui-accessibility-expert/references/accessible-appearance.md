# Accessible Appearance

Dynamic Type, color and contrast, motion preferences, transparency, assistive technology checks, and HIG sizing guidance.

## Dynamic Type

Dynamic Type lets users choose their preferred text size. SwiftUI respects this automatically when you use text styles.

### Text Styles

Always use semantic text styles instead of fixed sizes:

```swift
// ✅ Scales with Dynamic Type
Text("Movie Title")
    .font(.headline)

Text("Release Date")
    .font(.subheadline)

Text("Description")
    .font(.body)

// ❌ Fixed size ignores user preference
Text("Movie Title")
    .font(.system(size: 18))
```

### @ScaledMetric

Scale custom dimensions proportionally to Dynamic Type:

```swift
struct PosterView: View {
    // Scales from base value of 120 proportionally to the user's text size
    @ScaledMetric(relativeTo: .body) private var posterHeight: CGFloat = 120
    @ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 24

    var body: some View {
        VStack {
            AsyncImage(url: posterURL)
                .frame(height: posterHeight)
            Image(systemName: "star.fill")
                .frame(width: iconSize, height: iconSize)
        }
    }
}
```

### Layout Adaptation

Adapt layout when text sizes increase:

```swift
struct MovieInfoView: View {
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var body: some View {
        if dynamicTypeSize >= .accessibility1 {
            // ✅ Stack vertically at large text sizes
            VStack(alignment: .leading) {
                titleView
                metadataView
            }
        } else {
            HStack {
                titleView
                Spacer()
                metadataView
            }
        }
    }
}
```

### Limiting Dynamic Type Range

In rare cases, constrain the range to prevent layout breakage:

```swift
// ✅ Only when absolutely necessary — compact UI like tab bars
Text(tabLabel)
    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
```

> **Best practice**: Avoid limiting Dynamic Type unless layout genuinely breaks. Users who need accessibility sizes should get them.

## Color and Contrast

### WCAG AA Contrast Requirements

- **Normal text**: Minimum 4.5:1 contrast ratio against background
- **Large text** (18pt+ or 14pt bold): Minimum 3:1 contrast ratio
- **Non-text elements** (icons, borders, focus indicators): Minimum 3:1

### System Colors

System-defined colors automatically adapt to light/dark mode and accessibility settings:

```swift
// ✅ System colors maintain proper contrast in all appearances
Text("Title")
    .foregroundStyle(.primary)

Text("Subtitle")
    .foregroundStyle(.secondary)

// ❌ Custom colors may not meet contrast in all appearances
Text("Title")
    .foregroundStyle(Color(red: 0.7, green: 0.7, blue: 0.7))  // May fail contrast in light mode
```

### Differentiate Without Color

Never use color as the only means of conveying information:

```swift
// ✅ Color + icon + text
HStack {
    Image(systemName: status.isActive ? "checkmark.circle.fill" : "xmark.circle.fill")
    Text(status.isActive ? "Active" : "Inactive")
}
.foregroundStyle(status.isActive ? .green : .red)

// ❌ Color only
Circle()
    .fill(status.isActive ? .green : .red)
    .frame(width: 12, height: 12)
```

Check the environment to provide additional differentiation:

```swift
@Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor

var body: some View {
    HStack {
        Circle()
            .fill(isOnline ? .green : .gray)
        if differentiateWithoutColor {
            // ✅ Add text label when user needs non-color indicators
            Text(isOnline ? "Online" : "Offline")
                .font(.caption)
        }
    }
}
```

### Invert Colors

Mark images and media that should not be inverted when Smart Invert is active:

```swift
// ✅ Photos and artwork should not be inverted
AsyncImage(url: posterURL)
    .accessibilityIgnoresInvertColors()

// ✅ Video players
VideoPlayer(player: player)
    .accessibilityIgnoresInvertColors()
```

> **Note**: `accessibilityIgnoresInvertColors()` inherits through the view hierarchy. Set it on a container to exempt all children; set it with `false` on a child to re-enable inversion for that subtree.

### Increased Contrast

Provide higher-contrast alternatives when the user enables Increase Contrast:

```swift
@Environment(\.colorSchemeContrast) private var contrast

var body: some View {
    Text("Subtle label")
        .foregroundStyle(contrast == .increased ? .primary : .secondary)
}
```

## Motion Preferences

### Reduce Motion

Always check reduce motion and provide a non-animated alternative:

```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

var body: some View {
    ContentView()
        .transition(reduceMotion ? .opacity : .move(edge: .trailing))
}

// ✅ Conditional animation
func animateChange() {
    if reduceMotion {
        // Apply change without animation, or use simple fade
        withAnimation(.easeInOut(duration: 0.1)) {
            showDetail = true
        }
    } else {
        withAnimation(.spring(duration: 0.5, bounce: 0.3)) {
            showDetail = true
        }
    }
}
```

### Practical Motion Patterns

```swift
// ✅ Tighten springs when reduce motion is on
@Environment(\.accessibilityReduceMotion) private var reduceMotion

private var springAnimation: Animation {
    reduceMotion
        ? .easeInOut(duration: 0.15)
        : .spring(duration: 0.4, bounce: 0.3)
}

// ✅ Replace sliding transitions with fades
private var cardTransition: AnyTransition {
    reduceMotion ? .opacity : .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))
}

// ✅ Disable continuous/looping animations
TimelineView(.animation(paused: reduceMotion)) { context in
    PulsingIndicator(date: context.date)
}
```

### Dim Flashing Lights

For video or media content:

```swift
@Environment(\.accessibilityDimFlashingLights) private var dimFlashingLights

var body: some View {
    VideoPlayer(player: player)
        .onAppear {
            if dimFlashingLights {
                player.appliesFlashingLightDimming = true
            }
        }
}
```

### Animated Images

Check whether the user wants animated images (GIFs) to auto-play:

```swift
@Environment(\.accessibilityPlayAnimatedImages) private var playAnimatedImages

var body: some View {
    if playAnimatedImages {
        AnimatedGIFView(url: gifURL)
    } else {
        // ✅ Show static thumbnail instead
        StaticImage(url: gifURL)
    }
}
```

## Transparency

When Reduce Transparency is enabled, use solid backgrounds instead of materials:

```swift
@Environment(\.accessibilityReduceTransparency) private var reduceTransparency

var body: some View {
    ContentView()
        .background(
            reduceTransparency
                ? AnyShapeStyle(Color(.systemBackground))
                : AnyShapeStyle(.ultraThinMaterial)
        )
}
```

## Assistive Technology Checks

Query whether specific assistive technologies are active to adapt the interface:

```swift
@Environment(\.accessibilityVoiceOverEnabled) private var voiceOverEnabled
@Environment(\.accessibilitySwitchControlEnabled) private var switchControlEnabled

var body: some View {
    if voiceOverEnabled || switchControlEnabled {
        // ✅ Show controls that are normally revealed on hover/long-press
        AlwaysVisibleControls()
    } else {
        HoverRevealControls()
    }
}
```

> **Caution**: Only use these checks to enhance the experience for AT users (e.g., showing hidden controls). Never use them to degrade or limit functionality.

## HIG Sizing Guidance

### Minimum Tap Targets

- **iOS**: Minimum 44x44 points for touch targets
- **visionOS**: Minimum 60x60 points for indirect gesture targets

```swift
// ✅ Ensure small icons have adequate tap area
Button(action: dismiss) {
    Image(systemName: "xmark")
        .frame(width: 44, height: 44)
        .contentShape(.rect)
}

// ✅ Or use contentShape for accessibility hit testing
SmallIcon()
    .contentShape(.accessibility, Circle().inset(by: -10))
```

### Spacing

- Provide adequate spacing between interactive elements to prevent accidental activation
- Increase spacing at larger Dynamic Type sizes

```swift
@ScaledMetric private var spacing: CGFloat = 8

VStack(spacing: spacing) {
    // Content with scaled spacing
}
```

### Simple Gestures

- Prefer single-tap over multi-finger or complex gestures
- All functionality reachable via complex gestures must also be available through simple alternatives
- Swipe-to-delete must have an alternative (edit button, context menu)

## Best Practices

1. **Never hardcode font sizes** — use text styles (`.body`, `.headline`) or `@ScaledMetric`
2. **Test at all Dynamic Type sizes** — especially accessibility sizes (`.accessibility1` through `.accessibility5`)
3. **Use system colors** — they adapt to all accessibility appearances automatically
4. **Always pair color with another indicator** — icons, text, shapes, patterns
5. **Reduce motion means reduce, not remove** — use subtle fades instead of no animation
6. **Test with Smart Invert** — verify images and media are excluded with `accessibilityIgnoresInvertColors()`
7. **Mark decorative materials** — replace `.ultraThinMaterial` with solid colors when reduce transparency is on
