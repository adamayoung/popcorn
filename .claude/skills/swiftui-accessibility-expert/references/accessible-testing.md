# Accessible Testing

Accessibility Inspector, VoiceOver testing, Voice Control, automated audits, environment overrides, and visionOS considerations.

## Accessibility Inspector

Xcode's Accessibility Inspector lets you inspect and audit accessibility properties without enabling VoiceOver.

### How to Use

1. Open Accessibility Inspector: Xcode > Open Developer Tool > Accessibility Inspector
2. Select your simulator or device from the target picker
3. Click the crosshair button to enable element inspection
4. Hover over or click elements to see their accessibility properties

### What to Check

For each interactive element, verify:

- **Label**: Meaningful description (not "Button" or filename)
- **Value**: Current state for stateful elements
- **Traits**: Correct role (button, header, link, etc.)
- **Hint**: Optional; describes result of action
- **Actions**: Available custom actions
- **Frame**: Adequate size (44x44pt minimum on iOS)

### Running Audits

1. Click the "Audit" tab in Accessibility Inspector
2. Click "Run Audit" to check the current screen
3. Review reported issues — each includes a description, severity, and the affected element
4. Click on an issue to highlight the element on screen

## VoiceOver Testing Checklist

Systematic walkthrough for VoiceOver testing:

### Navigation

- [ ] Swipe right through the entire screen — every element is reachable
- [ ] No elements are skipped that should be accessible
- [ ] No unexpected elements are announced (decorative images, dividers)
- [ ] Reading order matches logical order (top-to-bottom, left-to-right)
- [ ] Headings are announced as "heading" — use the heading rotor to navigate between them

### Labels

- [ ] Every button has a label (not "Button" alone)
- [ ] Every image that conveys meaning has a label
- [ ] Labels describe purpose, not appearance ("Close" not "X")
- [ ] Labels don't include element type ("Delete" not "Delete button")
- [ ] Toggled states are announced ("Selected" / "Not selected")

### Actions

- [ ] Double-tap activates the correct action
- [ ] Swipe up/down on elements reveals available custom actions
- [ ] Escape gesture (two-finger scrub) dismisses modals
- [ ] Magic tap (two-finger double-tap) triggers media play/pause
- [ ] Adjustable elements respond to swipe up/down for increment/decrement

### Grouping

- [ ] Related content is grouped (card = one stop, not 5 separate stops)
- [ ] Grouped elements have a combined, meaningful label
- [ ] Interactive elements within groups are still reachable when needed
- [ ] Modal views trap focus — cannot navigate to background content

### Dynamic Content

- [ ] New content is announced when it appears
- [ ] Focus moves to relevant content after navigation
- [ ] Loading states are announced
- [ ] Error messages receive focus
- [ ] Empty states are announced

## Voice Control Testing

Voice Control lets users interact by speaking commands.

### Testing Steps

1. Enable Voice Control: Settings > Accessibility > Voice Control
2. Say "Show names" to display labels on all interactive elements
3. Verify every button/control has a visible name
4. Say "Tap [label]" for each interactive element
5. Verify the correct action occurs

### Key Checks

- [ ] All interactive elements have labels Voice Control can match
- [ ] `accessibilityInputLabels` provide alternative names for common elements
- [ ] No two elements on screen have the same label (causes ambiguity)
- [ ] Complex labels are supplemented with shorter input labels

## Switch Control Testing

For users who navigate with external switches:

```swift
// ✅ Technology-specific focus for Switch Control
@AccessibilityFocusState(for: .switchControl)
private var isSwitchFocused: Bool
```

- [ ] All interactive elements are reachable via Switch Control scanning
- [ ] Focus order is logical (no jumping around)
- [ ] Grouped elements are correctly grouped for scanning
- [ ] Custom actions are available through the Switch Control menu

## Accessibility Identifiers

`accessibilityIdentifier` is for **test automation only** — VoiceOver does not read it.

```swift
// ✅ Use identifier for UI test automation
Button("Submit") { submit() }
    .accessibilityIdentifier("submit-button")

// ❌ Don't confuse identifier with label
Button(action: submit) {
    Image(systemName: "paperplane")
}
.accessibilityIdentifier("Submit")  // NOT read by VoiceOver
// Still need:
.accessibilityLabel("Submit")
```

### Convention

- Use kebab-case for identifiers: `"movie-detail-title"`, `"search-field"`
- Keep identifiers stable across app versions for reliable test automation
- Never use identifiers as a substitute for labels

## Automated Accessibility Audits

### performAccessibilityAudit() (iOS 17+)

Run automated accessibility checks in XCUITests:

```swift
import XCTest

final class AccessibilityTests: XCTestCase {
    func testMovieDetailAccessibility() throws {
        let app = XCUIApplication()
        app.launch()

        // Navigate to the screen to audit
        app.buttons["First Movie"].tap()

        // ✅ Run full audit
        try app.performAccessibilityAudit()
    }

    func testHomeScreenAccessibility() throws {
        let app = XCUIApplication()
        app.launch()

        // ✅ Audit specific categories
        try app.performAccessibilityAudit(for: [
            .dynamicType,
            .contrast,
            .hitRegion,
            .sufficientElementDescription,
            .elementDetection
        ])
    }

    func testAccessibilityWithExclusions() throws {
        let app = XCUIApplication()
        app.launch()

        // ✅ Audit with known exceptions
        try app.performAccessibilityAudit(for: .all) { issue in
            // Return true to ignore the issue
            if issue.auditType == .contrast,
               issue.element?.identifier == "decorative-background" {
                return true  // Known decorative element
            }
            return false
        }
    }
}
```

### Audit Types

| Type | What It Checks |
|------|---------------|
| `.dynamicType` | Text respects Dynamic Type settings |
| `.contrast` | Color contrast meets minimum ratios |
| `.hitRegion` | Touch targets meet minimum size (44x44pt) |
| `.sufficientElementDescription` | Elements have meaningful labels |
| `.elementDetection` | Detects elements that may need accessibility support |
| `.textClipping` | Text is not clipped at larger sizes |
| `.all` | All of the above |

## Environment Overrides for Testing

### SwiftUI Previews

Test accessibility settings in previews:

```swift
#Preview("Large Dynamic Type") {
    MovieDetailView()
        .environment(\.dynamicTypeSize, .accessibility3)
}

#Preview("Reduce Motion") {
    MovieDetailView()
        .environment(\.accessibilityReduceMotion, true)
}

#Preview("Increased Contrast") {
    MovieDetailView()
        .environment(\.colorSchemeContrast, .increased)
}

#Preview("Differentiate Without Color") {
    MovieDetailView()
        .environment(\.accessibilityDifferentiateWithoutColor, true)
}
```

### Simulator

Use Xcode's Environment Overrides (Debug > Environment Overrides) to test:
- Dynamic Type sizes
- Bold Text
- Increase Contrast
- Reduce Motion
- Reduce Transparency
- Differentiate Without Color

## visionOS Accessibility Considerations

### Spatial Accessibility

- **Eye tracking**: Elements must be large enough for comfortable eye targeting (60x60pt minimum)
- **Head pointer**: Support head-pointer navigation for users who can't use eye tracking
- **Voice Control**: Full voice control support for hands-free interaction

### Depth and Distance

```swift
// ✅ Keep interactive content at comfortable depth
WindowGroup {
    ContentView()
}
// Avoid placing interactive elements far from the user or at extreme depth offsets
```

- Keep primary content at resting focus distance
- Avoid deep layering that requires users to refocus frequently
- Ensure interactive elements remain within comfortable reach

### Head-Anchored Content

Content anchored to the user's head movement must be accessible:

- Provide sufficient contrast against varying backgrounds
- Ensure text is readable at the display distance
- Support full VoiceOver navigation for anchored content

### Comfort Guidelines from HIG

- Avoid rapid motion toward the user
- Provide stable content — minimize content that tracks head movement
- Use gentle transitions between scenes
- Respect reduced motion preference especially in immersive spaces
- Test in both shared and full immersive spaces

## Common Testing Mistakes

1. **Testing only with VoiceOver OFF** — many issues only surface with VoiceOver active
2. **Testing at default text size only** — always test at accessibility sizes (`.accessibility3`+)
3. **Forgetting dark mode** — contrast ratios can fail in dark mode even when passing in light mode
4. **Not testing navigation order** — swipe through every screen; don't just inspect individual elements
5. **Skipping modal testing** — verify modals trap focus and escape gesture dismisses them
6. **Using identifiers instead of labels** — `accessibilityIdentifier` is invisible to VoiceOver
7. **Not testing with real devices** — simulator VoiceOver can behave differently from device VoiceOver
8. **Testing only happy paths** — test error states, empty states, loading states for accessibility too
