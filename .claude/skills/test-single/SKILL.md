---
name: test-single
description: Run a specific test target or test class
arguments: $ARGUMENTS
---

# Run specific tests

Run a subset of the app's test suite by specifying a test target, class, or method
(`$ARGUMENTS`). `<specifier>` is the `-only-testing` value: a test target,
`Target/ClassName`, or `Target/ClassName/methodName`.

**Preferred — Xcode MCP (`xcode`), when running inside Xcode.** Call it directly:

1. Get the workspace `tabIdentifier` from `mcp__xcode__XcodeListWindows`.
2. If unsure of the exact identifier, run `mcp__xcode__GetTestList` (with the
   `tabIdentifier`) to find targets/classes.
3. Run `mcp__xcode__RunSomeTests` with the `tabIdentifier` and the specifier(s)
   matching `$ARGUMENTS`. On a build failure, call `mcp__xcode__GetBuildLog` with the
   `tabIdentifier` and `severity: "error"`.

**Fallback — `make`, when the MCP isn't available.** Delegate to a **Haiku subagent**
(`subagent_type: general-purpose`, `model: haiku`) so output stays out of your context.
Do not run it yourself. Prompt the subagent to:

```text
Run `mkdir -p .build && make test TEST_TARGET=<specifier> > .build/last-test.log 2>&1`,
check the exit status, and report ONLY:
- Status: passed or failed
- Counts: total / passed / failed
- Each failing test as `SuiteName/testName` with its `file:line` and message (omit if none)
- On failure, the log path `.build/last-test.log`
Do not paste passing-test output or raw logs.
```

### Specifier examples

```text
MovieDetailsFeatureTests                                         # whole target
MovieDetailsFeatureTests/MovieDetailsViewModelTests              # a class/suite
MovieDetailsFeatureTests/MovieDetailsViewModelTests/loadSuccess  # one test
```
