---
description: Build the project intelligently
---

# Build the project based on context

First, I'll detect what needs to be built based on the current directory and project structure.

Then I'll use the appropriate MCP tool:

- For the main app: `mcp__XcodeBuildMCP__build_sim`
- For packages: `mcp__XcodeBuildMCP__swift_package_build`
- For specific schemes: Build with the detected scheme

The build will use your project's default simulator and configuration.
