# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**⚠️ IMPORTANT**: Keep this documentation updated! Run `/update-docs` after significant changes.
**Last Updated**: [CURRENT_DATE]

## 📋 Documentation Maintenance

- **When to Update**: After adding features, changing architecture, or modifying workflows
- **Update Command**: Use `/update-docs` to refresh all CLAUDE.md files
- **Optimize Setup**: Use `/claude-optimize` to analyze and improve configuration
- **Review Schedule**: Check documentation accuracy weekly

## Quick Reference

**Project**: [PROJECT_NAME - from analysis]
**Language**: Swift [VERSION - from analysis]
**Platform**: [iOS/macOS/etc - from analysis]
**Architecture**: [Detected pattern - SwiftUI/UIKit/etc]
**Key Command**: Build and test via MCP tools

## 🔧 XcodeBuildMCP Integration

**IMPORTANT**: This project uses XcodeBuildMCP for all Xcode operations. The MCP server is automatically available in Claude Code.

### Why XcodeBuildMCP?

- Provides intelligent, context-aware Xcode operations
- Automatically handles simulator management
- Simplifies device deployment
- Offers better error handling than raw xcodebuild

### Common MCP Operations

```swift
// Building
mcp__xcodebuildmcp__build_sim_name_proj      // Build for simulator
mcp__xcodebuildmcp__build_dev_proj           // Build for device

// Testing
mcp__xcodebuildmcp__test_sim_name_proj       // Test on simulator
mcp__xcodebuildmcp__swift_package_test       // Test Swift packages

// Running
mcp__xcodebuildmcp__build_run_sim_name_proj  // Build and run on simulator
mcp__xcodebuildmcp__launch_app_sim           // Launch existing app

// Utilities
mcp__xcodebuildmcp__clean_proj               // Clean build artifacts
mcp__xcodebuildmcp__list_sims                // List available simulators
mcp__xcodebuildmcp__screenshot               // Take simulator screenshot
```