# XcodeBuildMCP Best Practices

## Always Use MCP Tools

Never use raw xcodebuild commands. Always use the appropriate MCP tool:

- Building: `mcp__xcodebuildmcp__build_sim_name_proj`
- Testing: `mcp__xcodebuildmcp__test_sim_name_proj`
- Running: `mcp__xcodebuildmcp__build_run_sim_name_proj`
- Package operations: `mcp__xcodebuildmcp__swift_package_*`
