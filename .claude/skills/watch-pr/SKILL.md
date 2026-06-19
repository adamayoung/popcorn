---
name: watch-pr
description: Watch the current branch's PR — reply to and resolve review threads, fix failing checks, and optionally merge when ready
---

# Watch PR

Watch the open pull request for the current branch: handle review conversations,
fix failing status checks, and — when asked — merge once everything is green.
Repo is `adamayoung/popcorn`; `gh` is authenticated.

**Mode** — check the arguments passed to this skill (shown at the end). If they
include `merge` (e.g. `/watch-pr merge` or "merge when ready"), enable
**merge-when-ready**; otherwise run in **watch-only** mode.

## 0. Find the PR

```bash
gh pr view --json number,url,state,headRefName,mergeStateStatus,statusCheckRollup,reviewDecision
```

- No PR for the current branch → stop and tell the user (suggest `/pr`).
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
   threads come from the `claude-code-review` bot — weigh them on merit, not
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

```bash
gh pr checks --json name,state,bucket,link
```

Classify by `bucket`: `fail` = failing, `pending` = in progress, `pass` /
`skipping` = fine. The blocking checks are the CI workflows (`unit-tests`,
`lint`, `snapshot`, `release-build`). **`claude-code-review` is a non-blocking
neutral check** — its output is review threads (handled in §1a), so never treat
it as a failing gate. While anything is pending, block efficiently with
`gh pr checks --watch` rather than polling in a tight loop.

For each **failing** check, delegate log retrieval to a **Haiku subagent** so raw
CI logs never enter your context. Use the Agent tool with
`subagent_type: general-purpose` and `model: haiku` and this prompt:

```text
Find why the `<CHECK NAME>` check failed on the Popcorn PR for branch `<branch>`
and report concisely.

1. Run `gh run list --branch <branch> --limit 5 --json databaseId,name,conclusion`
   to find the failed run id.
2. Run `gh run view <id> --log-failed`.

Report back ONLY:
- The failing job/step
- The root cause
- The offending `file:line` and message (if any)

Do not paste raw logs.
```

Then fix the issue (the hook formats edited Swift files), run `make lint`, verify with
the matching skill (`/build-for-testing`, `/test`, `/test-snapshots`), commit (gitmoji +
`Co-Authored-By`), and `git push` — the push re-triggers CI. Increment that check's
attempt counter.

## 2. Loop guard (do not get stuck)

- Never reprocess a thread already in the ledger.
- **`claude-code-review` re-reviews statelessly on every push, so its comments
  never converge on their own** — each push can spawn a fresh batch. Batch your
  fixes into as few pushes as possible. Handle substantive findings; once a round
  produces only low-severity / nitpick (L-level) comments, treat that as a **stop
  point** — reply/resolve them and stop rather than chasing an endless loop.
- If a **new** thread repeats a topic you already fixed this run, do **not**
  re-edit — reply pointing to the earlier commit SHA and resolve it.
- A failing check gets at most **3** fix→push attempts. If it still fails with
  the same root cause, **stop** and report it to the user — never loop forever.
- End the loop when a full pass resolves no new substantive threads and has no
  actionable check failures. Hard backstop: ~10 passes, then report and stop.
- Waiting: use `gh pr checks --watch` for in-flight CI. When only waiting on a
  human to review, pause and resume later with `ScheduleWakeup` (a few minutes
  while CI is active; longer when idle). This skill also composes with `/loop`
  if the user prefers harness-driven cadence.

## 3. Ready / merge

The PR is **ready** when every review thread is resolved AND no blocking check is
failing or pending (`claude-code-review` being un-converged does not block).

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
