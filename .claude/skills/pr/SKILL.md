---
name: pr
description: Create a pull request
---

# Create a pull request

I'll create a pull request for the current branch by following these steps. If any steps fail, stop.

**Arguments:** pass `reviewed` to skip the internal code-reviewer pass (step 6) — use
this when the change has already been code-reviewed and converged (e.g. `/deliver`'s
Phase 3 already ran `/review-changes`). The review is also skipped automatically when
the diff touches no `*.swift`.

1. **The gate.** Formatting is handled automatically by the PostToolUse hook as files
   are edited, so there is no separate format step. Run the gate in order — stop on any
   failure:
   - `make lint` — the clean-tree lint gate (swiftlint `--strict` + swiftformat `--lint`
     over the whole repo; catches pre-existing violations the per-edit hook won't). Run
     it **first** (it depends on `clean-spm`, which clears build caches, so subsequent
     builds start cold — that's expected, not a hang). Delegate to a Haiku subagent.
   - **New-file re-lint:** for any file added in this branch (`git diff --diff-filter=A
     --name-only origin/main...HEAD -- '*.swift'`), run `swiftlint --no-cache` on it —
     the cache can false-green a brand-new file that CI's clean checkout would flag.
   - `/build-for-testing` — build succeeds with no warnings (warnings are errors).
   - `/test` — all unit tests pass.
   - `/test-snapshots` — all snapshot tests pass.
2. (Formatting is committed inline by the hook — no separate "apply code formatting"
   commit is needed.)
3. *(reserved)*
4. *(build is part of step 1's gate)*
5. *(tests are part of step 1's gate)*
6. **Code review** — **skip this step entirely** if `reviewed` was passed **or** the
   diff touches no `*.swift`. Otherwise spawn the `code-reviewer` agent to review all
   changes, following [`.github/CODE_REVIEW.md`](../../../.github/CODE_REVIEW.md). Pass it:
   - The full diff: `git diff origin/main...HEAD`
   - The list of changed files: `git diff --name-only origin/main...HEAD`
   - Instruct it to read full files (not just diff hunks) and compare with sibling implementations for pattern consistency
7. Summarize the code review findings:
    - List any critical or high-severity issues that should be addressed
    - List any medium-severity suggestions for improvement
    - Note any low-severity or stylistic recommendations
8. If there are critical/high-severity issues:
    - Recommend specific changes needed
    - Ask user for confirmation before proceeding (fix issues or continue anyway)
    - If user wants to fix issues, stop and let them address the feedback
9. Check if branch is up-to-date with main (warn if behind)
10. Run `git status` and `git diff origin/main...HEAD` to understand all changes
11. Analyze the commits and changes to generate an appropriate title and summary
12. Push the current branch to remote using `git push` (not `gh` CLI, which bypasses webhooks/workflows)
13. Create a PR using `gh pr create` with:
    - **IMPORTANT: Title MUST start with a gitmoji prefix** (e.g., "✨ Add new feature", "🐛 Fix bug", "📚 Improve documentation")
        - Refer to <https://gitmoji.dev> to use the correct emoji
        - Common: ✨ feature, 🐛 bugfix, ♻️ refactor, 🧪 tests, 📚 docs, 🔧 config, 🎨 style
    - A comprehensive summary with bullet points
    - Proper formatting with sections (Summary, Changes, Benefits, etc.)

The PR will include the Claude Code attribution footer.

$ARGUMENTS
