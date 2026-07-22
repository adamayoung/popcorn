---
name: test-snapshots
description: Run snapshot tests
---

# Run snapshot tests

Runs the `PopcornSnapshotTests` test plan on the iOS Simulator. Optional argument: a
`<TestTarget>/<TestClass>` or `<TestTarget>/<TestClass>/<testMethod>` for a subset.

**Preferred — Xcode MCP (`xcode`), when running inside Xcode.** Get the
`tabIdentifier` from `mcp__xcode__XcodeListWindows`, then run
`mcp__xcode__RunAllTests` (or `mcp__xcode__RunSomeTests` with `<specifier>` for a
subset) with that `tabIdentifier`, targeting the PopcornSnapshotTests plan.

**Fallback — `make`, when the MCP isn't available.** For a **long-running run you'll block on** (e.g. a `/deliver` pre-PR gate step), prefer a **backgrounded `Bash`** (`run_in_background: true`) that redirects to a log and appends `; echo "EXIT=$?"`, then — on the completion notification — grep the log for the `EXIT=` marker plus failing/mismatched snapshots (targeted greps keep the verbose log out of context); it self-reports **once** on exit, whereas a Haiku subagent driving its own poll loop tends to return premature "still waiting" notes. Otherwise, delegate to a **Haiku subagent**
(`subagent_type: general-purpose`, `model: haiku`). Do not run it yourself. Prompt it to:

```text
Run `mkdir -p .build && make test-snapshots [TEST_CLASS=<specifier>] > .build/last-snapshots.log 2>&1`,
check the exit status, and report ONLY:
- Status: passed or failed
- Counts: total / passed / failed
- Each failing test as `SuiteName/testName` with its `file:line` (omit if none)
- On failure, the log path `.build/last-snapshots.log`
Do not paste passing-test output or raw logs.
Run the command yourself, immediately, in the foreground — never reply before it
has finished, and never defer, poll, or say you are waiting.
You are report-only: apart from the log file the command writes, do not create,
edit, or delete any file, and never attempt to fix what you find — report it.
```

Snapshot failures usually mean the rendered UI changed — inspect the failure images to
decide whether the change is intentional (and re-record if so).
