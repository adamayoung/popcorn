---
name: tca-expert
description: 'Expert guidance on The Composable Architecture (TCA): reducers, effects, dependencies, navigation, testing, bindings, shared state, and performance. Use when writing TCA features, debugging reducers, reviewing TCA code, implementing navigation, or writing TCA tests.'
---

# The Composable Architecture (TCA)

## Overview

Use this skill for authoritative guidance on TCA 1.23+. Covers reducer composition, effect management, dependency injection, navigation patterns, testing strategies, bindings, shared state, and performance optimization.

## Agent behavior contract (follow these rules)

1. Always use the `@Reducer` macro — never hand-write `Reducer` conformances.
2. Use `@ObservableState` on all `State` structs — never use `WithViewStore` or `ViewStore` (deprecated).
3. Prefer `@Dependency` for all external interactions — never reach for singletons or global state.
4. Default to stack-based navigation for list-to-detail flows and tree-based for modals/alerts.
5. Write exhaustive `TestStore` tests by default; use non-exhaustive only for integration tests.
6. Keep `Reduce` body lightweight — offload async/CPU work to `.run` effects.
7. Use `@DependencyClient` macro for client definitions — never hand-write unimplemented defaults.
8. Prefer helper methods on the reducer over action ping-pong for sharing logic.

## First 60 seconds (triage template)

- Clarify the goal: new feature, navigation, testing, debugging, performance, or review.
- Collect minimal facts:
  - TCA version (1.23+ assumed)
  - Swift version and concurrency mode
  - Whether using stack-based or tree-based navigation
  - Whether the issue involves effects, state, or view integration
- Branch quickly:
  - new feature -> reducers + effects + dependencies
  - navigation issues -> navigation reference
  - test failures -> testing reference
  - performance -> performance reference
  - form/binding heavy -> bindings reference
  - cross-feature state -> shared state reference

## Routing map (read the right reference fast)

- `@Reducer`, State, Action, body, composition -> `references/reducers.md`
- `.run`, `.none`, cancellation, debouncing, long-living effects -> `references/effects.md`
- `@Dependency`, `@DependencyClient`, `DependencyKey`, wiring -> `references/dependencies.md`
- Stack-based, tree-based, alerts, dismissal -> `references/navigation.md`
- `TestStore`, exhaustive/non-exhaustive, patterns -> `references/testing.md`
- `@Bindable`, `.sending()`, `BindableAction`, `BindingReducer` -> `references/bindings.md`
- `@Shared`, persistence, deriving, concurrent mutations -> `references/shared-state.md`
- Store scoping, high-frequency actions, CPU work -> `references/performance.md`

## Common pitfalls -> next best move

- Action ping-pong between parent/child for shared logic -> extract helper method on reducer.
- `WithViewStore` / `ViewStore` usage -> migrate to `@ObservableState` + direct `store.property` access.
- Force-unwrapping dependency in `liveValue` -> use `@Dependency` inside `liveValue` closure.
- Testing non-deterministic effects -> inject controllable clocks and UUID generators.
- Navigation state not updating -> verify `.ifLet` / `.forEach` wiring in reducer body.
- Binding compile errors -> check `@Bindable var store` in view and `BindableAction` on Action.
- Shared state not syncing -> verify `@Shared` reference passing with `$` prefix.

## Verification checklist

- Confirm `@Reducer` macro is applied to all reducer structs.
- Confirm `@ObservableState` is on all State types.
- Confirm all external dependencies use `@Dependency`.
- Confirm navigation uses `.ifLet` (tree) or `.forEach` (stack) in reducer body.
- Confirm tests use `TestStore` with proper dependency overrides.
- Confirm effects capture state values, not `state` itself (e.g., `[id = state.id]`).
- Confirm no `ViewStore`, `WithViewStore`, or `IfLetStore` usage (all deprecated).

## References

- `references/reducers.md`
- `references/effects.md`
- `references/dependencies.md`
- `references/navigation.md`
- `references/testing.md`
- `references/bindings.md`
- `references/shared-state.md`
- `references/performance.md`
