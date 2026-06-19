---
name: implement-plan
description: Implement the current plan test-first, the Canon TDD way, driving to a single finishing condition — an empty test list. Derives a Canon TDD test list from the plan, shows it before any code, writes one failing test at a time, and keeps the list visible as it evolves. Use when the user asks to implement, build, or execute the current/approved plan.
skills:
  - canon-tdd
  - swift-concurrency
  - swift-testing-expert
  - swiftui-expert
  - swiftdata-expert
---

# Implement Plan

Turn the **current plan** into working, tested code — strictly test-first. This
skill is the wrapper that ties three things together: the plan (what to build),
the **`canon-tdd`** skill (how to build it), and a single finishing condition —
**the test list is empty** (when to stop). It does not invent its own TDD rules;
it delegates the discipline to `canon-tdd` and adds plan-awareness, the finishing
goal, and the project's specialist skills.

> Red-Green-Refactor is the engine. The test list is the steering wheel. This
> skill keeps the wheel on screen and drives until the list is empty.

## Agent Behaviour Contract

These are non-negotiable. Do them by default, without being reminded.

1. **Canon TDD is mandatory — invoke the `canon-tdd` skill.** No production code
   before a failing test. One test at a time. Refactor only on green. This skill
   exists to enforce that loop against the plan; do not freelance an
   implementation-first approach.
2. **Show the test list before any code — and every time it changes.** Print the
   Canon TDD test list as a checklist before the first edit, and re-print it
   whenever you add, remove, reword, or check off an item (see *Keep the test
   list visible*).
3. **The finishing condition is an empty test list.** "Done" means every item on
   the list has a written, passing test and the full suite is green — nothing
   less. Pair this with the `/goal` command for autonomous cross-turn iteration
   (see *Set the finishing goal*).
4. **Reach for the right specialist skill.** Use `swift-testing-expert` when
   writing/structuring tests, `swift-concurrency` for anything touching tasks,
   actors, `@MainActor`, `Sendable`, or data races, `swiftui-expert` for view and
   view-model work, and `swiftdata-expert` for anything touching `@Model`,
   `ModelContainer`, `ModelContext`, migrations, or CloudKit — don't hand-roll
   what those skills know.
5. **Document every public declaration — no exceptions.** Documenting it is part
   of "make it pass". Every public protocol, class, struct, enum, actor, model,
   property, initializer, method, subscript, and typealias you add or change MUST
   carry an accurate `///` doc comment (see *Document every public declaration*).
   Popcorn has no `make build-docs` build gate, so this is enforced by the
   **review agents** (`code-reviewer` and `plan-reviewer` both check public-decl
   docs), not a build — which makes self-discipline here mandatory, not optional.
6. **Expect Swift files to change after you write them.** A PostToolUse hook runs
   `swiftlint --fix` + `swiftformat` on every `.swift` file you Edit/Write, so the
   on-disk content can differ from what you wrote (see *The auto-formatting hook*).
7. **Commit at logical checkpoints — always green.** Like a human engineer, commit
   when a cohesive increment is complete and the code is in a **good state**, and
   **never commit a red or half-finished tree** (see *Commit at logical points*).
   This keeps the work committed as you go, so the downstream review (which diffs
   *committed* history) sees real progress rather than an empty diff.
8. **Finish with the completion checklist.** Before declaring done, run `/test`,
   `/test-snapshots`, and `/build-for-testing` (warnings-as-errors) — all three
   REQUIRED to pass — plus `make lint`. There are **no integration tests** in
   Popcorn; do not look for them.

## Locate the plan

Use the first that applies, then restate the plan's goal in a sentence so the
test list is anchored to it:

1. **An explicit target** the user named — a plan/design file path, or plan text
   passed as the skill argument.
2. **The active plan-mode plan** — the most recent plan you presented via
   `ExitPlanMode`.
3. **A plan in the conversation** — the most recent structured plan / task
   breakdown (including a `TodoWrite` list framed as the plan).

If there is no plan, stop and say so — offer to draft one first (e.g. via the
`Plan` agent or plan mode), and to `/review-plan` it before implementing. Never
fabricate a plan in order to implement it.

## Step 1 — Derive and show the test list

Invoke the **`canon-tdd`** skill and follow its steps. Start by translating the
plan into a **test list**: enumerate every behaviour, edge case, and error path
the plan implies — as a plain checklist, not code. For Popcorn that means
thinking across the layers a change touches:

- **Adapter mappers** — every new/changed mapper in
  `Adapters/Contexts/*/.../Mappers/`: property mapping, `nil` handling, empty
  arrays, fallback values.
- **Use cases** — every new use case in `Contexts/*/Sources/*Application/UseCases/`:
  happy path, error translation for each error type, app-config failure.
- **View models** — fetch success → `ready`, fetch failure → `error`, the loading
  guard, the ready guard, navigation returning `none`, and any feature-flag-gated
  behaviour (cover **both** the enabled and disabled paths).
- **Snapshot coverage** — new or changed SwiftUI views get a snapshot test (sibling
  patterns in the feature's snapshot target).
- **Concurrency / `Sendable` expectations**, localization keys, and any SwiftData
  `@Model` / migration / CloudKit behaviour the plan introduces.

**Print the list before writing any code**, e.g.:

```text
Test list — <plan goal>
- [ ] <Mapper> maps all DTO fields to the domain model
- [ ] <Mapper> falls back to <default> when <field> is nil
- [ ] <UseCase>.execute() returns <result> on success
- [ ] <UseCase>.execute() translates <RepoError> → <DomainError>
- [ ] <ViewModel> moves to .ready on successful fetch
- [ ] <ViewModel> moves to .error on fetch failure
- [ ] <ViewModel> hides <X> when <featureFlag> is disabled
- [ ] snapshot: <View> renders <state>
- [ ] document public API introduced by this change
```

It is a living list — you will add cases as implementation reveals them. Confirm
it with the user (or state it explicitly) before proceeding.

## Step 2 — Set the finishing goal

The completion condition for this whole effort is: **the test list is empty** —
every item has a written, passing test, and `/test` + `/test-snapshots` +
`/build-for-testing` (warnings-as-errors) are all green, with no unrelated files
modified.

For autonomous, cross-turn iteration toward that condition, use Claude Code's
`/goal` command. **You cannot set `/goal` yourself — it is user-initiated** — so
offer the user the exact command to run, then proceed with the TDD loop either
way:

```text
/goal every item on the Canon TDD test list has a written, passing test and
`/test`, `/test-snapshots`, and `/build-for-testing` all pass — without modifying
files unrelated to this plan; or stop after 25 turns
```

If the user sets it, Claude keeps taking turns until a fast model confirms the
condition. If they don't, drive the same loop yourself across the turn until the
list is empty. Either way the destination is identical: zero unchecked items.

## Step 3 — The TDD loop (one test at a time)

Per `canon-tdd`, repeat until the list is empty:

1. **Pick the next item** and write exactly **one** test (use
   `swift-testing-expert` for structure — `@Test`/`#expect`/`#require`,
   parameterisation, tags). Run it; watch it fail for the right reason.
2. **Make it pass** with the simplest production change that works — resist
   solving items still on the list. **Any public symbol you introduce here is
   documented in the same step** (see *Document every public declaration*) — a
   public declaration without a `///` comment is not "passing".
3. **Refactor only on green**, keeping every test passing and every public symbol
   documented.
4. **Update the list** — check off the item, and add any new cases the work
   revealed — then **re-print the list**.
5. **Commit when you reach a logical checkpoint** — when the increment is cohesive
   and green (see *Commit at logical points*). Not every micro-cycle; at
   meaningful milestones.

**Build/test mid-loop for speed.** While the change is localised to a single
package **and its public interface is unchanged**, run `/build-package` +
`/test-package` (they run `swift build`/`swift test` in the package directory —
far faster than the whole app). Switch to the full-app `/build-for-testing` +
`/test` once the change spans packages, touches a public interface, or you reach
the final gate. Prefer the Xcode MCP (`xcode`) when working inside Xcode. See
`CLAUDE.md` § "Incremental vs Full Builds".

**Popcorn-specific items the plan may add to the list:**

- A new `FeatureFlag` → the matching **Statsig gate must be created** (development
  environment only) via the Statsig MCP. See `CLAUDE.md` § "Statsig gate creation".
- A new **unit**-test target → register it in
  `TestPlans/PopcornUnitTests.xctestplan` (snapshot targets go in
  `PopcornSnapshotTests.xctestplan`) or its tests won't run.

## Commit at logical points

Build the change as a human engineer would — a sequence of small, working commits,
each a coherent step — not one giant uncommitted blob at the end. This matters
specifically because the downstream code review diffs **committed** history
(`git diff main...HEAD`); an empty working tree gives it nothing to review.

**When to commit** — at a *logical checkpoint*, when a cohesive increment is
complete: a mapper + its tests; a use case + its tests; a view model + its tests
(and the view's snapshot); a finished refactor. Group a few related test-list
items into one commit rather than committing every single red→green micro-cycle.
A good commit tells a story (`✨ Add region filtering to TV listings`,
`✅ Cover error paths for ChannelsUseCase`, `♻️ Extract region resolution`).

**Good state before every commit — never commit red:**

- The suite is **green** — run `/test-package` (or `/test` for cross-package
  work), and `/test-snapshots` if the increment touched a view, and confirm it
  passes.
- **Lint is clean** — `make lint` (the format hook handles most style on write,
  but it cannot catch every lint rule).
- **No half-finished or dead code** — no commented-out experiments, no stubbed
  function you haven't returned to, no debug prints. The tree compiles and every
  public symbol you added is documented.

If an increment isn't green yet, finish it (or stash the unfinished part) before
committing — a commit is a *working* state. Use a gitmoji-prefixed message (see
`docs/GIT.md`). Committing as you go means that by the time the test list is empty,
the work is fully committed — ready for review and PR with a clean history.

## Document every public declaration

Every public symbol you add or change MUST have an accurate `///` documentation
comment — this is a hard requirement (`CLAUDE.md`). There is **no `make
build-docs` build gate** in Popcorn, so a missing doc comment won't fail a
compile; instead the **review agents** (`code-reviewer` and `plan-reviewer`) flag
undocumented public surface, and an undocumented symbol will block the PR there.
Document **as you write it**, in the same green step — never as a clean-up pass at
the end.

This covers **all** public declarations, no exceptions:

- **Types** — `protocol`, `class`, `struct`, `enum`, `actor`, `typealias`, every
  domain model, `@Model`, and feature `ViewState`.
- **Members** — stored and computed `properties`, `initializers`, `methods`,
  `subscripts`, `enum` cases where meaning isn't obvious, and associated values.
- **Custom `Codable`** — `init(from:)` and `encode(to:)` in a `public extension`
  need `///` comments too (a common miss).

Quality, not just presence:

- Use correct DocC syntax — `- Parameter name:` (singular) for one parameter,
  `- Parameters:` (plural) for several; `- Returns:`; `- Throws:`.
- Write complete, specific descriptions — never placeholders (`/// ?`,
  `Array of...`). Watch for copy-paste errors (e.g. "movie" left in a TV-series
  doc, or `Movie.ID` where `TVSeries.ID` is meant).

For a bulk pass (a whole new context or feature, or sweeping many undocumented
symbols at once), delegate to the **`documentation-writer`** agent, which writes
DocC-style comments in an isolated context. Add a "document public API" item to
the test list when a behaviour introduces public surface, so it can't be silently
skipped.

## Keep the test list visible

The list is the user's window into progress. Re-print the full checklist (done +
remaining) whenever it changes — after checking off an item, after discovering
and adding a new case, after rewording or removing one. Each re-print should make
clear what just changed (e.g. "✓ added", "✓ done", "✗ removed — superseded by …").
Never let code changes outpace a stale on-screen list.

## Use the right specialist skills

- **`swift-testing-expert`** — when writing or restructuring tests: macro usage,
  `#require` over force-unwrap, traits/tags, parameterised tests, async waiting.
- **`swift-concurrency`** — when the plan touches tasks, actors, `@MainActor`,
  `Sendable`, async/await conversion, or any data-race / Swift 6 strict-concurrency
  diagnostic.
- **`swiftui-expert`** — when building or refactoring views, view models, state
  management, navigation wiring, or chasing view-update performance.
- **`swiftdata-expert`** — when the plan touches `@Model`, `ModelContainer`,
  `ModelContext`, `FetchDescriptor`, `@ModelActor`, migrations, or CloudKit sync.
- **`documentation-writer`** agent — for bulk DocC doc sweeps (see *Document every
  public declaration*).
- **`/test`, `/test-snapshots`, `/build-for-testing`, `/build-package`,
  `/test-package`** — delegate builds and test runs to these (they fan out to a
  Haiku subagent, or call the Xcode MCP when inside Xcode, keeping this context
  lean); don't call `make`/`swift` directly for them.

Invoke a specialist skill the moment its domain appears — not after you've already
hand-written something it would have done better.

## The auto-formatting hook (files change after you write them)

A `PostToolUse` hook matches `Edit|Write` and, for any `.swift` file, runs
`swiftlint --fix` then `swiftformat` on it. Consequences to plan around:

- **The file on disk may differ from what you wrote** — imports reordered,
  whitespace/indentation normalised, trailing commas adjusted, `self.` removed,
  etc. This is expected and correct; do not fight it or revert it. **Do not tell
  the user to run a formatter** — the hook already did.
- **Re-Read a `.swift` file before your next Edit to it** if that edit depends on
  exact surrounding text — a stale `old_string` (pre-format) can fail to match.
- **Don't attribute hook reformatting to your own diff.** When reviewing changes,
  separate "what I changed" from "what the formatter normalised".
- It only autofixes the single edited file, not the whole tree, and it cannot fix
  real compile errors or every lint rule — so still run `make lint`,
  `/build-for-testing`, and the test skills before finishing.

## Done — when the test list is empty

When every item is checked off:

1. Run `/test` and `/test-snapshots` — both must pass (`CLAUDE.md` requires it).
2. Run `/build-for-testing` — the build must succeed with **no warnings**
   (warnings are errors).
3. Run `make lint` — no violations.
4. Print the final, fully-checked test list and a short summary of what was
   implemented.
5. If a `/goal` was set, it clears automatically once the condition is confirmed.

Do not declare the plan implemented while any test-list item is unchecked or any
required suite is red. An empty list with `/test` + `/test-snapshots` +
`/build-for-testing` all green — that is the finish line.
