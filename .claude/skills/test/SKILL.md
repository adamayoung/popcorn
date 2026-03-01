---
name: test
description: Run all unit tests
---

# Run tests

Use the Xcode MCP if available, otherwise fall back to Make.

## Xcode MCP (preferred)

1. Run `mcp__xcode__XcodeListWindows` to get the `tabIdentifier` for the Popcorn workspace.
2. Run `mcp__xcode__RunAllTests` with the `tabIdentifier`.
3. If tests fail, review the output for failure details. Use `mcp__xcode__GetBuildLog` with `severity: "error"` if build errors caused the failure.

## Fallback

**Run via a subagent** (Task tool, `subagent_type: "general-purpose"`) to keep large logs out of the main context. The subagent should run `make test` from the project root and report back pass/fail with any test failures.
