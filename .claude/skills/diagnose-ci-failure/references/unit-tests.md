# Unit-test failure (Build and Test — Unit Test step)

The **Build and Test** job (workflow "Unit Tests", job `unit-tests`) runs the
unit suite after the build:

```bash
xcodebuild -scheme Popcorn \
  -destination "platform=iOS Simulator,name=iPhone 17 Pro,OS=26.5" \
  -skipMacroValidation -testPlan PopcornUnitTests \
  -parallel-testing-enabled NO test-without-building
```

Tests use the **Swift Testing** framework (`@Suite`, `@Test`, `#expect`,
`#require`) — never force-unwrap (`!`); use `try #require(...)`. The
`PopcornUnitTests` test plan selects the unit-test targets across every package.
On failure the job uploads `UnitTestResults.xcresult.zip`.

## Reading the failure

- A recorded `#expect(...)` failure prints the expression and actual-vs-expected
  at `file:line`.
- A `#require(...)` failure throws and aborts that test — the message names what
  couldn't be unwrapped.

## Common causes & fixes

1. **View-model test asserting on `viewState`.** After a logic change, a feature
   view-model test that asserts `viewState == .ready(...)` / `.error(...)` no
   longer matches. Decide which side is right: if the new behaviour is correct,
   update the expected `ViewState` value; if the change broke a flag-gated or
   error path, fix the view model. Per CLAUDE.md, flag-gated changes must update
   the test for **both** enabled and disabled paths.

2. **Mapper / use-case test mismatch.** An adapter mapper or context use case
   changed its output (renamed/re-typed property, new error translation) but the
   sibling `*MapperTests` / `Default*UseCaseTests` wasn't updated. Update the
   expectation (or fix the mapper/use case) — cover nil/empty/fallback and each
   error branch, not just the happy path.

3. **A test "doesn't run" / missing from the plan.** A new unit-test target was
   added but not registered in `TestPlans/PopcornUnitTests.xctestplan`, so CI
   never executes it (and a regression slips through, or a referenced target
   errors). Add an entry with `containerPath` (`container:`-prefixed relative
   path), `identifier`, and `name`. (Snapshot targets go in
   `PopcornSnapshotTests.xctestplan` instead.)

4. **SwiftData on-disk-store crash.** A `@Model`'s stored property named `id` or
   `hash` collides with `PersistentIdentifier` / `NSObject.hash` and only crashes
   against the **persisted** store as an `NSNumber → NSString` cast failure (not
   in-memory tests). Rename the property (e.g. `key` / `contentHash`) — see the
   `swiftdata-expert` skill.

## Reproduce locally

- `/test` — runs the full `PopcornUnitTests` plan (Haiku subagent).
- For one target/class: `/test-single <name>`.

## Output

**Summary:** Build and Test — Unit Test step — `Suite/test` at `file:line`.
**Cause:** the assertion / mapper-or-use-case mismatch / unregistered target / SwiftData store collision.
**Fix:** update the expectation or production code / register the target / rename the reserved property; re-run `/test`.
