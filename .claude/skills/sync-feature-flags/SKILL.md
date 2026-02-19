---
name: sync-feature-flags
description: Sync feature flags from Statsig gates to code
---

# Sync Feature Flags

Syncs Statsig feature gates (source of truth) to `FeatureFlag.swift` in code. Handles adding new flags, updating changed names/descriptions, and removing deleted flags with full cascading cleanup.

## Key Files

| File | Role |
|------|------|
| `Platform/FeatureAccess/Sources/FeatureAccess/Models/FeatureFlag.swift` | Static flag definitions + `allFlags` array |
| `Platform/FeatureAccess/Tests/FeatureAccessTests/FeatureFlagTests.swift` | Count assertion + ID arguments list |
| `Features/*/Sources/*/*.swift` | Client, Feature, and View files that consume flags |
| `Features/*/Tests/*/*.swift` | Feature flag tests (`*FeatureFlagsTests.swift`, `*ClientTests.swift`) |
| `Adapters/Contexts/*/Sources/*/*.swift` | Adapter `FeatureFlagProvider` implementations |
| `Adapters/Contexts/*/Tests/*/*.swift` | Adapter provider tests |
| `App/Features/AppRoot/AppRootClient.swift` | Root client with navigation-level flags |
| `App/Features/AppRoot/AppRootFeature.swift` | Root reducer reading navigation-level flags |

## Naming Convention

Statsig gate IDs use `snake_case`. Swift properties use `camelCase`.

| Statsig Gate ID | Swift Property | Swift Name |
|-----------------|---------------|------------|
| `media_search` | `.mediaSearch` | `"Media Search"` |
| `explore_discover_movies` | `.exploreDiscoverMovies` | `"Explore Discover Movies"` |
| `plot_remix_game` | `.plotRemixGame` | `"Plot Remix Game"` |
| `tv_series_intelligence` | `.tvSeriesIntelligence` | `"TV Series Intelligence"` |

Conversion rules:
- Split on `_`, capitalize each word after the first → camelCase property name
- Split on `_`, capitalize each word → Title Case name
- Single words stay as-is (e.g., `explore` → `.explore`, `"Explore"`)

## Steps

### Step 1: Check Statsig MCP Availability

Verify the Statsig MCP server is available by checking for `mcp__statsig__Get_List_of_Gates` in the tool list. If unavailable, tell the user:

> "The Statsig MCP server is not available. Please configure it and try again."

Stop here if unavailable.

### Step 2: Fetch All Gates from Statsig

Call `mcp__statsig__Get_List_of_Gates` to retrieve all feature gates. Extract `id`, `name`, and `description` from each gate.

### Step 3: Read Current Code Flags

Read `Platform/FeatureAccess/Sources/FeatureAccess/Models/FeatureFlag.swift` and parse:
- Each `static let` property: extract `id`, `name`, `description`
- The `allFlags` array entries

### Step 4: Compute Diff

Match gates to code flags by `id`. Categorize into three groups:

| Category | Condition |
|----------|-----------|
| **New** | Gate ID exists in Statsig but not in code |
| **Updated** | Gate ID exists in both but `name` or `description` differ |
| **Removed** | Flag ID exists in code but not in Statsig |

### Step 5: Report Diff

Present the diff to the user before making any changes:

```
Feature Flag Sync Report:

New (3):
  + media_search_v2 — "Media Search V2" — "Controls access to Media Search V2"
  + cast_details — "Cast Details" — "Controls access to Cast Details"
  + ...

Updated (1):
  ~ explore — name: "Explore" → "Explore Tab"

Removed (1):
  - backdrop_focal_point — "Backdrop Focal Point"

Proceed with sync?
```

If all three categories are empty, report "Feature flags are already in sync." and stop.

### Step 6: Apply Additions and Updates

For **new flags**, add to `FeatureFlag.swift`:

1. Add a `static let` property at the end of the last extension (before the closing `}`):

```swift
/// Controls access to <name>.
static let <camelCaseProperty> = FeatureFlag(
    id: "<snake_case_id>",
    name: "<Name from Statsig>",
    description: "<Description from Statsig>"
)
```

2. Add `.<camelCaseProperty>` to the `allFlags` array

**Empty Statsig descriptions**: If a gate has no description, generate one: `"Controls access to <name>"`

For **updated flags**, edit the existing `static let` to match the new `name` and/or `description` from Statsig. Also update the doc comment if the description changed.

### Step 7: Handle Removals (User Confirmation Required)

For each removed flag, perform a full impact search before asking for confirmation.

#### 7a: Search for All Usage Sites

For a flag named `.myFlag` with ID `my_flag`, search for:

```
# Direct flag references
rg "\.myFlag" -- find .myFlag references in code
rg "isMyFlagEnabled" -- find Client/State/View properties
rg "my_flag" -- find ID string references in tests
```

#### 7b: Present Impact List

Show the user every file and usage that will be affected:

```
Removing flag: .myFlag ("my_flag")

Affected files:
  Client:   Features/SomeFeature/Sources/.../SomeClient.swift
            - var isMyFlagEnabled: @Sendable () throws -> Bool
            - liveValue: isMyFlagEnabled closure
            - previewValue: isMyFlagEnabled closure
  Reducer:  Features/SomeFeature/Sources/.../SomeFeature.swift
            - State.isMyFlagEnabled property
            - State.init parameter
            - .updateFeatureFlags case
  View:     Features/SomeFeature/Sources/.../SomeView.swift
            - if store.isMyFlagEnabled { ... }
  Tests:    Features/SomeFeature/Tests/.../SomeFeatureFeatureFlagsTests.swift
            - All test methods referencing isMyFlagEnabled
  Adapter:  Adapters/.../FeatureFlagProvider.swift (if applicable)
            - isMyFlagEnabled() method

Confirm removal of .myFlag? (y/n)
```

#### 7c: Cascading Cleanup

When the user confirms removal of a flag, remove in this order:

1. **FeatureFlag.swift**: Remove `static let` property and `allFlags` entry
2. **Client** (`*Client.swift`):
   - Remove `var is<Flag>Enabled` property from the struct
   - Remove the closure from `liveValue`
   - Remove the closure from `previewValue`
   - If this was the last flag in the Client, also remove the `@Dependency(\.featureFlags) var featureFlags` line
3. **Reducer** (`*Feature.swift`):
   - Remove `State.is<Flag>Enabled` property and its init parameter
   - Remove the line from `.updateFeatureFlags` case
   - Remove any `guard state.is<Flag>Enabled` checks and their associated logic
4. **View** (`*View.swift`):
   - Remove `if store.is<Flag>Enabled { ... }` conditionals
   - Keep the content inside the conditional if it should always show, or remove it entirely if the feature is being deleted
5. **Tests** (`*FeatureFlagsTests.swift`, `*ClientTests.swift`):
   - Remove/update all test methods that reference the flag
   - Update "all flags enabled/disabled" tests to remove the flag
   - Update partial enablement tests
6. **Adapter** (if applicable):
   - Remove method from `FeatureFlagProvider`
   - Remove method from domain `FeatureFlagProviding` protocol
   - Remove adapter tests

### Step 8: Update FeatureFlagTests

After all additions, updates, and removals:

1. Update the count assertion:
```swift
#expect(FeatureFlag.allFlags.count == <new_count>)
```

2. Update the ID arguments list to match the current `allFlags` array — same order, same IDs.

### Step 9: Report Summary

After all changes are applied, present a summary:

```
Feature Flag Sync Complete:
  Added: 3 flags
  Updated: 1 flag
  Removed: 1 flag

Files modified:
  - Platform/FeatureAccess/Sources/FeatureAccess/Models/FeatureFlag.swift
  - Platform/FeatureAccess/Tests/FeatureAccessTests/FeatureFlagTests.swift
  - ... (list other modified files)
```

### Step 10: Remind User to Verify

After all changes:

> Remember to run the pre-PR checklist: `/format`, `/lint`, `/build`, `/test`

Do NOT run these automatically — let the user invoke them.

## Usage Patterns Reference

### Client Pattern

```swift
// In @DependencyClient struct:
var is<Flag>Enabled: @Sendable () throws -> Bool

// In liveValue:
is<Flag>Enabled: {
    featureFlags.isEnabled(.<flagProperty>)
}

// In previewValue:
is<Flag>Enabled: { true }
```

### Reducer Pattern

```swift
// State:
var is<Flag>Enabled: Bool  // default false in init

// Action:
case updateFeatureFlags

// Reduce:
case .updateFeatureFlags:
    state.is<Flag>Enabled = (try? client.is<Flag>Enabled()) ?? false
    return .none
```

### View Pattern

```swift
if store.is<Flag>Enabled {
    // Conditional UI
}
```

### Feature Flags Test Pattern

Four required test cases per feature:
1. All flags **enabled** — all client closures return `true`
2. All flags **disabled** — all client closures return `false`
3. Client **throws** — all closures throw, flags default to `false`
4. **Partial** enablement — one flag per test case, only that flag `true`

### Adapter Pattern (context-level flags only)

```swift
// Domain protocol:
public protocol FeatureFlagProviding: Sendable {
    func is<Flag>Enabled() throws(FeatureFlagProviderError) -> Bool
}

// Adapter:
func is<Flag>Enabled() throws(FeatureFlagProviderError) -> Bool {
    featureFlags.isEnabled(.<flagProperty>)
}
```

## Search Patterns for Flag Usage

To find all usage of a flag with property name `myFlag` and ID `my_flag`:

```bash
# Static property references (Client liveValue, Adapter providers)
rg "\.myFlag\b"

# Client/State/View property references
rg "isMyFlagEnabled"

# String ID references (tests, FeatureFlag.swift)
rg '"my_flag"'

# FeatureFlagProviding protocol methods (adapters)
rg "isMyFlagEnabled.*throws"
```

$ARGUMENTS
