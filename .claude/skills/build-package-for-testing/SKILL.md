---
name: build-package-for-testing
description: Build an individual Swift package for testing
---

# Build a Swift package for testing

Build a single Swift package **including its test targets** — use this to verify one
package's tests compile; use `/build-for-testing` for the entire app.

> The xcode MCP builds the whole Xcode project, not a single SwiftPM package,
> so it does **not** apply here — this skill uses the `swift` CLI directly.

Delegate to a **Haiku subagent** (`subagent_type: general-purpose`, `model: haiku`)
so the output stays out of your context. Do **not** run it yourself. Give it the
prompt below, then relay its report.

Subagent prompt:

```text
Build the Swift package (including test targets) at <package-dir> and report concisely:

    cd <package-dir> && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1

MANDATORY cleanup afterwards: `rm -rf <package-dir>/.build`. Leaving a package
`.build` directory behind causes later `make test` simulator-install failures.

Report back ONLY:
- Status: succeeded or failed
- Each error/warning as `file:line — message` (omit if none; warnings are errors)
Do not paste raw logs or successful-compilation output.
```

> Note: packages whose test targets import UIKit (e.g. snapshot-test targets) can't
> build their test targets via `swift build --build-tests` on macOS. For those, build
> sources only (`/build-package`) or use the full-app `/build-for-testing`.

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
