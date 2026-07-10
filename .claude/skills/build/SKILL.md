---
name: build
description: Build the project
---

# Build project

**Preferred — Xcode MCP (`xcode`), when running inside Xcode.** It returns a small
structured result, so call it directly (no subagent needed):

1. Get the workspace `tabIdentifier` from `mcp__xcode__XcodeListWindows`.
2. Run `mcp__xcode__BuildProject` with that `tabIdentifier`.
3. On failure, call `mcp__xcode__GetBuildLog` with the same `tabIdentifier` and
   `severity: "error"` to list the errors.

**Fallback — `make`, when the MCP isn't available.** For a **long-running run you'll block on** (e.g. a `/deliver` pre-PR gate step), prefer a **backgrounded `Bash`** (`run_in_background: true`) that redirects to a log and appends `; echo "EXIT=$?"`, then — on the completion notification — grep the log for the `EXIT=` marker plus errors/warnings (targeted greps keep the verbose log out of context); it self-reports **once** on exit, whereas a Haiku subagent driving its own poll loop tends to return premature "still waiting" notes. Otherwise, delegate to a **Haiku subagent**
(Agent tool, `subagent_type: general-purpose`, `model: haiku`) so the verbose output
stays out of your context. Do not run it yourself. Prompt the subagent to:

```text
Run `mkdir -p .build && make build > .build/last-build.log 2>&1`, check the exit
status, and report ONLY:
- Status: succeeded or failed
- Error and warning counts
- Each error/warning as `file:line — message` (omit if none; warnings are errors)
- On failure, the log path `.build/last-build.log`
Do not paste raw logs or successful-compilation output.
```

After fixing any issues, re-invoke this skill to re-check.
