---
name: format
description: Format code with swiftlint and swiftformat
---

# Format code

**Run via a subagent** (Task tool, `subagent_type: "general-purpose"`) to keep large logs out of the main context. The subagent should run `make format` from the project root and report back pass/fail with any errors or files changed.
