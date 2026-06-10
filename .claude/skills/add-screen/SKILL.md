---
name: add-screen
description: Add a screen to an existing feature
---

# Add a Screen to an Existing Tab

Guide for adding a new screen/view to an existing tab with MVVM navigation.

In MVVM, navigation is owned by the App layer: each tab has a `Router`
(`@Observable @MainActor`) holding a typed `Route` enum stack bound to a
`NavigationStack(path:)`, plus a `RouterNavigator` value type that implements every
leaf feature's `Navigating` protocol by mutating the router. A view model never
pushes screens itself — it calls a method on its injected navigator.

Use `App/Features/ExploreRoot/{ExploreRouter.swift, Views/ExploreRootView.swift}`
and `App/Composition/ViewModelFactory.swift` as the canonical reference.

## Required Information

Ask the user for:
- **Tab / parent root** (e.g., ExploreRoot, WatchlistRoot)
- **New screen name** (e.g., MovieCredits, PersonFilmography)
- **Navigation trigger** (which view model action leads to this screen)

## Steps

### 1. Create the New Feature

If the screen needs its own feature module, build it following the `add-feature`
workflow: a `{ScreenName}ViewModel` (`@Observable @MainActor` exposing
`ViewState<ViewSnapshot>`), a `{ScreenName}Dependencies` struct with
`live(services:)`, a `{ScreenName}Navigating` protocol, and a `{ScreenName}View`
owning the view model via `@State`.

### 2. Add a Factory Method

In `App/Composition/ViewModelFactory.swift`, add a `make{ScreenName}` method that
wires the feature's `Dependencies.live(services:)` to a navigator:

```swift
func make{ScreenName}(
    id: Int,
    navigator: some {ScreenName}Navigating
) -> {ScreenName}ViewModel {
    {ScreenName}ViewModel(
        id: id,
        dependencies: .live(services: services),
        navigator: navigator
    )
}
```

### 3. Add a Route Case

In the tab's router file, add a case to the `Route` enum. The enum is `Hashable`
and carries the values needed to build the destination view model:

```swift
enum {Tab}Route: Hashable {
    case existingScreen(id: Int)
    case {screenName}(id: Int)  // Add this
}
```

### 4. Add the Navigator Method

The source feature's view model calls a method on its `Navigating` protocol. Add
that requirement to the protocol if it doesn't exist:

```swift
@MainActor
public protocol {SourceFeature}Navigating {
    func open{ScreenName}(id: Int)  // Add this
}
```

Then implement it in the tab's `RouterNavigator` by appending the new route:

```swift
@MainActor
struct {Tab}RouterNavigator: {SourceFeature}Navigating /* , ... */ {
    let router: {Tab}Router

    func open{ScreenName}(id: Int) {
        router.path.append(.{screenName}(id: id))
    }
}
```

And call it from the source view model:

```swift
public func selectSomeItem(id: Int) {
    navigator.open{ScreenName}(id: id)
}
```

### 5. Wire the Destination in the NavigationStack

In the tab's root view, the `NavigationStack(path:)` is bound to `$router.path`.
Add the new case to the `navigationDestination` switch, building the view model
through the factory and a navigator bound to this router:

```swift
NavigationStack(path: $router.path) {
    {Tab}View(viewModel: {tab}ViewModel)
        .navigationDestination(for: {Tab}Route.self) { route in
            destination(route)
        }
}

@ViewBuilder
private func destination(_ route: {Tab}Route) -> some View {
    switch route {
    case .existingScreen(let id):
        ExistingView(viewModel: factory.makeExisting(id: id, navigator: navigator))
    case .{screenName}(let id):
        {ScreenName}View(viewModel: factory.make{ScreenName}(id: id, navigator: navigator))  // Add this
    }
}

private var navigator: {Tab}RouterNavigator {
    {Tab}RouterNavigator(router: router)
}
```

For a modal instead of a push, add an `@Observable` presentation item property to
the router (e.g. `presented{ScreenName}: Presented{ScreenName}?`), have the
navigator method set it, and present it with `.sheet(item:)` /
`.fullScreenCover(item:)` in the root view.

Use SCREAMING_SNAKE_CASE keys for all user-facing strings. Build first, then add
English values in `Localizable.xcstrings` — see [SWIFTUI.md § Localization](docs/SWIFTUI.md).

### 6. Update Tests

- Add a spy implementing the source feature's `Navigating` protocol and assert the
  new method fires when the triggering view-model action runs.
- Add view-model and snapshot tests for the new screen following `add-feature`.

$ARGUMENTS
