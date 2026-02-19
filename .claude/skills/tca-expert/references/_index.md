# Reference Index

Quick navigation for The Composable Architecture topics.

## Fundamentals

| File | Description |
|------|-------------|
| `reducers.md` | `@Reducer` macro, State, Action, body, composition, child reducers |
| `effects.md` | `.run`, `.none`, cancellation, debouncing, combining, long-living effects |
| `dependencies.md` | `@Dependency`, `@DependencyClient`, `DependencyKey`, registration, overrides |

## Navigation

| File | Description |
|------|-------------|
| `navigation.md` | Stack-based (push/pop), tree-based (sheets/covers/alerts), enum destinations, deep linking, dismissal |

## State & Bindings

| File | Description |
|------|-------------|
| `bindings.md` | `@Bindable`, `.sending()`, `BindableAction`, `BindingReducer`, two-way binding controls |
| `shared-state.md` | `@Shared`, persistence, cross-feature state, concurrent mutations |

## Testing & Performance

| File | Description |
|------|-------------|
| `testing.md` | `TestStore`, exhaustive/non-exhaustive, dependency overrides, navigation testing |
| `performance.md` | Store scoping, observation mechanics, high-frequency actions, CPU offloading |

---

## Quick Links by Problem

### I need to...

- **Create a new TCA feature** → `reducers.md` (State, Action, body, @Reducer)
- **Make an API call from a reducer** → `effects.md` (.run, async operations)
- **Cancel an in-flight request** → `effects.md` (Cancellation, CancelID)
- **Debounce search input** → `effects.md` (Debouncing)
- **Define a dependency client** → `dependencies.md` (@DependencyClient, DependencyKey)
- **Override a dependency in tests** → `dependencies.md` (Overrides) + `testing.md` (TestStore)
- **Push/pop a detail screen** → `navigation.md` (Stack-based navigation)
- **Show a sheet or alert** → `navigation.md` (Tree-based navigation)
- **Dismiss from a child feature** → `navigation.md` (Dismissal)
- **Bind a TextField/Toggle to TCA state** → `bindings.md` (@Bindable, .sending())
- **Share state between features** → `shared-state.md` (@Shared)
- **Write tests for a reducer** → `testing.md` (TestStore, exhaustive testing)
- **Fix slow view re-renders** → `performance.md` (Store scoping, observation)

### I'm getting an error about...

- **ViewStore or WithViewStore** → `reducers.md` — migrate to `@ObservableState` + direct store access
- **Binding compile errors** → `bindings.md` — check `@Bindable var store` and `BindableAction`
- **Effect not firing** → `effects.md` — verify `.run` returns correctly, check cancellation
- **Navigation state not updating** → `navigation.md` — verify `.ifLet` / `.forEach` wiring
- **Shared state not syncing** → `shared-state.md` — verify `$` prefix for reference passing
- **Test assertion failures** → `testing.md` — check action ordering, dependency overrides
- **Unimplemented dependency crash** → `dependencies.md` — provide test override or use `@DependencyClient`

---

## File Statistics

| File | Lines | Primary Topics |
|------|-------|---------------|
| `reducers.md` | 245 | @Reducer, State, Action, body, composition |
| `effects.md` | 232 | .run, cancellation, debouncing, combining |
| `dependencies.md` | 201 | @Dependency, @DependencyClient, DependencyKey |
| `navigation.md` | 323 | Stack-based, tree-based, alerts, dismissal |
| `bindings.md` | 200 | @Bindable, .sending(), BindingReducer |
| `shared-state.md` | 227 | @Shared, persistence, concurrent mutations |
| `testing.md` | 338 | TestStore, exhaustive, non-exhaustive |
| `performance.md` | 181 | Scoping, observation, high-frequency actions |
