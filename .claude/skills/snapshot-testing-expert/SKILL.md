---
name: snapshot-testing-expert
description: 'Expert guidance on snapshot testing with swift-snapshot-testing: writing snapshot tests, configuring strategies, device layouts, recording modes, Xcode Cloud CI compatibility, and reviewing snapshot test code. Use when writing new snapshot tests, adding snapshot coverage to features, debugging snapshot failures, reviewing snapshot test code, or configuring CI for snapshots.'
---

# Snapshot Testing (swift-snapshot-testing)

## Overview

Use this skill for authoritative guidance on snapshot testing in the Popcorn project using Point-Free's swift-snapshot-testing 1.18+. Covers writing snapshot tests with Swift Testing, configuring image strategies, device layouts, recording modes, Xcode Cloud CI compatibility, and reviewing snapshot test code.

## Agent Behavior Contract

1. **Always use Swift Testing** (`@Suite`, `@Test`, `import Testing`) — never XCTest for snapshot tests.
2. **Always use `verifySnapshot` + `Issue.record`** — not `assertSnapshot` — to support the `snapshotDirectory` parameter for Xcode Cloud CI compatibility.
3. **Always include `snapshotDirectory: Self.snapshotDirectory`** in every `verifySnapshot` call — this enables CI resolution from `Bundle.module`.
4. **Always use `.snapshots(record: .missing)` on the `@Suite`** — records only missing snapshots, safe for CI.
5. **Always annotate snapshot test suites with `@MainActor`** — SwiftUI views require main thread rendering.
6. **Always use `.image(layout: .device(config: .iPhone13Pro))` as the default strategy** — consistent rendering across environments.
7. **Always wrap views in `NavigationStack`** when testing screens that appear within navigation — matches production context.
8. **Always use `EmptyReducer()` for TCA stores in snapshot tests** — snapshots capture visual state, not behavior.
9. **Never force unwrap** in snapshot tests — use optional chaining (SwiftLint `force_unwrapping` rule).
10. **Preview data must use real TMDb IDs and image URLs** — ensures snapshots render authentic content.

## First 60 Seconds (Triage Template)

- Clarify the goal: new snapshot test, debugging failure, CI issue, or review.
- Collect minimal facts:
  - Which feature/view needs snapshot coverage?
  - Is the issue local-only or CI-specific (Xcode Cloud)?
  - Is this a new snapshot or a mismatch with an existing reference?
- Branch quickly:
  - new snapshot test -> `references/writing-tests.md`
  - CI failure / Xcode Cloud -> `references/xcode-cloud.md`
  - snapshot mismatch -> `references/debugging.md`
  - strategy/layout questions -> `references/strategies.md`
  - review -> verification checklist below

## Common Pitfalls -> Next Best Move

- **Snapshot test fails in Xcode Cloud with "No reference found on disk"** -> `references/xcode-cloud.md` — snapshot images must be bundled as `.copy` resources and resolved from `Bundle.module` in CI.
- **Using `assertSnapshot` instead of `verifySnapshot`** -> `assertSnapshot` lacks `snapshotDirectory` parameter — switch to `verifySnapshot` + `Issue.record` pattern.
- **Snapshot renders blank or partially loaded** -> ensure preview data includes image URLs; use `timeout` parameter if async loading needed.
- **Snapshot mismatch after UI change** -> delete old snapshot PNG, re-run to record new one, commit the updated PNG.
- **Different results on different machines** -> use fixed device config (`.iPhone13Pro`), not `.sizeThatFits` which varies by host.
- **Force unwrap lint error on `Bundle.module.resourceURL!`** -> use optional chaining (`resourceURL?`).
- **Missing `Bundle.module`** -> ensure Package.swift test target declares `resources: [.copy("Views/__Snapshots__")]`.
- **Snapshot test not running in CI** -> ensure target is registered in `TestPlans/PopcornSnapshotTests.xctestplan`.

## Verification Checklist

- Confirm test uses `@Suite(.snapshots(record: .missing))` and `@MainActor`.
- Confirm test uses `verifySnapshot` with `snapshotDirectory: Self.snapshotDirectory`, not `assertSnapshot`.
- Confirm `snapshotDirectory` computed property exists — returns `nil` locally, `Bundle.module` path in CI.
- Confirm Package.swift has `resources: [.copy("Views/__Snapshots__")]` on the snapshot test target.
- Confirm snapshot PNG is committed to git in `__Snapshots__/{TestTypeName}/{testName}.1.png`.
- Confirm snapshot test target is registered in `TestPlans/PopcornSnapshotTests.xctestplan`.
- Confirm preview data uses `static var` (not `static let` for `@Model` types).
- Confirm no force unwraps in test code.

## References

- `references/writing-tests.md` — step-by-step guide to writing snapshot tests
- `references/strategies.md` — image strategies, device configs, layout options
- `references/xcode-cloud.md` — CI compatibility, Bundle.module, resource bundling
- `references/debugging.md` — troubleshooting snapshot failures
