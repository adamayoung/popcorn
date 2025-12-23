---
description: Perform a code review
---

# Code Review

I'll use the specialized code-reviewer agent to perform a comprehensive review of your current branch compared to main.

## Review Process

1. Verify current branch (must not be on main)
2. Gather uncommitted changes with `git diff HEAD`
3. Gather committed changes with `git diff origin/main...HEAD`
4. Invoke the code-reviewer agent with the complete context

The code-reviewer agent will review all changes against project standards (AGENTS.md, SWIFT.md, SWIFTUI.md, TCA.md, CLEANARCHITECTURE.md, SWIFTDATA.md) and provide severity-based feedback focusing on:

- Correctness and safety
- Swift 6.2 concurrency violations
- Architecture violations (layer boundaries, DDD principles)
- Missing or inadequate tests
- Security concerns
- Performance issues

The agent will check Apple documentation when needed to verify API behavior and availability.
