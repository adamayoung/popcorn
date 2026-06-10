---
name: test-ui
description: Run UI tests
---

# Run UI tests

Runs the `PopcornUITests` test plan on the iOS Simulator. Optional argument: a
`<TestTarget>/<TestClass>` or `<TestTarget>/<TestClass>/<testMethod>` for a subset.

**Preferred — Xcode MCP (`xcode`), when running inside Xcode.** Get the
`tabIdentifier` from `mcp__xcode__XcodeListWindows`, then run
`mcp__xcode__RunAllTests` (or `mcp__xcode__RunSomeTests` with `<specifier>` for a
subset) with that `tabIdentifier`, targeting the PopcornUITests plan.

**Fallback — `make`, when the MCP isn't available.** Delegate to a **Haiku subagent**
(`subagent_type: general-purpose`, `model: haiku`). Do not run it yourself. Prompt it to:

```text
Run `mkdir -p .build && make test-ui [TEST_CLASS=<specifier>] > .build/last-ui.log 2>&1`,
check the exit status, and report ONLY:
- Status: passed or failed
- Counts: total / passed / failed
- Each failing test as `SuiteName/testName` with its `file:line` and message (omit if none)
- On failure, the log path `.build/last-ui.log`
Do not paste passing-test output or raw logs.
```
