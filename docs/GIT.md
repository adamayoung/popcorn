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
3. Run the full Pre-PR Checklist (see CLAUDE.md): `make lint`, `/build-for-testing`, `/test`, `/test-snapshots` (formatting is applied automatically by the PostToolUse hook)
4. Create PR with descriptive title and summary
5. Link related issues

## Creating PRs

### PR Title Format

**Required format**: `<gitmoji> <description>`

Examples:
- `✨ Add user authentication`
- `🐛 Fix movie caching bug`
- `♻️ Refactor navigation stack`

Use the gitmoji that best matches the primary change. Reference [gitmoji.dev](https://gitmoji.dev) for the correct emoji.

### PR Description

- Give a comprehensive summary of the PR with bullet points
- Include sections: Summary, Changes, Benefits (as appropriate)

## GitHub

- Use the GitHub CLI (`gh`) for PR operations
