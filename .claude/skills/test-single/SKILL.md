---
name: test-single
description: Run a specific test target or test class
arguments: $ARGUMENTS
---

# Run specific tests

Run a subset of the app's test suite by specifying a test target, class, or method.

## Xcode MCP (preferred)

1. Run `mcp__xcode__XcodeListWindows` to get the `tabIdentifier` for the Popcorn workspace.
2. If unsure of the exact test specifier, run `mcp__xcode__GetTestList` to find available test targets and classes.
3. Run `mcp__xcode__RunSomeTests` with the `tabIdentifier` and the test specifiers matching `$ARGUMENTS`.

## Fallback

**Run via a subagent** (Task tool, `subagent_type: "general-purpose"`) to keep large logs out of the main context. The subagent should run `make test TEST_TARGET=<specifier>` from the project root and report back pass/fail with any test failures.

`<specifier>` is the `-only-testing` value (e.g. a test target or `Target/ClassName/methodName`).

### Examples

```bash
# Run all tests in a specific test target
make test TEST_TARGET=MovieDetailsFeatureTests

# Run a specific test class
make test TEST_TARGET=MovieDetailsFeatureTests/MovieDetailsFeatureTests

# Run a specific test method
make test TEST_TARGET=MovieDetailsFeatureTests/MovieDetailsFeatureTests/testFetchMovieDetails
```
