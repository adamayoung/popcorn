---
name: canon-tdd
description: Implement features and fix bugs test-first, the Canon TDD way (test list → one test → make it pass → refactor → repeat). Use when implementing any new feature, screen, view model, use case, mapper, or domain model, fixing a bug, or executing a plan — write the test list and a failing test BEFORE production code.
---

# Canon TDD

Test-driven development the way Kent Beck describes as "Canon TDD", per
<https://adam-young.co.uk/blog/canon-tdd/>. CLAUDE.md mandates a TDD approach for
this project; this skill is the detailed how.

> **Red-Green-Refactor is the engine. The Test List is the steering wheel.**

## Agent behaviour contract

The point of this skill: do these by default, without being reminded.

1. **Start with a test list, and show it.** Before touching production code,
   enumerate the behaviours and edge cases as a checklist and confirm it with the
   user (or state it explicitly). This is the steering wheel — it defines "done".
2. **No production code before a failing test.** Write exactly **one** test,
   run it, and watch it fail for the right reason. Never write the implementation
   first and back-fill tests.
3. **One test at a time.** Do not convert the whole test list into code up front
   — the first passing test often forces a design change that affects the rest.
4. **Refactor only on green**, and keep refactoring out of the make-it-pass step.
5. **Repeat until the test list is empty**, adding newly-discovered cases to the
   list as you go.

## The five steps

1. **Write a test list** — every behavioural variant and edge case you can think
   of, as a plain checklist. Not code yet. It's a living list: add to it whenever
   implementation reveals a new case.
2. **Write a test** — pick the next item and write one real, automated test:
   setup, invocation, and **assertions**. Define *what* the system does and *how
   it's invoked* — not how it works inside. Run it; confirm it fails.
3. **Make it pass** — change the system to satisfy that test with the simplest
   thing that works. Nothing more; resist solving items still on the list.
4. **Optionally refactor** — improve names, structure, and duplication while every
   test stays green. Skip if there's nothing to improve.
5. **Repeat** — next item, until the list is empty.

## Separate interface from implementation

A test fixes a *decision* about the interface (the call shape, inputs, outputs)
and should be silent about the internals. Tests that assert on private mechanics
break under refactoring and defeat step 4. For a view model, assert on the public
`viewState` and on navigator spy calls — not on private helpers or intermediate
state.

## Anti-patterns (don't)

- **Tests without assertions** — a test that invokes but asserts nothing proves
  nothing.
- **Pre-converting the whole list to code** — write one test, learn, then the
  next. Batching tests locks in design decisions before you've learned anything.
- **Mixing refactor into make-it-pass** — keep "make it work" and "make it clean"
  as separate steps on either side of green.
- **Premature abstraction from duplication** — a little duplication across two
  green tests is fine; abstract when the shape is clear, not at the first repeat.

## In this codebase (Popcorn)

Apply the loop with the project's tooling and conventions:

- **Framework:** Swift Testing — `@Suite`, `@Test`, `#expect`, `#require`. Never
  force-unwrap in tests; unwrap optionals with `try #require(...)`.
- **Run tests via the delegated skills**, not `make`/`swift` directly, so output
  stays out of context. For a change localised to one package whose public
  interface is unchanged, prefer **`/test-package`** (faster). Otherwise use
  **`/test`** (full unit suite) and **`/test-snapshots`** (snapshot suite). Re-run
  the relevant skill after each red→green and after refactoring.
- **Test at every layer the change touches.** Put items for all of them on the
  list from the start, with happy-path *and* error/edge cases:
  - **Mappers** (adapter `DataSources/Mappers/`) — property mapping, `nil`
    handling, empty arrays, fallback values. Follow sibling `*MapperTests.swift`.
  - **Use cases** (context `*Application/UseCases/`) — happy path, plus error
    translation for each error type and app-config failure. Follow sibling
    `Default*UseCaseTests.swift`.
  - **View models** (feature root) — drive the view model with a stub
    `*Dependencies` and a spy `*Navigating`, then assert on `viewState` and the
    navigator spy. Cover: fetch success → ready, fetch failure → error, the
    loading guard, the ready guard, navigation calls. When the view model is
    feature-flag-gated, cover **both** the enabled and disabled paths.
  - **Views** — snapshot tests for new or visibly-changed views (`/test-snapshots`).
- **Domain models / new screens:** when the list involves a new domain model,
  derive its shape from TMDb per `docs/TMDB_MAPPING.md` (and the `tmdb` MCP for
  authoritative data) rather than inventing fields — but the tests assert on the
  mapped **domain** values, not raw TMDb payloads.
- **Bug fixes:** the first item on the list is a test that **reproduces the bug**
  (red), then the fix (green) — never fix first.
- **Public API:** when a change adds or modifies a `public` declaration, put a
  completion item on the list for its `///` doc comment (delegate to the
  `documentation-writer` agent) — it isn't a test, but it's part of "done".

## Project bookkeeping (part of "done")

When the test list adds new test infrastructure, the matching registration is a
completion item, not an afterthought:

- **New unit-test target** → register it in `TestPlans/PopcornUnitTests.xctestplan`
  (`containerPath`, `identifier`, `name`), or the tests won't run.
- **New snapshot-test target** → register it in
  `TestPlans/PopcornSnapshotTests.xctestplan` instead.
- **New `FeatureFlag`** → create the matching Statsig gate (see CLAUDE.md →
  "Feature flag creation").

## Finishing condition

You are done when the test list is empty **and** the gate is green: `/test` (unit)
and `/test-snapshots` (snapshots) both pass, and `/build-for-testing` builds with
no warnings (warnings are errors). Use the package-level skills mid-loop for speed,
but run the full-app skills as the final check before opening a PR.

Formatting is applied automatically as you edit; the clean-tree lint gate is
`make lint` (run via the pre-PR checklist).

## When NOT to use it

Pure refactors with existing coverage, config/CI edits, and docs-only changes don't
start from a new failing test — keep the existing tests green instead. TDD is for
*new behaviour* and *bug fixes*.
