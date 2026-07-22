---
name: build-package
description: Build an individual Swift package
---

# Build a Swift package

Build a single Swift package — use this when you only need to verify one package
compiles; use `/build` for the entire app.

> The xcode MCP builds the whole Xcode project, not a single SwiftPM package,
> so it does **not** apply here — this skill uses the `swift` CLI directly.

Delegate to a **Haiku subagent** (`subagent_type: general-purpose`, `model: haiku`)
so the output stays out of your context. Do **not** run it yourself. Give it the
prompt below, then relay its report.

Subagent prompt:

```text
Build the Swift package at <package-dir> and report concisely:

    cd <package-dir> && swift build -Xswiftc -warnings-as-errors 2>&1

MANDATORY cleanup afterwards: `rm -rf <package-dir>/.build`. Leaving a package
`.build` directory behind causes later `make test` simulator-install failures.

Report back ONLY:
- Status: succeeded or failed
- Each error/warning as `file:line — message` (omit if none; warnings are errors)
Do not paste raw logs or successful-compilation output.
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
