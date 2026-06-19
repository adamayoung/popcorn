# Lint job failure (SwiftLint / SwiftFormat)

The **Lint** job (workflow "Lint", job `lint`) runs on macOS and installs the
tools via Homebrew, then runs:

- `swiftlint --strict .` — every warning is an error.
- `swiftformat --lint .` — fails if any file is not already formatted.

CI installs SwiftLint and SwiftFormat via `brew` (latest stable). Your local
tools should be the same versions — local `make lint` runs the identical
`swiftlint --strict .` / `swiftformat --lint .`. If local tools are older/newer
than CI's brew versions, you can see spurious failures on unchanged code.

> Formatting is normally applied automatically by the PostToolUse hook after
> edits. The lint **gate** is `make lint`. There is no `/format` or `/lint`
> skill in Popcorn — use `make lint` to check.

## Reading the failure

- SwiftLint emits `file:line:col: error: <message> (rule_id)` (CI uses the
  `github-actions-logging` reporter). The `rule_id` in parentheses is the lever —
  look it up in `.swiftlint.yml`.
- SwiftFormat `--lint` lists files it *would* change; it doesn't always say which
  rule. Run `swiftformat --lint --verbose .` locally to see the rules, or just
  format and diff.

## Common causes & fixes

1. **A real style/format violation in changed Swift.**
   - Fix: let the PostToolUse hook reformat, or run `make format`
     (`swiftlint --fix . && swiftformat .`), commit the result, then `make lint`
     to confirm clean. Most format failures need nothing more.
   - For SwiftLint rules that can't autocorrect (line length, cyclomatic
     complexity, force-unwrap/try) fix the flagged `file:line` by hand per the
     project's style. Note: SwiftFormat indents `#else` blocks deeper than the
     `#if` — accept that, don't "fix" it.

2. **Version drift — `superfluous_disable_command` on *unchanged* code.** A
   rule's behaviour changed between SwiftLint releases, so a
   `// swiftlint:disable` that was needed before is now flagged as superfluous.
   This is almost never a real violation — match your local `swiftlint version`
   to CI's brew version rather than editing the flagged `// swiftlint:disable`.

## Reproduce locally

- `make lint` — runs `swiftlint --strict .` + `swiftformat --lint .` (delegate
  to a Haiku subagent; logs stay out of context).
- `make format` — auto-fixes, then re-run `make lint`.

## Output

**Summary:** Lint job — SwiftLint/SwiftFormat — `rule_id` at `file:line`.
**Cause:** the violation (or version drift) tied to a changed file.
**Fix:** `make format` then `make lint`; or match CI's brew tool version for drift.
