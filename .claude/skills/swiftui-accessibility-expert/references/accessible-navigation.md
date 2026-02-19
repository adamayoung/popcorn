# Accessible Navigation

Sort priority, rotors, linked groups, focus management, notifications, and chart accessibility.

## Sort Priority

Control the order in which VoiceOver navigates elements. Higher values are visited first.

```swift
// ✅ Ensure title is read before metadata
HStack {
    MetadataView()
        .accessibilitySortPriority(0)

    Spacer()

    TitleView()
        .accessibilitySortPriority(1)  // Read first despite being trailing
}
```

### Column-Wise Navigation

For multi-column layouts, combine sort priority with `.contain` to navigate column by column:

```swift
HStack {
    VStack {
        Text("Title A")
        Text("Subtitle A")
    }
    .accessibilityElement(children: .contain)
    .accessibilitySortPriority(2)

    VStack {
        Text("Title B")
        Text("Subtitle B")
    }
    .accessibilityElement(children: .contain)
    .accessibilitySortPriority(1)
}
// VoiceOver order: Title A → Subtitle A → Title B → Subtitle B
```

> **Note**: Without sort priority and `.contain`, VoiceOver might read left-to-right per row: "Title A, Title B, Subtitle A, Subtitle B."

## Rotors

Rotors let VoiceOver users filter and navigate through specific types of content.

### Custom Rotors

Create rotors for filtered navigation within a list:

```swift
struct MovieListView: View {
    let movies: [Movie]

    var body: some View {
        List(movies) { movie in
            MovieRow(movie: movie)
        }
        .accessibilityRotor("Favorites") {
            ForEach(movies.filter(\.isFavorite)) { movie in
                AccessibilityRotorEntry(movie.title, id: movie.id)
            }
        }
        .accessibilityRotor("Unwatched") {
            ForEach(movies.filter { !$0.isWatched }) { movie in
                AccessibilityRotorEntry(movie.title, id: movie.id)
            }
        }
    }
}
```

### Rotor Entry with Namespace

For entries that need to target specific views:

```swift
struct ContentView: View {
    @Namespace private var namespace
    let items: [Item]

    var body: some View {
        VStack {
            ForEach(items) { item in
                ItemRow(item: item)
                    .accessibilityRotorEntry(id: item.id, in: namespace)
            }
        }
        .accessibilityRotor("Flagged Items", entries: items.filter(\.isFlagged), entryID: \.id, in: namespace)
    }
}
```

### System Rotors

SwiftUI supports standard system rotors that VoiceOver users expect:

- **Headings** — navigates elements with `.isHeader` trait or `.h1`–`.h6` heading levels
- **Links** — navigates elements with `.isLink` trait
- **Text Fields** — navigates text input fields
- **Images** — navigates elements with `.isImage` trait
- **Landmarks** — navigates `NavigationSplitView` sidebars, `TabView`
- **Lists** — navigates `List` views
- **Tables** — navigates `Table` views

> **Best practice**: Use semantic traits (`.isHeader`, `.isLink`) and standard SwiftUI views to populate system rotors automatically.

## Linked Groups

Link accessibility elements across separate views with a shared namespace:

```swift
struct FormRow: View {
    @Namespace private var linkNamespace

    var body: some View {
        HStack {
            Text("Email")
                .accessibilityLinkedGroup(id: "email", in: linkNamespace)

            Spacer()

            TextField("Enter email", text: $email)
                .accessibilityLinkedGroup(id: "email", in: linkNamespace)
        }
    }
}
```

Linked groups tell VoiceOver that these elements are semantically related, improving navigation between label-field pairs.

## Focus Management

### AccessibilityFocusState

Move VoiceOver focus programmatically in response to state changes:

```swift
struct SearchView: View {
    @AccessibilityFocusState private var isSearchFocused: Bool
    @State private var searchResults: [Result] = []

    var body: some View {
        VStack {
            TextField("Search", text: $query)

            if searchResults.isEmpty {
                Text("No results found")
                    .accessibilityFocused($isSearchFocused)
            } else {
                ResultsListView(results: searchResults)
            }
        }
        .onChange(of: searchResults) {
            if searchResults.isEmpty {
                isSearchFocused = true  // Move VoiceOver focus to "No results"
            }
        }
    }
}
```

### Enum-Based Focus

Track focus across multiple elements:

```swift
enum FormField: Hashable {
    case name, email, password
}

struct FormView: View {
    @AccessibilityFocusState private var focusedField: FormField?

    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .accessibilityFocused($focusedField, equals: .name)
            TextField("Email", text: $email)
                .accessibilityFocused($focusedField, equals: .email)
            SecureField("Password", text: $password)
                .accessibilityFocused($focusedField, equals: .password)
        }
    }

    func validateAndAdvance() {
        if name.isEmpty {
            focusedField = .name
        } else if email.isEmpty {
            focusedField = .email
        }
    }
}
```

### Technology-Specific Focus

Target focus changes to specific assistive technologies:

```swift
// ✅ Only move focus for VoiceOver users
@AccessibilityFocusState(for: .voiceOver)
private var isAlertFocused: Bool

// ✅ Only move focus for Switch Control users
@AccessibilityFocusState(for: .switchControl)
private var isSwitchFocused: Bool
```

## Notifications

Post accessibility notifications to inform assistive technologies of changes (iOS 17+).

### Announcement

Announce dynamic content changes:

```swift
// ✅ Announce result of an action
func addToWatchlist() {
    watchlist.append(movie)
    AccessibilityNotification.Announcement("Added to watchlist")
        .post()
}
```

### Announcement Priority (iOS 17+)

Control whether announcements interrupt or queue:

```swift
// High priority — interrupts current speech
AccessibilityNotification.Announcement("Error: Network unavailable")
    .post(priority: .high)

// Default priority — queued after current speech
AccessibilityNotification.Announcement("Download complete")
    .post()
```

### Layout Changed

Notify when the layout changes but the screen hasn't changed (e.g., new content appeared):

```swift
func showBanner() {
    isBannerVisible = true
    // Move focus to the new banner
    AccessibilityNotification.LayoutChanged(bannerElement)
        .post()
}
```

### Screen Changed

Notify when the entire screen content has changed:

```swift
func navigateToNewContent() {
    currentPage = .detail
    AccessibilityNotification.ScreenChanged(detailView)
        .post()
}
```

### Page Scrolled

Notify VoiceOver of page scroll events with descriptive text:

```swift
func scrollToNextPage() {
    currentPage += 1
    AccessibilityNotification.PageScrolled("Page \(currentPage) of \(totalPages)")
        .post()
}
```

## Chart Accessibility

Make Swift Charts accessible with descriptive chart summaries:

```swift
struct SalesChart: View {
    let data: [SalesData]

    var body: some View {
        Chart(data) { item in
            BarMark(
                x: .value("Month", item.month),
                y: .value("Sales", item.sales)
            )
        }
        .accessibilityChartDescriptor(SalesChartDescriptor(data: data))
    }
}

struct SalesChartDescriptor: AXChartDescriptorRepresentable {
    let data: [SalesData]

    func makeChartDescriptor() -> AXChartDescriptor {
        let xAxis = AXCategoricalDataAxisDescriptor(
            title: "Month",
            categoryOrder: data.map(\.month)
        )
        let yAxis = AXNumericDataAxisDescriptor(
            title: "Sales",
            range: 0...Double(data.map(\.sales).max() ?? 0),
            gridlinePositions: []
        ) { value in "\(Int(value)) units" }

        return AXChartDescriptor(
            title: "Monthly Sales",
            summary: "Sales data from January to December",
            xAxis: xAxis,
            yAxis: yAxis,
            series: [
                AXDataSeriesDescriptor(
                    name: "Sales",
                    isContinuous: false,
                    dataPoints: data.map {
                        .init(x: $0.month, y: Double($0.sales))
                    }
                )
            ]
        )
    }
}
```

VoiceOver users can navigate chart data points individually and hear the audio graph representation.

## Best Practices

1. **Use sort priority sparingly** — let natural layout order work when possible; only override when visual and logical order differ
2. **Create custom rotors for long lists** — helps users quickly filter to content they care about
3. **Move focus to new content** — when something appears (alert, error, new section), programmatically move VoiceOver focus there
4. **Announce results of actions** — "Added to watchlist", "Item deleted", "3 results found"
5. **Use appropriate notification type** — `LayoutChanged` for partial updates, `ScreenChanged` for full navigation changes, `Announcement` for status updates
6. **Don't spam announcements** — batch rapid updates; use `updatesFrequently` trait for live content instead of repeated announcements
7. **Test rotor navigation** — rotate with two fingers on screen to access rotors; verify custom rotors appear and navigate correctly
