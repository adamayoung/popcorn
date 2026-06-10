---
name: test-package
description: Run tests for an individual Swift package
---

# Test a Swift package

Run tests for a single Swift package — use this when you only need to test one
package; use `/test` for the entire app's suite.

> The xcode MCP builds/tests the whole Xcode project, not a single SwiftPM
> package, so it does **not** apply here — this skill uses the `swift` CLI directly.

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

> Note: feature/adapter packages with snapshot-test targets that import UIKit can't
> build their **test** targets via `swift build --build-tests` on macOS. For those,
> build sources only (`swift build -Xswiftc -warnings-as-errors`) or use the full-app
> `/test`.
