# MCP Best Practices

Always use MCP tools when available.

## XcodeBuildMCP

Never use raw xcodebuild commands. Always use the appropriate MCP tool:

### Simulator Operations
- Building: `mcp__XcodeBuildMCP__build_sim`
- Testing: `mcp__XcodeBuildMCP__test_sim`
- Running: `mcp__XcodeBuildMCP__build_run_sim`
- Boot simulator: `mcp__XcodeBuildMCP__boot_sim`
- List simulators: `mcp__XcodeBuildMCP__list_sims`
- Install app: `mcp__XcodeBuildMCP__install_app_sim`
- Launch app: `mcp__XcodeBuildMCP__launch_app_sim`

### Device Operations
- Building: `mcp__XcodeBuildMCP__build_device`
- Testing: `mcp__XcodeBuildMCP__test_device`
- List devices: `mcp__XcodeBuildMCP__list_devices`
- Install app: `mcp__XcodeBuildMCP__install_app_device`
- Launch app: `mcp__XcodeBuildMCP__launch_app_device`

### macOS Operations
- Building: `mcp__XcodeBuildMCP__build_macos`
- Testing: `mcp__XcodeBuildMCP__test_macos`
- Running: `mcp__XcodeBuildMCP__build_run_macos`
- Launch app: `mcp__XcodeBuildMCP__launch_mac_app`

### Swift Package Operations
- Building: `mcp__XcodeBuildMCP__swift_package_build`
- Testing: `mcp__XcodeBuildMCP__swift_package_test`
- Running: `mcp__XcodeBuildMCP__swift_package_run`
- Clean: `mcp__XcodeBuildMCP__swift_package_clean`

### Project Management
- Clean: `mcp__XcodeBuildMCP__clean`
- List schemes: `mcp__XcodeBuildMCP__list_schemes`
- Discover projects: `mcp__XcodeBuildMCP__discover_projs`
- Session defaults: `mcp__XcodeBuildMCP__session-set-defaults`

### UI Testing (Simulator)
- Tap: `mcp__XcodeBuildMCP__tap`
- Swipe: `mcp__XcodeBuildMCP__swipe`
- Type text: `mcp__XcodeBuildMCP__type_text`
- Screenshot: `mcp__XcodeBuildMCP__screenshot`
- Describe UI: `mcp__XcodeBuildMCP__describe_ui`

## sosumi

Use sosumi to search and fetch Apple Developer documentation:

- Search: `mcp__sosumi__searchAppleDocumentation`
- Fetch: `mcp__sosumi__fetchAppleDocumentation`

Always reference platform versions from the **Platform Targets** section in AGENTS.md.
