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

**Fallback — `make`, when the MCP isn't available.** For a **long-running run you'll block on** (e.g. a `/deliver` pre-PR gate step), prefer a **backgrounded `Bash`** (`run_in_background: true`) that redirects to a log and appends `; echo "EXIT=$?"`, then — on the completion notification — grep the log for the `EXIT=` marker plus failing tests (targeted greps keep the verbose log out of context); it self-reports **once** on exit, whereas a Haiku subagent driving its own poll loop tends to return premature "still waiting" notes. Otherwise, delegate to a **Haiku subagent**
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
Run the command yourself, immediately, in the foreground — never reply before it
has finished, and never defer, poll, or say you are waiting.
You are report-only: apart from the log file the command writes, do not create,
edit, or delete any file, and never attempt to fix what you find — report it.
```

### Specifier examples

```text
MovieDetailsFeatureTests                                         # whole target
MovieDetailsFeatureTests/MovieDetailsViewModelTests              # a class/suite
MovieDetailsFeatureTests/MovieDetailsViewModelTests/loadSuccess  # one test
```
