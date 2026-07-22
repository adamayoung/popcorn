---
name: test-package
description: Run tests for an individual Swift package
---

# Test a Swift package

Run tests for a single Swift package — use this when you only need to test one
package; use `/test` for the entire app's suite.

> The xcode MCP builds/tests the whole Xcode project, not a single SwiftPM
> package, so it does **not** apply here — this skill uses the `swift` CLI directly.

## Gate first — feature packages can't be tested via the SwiftPM CLI

**Before delegating, check the package.** A **feature** package — anything under
`Features/`, or any package with a snapshot-test target (look for a `__Snapshots__/`
directory, or a test target that imports `SnapshotTestHelpers` / `UIKit`) —
**cannot be built or tested from the SwiftPM CLI at all**, so this skill does not
apply to it. Two independent blockers, either of which fails the run before any
test executes:

- `swift build --build-tests` / `swift test` fail building the snapshot target's
  `import UIKit` on macOS.
- `swift build` — even **sources-only** — fails at the manifest with *"found N
  file(s) which are unhandled"*, because the committed `__Snapshots__/*.png`
  references are undeclared resources to the SwiftPM CLI (Xcode handles them fine).

There is therefore **no sources-only fallback** for a feature package. Route it to
the full-app xcodebuild gate instead — **`/build-for-testing`**, **`/test`**, and
**`/test-snapshots`** — and don't spawn the subagent below. Only **context**,
**adapter**, **core**, and **platform** packages (no snapshot target) are testable
here; proceed with those.

Delegate to a **Haiku subagent** (`subagent_type: general-purpose`, `model: haiku`)
so the output stays out of your context. Do **not** run it yourself. Give the
subagent the prompt below, then relay its report.

Subagent prompt:

```text
Test the Swift package at <package-dir> and report concisely. Testing is two steps —
build with warnings-as-errors, then run tests skipping the rebuild:

    cd <package-dir> && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1 \
      && swift test --skip-build 2>&1

(The build step uses warnings-as-errors; the test step does not — matching the
app-level `make test`.)

MANDATORY cleanup afterwards: `rm -rf <package-dir>/.build`. Leaving a package
`.build` directory behind causes later `make test` simulator-install failures.

Report back ONLY:
- Build: succeeded or failed (+ each error/warning as `file:line — message`)
- Tests: passed or failed, with total / passed / failed counts
- Each failing test as `SuiteName/testName` with its `file:line` and the message
Do not paste raw logs or passing-test output.
Run the command yourself, immediately, in the foreground — never reply before it
has finished, and never defer, poll, or say you are waiting.
You are report-only: apart from the log file the command writes, do not create,
edit, or delete any file, and never attempt to fix what you find — report it.
```

### Package locations

| Layer | Path pattern |
|-------|-------------|
| Contexts | `Contexts/<PackageName>/` |
| Context Adapters | `Adapters/Contexts/<PackageName>/` |
| Platform Adapters | `Adapters/Platform/<PackageName>/` |
| Features | `Features/<PackageName>/` |
| Core | `Core/<PackageName>/` |
| Platform | `Platform/<PackageName>/` |
| AppDependencies | `AppDependencies/` |

> **Feature packages are excluded** — see *Gate first* above. Any package with a
> snapshot-test target can't be built or tested via the SwiftPM CLI (UIKit **and**
> undeclared `__Snapshots__` resources both block it, with no sources-only
> fallback); test it through the full-app `/build-for-testing` / `/test` /
> `/test-snapshots` instead.
