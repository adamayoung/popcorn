---
name: watch-pr
description: Watch the current branch's PR (or a given PR number) — reply to and resolve review threads, fix failing checks, and optionally merge when ready
---

# Watch PR

Watch the open pull request for the current branch: handle review conversations,
fix failing status checks, and — when asked — merge once everything is green.
Repo is `adamayoung/popcorn`; `gh` is authenticated.

**Mode** — check the arguments passed to this skill (shown at the end). If they
include `merge` (e.g. `/watch-pr merge` or "merge when ready"), enable
**merge-when-ready**; otherwise run in **watch-only** mode.

**Run in the background.** Watching blocks on CI for minutes at a time, so run the
watch as a background task — the user can keep interacting while it runs, and is
pinged when the PR needs attention or is ready. Don't tie up the foreground on a
wait loop.

## 0. Find the PR

**A PR number in the arguments wins.** If the arguments include a PR number
(e.g. `/watch-pr 123` or `/watch-pr merge 123`), watch that PR and skip branch
discovery entirely — pin **every** `gh` call in this skill to it (`gh pr view
<NUMBER>`, `gh pr checks <NUMBER>`, `gh pr update-branch <NUMBER>`, `gh pr merge
<NUMBER>`, and pass it to `/fix-pr-checks`). A caller that launches this skill **in
the background** (e.g. `/deliver` Phase 10, which may move the session to another
deliverable's worktree while the watch runs) must pass the number — the watch must
never depend on "current branch" staying stable for its lifetime.

```bash
gh pr view [<NUMBER>] --json number,url,state,headRefName,mergeStateStatus,statusCheckRollup,reviewDecision
```

- No PR found (none for the current branch, or the given number doesn't resolve) →
  stop and tell the user (suggest `/pr`).
- State not `OPEN` → stop and report.

Keep a **run ledger** in your working notes: resolved thread IDs, a topic
signature per handled thread (`path:line` + short gist), and a fix-attempt
counter per failing check. Use it to avoid repeating work (see Loop Guard).

## 1. Watch loop

Repeat the pass below until the PR is **ready** (§3) or **stuck** (§2).

### 1a. Review threads

Fetch unresolved threads (use the PR number from step 0):

```bash
gh api graphql -f query='
query($owner:String!,$name:String!,$number:Int!){
  repository(owner:$owner,name:$name){
    pullRequest(number:$number){
      reviewThreads(first:100){
        nodes{
          id isResolved isOutdated path line
          comments(first:50){ nodes{ author{login} body createdAt } }
        }
      }
    }
  }
}' -f owner=adamayoung -f name=popcorn -F number=<NUMBER>
```

For each thread where `isResolved` is `false` and whose `id` is not already in
the ledger:

1. Read the comment(s) and decide whether a code change is warranted. Many
   threads come from the Claude review bot (the `claude-review` job) — weigh them on merit, not
   authority (see Loop Guard for its re-review behaviour).
2. **Needs a fix** (clear and in scope): edit the code (the PostToolUse hook formats
   each Swift file on save), then **run `make lint`** as the clean-tree gate, and
   verify with `/build-for-testing` and `/test` — plus `/test-snapshots` if the change
   touches UI/snapshots. Those skills run via the Xcode MCP or a Haiku subagent, so
   their output stays out of your context. Commit with a gitmoji message + the
   `Co-Authored-By` footer, then `git push`. Note the commit SHA.
3. **No fix warranted** (you disagree, out of scope, it's a question, or already
   done): make no code change — you'll explain in the reply.
4. **Reply** on the thread: what you assessed and whether you fixed it (include
   the commit SHA when you did):

   ```bash
   gh api graphql -f query='mutation($id:ID!,$body:String!){
     addPullRequestReviewThreadReply(input:{pullRequestReviewThreadId:$id,body:$body}){ comment{ id } }
   }' -f id=<THREAD_ID> -f body='<your feedback>'
   ```

5. **Resolve** the thread:

   ```bash
   gh api graphql -f query='mutation($id:ID!){
     resolveReviewThread(input:{threadId:$id}){ thread{ isResolved } }
   }' -f id=<THREAD_ID>
   ```

6. Record the thread ID and its topic signature in the ledger.

### 1b. Status checks

Delegate failing-check fixing to **`/fix-pr-checks`** — it lists the checks, routes
each failing one to **`/diagnose-ci-failure`** (lint / build / unit-tests / snapshot /
release-build) via a Haiku subagent so raw CI logs never enter your context, applies
and verifies the fix locally, commits, pushes **once**, and returns a summary (fixed
w/ SHAs, exhausted, skipped, pending, whether it pushed). It shares **this run's
ledger**, so the 3-attempt cap per check is honoured across passes. Fold its summary
into the ledger; if it pushed, the next pass re-checks.

The blocking checks are the CI workflows (`lint`, `unit-tests`, `snapshot`,
`release-build`). **The Claude review (the `claude-review` job in the `Claude Code`
workflow) is a non-blocking neutral check** — its output is review threads (handled in
§1a), so `/fix-pr-checks` never treats it as a failing gate.

**Waiting stays here** (orchestration, not the fix primitive): if checks are `pending`
and nothing is failing, block efficiently with `gh pr checks --watch` rather than
polling in a tight loop, then loop. If `/fix-pr-checks` reports a check **exhausted**,
stop and report it per the Loop Guard.

## 2. Loop guard (do not get stuck)

- Never reprocess a thread already in the ledger.
- **The Claude review re-reviews statelessly on every push, so its comments
  never converge on their own** — each push can spawn a fresh batch. Batch your
  fixes into as few pushes as possible. Handle substantive findings; once a round
  produces only low-severity / nitpick (L-level) comments, treat that as a **stop
  point** — reply/resolve them and stop rather than chasing an endless loop.
- If a **new** thread repeats a topic you already fixed this run, do **not**
  re-edit — reply pointing to the earlier commit SHA and resolve it.
- **Check-fix attempts are `/fix-pr-checks`' job** — it shares this ledger and caps a
  failing check at **3** fix→push attempts. If it reports a check **exhausted** (still
  failing on the same root cause after 3), **stop** and report it to the user — never
  loop forever.
- End the loop when a full pass resolves no new substantive threads and has no
  actionable check failures. Hard backstop: ~10 passes, then report and stop.
- Waiting: use `gh pr checks --watch` for in-flight CI. When only waiting on a
  human to review, pause and resume later with `ScheduleWakeup` (a few minutes
  while CI is active; longer when idle). This skill also composes with `/loop`
  if the user prefers harness-driven cadence.

## 3. Ready / merge

The PR is **ready** when every review thread is resolved AND no blocking check is
failing or pending (the Claude review being un-converged does not block).

**Ready means mergeable *now*.** Before declaring ready, check `mergeStateStatus`
(from step 0). If it is `BEHIND`, bring the branch up to date and wait for the re-run
so the PR isn't reported ready while still needing a rebase:

```bash
gh pr update-branch        # merges latest main into the PR branch
gh pr checks --watch       # wait for the re-triggered CI
```

Re-check threads + checks after the update, then proceed. (If `update-branch` reports
a conflict it can't resolve, stop and surface it to the user.)

- **Watch-only**: report "PR is ready" with a short summary (threads handled,
  checks green, branch up to date) and stop.
- **Merge-when-ready**: on ready, merge and clean up, then report the result.

  **First ensure a clean working tree** — `gh pr merge --delete-branch` switches
  to `main` and pulls afterward, which fails if anything is dirty. Building via the
  Xcode MCP can leave a stray edit in a feature's `Localizable.xcstrings`
  (`extractionState: stale`); revert any such build artifact first:

  ```bash
  git checkout -- '*.xcstrings'   # drop any build-touched string-catalog edits
  git status --porcelain          # must be empty before merging
  gh pr merge --squash --delete-branch
  ```

  **Inside a `/deliver` worktree**, merge without local cleanup — `--delete-branch`
  checks out `main`, which fails in a worktree (`main` is checked out by the main
  checkout). Use `gh pr merge <NUMBER> --squash` alone and leave branch/worktree
  cleanup to `/deliver` Phase 12's teardown.

  If `gh pr merge` reports the **server merge succeeded but local cleanup failed**
  (e.g. "cannot pull with rebase: You have unstaged changes"), the PR did merge —
  recover the local repo: confirm with `gh pr view <NUMBER> --json state` (expect
  `MERGED`), then `git checkout -- '*.xcstrings'`, `git checkout main`,
  `git pull --ff-only`, and `git branch -D <branch>`.

## Guardrails

- **Use `git push`**, never the `gh` CLI, to push commits (the `gh` push bypasses
  webhooks/workflow triggers). `gh` is only for PR/review API calls here.
- Never edit `.github/workflows/*` or other CI/config to force a check green, and
  never force-push, without surfacing to the user first.
- If a requested change is ambiguous or risky, reply on the thread with your
  assessment and leave it for the user (note it in the final summary) rather than
  guessing.
- Run the pre-PR gate (`make lint`, `/build-for-testing`, `/test`, `/test-snapshots`)
  after the **last** code change in a pass, before pushing. (Formatting is handled by
  the PostToolUse hook as files are edited.)

Arguments: $ARGUMENTS
