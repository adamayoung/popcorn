---
description: Build the project intelligently
---

# Build the project based on context

First, I'll detect what needs to be built based on the current directory and project structure.

Then I'll use the appropriate MCP tool:

- For the main app: `mcp__xcodebuildmcp__build_sim_name_proj`
- For packages: `mcp__xcodebuildmcp__swift_package_build`
- For specific schemes: Build with the detected scheme

The build will use your project's default simulator and configuration.
