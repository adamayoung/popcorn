---
name: test
description: Run all unit tests
---

# Run tests

**Preferred — Xcode MCP (`xcode`), when running inside Xcode.** Call it directly
(small structured result, no subagent needed):

1. Get the workspace `tabIdentifier` from `mcp__xcode__XcodeListWindows`.
2. Run `mcp__xcode__RunAllTests` with that `tabIdentifier`.
3. If a build error caused the failure, call `mcp__xcode__GetBuildLog` with the same
   `tabIdentifier` and `severity: "error"`.

**Fallback — `make`, when the MCP isn't available.** For a **long-running run you'll block on** (e.g. a `/deliver` pre-PR gate step), prefer a **backgrounded `Bash`** (`run_in_background: true`) that redirects to a log and appends `; echo "EXIT=$?"`, then — on the completion notification — grep the log for the `EXIT=` marker plus failing tests (targeted greps keep the verbose log out of context); it self-reports **once** on exit, whereas a Haiku subagent driving its own poll loop tends to return premature "still waiting" notes. Otherwise, delegate to a **Haiku subagent**
(Agent tool, `subagent_type: general-purpose`, `model: haiku`) so the output stays out
of your context. Do not run it yourself. Prompt the subagent to:

```text
Run `mkdir -p .build && make test > .build/last-test.log 2>&1`, check the exit
status, and report ONLY:
- Status: passed or failed
- Counts: total / passed / failed
- Each failing test as `SuiteName/testName` with its `file:line` and the assertion
  message (omit if none)
- On failure, the log path `.build/last-test.log`
Do not paste passing-test output or raw logs.
Run the command yourself, immediately, in the foreground — never reply before it
has finished, and never defer, poll, or say you are waiting.
You are report-only: apart from the log file the command writes, do not create,
edit, or delete any file, and never attempt to fix what you find — report it.
```

After fixing any issues, re-invoke this skill to re-check.
