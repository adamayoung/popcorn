---
description: Perform a code review
---

# Code Review

I'll perform a comprehensive code review for the current branch compared to main, including both committed and uncommitted changes.

## Review Process

1. Check current branch and ensure not on main
2. Show uncommitted changes with `git diff HEAD`
3. Show committed changes with `git diff origin/main...HEAD`
4. Review Swift source files only (exclude build artifacts, dependencies)
5. Check against project conventions and best practices
6. Provide structured, actionable feedback

## Documentation References

Review code against these project standards:

- **AGENTS.md** - Overall architecture and conventions
- **SWIFT.md** - Swift 6.2 patterns and modern API usage
- **SWIFTUI.md** - SwiftUI best practices and anti-patterns
- **TCA.md** - The Composable Architecture patterns
- **CLEANARCHITECTURE.md** - Layer boundaries and DDD principles
- **SWIFTDATA.md** - CloudKit and persistence patterns
- **GIT.md** - Commit message conventions (gitmoji)

## Focus Areas

- **Swift 6.2 Concurrency**: Check for strict concurrency violations, proper `@MainActor` usage
- **TCA Patterns**: Reducer structure, dependency injection, navigation patterns
- **Layer Boundaries**: No domain leaking into infrastructure, proper mapper usage
- **SwiftData**: CloudKit compatibility (no `@Attribute(.unique)`, optional properties)
- **Modern APIs**: SwiftUI vs deprecated patterns, modern Foundation usage
- **Security**: No exposed secrets, API keys, or credentials
- **Test Coverage**: Business logic has tests, TCA reducers tested
- **Performance**: Heavy computations not in view body, efficient data flow

## Feedback Format

Provide feedback in this structured format:

### Summary

[Overall assessment of the changes]

### Critical Issues 🔴

[Bugs, security vulnerabilities, breaking changes that must be fixed]

### Suggestions 🟡

[Improvements, refactoring opportunities, better patterns]

### Positive Notes ✅

[Well-written code, good patterns, thoughtful implementations]

### Action Items

[Specific, actionable fixes with code examples where helpful]

## Review Guidelines

For each issue identified:

- **What's wrong**: Describe the issue clearly
- **Why it matters**: Explain the impact or risk
- **How to fix**: Provide specific code changes or guidance
- **Reference**: Link to relevant documentation (e.g., SWIFTUI.md:42)

Be constructive and helpful in your feedback.
