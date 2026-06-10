---
name: test
description: Run all unit tests
---

# Run tests

**Preferred — Xcode MCP (`xcode`), when running inside Xcode.** Call it directly
(small structured result, no subagent needed):

1. Get the workspace `tabIdentifier` from `mcp__xcode__XcodeListWindows`.
2. Run `mcp__xcode__RunAllTests` with that `tabIdentifier`.
3. If a build error caused the failure, call `mcp__xcode__GetBuildLog` with the same
   `tabIdentifier` and `severity: "error"`.

**Fallback — `make`, when the MCP isn't available.** Delegate to a **Haiku subagent**
(Agent tool, `subagent_type: general-purpose`, `model: haiku`) so the output stays out
of your context. Do not run it yourself. Prompt the subagent to:

```text
Run `mkdir -p .build && make test > .build/last-test.log 2>&1`, check the exit
status, and report ONLY:
- Status: passed or failed
- Counts: total / passed / failed
- Each failing test as `SuiteName/testName` with its `file:line` and the assertion
  message (omit if none)
- On failure, the log path `.build/last-test.log`
Do not paste passing-test output or raw logs.
```

After fixing any issues, re-invoke this skill to re-check.
