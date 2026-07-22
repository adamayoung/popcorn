---
name: fix-pr-checks
description: Fix the currently-failing status checks on the current branch's PR in one sweep — route each failing check to /diagnose-ci-failure (via a Haiku subagent), apply and verify the fix, commit, and push once — then return a summary. Use standalone when CI is red, or as the check-fixing step invoked by /watch-pr. Repo is adamayoung/popcorn.
---

# Fix PR Checks

Get a pull request's **failing checks** green: for each failing blocking check,
diagnose the cause, apply and verify a fix, and push. This is a **single sweep**
over the checks failing *right now* — it diagnoses and fixes them, pushes once,
and returns. Waiting on pending checks and deciding whether to sweep again belong
to the caller (you, or `/watch-pr`).

Repo is `adamayoung/popcorn`; `gh` is authenticated.

## The four blocking checks

Popcorn's gate is exactly four jobs: **Unit Tests** (`Build and Test`), **Lint**,
**Snapshot Tests** (`Build and Snapshot Test`), and **Release Build**
(`Build (Release)`). `claude-review` is a **non-blocking neutral** check — never
act on it, never wait on it.

## It stands on the diagnosis skill

Don't read CI logs yourself. The analysis is already a capability — delegate it to
a **Haiku subagent** running `/diagnose-ci-failure`, so raw logs never enter your
context and you get back a `file:line` cause and a concrete fix. Every blocking
check routes to that one skill (lint, build, unit tests, snapshot, release) —
there is no separate integration diagnosis in Popcorn.

This skill is the **act-on-it** layer: route → fix → verify → commit → push.

## Principles

1. **One sweep, then return.** Handle every check failing at invocation, push
   once, report. Don't loop waiting for the re-run — that convergence is the
   caller's job.
2. **Diagnose via Haiku, fix locally.** Get Cause/Fix from `/diagnose-ci-failure`,
   then apply it and **verify before claiming it fixed** with the delegated
   build/test skills.
3. **Respect the attempt cap.** A check gets at most **3** fix→push attempts
   (tracked in the run ledger). If it still fails on the same root cause, stop
   touching it and report it exhausted — never loop forever.
4. **Failing only.** Act on `fail` checks. `pending` checks are not yours to
   chase — report them and leave waiting to the caller. `claude-review` and other
   neutral checks are non-blocking — ignore them.
5. **Never fake green.** Don't edit `.github/workflows/*` or CI config to silence a
   check, and don't force-push, without surfacing to the user first.

## 0. Find the PR

```bash
gh pr view --json number,url,state,headRefName
```

- An explicit PR number in the arguments overrides the current branch.
- No PR for the current branch → stop and tell the user (suggest `/pr`).
- State not `OPEN` → stop and report.

## 1. List the checks

```bash
gh pr checks --json name,state,bucket,link
```

Classify by `bucket`: `fail` = fix it (below); `pending` = report and leave for
the caller to wait on; `pass` / `skipping` / neutral (`claude-review`) = ignore.
If nothing is failing, return immediately (note any pending checks).

## 2. Diagnose each failing check (Haiku)

For each `fail` check under its attempt cap, spawn a diagnosis subagent — Agent
tool, `subagent_type: general-purpose`, `model: haiku` — substituting the check
name:

```text
The `<CHECK NAME>` check failed on the Popcorn PR for branch `<branch>`.

Use the `/diagnose-ci-failure` skill to diagnose it. The skill identifies the
failing job, locates the run, reads the log, and maps it to a cause and fix.

Report back ONLY the skill's three-section result — Summary, Cause, Fix —
including the offending `file:line` (or `Suite/test` / `rule_id`). Do not paste
raw logs. Start the diagnosis immediately and reply only when it is complete —
never defer or say you are waiting. You are diagnosis-only: do not create, edit,
or delete any file, and never apply the fix yourself — the caller applies it.
```

## 3. Apply, verify, commit

From the returned Cause/Fix:

1. **Apply the fix** to the offending `file:line`.
2. **Verify locally** with the matching delegated skill — `make lint` (Lint),
   `/build-for-testing` (Build), `/test` (Unit Tests), `/test-snapshots`
   (Snapshot), or a local `-configuration Release` build (Release Build). They
   run in Haiku subagents; logs stay out of context.
3. **Commit** with a gitmoji message; record the SHA. **Batch the sweep's
   pushes** — commit per fix, but `git push` **once** after all failing checks are
   handled (§4), so the re-run covers everything in one CI cycle.
4. Increment that check's attempt counter in the ledger.

If the diagnosis is ambiguous or the fix is risky (e.g. a snapshot diff you can't
confidently classify as re-record vs regression), don't guess — leave the check,
note it for the user, and move on.

## 4. Push once, then finish

After all failing checks are handled, if you committed any fixes, `git push`
once (it re-triggers CI — expected). Always use `git push`, never `gh` push.

## Return: sweep summary

Report, concisely:

- **Fixed** — check name → cause (`file:line`) → commit SHA.
- **Exhausted** — checks at the 3-attempt cap still failing on the same root
  cause; stop and hand to the user.
- **Skipped/ambiguous** — failing checks you intentionally left (risky/unclear),
  with why.
- **Pending** — checks still in progress, left for the caller to wait on.
- Whether you pushed (and thus re-triggered CI) so the caller can decide whether
  to sweep again.

Arguments: $ARGUMENTS
