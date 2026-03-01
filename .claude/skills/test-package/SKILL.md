---
name: test-package
description: Run tests for an individual Swift package
---

# Test a Swift package

Run tests for a single Swift package. Use this when you only need to test a specific package — use `/test` instead when you need to run the entire app's test suite.

Testing is a two-step process: build with warnings-as-errors first, then run tests with `--skip-build`.

## Xcode MCP (preferred)

1. Run `mcp__xcode__XcodeListWindows` to get the `tabIdentifier` for the Popcorn workspace.
2. Run `mcp__xcode__GetTestList` to find test targets for the package.
3. Run `mcp__xcode__RunSomeTests` with the relevant test specifiers for the package's test targets.

## Fallback

**Run via a subagent** (Task tool, `subagent_type: "general-purpose"`) to keep large logs out of the main context. The subagent should run the commands from the package directory and report back pass/fail with any errors or test failures.

```
cd <package-dir> && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1 && swift test --skip-build 2>&1
```

Note: The build step uses `-Xswiftc -warnings-as-errors`. The test execution step does not — consistent with how the app-level `make test` works.

### Examples

```bash
# Context package
cd Contexts/PopcornMovies && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1 && swift test --skip-build 2>&1

# Adapter package
cd Adapters/Contexts/PopcornMoviesAdapters && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1 && swift test --skip-build 2>&1

# Feature package
cd Features/MovieDetailsFeature && swift build --build-tests -Xswiftc -warnings-as-errors 2>&1 && swift test --skip-build 2>&1
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
