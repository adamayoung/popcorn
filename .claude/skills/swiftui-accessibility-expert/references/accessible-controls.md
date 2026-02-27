# Accessible Controls

Traits, actions, adjustable controls, gestures, scroll actions, and accessibility representation for SwiftUI views.

## Accessibility Traits

Traits describe the behavior and role of an accessibility element. VoiceOver uses them to communicate how users can interact with elements.

### Complete Trait Reference

| Trait | Description | When to Use |
|-------|-------------|-------------|
| `.isButton` | Activatable element | Custom views acting as buttons |
| `.isHeader` | Section heading | Section titles for rotor navigation |
| `.isSelected` | Currently selected item | Tabs, segmented controls, selection lists |
| `.isLink` | Opens a URL or navigates | Elements that open web content or deep links |
| `.isSearchField` | Text input for search | Custom search fields |
| `.isImage` | Visual content | Custom image views (standard `Image` gets this automatically) |
| `.isStaticText` | Non-interactive text | Text that isn't tappable (usually automatic) |
| `.isKeyboardKey` | Custom keyboard key | Custom keyboard implementations |
| `.isSummaryElement` | Summary of app state | Lock screen widgets, status summaries |
| `.playsSound` | Plays audio on activation | Buttons that trigger sound effects |
| `.startsMediaSession` | Begins media playback | Play buttons for audio/video |
| `.allowsDirectInteraction` | Bypasses VoiceOver | Piano keys, drawing canvas areas |
| `.causesPageTurn` | Triggers page navigation | Swipe-to-paginate controls |
| `.isToggle` | Binary on/off control | Custom toggle implementations |
| `.isModal` | Modal content | Overlays that should trap VoiceOver focus |
| `.updatesFrequently` | Live-updating content | Timers, stock tickers, scores |
| `.tabBar` | Tab bar container | Custom tab bar implementations |

### Adding and Removing Traits

```swift
// ✅ Add traits to describe behavior
Text("Featured")
    .accessibilityAddTraits(.isHeader)

// ✅ Add multiple traits
CustomPlayerButton()
    .accessibilityAddTraits([.isButton, .startsMediaSession])

// ✅ Remove incorrect automatic traits
NavigationLink {
    DetailView()
} label: {
    CardView()
}
.accessibilityRemoveTraits(.isButton)  // If NavigationLink shouldn't sound like a button
```

### Common Patterns

```swift
// ✅ Selected state in a list
ForEach(tabs, id: \.self) { tab in
    TabButton(tab: tab)
        .accessibilityAddTraits(tab == selectedTab ? .isSelected : [])
}

// ✅ Summary element for widget
Text("\(unreadCount) unread messages")
    .accessibilityAddTraits(.isSummaryElement)

// ✅ Frequently updating content
Text(timerDisplay)
    .accessibilityAddTraits(.updatesFrequently)
    .accessibilityLabel("Time remaining")
    .accessibilityValue(timerDisplay)
```

## Accessibility Actions

Actions define what happens when VoiceOver users activate an element.

### Default Action

The default action fires on double-tap:

```swift
// ✅ Named default action (VoiceOver says "double-tap to toggle favorite")
MovieCardView(movie: movie)
    .accessibilityAction(named: "Toggle favorite") {
        toggleFavorite(movie)
    }
```

### Named Actions

Named actions appear in VoiceOver's actions rotor (swipe up/down):

```swift
// ✅ Multiple named actions
MessageRow(message: message)
    .accessibilityAction(named: "Reply") { reply(to: message) }
    .accessibilityAction(named: "Forward") { forward(message) }
    .accessibilityAction(named: "Delete") { delete(message) }
```

### Action View Builder (iOS 16+)

Use the view builder variant for labeled actions:

```swift
MovieRow(movie: movie)
    .accessibilityActions {
        Button("Add to Watchlist") { addToWatchlist(movie) }
        Button("Share") { share(movie) }
        Button("Hide") { hide(movie) }
    }
```

### Action Categories (iOS 18+)

Organize actions into categories for cleaner presentation:

```swift
MovieRow(movie: movie)
    .accessibilityActions(category: .edit) {
        Button("Rename") { rename(movie) }
        Button("Move to Collection") { moveToCollection(movie) }
    }
```

### Standard Action Kinds

| Kind | Trigger | Use Case |
|------|---------|----------|
| `.default` | Double-tap | Primary action |
| `.escape` | Two-finger scrub (Z gesture) | Dismiss modal, go back |
| `.delete` | Three-finger swipe | Delete item |
| `.magicTap` | Two-finger double-tap | Context-specific primary action (play/pause media) |
| `.showMenu` | — | Show context menu |

```swift
// ✅ Escape to dismiss custom modal
CustomModal()
    .accessibilityAction(.escape) {
        dismiss()
    }

// ✅ Magic tap for media playback
PlayerView()
    .accessibilityAction(.magicTap) {
        togglePlayPause()
    }
```

## Adjustable Controls

For elements with incrementable/decrementable values (pickers, steppers, carousels treated as a single control):

```swift
// ✅ Custom stepper
CustomStepper(value: $quantity, range: 1...10)
    .accessibilityLabel("Quantity")
    .accessibilityValue("\(quantity)")
    .accessibilityAdjustableAction { direction in
        switch direction {
        case .increment:
            quantity = min(quantity + 1, 10)
        case .decrement:
            quantity = max(quantity - 1, 1)
        @unknown default:
            break
        }
    }
```

### Carousel Accessibility: Two Patterns

Choose between two patterns depending on whether carousel items should be individually selectable.

#### Pattern 1: Per-Item Buttons (Individually Selectable)

Use when each item is a tappable button navigating to its own destination. Each item is a separate VoiceOver stop with its own label, hint, and identifier.

```swift
// ✅ Each item is independently selectable — users can tap any item directly
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

#### Pattern 2: Adjustable Single Element

Use when the carousel is a single control (like a page indicator or image gallery) where only one item is active at a time.

> **Warning**: `.accessibilityElement()` on a container makes all children invisible to VoiceOver. Individual items cannot be selected. Do NOT use this pattern when each item should be independently tappable.

```swift
// ✅ Single-element carousel — swipe up/down to change selection
ScrollView(.horizontal) {
    // carousel content
}
.accessibilityElement()
.accessibilityLabel("Movie carousel")
.accessibilityValue("\(items[selectedIndex].title), \(selectedIndex + 1) of \(items.count)")
.accessibilityAdjustableAction { direction in
    switch direction {
    case .increment:
        selectedIndex = min(selectedIndex + 1, items.count - 1)
    case .decrement:
        selectedIndex = max(selectedIndex - 1, 0)
    @unknown default:
        break
    }
}
```

## Scroll Actions

For custom scrollable content:

```swift
CustomScrollView()
    .accessibilityScrollAction { edge in
        switch edge {
        case .top: scrollToTop()
        case .bottom: scrollToBottom()
        case .leading: scrollToPrevious()
        case .trailing: scrollToNext()
        @unknown default: break
        }
    }
```

## Gestures and Direct Touch

### Activation Point

Control where the activation tap targets:

```swift
// ✅ Large area with specific activation point
CardView()
    .accessibilityActivationPoint(.center)
```

### Drag and Drop

```swift
// ✅ Accessible drag source
DraggableItem()
    .accessibilityDragPoint(.center, description: "Drag movie")

// ✅ Accessible drop target
DropZone()
    .accessibilityDropPoint(.center, description: "Drop here to add to watchlist")
```

### Direct Touch

Bypass VoiceOver gesture handling for areas that need raw touch (piano keyboards, drawing):

```swift
// ✅ Piano key needs direct touch
PianoKey()
    .accessibilityDirectTouch(options: .silentOnTouch)
```

### Zoom Action

For views that support pinch-to-zoom:

```swift
ZoomableImageView()
    .accessibilityZoomAction { action in
        switch action.direction {
        case .zoomIn: zoomIn()
        case .zoomOut: zoomOut()
        @unknown default: break
        }
    }
```

## Accessibility Representation

### ButtonStyle Representation

When creating custom button styles, provide an accessibility representation so VoiceOver understands the control:

```swift
struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(configuration.isPressed ? Color.gray : Color.blue)
            .clipShape(.capsule)
    }

    // ✅ Provide accessibility representation
    func accessibilityRepresentation(configuration: Configuration) -> some View {
        Button(configuration)
            .buttonStyle(.bordered)
    }
}
```

### UIViewRepresentable

Bridge UIKit accessibility to SwiftUI:

```swift
struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.isAccessibilityElement = true
        map.accessibilityLabel = "Map"
        map.accessibilityTraits = .allowsDirectInteraction
        return map
    }
}
```

### Combine Converts Actions

When using `.accessibilityElement(children: .combine)`, child actions become named custom actions on the combined element:

```swift
// ✅ Child buttons become named actions on the combined element
HStack {
    Text(movie.title)
    Spacer()
    Button("Favorite") { favorite() }
    Button("Share") { share() }
}
.accessibilityElement(children: .combine)
// VoiceOver: "Movie Title. Actions available: Favorite, Share"
```

## State-Dependent Toggle Buttons

Toggle buttons that switch between two states need careful accessibility treatment. The label must communicate both the current state and what action will occur on activation.

### Pattern: Full Accessibility Toggle Button

```swift
@Environment(\.accessibilityReduceMotion) private var reduceMotion

Button(
    // ✅ State-dependent label tells VoiceOver both current state AND intended action
    item.isOnWatchlist
        ? LocalizedStringResource("REMOVE_FROM_WATCHLIST", bundle: .module)
        : LocalizedStringResource("ADD_TO_WATCHLIST", bundle: .module),
    // ✅ State-dependent icon gives sighted users visual feedback
    systemImage: item.isOnWatchlist ? "eye" : "plus"
) {
    store.send(.toggleOnWatchlist)
}
// ✅ State-dependent identifier enables UI testing of toggle state
.accessibilityIdentifier(
    item.isOnWatchlist
        ? "movie-details.watchlist-toggle.on"
        : "movie-details.watchlist-toggle.off"
)
// ✅ Smooth icon transition on state change
.contentTransition(.symbolEffect(.replace))
// ✅ Respect reduce motion — disable animation when preference is set
.animation(reduceMotion ? nil : .default, value: item.isOnWatchlist)
// ✅ Haptic confirmation for state changes
.sensoryFeedback(.selection, trigger: item.isOnWatchlist)
```

### Key Principles

1. **Label describes the action, not the state** — "Add to Watchlist" / "Remove from Watchlist" tells VoiceOver users what will happen. Avoid generic labels like "Watchlist" that don't indicate the action.
2. **State-dependent `accessibilityIdentifier`** — use suffixes like `.on` / `.off` so UI tests can assert on the current toggle state without reading the label.
3. **`.sensoryFeedback(.selection, trigger:)`** — provides haptic confirmation when the state changes, benefiting users who may not see the visual change.
4. **`.contentTransition(.symbolEffect(.replace))`** — animates the SF Symbol swap smoothly for sighted users.
5. **Respect `reduceMotion`** — pass `nil` animation when the user has enabled Reduce Motion (see Accessible Appearance > Motion Preferences).

### Common Mistakes

```swift
// ❌ Generic label — VoiceOver says "Watchlist" with no indication of action
Button("Watchlist", systemImage: "eye") { toggle() }

// ❌ No accessibilityIdentifier — UI tests can't verify toggle state
Button(label, systemImage: icon) { toggle() }

// ❌ Missing sensoryFeedback — state change has no haptic confirmation
Button(label, systemImage: icon) { toggle() }
    .contentTransition(.symbolEffect(.replace))

// ❌ Ignoring reduceMotion — animation plays regardless of preference
Button(label, systemImage: icon) { toggle() }
    .animation(.default, value: isToggled)
```

## Best Practices

1. **Use semantic controls** — `Button`, `Toggle`, `Picker`, `Slider` come with correct traits automatically
2. **Don't put `onTapGesture` on Text/Image** — use `Button` instead for correct accessibility behavior
3. **Add hints to navigation buttons** — when a button's label is an item name (movie title, person name), add a hint describing the destination (e.g., "View movie details")
4. **Choose the right carousel pattern** — use per-item buttons (Pattern 1) when items navigate to individual destinations; use adjustable (Pattern 2) only when the carousel is a single-value control
5. **Never use `.accessibilityElement()` on a container with tappable children** — it collapses all children into one opaque element, making individual items unreachable by VoiceOver
6. **Magic tap is app-wide** — the two-finger double-tap bubbles up the view hierarchy; use it for the primary media action
7. **Test named actions** — swipe up/down on an element in VoiceOver to verify all actions are discoverable
8. **Remove redundant traits** — after combining children, remove `.isButton` from the parent if the combined element shouldn't be a button
9. **Toggle buttons need action-oriented labels** — use state-dependent labels that describe the action ("Add to…" / "Remove from…"), not just the state name
10. **Add haptic feedback to toggle buttons** — use `.sensoryFeedback(.selection, trigger:)` so users feel the state change
