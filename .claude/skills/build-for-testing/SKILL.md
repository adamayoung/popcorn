---
name: build-for-testing
description: Build the project for testing
---

# Build for testing

**Run via a subagent** (Task tool, `subagent_type: "general-purpose"`) to keep large logs out of the main context. The subagent should run `make build-for-testing` from the project root and report back pass/fail with any errors.

This differs from `/build` (`make build`) in that it also compiles all test targets, ensuring they build cleanly before running tests. Both use warnings-as-errors.
