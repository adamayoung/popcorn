---
name: build-for-testing
description: Build the project for testing
---

# Build for testing

Builds the app **and all test targets** (so they compile cleanly before running
tests). Like `/build`, this uses warnings-as-errors.

**Preferred — Xcode MCP (`xcode`), when running inside Xcode.** Call it directly
(small structured result, no subagent needed):

1. Get the workspace `tabIdentifier` from `mcp__xcode__XcodeListWindows`.
2. Run `mcp__xcode__BuildProject` with that `tabIdentifier` and `buildForTesting: true`.
3. On failure, call `mcp__xcode__GetBuildLog` with the same `tabIdentifier` and
   `severity: "error"`.

**Fallback — `make`, when the MCP isn't available.** For a **long-running run you'll block on** (e.g. a `/deliver` pre-PR gate step), prefer a **backgrounded `Bash`** (`run_in_background: true`) that redirects to a log and appends `; echo "EXIT=$?"`, then — on the completion notification — grep the log for the `EXIT=` marker plus errors/warnings (targeted greps keep the verbose log out of context); it self-reports **once** on exit, whereas a Haiku subagent driving its own poll loop tends to return premature "still waiting" notes. Otherwise, delegate to a **Haiku subagent**
(Agent tool, `subagent_type: general-purpose`, `model: haiku`) so the output stays out
of your context. Do not run it yourself. Prompt the subagent to:

```text
Run `mkdir -p .build && make build-for-testing > .build/last-build-for-testing.log 2>&1`,
check the exit status, and report ONLY:
- Status: succeeded or failed
- Error and warning counts
- Each error/warning as `file:line — message` (omit if none; warnings are errors)
- On failure, the log path `.build/last-build-for-testing.log`
Do not paste raw logs or successful-compilation output.
Run the command yourself, immediately, in the foreground — never reply before it
has finished, and never defer, poll, or say you are waiting.
You are report-only: apart from the log file the command writes, do not create,
edit, or delete any file, and never attempt to fix what you find — report it.
```

After fixing any issues, re-invoke this skill to re-check.
