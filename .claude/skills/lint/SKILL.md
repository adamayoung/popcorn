---
name: lint
description: Lint code with swiftlint and swiftformat
---

# Lint code

**Run via a subagent** (Task tool, `subagent_type: "general-purpose"`) to keep large logs out of the main context. The subagent should run `make lint` from the project root and report back pass/fail with any violations.
