# Accessible Grouping

Accessibility children behavior, combining and containing, conditional grouping, hidden elements, modal views, labeled pairs, and synthetic children.

## Accessibility Children Behavior

`accessibilityElement(children:)` controls how a view's children appear in the accessibility tree.

### .combine

Merges all children into a single accessibility element. Labels are concatenated; child actions become named custom actions.

```swift
// ✅ Card becomes one VoiceOver stop
HStack {
    AsyncImage(url: movie.posterURL)
    VStack(alignment: .leading) {
        Text(movie.title)
        Text(movie.year)
            .foregroundStyle(.secondary)
    }
    Spacer()
    Image(systemName: "chevron.right")
}
.accessibilityElement(children: .combine)
// VoiceOver reads: "Movie poster, Inception, 2010"
```

### .contain

Keeps children as individual elements but groups them logically. VoiceOver navigates through children within the container.

```swift
// ✅ Each item in the section is individually navigable
VStack(alignment: .leading) {
    Text("Cast")
        .accessibilityAddTraits(.isHeader)
    ForEach(cast) { person in
        CastRow(person: person)
    }
}
.accessibilityElement(children: .contain)
```

### .ignore (Default)

Removes all children from the accessibility tree. The parent becomes the sole element.

```swift
// ✅ Custom element with manual label (children ignored)
CustomGraphView()
    .accessibilityElement()  // children: .ignore is the default
    .accessibilityLabel("Revenue trend, increasing 15% this quarter")
```

### Decision Guide: When to Use Each

| Scenario | Children Behavior | Rationale |
|----------|------------------|-----------|
| Card with title, subtitle, image | `.combine` | One logical item, reduce VoiceOver stops |
| List row with action buttons | `.combine` | Actions become named custom actions |
| Form section with multiple fields | `.contain` | Each field needs individual interaction |
| Multi-column layout | `.contain` with sort priority | Navigate column-by-column |
| Custom drawing / Canvas | `.ignore` with manual label | No meaningful child structure |
| Navigation section with header | `.contain` | Header and items individually navigable |

## Conditional Grouping

Switch between grouping strategies based on state:

```swift
struct MovieRow: View {
    @Binding var isEditing: Bool
    let movie: Movie

    var body: some View {
        HStack {
            if isEditing {
                Button("Delete") { delete(movie) }
            }
            Text(movie.title)
            Text(movie.year)
        }
        // ✅ Combine when browsing, contain when editing (so delete button is reachable)
        .accessibilityElement(children: isEditing ? .contain : .combine)
    }
}
```

## Trait Cleanup After Combine

When combining children that include buttons, the combined element may inherit the `.isButton` trait. Remove it if the combined element isn't a button:

```swift
HStack {
    Text(movie.title)
    Spacer()
    Button("Favorite") { toggleFavorite() }
    Button("Share") { share() }
}
.accessibilityElement(children: .combine)
.accessibilityRemoveTraits(.isButton)  // ✅ Combined element is not itself a button
// Actions "Favorite" and "Share" remain accessible via swipe up/down
```

## Content Shape for Accessibility

Define custom hit-testing areas for accessibility:

```swift
// ✅ Expand the accessible touch area beyond visible bounds
SmallButton()
    .contentShape(.accessibility, Circle().inset(by: -20))

// ✅ Different shapes for visual and accessibility hit testing
AnnotationDot()
    .contentShape(.interaction, Circle())  // Visual taps
    .contentShape(.accessibility, Circle().inset(by: -15))  // Larger area for VoiceOver
```

## Labeled Pairs

Connect a label view with its associated control using `accessibilityLabeledPair`:

```swift
struct SettingsRow: View {
    @Namespace private var pairNamespace

    var body: some View {
        HStack {
            Text("Volume")
                .accessibilityLabeledPair(role: .label, id: "volume", in: pairNamespace)

            Slider(value: $volume)
                .accessibilityLabeledPair(role: .content, id: "volume", in: pairNamespace)
        }
    }
}
```

This tells VoiceOver that "Volume" is the label for the slider, allowing the user to hear "Volume, 50%, adjustable" when focused on the slider.

## Hidden Elements

### accessibilityHidden

Remove an element from the accessibility tree entirely:

```swift
// ✅ Hide decorative separators
Divider()
    .accessibilityHidden(true)

// ✅ Hide redundant information already conveyed elsewhere
Image(systemName: "star.fill")
    .accessibilityHidden(true)  // Rating value is already in the text

// ✅ Hide background decorations
BackgroundPatternView()
    .accessibilityHidden(true)
```

### Opacity and Accessibility

Views with `opacity(0)` are automatically hidden from accessibility. Use this when you need an invisible element that also shouldn't be accessible:

```swift
// ✅ Invisible AND hidden from accessibility
PlaceholderView()
    .opacity(0)

// ⚠️ If you need invisible but still accessible, use .hidden with accessibility override
PlaceholderView()
    .opacity(0)
    .accessibilityElement()
    .accessibilityLabel("Hidden content placeholder")
```

## Modal Views

The `.isModal` trait prevents VoiceOver from navigating to elements behind the modal:

```swift
// ✅ Trap VoiceOver focus within modal overlay
struct CustomAlertView: View {
    var body: some View {
        VStack {
            Text("Delete this item?")
            HStack {
                Button("Cancel") { dismiss() }
                Button("Delete") { deleteItem() }
            }
        }
        .accessibilityAddTraits(.isModal)
    }
}
```

> **Note**: SwiftUI's built-in `.sheet`, `.alert`, and `.fullScreenCover` automatically apply modal behavior. Only use `.isModal` for custom overlay implementations.

## Synthetic Children

For views without a natural view hierarchy (Canvas, custom drawing), create synthetic accessibility children:

```swift
struct CustomChartView: View {
    let dataPoints: [DataPoint]

    var body: some View {
        Canvas { context, size in
            // Custom drawing code
        }
        .accessibilityChildren {
            // ✅ Create virtual accessibility elements for each data point
            ForEach(dataPoints) { point in
                Text("\(point.label): \(point.value)")
                    .accessibilityLabel("\(point.label)")
                    .accessibilityValue("\(point.value)")
            }
        }
    }
}
```

This creates an accessibility subtree that doesn't correspond to any visible views, allowing VoiceOver to navigate through the data points even though they're drawn on a Canvas.

## Grouping Patterns

### Card Pattern

```swift
// ✅ Combine a card into one VoiceOver stop
struct MovieCard: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: movie.posterURL)
            Text(movie.title)
                .font(.headline)
            Text(movie.genre)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)  // If tappable
    }
}
```

### List Row with Actions

```swift
// ✅ Row with swipe actions — combine so actions become named custom actions
struct MovieListRow: View {
    let movie: Movie

    var body: some View {
        HStack {
            Text(movie.title)
            Spacer()
            Text(movie.rating)
        }
        .accessibilityElement(children: .combine)
        .accessibilityActions {
            Button("Add to Watchlist") { addToWatchlist() }
            Button("Share") { share() }
        }
    }
}
```

### Section with Header

```swift
// ✅ Contain so header and items are individually navigable
VStack(alignment: .leading) {
    Text("Trending")
        .font(.title2)
        .accessibilityAddTraits(.isHeader)

    ScrollView(.horizontal) {
        LazyHStack {
            ForEach(trendingMovies) { movie in
                MovieCard(movie: movie)
            }
        }
    }
}
.accessibilityElement(children: .contain)
```

## Best Practices

1. **Reduce VoiceOver stops** — combine related elements (title + subtitle + image) into one stop
2. **Don't over-combine** — if elements need individual interaction (buttons, fields), use `.contain`
3. **Clean up traits after combine** — remove `.isButton` from combined elements that aren't buttons
4. **Use conditional grouping** — switch between `.combine` and `.contain` based on editing/selection state
5. **Hide decorative elements** — dividers, background images, redundant icons
6. **Test VoiceOver navigation count** — swipe through a screen and count stops; aim for the minimum needed to convey all information
7. **Use Canvas children** — always provide `accessibilityChildren` for Canvas or custom-drawn content
