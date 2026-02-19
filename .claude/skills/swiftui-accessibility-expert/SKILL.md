---
name: swiftui-accessibility-expert
description: 'Expert guidance on SwiftUI accessibility: labels, traits, actions, focus management, Dynamic Type, motion, color, grouping, rotors, and testing. Use when building or reviewing SwiftUI views, fixing VoiceOver issues, adding accessibility support, reviewing accessibility compliance, or improving assistive technology experience.'
---

# SwiftUI Accessibility

## Overview

This skill provides comprehensive guidance for building SwiftUI apps accessible to everyone — including users of VoiceOver, Voice Control, Switch Control, and other assistive technologies across iOS, macOS, and visionOS.

**Scope**: SwiftUI accessibility modifiers, accessibility tree management, assistive technology support, Dynamic Type, motion/color/contrast preferences, accessibility testing.

**Relationship to swiftui-expert-skill**: The swiftui-expert-skill covers general SwiftUI best practices. This skill owns all accessibility concerns in depth — labels, traits, actions, grouping, focus management, motion, color, testing. Where topics overlap (e.g., Dynamic Type), this skill provides the authoritative accessibility perspective.

## Agent Behavior Contract

1. **Every interactive element must have a meaningful `accessibilityLabel`** — "Delete" not "Button", "Close" not "X icon". Labels describe purpose, not appearance. Labels must not include the element type (VoiceOver adds it).
2. **Decorative images must use `Image(decorative:)` or `.accessibilityHidden(true)`** — prevent VoiceOver from reading filenames or placeholder text for purely visual elements.
3. **Use semantic controls** — `Button`, `Toggle`, `Picker`, `Slider` instead of `onTapGesture` on `Text`/`Image`. Semantic controls provide correct traits, actions, and values automatically.
4. **Never use color alone to convey meaning** — pair with text, icons, or shapes. Check `accessibilityDifferentiateWithoutColor` for additional non-color indicators.
5. **Respect Dynamic Type** — no hardcoded font sizes; use text styles (`.body`, `.headline`) and `@ScaledMetric` for custom dimensions. Test at accessibility sizes.
6. **Animations must check `accessibilityReduceMotion`** — provide a static or fade alternative. Reduce means reduce, not remove — use subtle transitions instead of no animation.
7. **Group related elements with `.accessibilityElement(children: .combine)`** — reduce VoiceOver stops. A card with title, subtitle, and image should be one stop, not three.
8. **Test with Accessibility Inspector and VoiceOver** — use `performAccessibilityAudit()` in UI tests. Test at multiple Dynamic Type sizes, in dark mode, and with reduce motion enabled.

## Quick Decision Tree

When a developer needs accessibility guidance:

- **Adding labels or descriptions?**
  └─ `references/accessible-descriptions.md` — labels, values, hints, headings, custom content, speech
- **Making a control work with VoiceOver?**
  └─ `references/accessible-controls.md` — traits, actions, adjustable, gestures, representation
- **Handling Dynamic Type, color, or motion?**
  └─ `references/accessible-appearance.md` — text styles, @ScaledMetric, contrast, reduce motion
- **Fixing navigation or focus issues?**
  └─ `references/accessible-navigation.md` — sort priority, rotors, focus state, notifications
- **Reducing VoiceOver stops or structuring elements?**
  └─ `references/accessible-grouping.md` — combine, contain, ignore, conditional grouping, modal
- **Testing or auditing accessibility?**
  └─ `references/accessible-testing.md` — Inspector, VoiceOver checklist, performAccessibilityAudit

## Triage-First Playbook

Common VoiceOver/accessibility errors and the next best move:

- **VoiceOver reads "Button" with no label** → `references/accessible-descriptions.md` — add `accessibilityLabel` describing the action
- **Decorative image announced by VoiceOver** → `references/accessible-descriptions.md` — use `Image(decorative:)` or `.accessibilityHidden(true)`
- **Too many VoiceOver stops on a card/row** → `references/accessible-grouping.md` — use `.accessibilityElement(children: .combine)`
- **Color-only indicator not conveyed** → `references/accessible-appearance.md` — pair with icon/text, check `accessibilityDifferentiateWithoutColor`
- **Custom control not interactive for VoiceOver** → `references/accessible-controls.md` — add correct traits and actions
- **VoiceOver reads elements in wrong order** → `references/accessible-navigation.md` — use `accessibilitySortPriority`
- **Button says item name but no action context** → `references/accessible-descriptions.md` — add `accessibilityHint` describing the navigation destination or result
- **Animations don't respect reduce motion** → `references/accessible-appearance.md` — check `accessibilityReduceMotion`, provide fade alternative
- **Focus not moving after content change** → `references/accessible-navigation.md` — use `@AccessibilityFocusState` or post `AccessibilityNotification`

## Core Patterns Reference

### Labeling an Icon Button

```swift
Button(action: toggleFavorite) {
    Image(systemName: isFavorite ? "heart.fill" : "heart")
}
.accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
```

### Grouping a Card

```swift
HStack {
    AsyncImage(url: movie.posterURL)
    VStack(alignment: .leading) {
        Text(movie.title)
        Text(movie.year)
    }
}
.accessibilityElement(children: .combine)
```

### Conditional Grouping

```swift
HStack {
    if isEditing {
        Button("Delete") { delete() }
    }
    Text(movie.title)
}
.accessibilityElement(children: isEditing ? .contain : .combine)
```

### Carousel with Per-Item Buttons and Hints

Use when each carousel item navigates to its own destination. Each item is an independent VoiceOver stop.

```swift
Carousel {
    ForEach(Array(movies.enumerated()), id: \.offset) { offset, movie in
        Button {
            didSelectMovie(movie.id)
        } label: {
            MovieCard(movie: movie)
        }
        .accessibilityIdentifier("carousel.movie.\(offset)")
        .accessibilityLabel(movie.title)
        .accessibilityHint("View movie details")
        .buttonStyle(.plain)
    }
}
.accessibilityIdentifier("movies.carousel")
```

> **Warning**: Do NOT use `.accessibilityElement()` on the carousel container when items should be individually tappable — it collapses all children into one opaque element.

### Checking Reduce Motion

```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

var body: some View {
    ContentView()
        .transition(reduceMotion ? .opacity : .move(edge: .trailing))
}
```

### Dynamic Type with @ScaledMetric

```swift
@ScaledMetric(relativeTo: .body) private var posterHeight: CGFloat = 120

AsyncImage(url: posterURL)
    .frame(height: posterHeight)
```

## Review Checklist

### Labels & Descriptions
- [ ] Every interactive element has a meaningful `accessibilityLabel`
- [ ] Navigation buttons with item-name labels have an `accessibilityHint` describing the destination
- [ ] Decorative images use `Image(decorative:)` or `.accessibilityHidden(true)`
- [ ] Labels describe purpose, not appearance
- [ ] Labels and hints are localized

### Traits & Roles
- [ ] Semantic controls used (`Button`, `Toggle`, not `onTapGesture` on `Text`)
- [ ] Headers marked with `.isHeader` or `.h1`–`.h6`
- [ ] Selected states use `.isSelected` trait
- [ ] Modal overlays use `.isModal` trait

### Controls & Actions
- [ ] Custom actions provided for multi-action elements
- [ ] Adjustable action for carousels/steppers
- [ ] Escape action for custom dismissals
- [ ] Magic tap for media play/pause

### Grouping & Hierarchy
- [ ] Related content grouped with `.combine` to reduce VoiceOver stops
- [ ] Interactive elements within groups still reachable (`.contain` when editing)
- [ ] Redundant traits cleaned up after combining
- [ ] Canvas views provide `accessibilityChildren`

### Appearance & Adaptability
- [ ] No hardcoded font sizes — text styles or `@ScaledMetric`
- [ ] Color is not the sole indicator of meaning
- [ ] Animations respect `accessibilityReduceMotion`
- [ ] Images exempt from Smart Invert with `accessibilityIgnoresInvertColors()`
- [ ] Minimum tap targets: 44x44pt (iOS), 60x60pt (visionOS)

### Testing
- [ ] Tested with VoiceOver enabled
- [ ] Tested at accessibility Dynamic Type sizes
- [ ] `performAccessibilityAudit()` in UI tests
- [ ] Tested in both light and dark mode for contrast

## Reference Files

| File | Description |
|------|-------------|
| `references/_index.md` | Navigation index with quick links by problem |
| `references/accessible-descriptions.md` | Labels, values, hints, headings, custom content, speech customization |
| `references/accessible-controls.md` | Traits (all 17), actions, adjustable, gestures, representation |
| `references/accessible-appearance.md` | Dynamic Type, color/contrast, motion, transparency, AT checks |
| `references/accessible-navigation.md` | Sort priority, rotors, linked groups, focus, notifications, charts |
| `references/accessible-grouping.md` | Children behavior, conditional grouping, hidden, modal, Canvas |
| `references/accessible-testing.md` | Inspector, VoiceOver checklist, audits, environment overrides, visionOS |
