---
description: Create a pull request
---

# Create a pull request

I'll create a pull request for the current branch by following these steps. If any steps fail, stop.

1. Run `/format` to format code
2. Check for formatting changes and commit them if needed with message "🤖 apply code formatting"
3. Run `/lint` to verify code style and quality
4. Run `/test` to verify all tests pass
5. Run `/build` to ensure project builds successfully
6. Check if branch is up-to-date with main (warn if behind)
7. Run `git status` and `git diff origin/main...HEAD` to understand all changes
8. Analyze the commits and changes to generate an appropriate title and summary
9. Push the current branch to remote if not already pushed
10. Create a PR using `gh pr create` with:
    - A descriptive title with gitmoji prefix (e.g., "✨ Add new feature" or "📚 Improve documentation")
        - Refer to <https://gitmoji.dev> to use the correct emoji
    - A comprehensive summary with bullet points
    - Proper formatting with sections (Summary, Changes, Benefits, etc.)

The PR will include the Claude Code attribution footer.

$ARGUMENTS
