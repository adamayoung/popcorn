---
name: diagnose-ci-failure
description: Diagnose a failing CI check (lint, build, unit tests, snapshot tests, or release build) — identify which job failed, the cause, and a concrete fix
---

# Diagnose a CI workflow failure

## Overview

Popcorn's PR gate is **four blocking GitHub Actions jobs** — **Lint**, **Unit
Tests**, **Snapshot Tests**, and **Release Build**. They all gate every PR to
`main`, so a CI failure is **almost always caused by the change under review** —
a lint violation, a compile warning/error, a broken unit test, a snapshot
regression, or a Release-only compile failure. Start from the diff, not from
"maybe it's flaky".

The diagnosis differs per job, so this skill is a **router**: identify the
failing job, then follow the matching reference file for that job's causes,
fixes, and local-reproduction command.

> **`claude-review` is not a CI job.** It's a non-blocking, neutral PR check (an
> AI reviewer). A red/neutral `claude-review` does not gate merge and is not in
> scope here — only the four jobs above are.

## Agent Behaviour Contract

1. **Identify the failing job first** — `Lint`, `Build and Test` (Unit Tests),
   `Build and Snapshot Test`, or `Build (Release)`. Don't guess the cause before
   you know the job.
2. **Assume the change caused it.** CI gates the PR; read the diff and tie the
   failure to a changed file. Don't open with "transient" or "flaky".
3. **Treat warnings as errors.** Build steps fail on warnings (Swift 6.2 strict
   concurrency) — a deprecation, unused-binding, or `Sendable`/actor-isolation
   warning is a real failure.
4. **Reproduce locally before declaring a fix** using the matching tool
   (`make lint`, `/build-for-testing`, `/test`, `/test-snapshots`, or a local
   Release build).
5. **Output the three sections** (Summary / Cause / Fix) defined below — concise,
   tied to `file:line` / `Suite/test` / rule id.

## Locate the failing run

Use the first that applies:

- A path or run id the caller handed you.
- `gh pr checks` — shows which check (job) is red and its run link.
- The current branch's run via the `gh` CLI:
  `gh run list --branch "$(git branch --show-current)" --limit 5`, then
  `gh run view <id> --log-failed`.
- The unit/snapshot jobs upload a `*.xcresult.zip` artifact on failure; the
  `--log-failed` output already carries the `file:line` / failing-test lines —
  read those first.

## Quick decision tree

Once you know which job failed:

- **Lint** (`swiftlint --strict .` / `swiftformat --lint .`)?
  └─ `references/lint.md` — style/format violations + the version-drift gotcha
- **Build and Test** — the **Build** step failed (compile)?
  └─ `references/build.md` — compile errors and warnings-as-errors
- **Build and Test** — the **Unit Test** step failed?
  └─ `references/unit-tests.md` — failing `Suite/test`, view-model/mapper/SwiftData
- **Build and Snapshot Test** failed?
  └─ `references/snapshot.md` — reference-image mismatch (re-record vs regression)
- **Build (Release)** failed?
  └─ `references/release-build.md` — Release-config / `#if DEBUG` / `#Preview`

## Triage-first playbook

Symptom → next move:

- **SwiftLint rule violation (`error: … (rule_id)`)** → `references/lint.md`
- **`superfluous_disable_command` on unchanged code** → `references/lint.md` (version drift)
- **SwiftFormat `--lint` reports a file would change** → `references/lint.md`
- **`warning: … treated as error` / `error:` from the Build step** → `references/build.md`
- **A `Suite/test` recorded a failure / `#expect`/`#require` failed** → `references/unit-tests.md`
- **A test "doesn't run" / missing from the plan** → `references/unit-tests.md`
- **SwiftData crash decoding the on-disk store (`NSNumber`→`NSString`)** → `references/unit-tests.md`
- **A snapshot test fails with an image diff** → `references/snapshot.md`
- **Compiles in Debug but fails only in `Build (Release)`** → `references/release-build.md`

## Output format

Produce exactly these three sections (keep it under ~150 words; if the caller
asked for a file, write the markdown there and nothing else, otherwise reply
directly):

**Summary:** which job and step failed, and the specific error (rule /
`file:line` / failing `Suite/test`).

**Cause:** the root cause, tied to a changed file where possible.

**Fix:** the concrete next step from the relevant reference file.

## Reference files

| File | Failing job | Covers |
|------|-------------|--------|
| `references/_index.md` | — | Navigation index by job + symptom |
| `references/lint.md` | Lint | SwiftLint `--strict`, SwiftFormat `--lint`, version drift |
| `references/build.md` | Build and Test (Build step) | compile errors, warnings-as-errors |
| `references/unit-tests.md` | Build and Test (Unit Test step) | Swift Testing failures, test-plan registration, SwiftData store gotcha |
| `references/snapshot.md` | Build and Snapshot Test | reference-image mismatch, re-record vs regression |
| `references/release-build.md` | Build (Release) | Release-config / `#if DEBUG` / `#Preview` failures |
