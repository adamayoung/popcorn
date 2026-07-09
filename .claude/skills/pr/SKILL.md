---
name: pr
description: Create a pull request
---

# Create a pull request

I'll create a pull request for the current branch by following these steps. If any steps fail, stop.

**Arguments:** pass `reviewed` to skip the internal code-reviewer pass (step 4) — use
this when the change has already been code-reviewed and converged (e.g. `/deliver`'s
Phase 3 already ran `/review-changes`). The review is also skipped automatically when
the diff touches no `*.swift`.

1. **Commit all outstanding work.** Formatting is applied automatically by the
   PostToolUse hook as files are edited, so there is no separate format step. Run `git
   status`; if the working tree has any uncommitted/unstaged changes, stage and commit
   them — the PR reflects **committed history only**, so anything left uncommitted is
   **missing from the PR**. First **verify no secrets, `.env`, or build artifacts** are
   included (`.env` must stay gitignored; check `git status` before `git add`). Use a
   descriptive gitmoji message. If the tree is already clean (e.g. work was committed
   during `/deliver`), this is a no-op.
2. **Rebase onto the latest `origin/main`.** Fetch the remote and rebase the feature
   branch directly onto `origin/main` — do this **before** the gate so the gate (and
   the eventual PR) reflects the real merge result, not stale code:

    ```bash
    git fetch origin
    git rebase origin/main
    ```

    - **Rebase onto `origin/main`, not local `main`** — this is **worktree-safe**. A
      `/deliver` runs inside a git worktree, and `git checkout main` there fails
      (`fatal: 'main' is already used by worktree …`) whenever the main checkout is on
      `main`; rebasing onto `origin/main` avoids checking `main` out at all and uses
      the true remote base directly.
    - If `git rebase` reports conflicts, **stop**, resolve them, then continue. Never
      skip or force past a conflict you don't understand.
    - The rebase rewrites the branch tip, so a branch that was **already pushed** needs
      `git push --force-with-lease` at the push step below.
    - Already branched off an up-to-date `origin/main` with nothing to replay → fast
      no-op.
3. **The gate** — run in order, stop on any failure (the rebase above means this runs
   against the post-merge tree). Scale it to the diff first:
   - **Docs-only fast gate.** When the diff touches **no build- or test-affecting
     files** — no `*.swift` and none of `Makefile`, `Package.swift`/`Package.resolved`,
     `*.xctestplan`, `*.xcconfig`, `*.pbxproj`, `*.xcstrings`, or
     `.github/workflows/**` — the build/test legs have nothing to exercise: run
     `make lint` only and skip the rest of this step. Detect with:

     ```bash
     git diff --name-only origin/main...HEAD \
       | grep -qE '\.swift$|Makefile|Package\.(swift|resolved)$|\.xctestplan$|\.xcconfig$|\.pbxproj|\.xcstrings$|^\.github/workflows/' \
       && echo "code/build touched → full gate" \
       || echo "docs-only → make lint only"
     ```

     The PR's own CI still runs its full matrix regardless — this only trims the
     **local** gate; it never lowers what actually guards `main`. When in doubt, run
     the full gate.
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

   If the gate fails, stop and fix — **commit the fixes** — then re-run; never open a PR
   on a red gate.
4. **Code review** — **skip this step entirely** if `reviewed` was passed **or** the
   diff touches no `*.swift`. Otherwise spawn the `code-reviewer` agent to review all
   changes, following [`.github/CODE_REVIEW.md`](../../../.github/CODE_REVIEW.md). Pass it:
   - The full diff: `git diff origin/main...HEAD`
   - The list of changed files: `git diff --name-only origin/main...HEAD`
   - Instruct it to read full files (not just diff hunks) and compare with sibling implementations for pattern consistency
5. Summarize the code review findings:
    - List any critical or high-severity issues that should be addressed
    - List any medium-severity suggestions for improvement
    - Note any low-severity or stylistic recommendations
6. If there are critical/high-severity issues:
    - Recommend specific changes needed
    - Ask user for confirmation before proceeding (fix issues or continue anyway)
    - If user wants to fix issues, stop and let them address the feedback
7. **Ensure a clean working tree before pushing.** Re-run `git status`; commit anything
   still outstanding (review fixes from steps 4–6, or gate fixes) so the push includes
   everything. Then run `git diff origin/main...HEAD` to understand all changes.
8. Analyze the commits and changes to generate an appropriate title and summary
9. Push the current branch to remote using `git push` (not `gh` CLI, which bypasses
   webhooks/workflows) — use `git push --force-with-lease` if you rebased in step 2.
10. Create a PR using `gh pr create` with:
    - **IMPORTANT: Title MUST start with a gitmoji prefix** (e.g., "✨ Add new feature", "🐛 Fix bug", "📚 Improve documentation")
        - Refer to <https://gitmoji.dev> to use the correct emoji
        - Common: ✨ feature, 🐛 bugfix, ♻️ refactor, 🧪 tests, 📚 docs, 🔧 config, 🎨 style
    - A comprehensive summary with bullet points
    - Proper formatting with sections (Summary, Changes, Benefits, etc.)

The PR will include the Claude Code attribution footer.

$ARGUMENTS
