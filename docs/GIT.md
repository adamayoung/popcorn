# Agent guide for using Git

## Branch Naming

- feature/description - New features
- fix/description - Bug fixes
- refactor/description - Code improvements
- docs/description - Documentation

## Commit Messages

Follow gitmoji conventions (see [gitmoji.dev](https://gitmoji.dev)):

- ✨ New feature
- 🐛 Bug fix
- ♻️ Code restructuring/refactoring
- 📚 Documentation
- ✅ Test changes
- 🎨 Code style/formatting
- 🚀 Performance improvements
- 🔒 Security fixes
- 🤖 Automated changes (formatting, code generation)

## Pre-commit Checklist

- [ ] SwiftLint passes (required)
- [ ] SwiftFormat passes (required)
- [ ] Tests pass
- [ ] No compiler warnings

## PR Workflow

1. Create feature branch from main
2. Make changes, commit often
3. Run `/format` and `/lint` before creating PR
4. Create PR with descriptive title and summary
5. Link related issues
6. Request review from [specify]

## Git instructions

- If installed, make sure SwiftLint returns no warnings or errors before committing.
- If installed, make sure SwiftFormat in lint mode returns no warnings or errors before committing.

## Creating PRs

- Create a title with appropriate gitmoji that best suits the PR based on changes on the branch when compared with main branch
- Reference [gitmoji.dev](https://gitmoji.dev) for the correct emoji
- Give a comprehensive summary of the PR with bullet points
- Include sections: Summary, Changes, Benefits (as appropriate)

## GitHub

- if installed, use the GitHub CLI
