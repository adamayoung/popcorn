# Accessible Descriptions

Labels, values, hints, headings, custom content, input labels, and speech customization for SwiftUI views.

## Accessibility Labels

The accessibility label is the primary text VoiceOver reads for an element. Every interactive or informative element must have a meaningful label.

### String-Based Labels

```swift
// ✅ Clear, concise label describing the action
Button(action: toggleFavorite) {
    Image(systemName: isFavorite ? "heart.fill" : "heart")
}
.accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")

// ❌ Label describes appearance, not purpose
Button(action: toggleFavorite) {
    Image(systemName: "heart.fill")
}
.accessibilityLabel("Filled heart icon")
```

### Closure-Based Labels (iOS 15+)

Use when you need to build complex labels from child content:

```swift
HStack {
    Image(systemName: "star.fill")
    Text("4.5")
}
.accessibilityElement(children: .combine)
.accessibilityLabel { label in
    // 'label' contains the combined text from children
    Text("Rating: \(label)")
}
```

### Conditional Labels with `isEnabled:`

Provide context-sensitive labels that change based on state:

```swift
Image(systemName: "play.fill")
    .accessibilityLabel("Play")
    .accessibilityLabel(isEnabled: isLive) {
        Text("Play live stream")
    }
```

### Built-In Label Behavior

SwiftUI provides automatic labels for many views:

```swift
// ✅ Label() provides both visual text and accessibility label
Label("Settings", systemImage: "gear")

// ✅ Button with text content gets automatic label
Button("Delete") { /* ... */ }

// ✅ Toggle with text
Toggle("Dark Mode", isOn: $isDarkMode)

// ⚠️ Image-only button has NO automatic label — you must add one
Button(action: { /* ... */ }) {
    Image(systemName: "trash")
}
.accessibilityLabel("Delete")
```

### Localization

Accessibility labels inherit the app's localization. Use `LocalizedStringKey` or `String(localized:)`:

```swift
Image(systemName: "magnifyingglass")
    .accessibilityLabel(Text("Search", comment: "Accessibility label for search button"))
```

## Decorative Images

Decorative images must be hidden from assistive technologies to avoid noise.

```swift
// ✅ Image(decorative:) — excluded from accessibility tree
Image(decorative: "background-pattern")

// ✅ Explicitly hidden
Image("divider-line")
    .accessibilityHidden(true)

// ✅ System images used decoratively
Image(systemName: "circle.fill")
    .accessibilityHidden(true)

// ❌ Decorative image without hiding — VoiceOver reads filename
Image("background-pattern")
```

## Accessibility Values

Values represent the current state of an element (e.g., a slider's position, toggle state).

```swift
// ✅ Value communicates current state
StarRatingView(rating: 3, maxRating: 5)
    .accessibilityLabel("Rating")
    .accessibilityValue("\(rating) out of \(maxRating) stars")

// ✅ Progress indicator
ProgressView(value: progress)
    .accessibilityLabel("Download progress")
    .accessibilityValue("\(Int(progress * 100)) percent")
```

## Accessibility Hints

Hints describe the result of performing an action. They are optional — VoiceOver reads them after a short delay, and users can disable them.

```swift
// ✅ Hint describes result of action
Button("Add to Cart") { /* ... */ }
    .accessibilityHint("Adds this item to your shopping cart")

// ❌ Hint repeats the label
Button("Add to Cart") { /* ... */ }
    .accessibilityHint("Tap to add to cart")  // Redundant — VoiceOver already says "double-tap to activate"

// ❌ Hint includes gesture instruction
Button("Play") { /* ... */ }
    .accessibilityHint("Double-tap to play the video")  // VoiceOver provides gesture instructions
```

> **Best practice**: Begin hints with a verb and describe the result, not the gesture. "Opens the settings screen" not "Double-tap to open settings."

### When to Add Hints

Hints are most valuable when the label alone doesn't convey what will happen on activation:

```swift
// ✅ Navigation buttons in carousels/lists — label is the item name, hint clarifies the action
Button {
    navigateToMovie(movie.id)
} label: {
    MovieCard(movie: movie)
}
.accessibilityLabel(movie.title)
.accessibilityHint(Text("VIEW_MOVIE_DETAILS_HINT", bundle: .module))

// ✅ Buttons whose label is a person/place/thing name — hint explains the navigation
Button {
    navigateToPerson(person.id)
} label: {
    PersonCard(person: person)
}
.accessibilityLabel(person.name)
.accessibilityHint("View person details")

// ✅ Buttons with ambiguous outcomes
Button("Submit") { /* ... */ }
    .accessibilityHint("Sends your review for approval")
```

**Skip hints when the label already makes the action obvious:**

```swift
// ✅ No hint needed — "Delete message" is self-explanatory
Button("Delete message") { /* ... */ }

// ✅ No hint needed — "Play trailer" is clear
Button("Play trailer") { /* ... */ }
```

## Input Labels

Input labels provide alternative labels for Voice Control. Users can say any of these to activate the element:

```swift
Button(action: search) {
    Image(systemName: "magnifyingglass")
}
.accessibilityLabel("Search")
.accessibilityInputLabels(["Search", "Find", "Look up"])
```

Voice Control users can say "Tap Search", "Tap Find", or "Tap Look up" to activate the button. The first label is the primary one; order by decreasing specificity.

## Headings

Headings enable VoiceOver users to navigate between sections using the rotor.

### isHeader Trait

```swift
Text("Popular Movies")
    .font(.title2)
    .accessibilityAddTraits(.isHeader)
```

### Heading Levels (iOS 15+)

Use heading levels for hierarchical navigation:

```swift
Text("Movies")
    .accessibilityHeading(.h1)

Text("Now Playing")
    .accessibilityHeading(.h2)

Text("Action")
    .accessibilityHeading(.h3)
```

> **Best practice**: Use heading levels consistently. Don't skip levels (e.g., `.h1` to `.h3` without `.h2`). VoiceOver users rely on heading levels to understand page structure.

## Custom Content

Custom content delivers supplementary information on demand. VoiceOver reads primary info first; users swipe vertically to access custom content.

### Basic Custom Content

```swift
MovieCardView(movie: movie)
    .accessibilityCustomContent("Genre", movie.genre)
    .accessibilityCustomContent("Release Date", movie.releaseDate, formatted: Date.FormatStyle(date: .abbreviated))
    .accessibilityCustomContent("Rating", "\(movie.rating) out of 10")
```

### Importance Levels

```swift
MovieCardView(movie: movie)
    // .high — always announced with the element
    .accessibilityCustomContent("Director", movie.director, importance: .high)
    // .default — available on demand via vertical swipe
    .accessibilityCustomContent("Runtime", movie.runtime, importance: .default)
```

### Custom Content Keys

Define reusable keys for consistent labeling across your app:

```swift
extension AccessibilityCustomContentKey {
    static let genre = AccessibilityCustomContentKey("Genre")
    static let director = AccessibilityCustomContentKey("Director")
}

// Usage
MovieCardView(movie: movie)
    .accessibilityCustomContent(.genre, movie.genre)
    .accessibilityCustomContent(.director, movie.director, importance: .high)
```

## Text Content Type

Tells assistive technologies how to interpret the text content:

```swift
// Messaging apps — enables message-specific VoiceOver behavior
Text(message.body)
    .accessibilityTextContentType(.messaging)

// Code editors
Text(code)
    .accessibilityTextContentType(.sourceCode)

// Document editors
Text(document.content)
    .accessibilityTextContentType(.wordProcessing)

// Long-form reading
Text(article.body)
    .accessibilityTextContentType(.narrative)
```

## Speech Customization

Control how VoiceOver pronounces content using `AttributedString` speech attributes.

### Pitch

```swift
var greeting = AttributedString("Welcome!")
greeting.accessibilitySpeechAdjustedPitch = 1.2  // Higher pitch
Text(greeting)
```

### Spell Out

```swift
var code = AttributedString("ABC123")
greeting.accessibilitySpeechSpellsOutCharacters = true
Text(code)
```

### Phonetic Pronunciation

```swift
var name = AttributedString("Hermione")
name.accessibilitySpeechPhoneticNotation = "her-MY-oh-nee"
Text(name)
```

### Punctuation

```swift
var path = AttributedString("/usr/local/bin")
path.accessibilitySpeechIncludesPunctuation = true
Text(path)  // VoiceOver reads "slash usr slash local slash bin"
```

### Queuing

Control whether new announcements interrupt or queue after the current one:

```swift
var announcement = AttributedString("New message received")
announcement.accessibilitySpeechQueueAnnouncement = true  // Queue, don't interrupt
Text(announcement)
```

## Best Practices

1. **Labels should be concise** — "Play" not "This button plays the video"
2. **Labels describe purpose, not appearance** — "Close" not "X button"
3. **Labels should not include the element type** — "Delete" not "Delete button" (VoiceOver adds the type)
4. **Values are for dynamic state** — use labels for identity, values for current state
5. **Hints are optional** — only add them when the action's result isn't obvious from the label
6. **Test with VoiceOver** — listen to how labels are read in context; adjust for clarity
7. **Localize all labels** — accessibility strings must be localized like any other user-facing text
