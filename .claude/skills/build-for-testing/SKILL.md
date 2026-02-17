---
name: build-for-testing
description: Build the project for testing
---

# Build for testing

Use the Xcode MCP if available, otherwise fall back to Make.

## Xcode MCP (preferred)

1. Run `mcp__xcode__XcodeListWindows` to get the `tabIdentifier` for the Popcorn workspace.
2. Run `mcp__xcode__BuildProject` with the `tabIdentifier`.
3. If the build fails, run `mcp__xcode__GetBuildLog` with `severity: "error"` to see errors.

Note: Xcode MCP builds for testing implicitly when using `BuildProject` with a test-enabled scheme.

## Fallback

Run `make build-for-testing` from the project root.
