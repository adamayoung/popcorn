---
name: deliver
description: Take the current plan all the way to a ready-to-merge pull request — review the plan (scaled to risk), implement it test-first, code-review and fix, security-review, verify the acceptance criteria, open the PR, and watch it green. Use after you have an approved plan (e.g. from plan mode) and want the rest of the feature pipeline run end-to-end. Invoking it is itself plan approval — it then runs autonomously to a single hard stop: ready-to-merge.
---

# Deliver

Drive the **current plan** through the whole feature pipeline to a PR that is
green and ready to merge. This skill is an **orchestrator** — it sequences the
existing skills and adds the safety gates; the expertise lives in the pieces
it invokes. It runs **autonomously** from invocation (which is itself plan
approval) to a single hard stop — **ready-to-merge** — auto-scaling its
machinery to the change's risk, and writing a short **retrospective** that
rides the delivery's own PR. Every run happens in its **own git worktree**
(Phase 1; torn down on merge, Phase 12) so the user's main checkout stays
free. The plan is created first with plan mode — `/deliver` picks up from
there.

```text
you approve the plan ─▶ /deliver ─▶ entry gate (ACs?) ─▶ worktree ─▶ [review-plan] ─▶
  implement ─▶ code-review + fix ─▶ security-review + fix ─▶ capture ─▶
  rubric check (ACs met?) ─▶ retro (pre-PR) ─▶ /pr reviewed ─▶ /watch-pr ─▶
  GATE: ready-to-merge ─▶ wrap-up (wiki + recurring-pattern scan)
  ▲ the only hard stop
  … then, when the PR actually merges (maybe a later session): teardown (Phase 12)
```

**Detail on demand:** procedures, traps, and incident history live in
[`references/`](references/) — read the named file when its phase arrives,
not up front.

## Agent Behaviour Contract

Non-negotiable. Do these by default, without being reminded.

1. **Invoking `/deliver` is plan approval — run autonomously to the one
   gate** (the diagram above), with no second "is the plan ok?" prompt. The
   only legitimate mid-run pauses: a **blocker** from `/review-plan`
   (Phase 2), or a **red gate you cannot triage** (§4).
2. **Delegate to the existing skills — don't reinvent them**: `/review-plan`,
   `/implement-plan`, `/review-changes`, `/security-review`,
   `/capture-knowledge`, `/pr`, `/watch-pr`, `/fix-pr-checks`.
3. **Never work on `main` — always in a fresh worktree**, entered **before**
   `/review-plan` or any file edit (`CLAUDE.md` forbids editing `main`).
4. **A red gate triages before it stops.** In-diff failure → fix test-first
   and re-run. Pre-existing/unrelated (a check not touching your diff, often
   a transient CI flake) → re-run once; still red and not yours → **surface
   it to the user** — Popcorn has no off-branch self-heal path, so never
   patch someone else's failure onto this branch, and never hard-stop on it
   silently. Only a genuine, in-diff, unfixable break stops the pipeline.
5. **Test-first all the way.** Every review-loop fix follows `canon-tdd` —
   failing test first. No untested patches.
6. **Keep a durable phase ledger** — a `TaskCreate` list, one task per phase,
   statuses current, recording branch, PR number, and weight. A
   template→replicate delivery adds the **`Phase 4a — reference-unit
   review`** gate task, which **blocks Phase 9**. A multi-deliverable plan
   keeps one ledger sub-tree per deliverable.
7. **Jot knowledge candidates the moment a learning occurs** (a lookup, a
   gotcha, a SwiftData/CloudKit or TMDb-mapping surprise, a non-obvious
   decision) — one line each (`<category>: <gist> [where]`), in the ledger.
   Phase 6 curates them; reconstruction later loses the best material.
8. **Auto-start after plan-mode approval.** `ExitPlanMode` approval IS the
   start signal — invoke `/deliver` immediately; pause first only if
   Phase 0's entry gate fires.

## Auto mode & async invocation

`/deliver auto` replaces every stop-and-ask decision with an **adversarial
panel** of three Opus subagents (majority verdict, ledger audit trail);
decision points are marked **Auto:** below. Never delegated: a **data-loss or
breaking-change plan blocker is a hard stop even in auto**. `/deliver` can
also be queued headless (the plan + ACs must travel in the trigger prompt).
Panel procedure and queuing caveats:
[`references/auto-and-async.md`](references/auto-and-async.md). In attended
mode the **Auto:** branches do not apply — stop and ask, as written.

## Delivery weight — auto-scale to risk

Judge from the plan; re-confirm from the diff after Phase 3; record in the
ledger. **Lite** — small, mechanical, single-unit, no risky surface (no
concurrency (`Task`/actor/`Sendable`), SwiftData `@Model`/CloudKit-schema, or
migration changes; no factory/navigator wiring or feature-flag/Statsig
gating; no new public API beyond a simple additive method; single package;
under a few hundred changed lines) ⇒ skip `/review-plan`'s critics;
`/review-changes` takes its single-reviewer path. **Full** — anything risky
or large. **When unsure, prefer full.**

**Per-unit novelty — a second axis on top of Lite/Full.** Weight scales the
machinery to *size and risk*; novelty scales it to *how much of the diff is
genuinely new*. During Phase 3, tag each cohesive unit in the ledger as either
`novel` or `clone-of:<merged-sibling-path>`. A unit is a **clone** only when it
is a wholesale copy of a sibling that is **already merged on `main`** (so
already reviewed), with differences limited to mechanical renames/substitutions
plus a short, enumerable set of intended deviations (the context dependency, a
transition-context string, accessibility IDs, localization values). "Looks like
a clone" ≠ "is a clone" — the **parity diff in Phase 4** is what proves it, and
any non-mechanical delta reclassifies the unit `novel`. Novelty is judged **per
unit, not per PR**: a PR can hold a genuine clone package *and* new
migration/context code that only mirrors a sibling's *shape* — the latter is
`novel` and gets the full fan-out. Clone units take the parity lane (Phase 4)
and the `cp`+`sed` implementation path (Phase 3); `novel` units are unchanged.

## Multi-deliverable plans — one run, several PRs

A plan that is a *program* of cohesive deliverables becomes **one PR per
deliverable**. Decompose in Phase 0 with a dependency graph: **dependent**
(consumes a type/API/helper/file another introduces *or substantially
changes*) → **sequence** it
(branch off its dependency, or wait for its merge); **independent** → own
worktree + branch + PR; **unsure → treat as dependent**. Execution is
**serial implement, concurrent watch**: one deliverable at a time through
Phases 1→9, but once its PR is open, start its `/watch-pr` **in the
background** and move to the next. The gate reports the **batch**; each
worktree is torn down as *its* PR merges; a stuck PR never blocks the others.
The full per-deliverable pipeline applies unchanged. (Genuinely parallel
implementation = separate `/deliver` sessions.)

## Context & isolation (by design)

- The conductor stays **lean** (plan reference, ledger, gate, short per-phase
  summaries); heavy work is already isolated in Workflows/subagents (the
  `/review-plan` critics, the `code-reviewer` fan-out, the backgrounded-shell /
  Haiku build/test runners) — keep it that way.
- **Implement runs inline — on purpose** (the TDD list stays visible). Do
  **not** convert it to a silent subagent.
- **The gate stays in the main agent**; phases hand off via git / disk / the
  PR, not context.
- Separate worktrees get separate `DerivedData`/`.build` dirs; run builds
  sequentially *within* one worktree. **Inside a worktree, build/test via
  `make`, not the Xcode MCP** — Xcode has the *main checkout's* workspace open
  ([`references/worktree-lifecycle.md`](references/worktree-lifecycle.md)). For
  a **long-running gate run you'll block on** (Phase 9), prefer a **backgrounded
  `Bash`** (`run_in_background: true`) that logs to a file and appends
  `; echo "EXIT=$?"`, then grep the log for the exit marker + errors on the
  completion notification — it self-reports **once** on exit, whereas a Haiku
  subagent driving its own poll loop returns premature "still waiting" notes.
  **Never nest `&` inside that command** (`( make … ) &`) — the harness already
  backgrounds it for you, so an extra `&` detaches the real command and the
  wrapper script exits immediately, making the harness report the wrapper's
  premature `exit 0` rather than the gate's true result. Let the backgrounded job
  run the command in its foreground (`make … > log 2>&1; echo "EXIT=$?" >> log`).
  A Haiku subagent is still right for short, foreground summaries.

## Phase 0 — Preconditions

- **A plan must exist** (named target → plan-mode plan → most recent in
  conversation). None → stop; point at plan mode. Never invent one.
- **A plan born from a review finding is a hypothesis** — verify against the
  code (quick `Explore`) *before* planning or asking strategy questions.
- **State the goal** in a sentence; **judge the weight**; open the ledger.
- **Pull wiki context** best-effort (`get_context` on the goal) and skim the
  auto-memory (`MEMORY.md`) for durable preferences and prior decisions;
  degrade silently if a store is absent.
- **Consult the knowledge base** — skim the entry headings of
  [`knowledge/gotchas.md`](../../../knowledge/gotchas.md), read the entries
  (and any [`knowledge/decisions/`](../../../knowledge/decisions/) ADR)
  relevant to the goal's area, and record one
  `consulted: <entries | none relevant>` line in the ledger. Captured
  knowledge only compounds if it is read at entry — the ledger line is what
  makes this step checkable.
- **Decompose a multi-deliverable plan** (rules above); single-deliverable
  plans skip this.
- **Entry gate — acceptance criteria required.** Plans are expected as
  *"As a \<user-type\> I want \<feature\> so that \<reason\>"* + acceptance
  criteria. Extract the ACs verbatim as
  the **delivery rubric** (consumed in Phase 7) into the ledger. Absent →
  stop and ask for them ("Given X, when Y, then Z") — don't enter the
  worktree. **Auto:** panel — proceed rubric-less (Phase 7 no-ops) vs stop.
- **Read the plan's content into context now** — `EnterWorktree` switches CWD
  (clearing the plans cache), and a fresh worktree lacks uncommitted local
  files; the plan must travel in the conversation.

## Phase 1 — Enter an isolated worktree (before any edit)

Procedures and traps:
[`references/worktree-lifecycle.md`](references/worktree-lifecycle.md).

1. **GC first**: reclaim prior worktrees whose PRs have since merged (one
   `list_pull_requests` call → branch→merged map → remove) — this sweep keeps
   unattended runs from leaking disk.
2. **Enter** with `EnterWorktree(name: "<prefix>/<slug>")` (`feature/`,
   `fix/`, `chore/`, …) — sanctioned auto-use, don't ask. **Verify the branch
   name afterwards** (`git branch --show-current`; `git branch -m` if the
   tool renamed it). Already in a worktree? Don't nest — branch there.
3. **Copy the gitignored files in** from the main checkout:
   `.claude/settings.local.json` (the permission allowlist) **and**
   `Configs/Secrets.xcconfig` (the app and app-hosted tests crash at launch
   without `TMDB_API_KEY`).
4. **Record worktree + branch in the ledger, and (re-)create the ledger
   here** — it is CWD-scoped and cleared by `EnterWorktree`, an MCP
   reconnect, or a plan-mode exit; found empty later → re-create from the
   phase list, it isn't lost work.
5. **Edit via worktree paths**: re-`Read` anything read before entering, and
   **verify `git status` shows your diff in the worktree before trusting the
   first green build** (empty diff + baseline counts = edits went to `main`).

Invoked from plan mode? That approval *is* the start signal — exit plan mode,
enter, proceed.

## Phase 2 — Harden the plan (no approval stop)

**Lite, or already reviewed this session** (a converged `/review-plan`, or
`ExitPlanMode` approval) → skip the critics. **Full with an unreviewed plan**
→ invoke `/review-plan`, present the revised plan + a one-line change log
(applied / rejected) as an **FYI**, keep going —
except a **blocker** (wrong approach, breaking, data-loss, a CloudKit
migration that would drop data), which stops the run. **Auto:**
data-loss/breaking = hard stop (never delegated); other blockers → panel.

## Phase 3 — Implement the plan

Invoke **`/implement-plan`** (Canon TDD: list shown first, one failing test
at a time, done only when the list is empty and `/test`, `/test-snapshots`,
and `/build-for-testing` are green). It commits at logical checkpoints —
required: Phase 4 reviews **committed** history. Don't advance until the
suites pass and the work is committed; re-confirm the weight from the diff.
**Record the green-gate SHA in the ledger** — the HEAD commit at which the
finishing gate (`build-for-testing` + `test` + `test-snapshots`) last passed;
update it after any Phase 4/5 code fix that re-runs that gate green (a fix that
is *not* re-gated green does not update it, so Phase 9 then runs the full gate).
Phase 9 passes this SHA to `/pr` to skip a redundant build/test when only docs
changed since. Popcorn bookkeeping: a new `FeatureFlag` needs its Statsig gate (CLAUDE.md →
*Feature flag creation*); a new unit-test target needs registering in
`TestPlans/PopcornUnitTests.xctestplan` (snapshot targets in the snapshot
plan). Hard checkpoints:

- **"Fix every instance of pattern X" → enumerate ALL sites up front** with a
  single **type-driven sweep**, listed in the test list before implementing —
  piecemeal discovery ships subsets (incidents:
  [`references/review-loops.md`](references/review-loops.md)).
- **A clone unit (`clone-of:<sibling>`) → implement by `cp -R` + ordered
  `sed`, not by hand.** Copy the already-merged sibling wholesale and
  substitute; it inherits the sibling's tests and formatting. Two traps:
  substitute the *specific* product/module names **before** the generic rename,
  and rename **dirs before files in two passes** (full procedure and the
  snapshot / `.swiftformat` traps:
  [`references/review-loops.md`](references/review-loops.md)).
- **Consult the specialist skills — mandatory, topic-triggered, including for
  fanned-out subagents.** `swift-concurrency` the moment actors,
  `@MainActor`, `Sendable`/`@unchecked Sendable`, locks, `Task`/task groups,
  or any data-race question appears — to *design*, not just debug;
  `swift-testing-expert` when writing or structuring tests;
  `swiftui-expert` / `swiftui-accessibility-expert` for view work;
  `swiftdata-expert` for `@Model`/CloudKit/migration work;
  `snapshot-testing-expert` when adding or re-recording snapshots. Same in
  Phase 4: run concurrency-sensitive findings through `swift-concurrency`
  before accepting or dismissing them.

## Phase 4 — Code review + fix loop

**Skip entirely if the diff has no Swift source** (`/review-changes`
self-gates). Review **stable** code once the design settles — not per TDD
item. Granularity by weight:

- **Lite / single-unit** → one review of the full diff (single-reviewer
  path).
- **Full, template→replicate** (one pattern across N≥3 cohesive units) →
  **review the reference unit before the rest are generated**: the hard
  `Phase 4a — reference-unit review @ <sha>` ledger task **blocks Phase 9**
  (procedure: [`references/review-loops.md`](references/review-loops.md)).
- **Full, otherwise** → one review of the full end diff via the fan-out
  path; do **not** interleave per unit.
- **Clone of a merged sibling** (a unit tagged `clone-of:<sibling>`) → **parity
  review, not a fan-out.** Diff the clone against its sibling and confirm every
  difference is either a mechanical rename/substitution or one of the intended
  deviations listed in the ledger. Anything else — logic that differs, a
  modifier dropped, an import that isn't a rename — is **reclassified `novel`**
  and goes through the full fan-out for that delta. The **novel** units in the
  same PR still get the full end-diff fan-out; the clone units do not (procedure:
  [`references/review-loops.md`](references/review-loops.md)).

Converge via **`/review-changes`**: read the severity-graded report; fix each
**Critical/High** test-first, re-run `/test` (+ `/test-snapshots` if UI
changed), **commit the fix** (an uncommitted fix re-reviews as
still-broken); re-invoke; repeat until none remain. **Cap at 3 iterations**,
then stop and surface. **Auto:** panel — proceed (note unresolved findings in
the PR description) vs stop. Medium/Low: apply the cheap, clearly-correct
ones; note the rest in the PR description. This is the **single substantive
review** — `/pr` therefore runs in `reviewed` mode (Phase 9).

**Phase 4 ∥ Phase 5 on the cold pass.** Code review (Phase 4) and security
review (Phase 5) both only **read** the committed tree, so their **cold first
pass may run concurrently** — converge them independently. **Serialize only on
the fix path:** if either produces fixes, apply them, then re-run the *other* on
the fixed tree (a review of a now-stale tree doesn't count). Guardrail: review
agents are read-mostly (`git diff` + file reads); if one runs a build it may
contend with the other on the worktree's single build dir — acceptable for the
cold pass. Rubric verification (Phase 7) stays strictly **after** both
converge — it is the maker-graded exit gate and it builds/tests, so it is never
part of the parallel set. (PR #82's retro did this ad hoc; this makes it the
default.)

## Phase 5 — Security review + fix loop

**Run only when the diff touches a security-relevant surface**: Swift source,
`Package.swift`/`Package.resolved`, `Configs/*.xcconfig` handling,
`.github/workflows/`, or `.claude/settings*`. Pure docs/markdown → skip. No
scale-down on lite.
Invoke **`/security-review`** (findings only — the conductor fixes) and
converge with the Phase 4 loop: fix each **High** (and any Medium with a
concrete attack path) test-first where reproducible, commit, re-invoke, cap
at 3. Its **cold first pass may run concurrently with Phase 4** (both are
read-only on the same committed tree — see the *Phase 4 ∥ Phase 5* note);
serialize only once either yields fixes. **Auto:** panel — but a **credential leak or clear exploit is a hard
stop even in auto**. This is the pipeline's **only** security gate (CI has no
SAST). Surfaces that bite:
[`references/review-loops.md`](references/review-loops.md).

## Phase 6 — Capture learnings

Invoke **`/capture-knowledge`**, passing the ledger's knowledge-candidates
list as the skill argument (`$ARGUMENTS` — it travels with the call even
after compaction). It curates: durable, non-obvious, reusable items only,
deduped against `knowledge/`, written to the right file (gotchas / an ADR).
Before `/pr`, so the notes ride the same PR. Capturing nothing is a valid
outcome. Exception: one or two small entries already authored during
implementation may be committed inline instead — note the inline capture in
the retro.

## Phase 7 — Rubric verification (exit gate)

Take the rubric (Phase 0 ACs) from the ledger; none extracted → skip. How it
is graded depends on weight:

- **Lite** → verify inline: each AC against the committed diff — behaviour
  by diff-scan or a targeted test (`swift test --filter …` in the package
  dir, or `/test-single` for app-level targets), coverage by the test +
  assertion existing at every layer the change touches (mapper / use case /
  view model).
- **Full** → **an independent grader, not the conductor** — the maker does
  not grade its own homework. Spawn ONE subagent (general-purpose; inherit
  the model) given ONLY the rubric verbatim and the instruction to judge the
  committed work (`git diff origin/main...HEAD`, reading files and running
  targeted tests as needed) — no conversation context, no
  implementation narrative. It returns per-AC `met`/`not met` + one-line
  evidence (file:line or test name). Run it **synchronously** — it may
  build/test, and builds are sequential within a worktree. Grader dies or
  returns unusable output → fall back to the inline path and note it in the
  ledger — **a dead grader is not a pass**.

Satisfied → mark off. Not → fix test-first, commit, re-verify (full weight:
re-run the grader); a gap needing a plan change is noted in the PR
description. *"Did we build what the plan said?"*, not *"did the build
pass?"*.

## Phase 8 — Write the retrospective (pre-PR)

Write the retro **now, before the PR opens, so it rides the PR itself** and
the gate is never re-opened by a routine retro push. Mandatory. A dated entry
in [`knowledge/delivery-retros.md`](../../../knowledge/delivery-retros.md),
headed with the **branch name** (Phase 9 backfills the PR number): phases /
skills telemetry, what worked, friction, deviations, one improvement; omit
`watch:` (post-gate amendments only, Phase 11). **Commit it on the PR
branch**, then run the **windowing step** (>~12 full entries → distil the
oldest into the archive table). Format detail:
[`references/wrap-up.md`](references/wrap-up.md).

## Phase 9 — Create the PR

**Gate check first (template→replicate only):** the `Phase 4a` ledger task
must be **completed** — still open → back to Phase 4.

Invoke **`/pr reviewed base=<green-gate-sha>`** — `reviewed` because Phase 4
already converged this code (so `/pr` skips its internal review), and
`base=<green-gate-sha>` is the Phase 3 green-gate SHA from the ledger (omit the
arg if none was recorded). It rebases onto `origin/main`, runs the
**mandatory pre-PR gate** — `make lint` + the new-file `--no-cache` re-lint,
`/build-for-testing` (warnings-as-errors), `/test`, `/test-snapshots`;
scaled to a lint-only fast gate when nothing build-affecting changed since
**either `origin/main` or the green-gate base** — pushes with `git push`, and
opens the PR.

**Green-gate fast-path:** when the green-gate SHA is still an ancestor of HEAD
(the rebase was a no-op) and the only delta since it is docs (the Phase 6
capture + Phase 8 retro `.md`), `/pr` skips the build/test/snapshot legs and
runs lint only. This is safe because the identical tree already passed the
identical gate in Phase 3, proven by `/pr`'s is-ancestor + docs-only-delta
checks; **CI still runs the full matrix**, so the local skip never lowers what
guards `main`. Note the gate's coverage: it
builds Debug, so a **Release-only** failure (`release-build.yml`) is caught
by CI, not locally — expected; Phase 10 handles it. The `claude-review` job
is a **non-blocking** neutral check — never treat it as a gate. **Run each long
gate leg as a backgrounded `Bash`** that logs to a file and self-reports on exit
(see *Context & isolation* above), not a Haiku subagent — a subagent driving its
own poll loop returns premature "still waiting" notes on multi-minute runs.

**If the gate fails, triage** (§4): the failing test/file in
`git diff --name-only origin/main...HEAD`? **In-diff** →
fix test-first, commit, re-run; stop only if it can't converge (**Auto:**
panel — open with the failure noted vs stop). **Pre-existing/unrelated** →
re-run once; still red and not yours → surface it to the user — never patch
an unrelated failure here.

Record the PR number/URL in the ledger. **Backfill the retro heading** with
the PR number, commit, push immediately — pre-gate (the superseded CI run is
cancelled by the concurrency group).

## Phase 10 — Watch to ready → GATE: ready-to-merge

Invoke **`/watch-pr`** in **watch-only** mode, **in the background**,
**passing the PR number from the ledger** (`/watch-pr <number>`) — a
background watch must be pinned to its PR, not to "current branch", which
changes when the conductor moves to the next deliverable's worktree. It
resolves threads, fixes failing checks (via `/fix-pr-checks`; unrelated
failures surface per §4), and loops until **ready** or **stuck**. Ready means
**mergeable now** (branch brought up to date with `main`, re-run green).

**THE GATE — hard stop.** Ready → stop; hand the merge to the user; report
the PR URL and state; run Phase 11. The worktree **stays** (torn down only on
merge, Phase 12). Stuck → stop, summarise what's blocking, **keep the
worktree**. **Auto:** stuck → panel (retry via `ScheduleWakeup` vs stop); the
gate itself is not a panel decision — in auto, ready behaves as the `merge`
opt-in. **Opt-in auto-merge:** only if the user passed `merge`, forward it
(`/watch-pr merge <number>`) — the gate becomes "report the merge" → Phase 12.

## Phase 11 — Wrap-up (wiki, pattern scan, exceptional retro amendment)

The retro is already on the PR (Phase 8) — **the default path pushes nothing
after the gate**. Guidance:
[`references/wrap-up.md`](references/wrap-up.md).

- **Amend the retro only for a noteworthy watch phase** (stuck check, new
  Critical/High thread, un-converging review-bot loop, wrong readiness call):
  append a one-line `watch:` bullet, commit, push — on the PR branch
  (watch-only), or a fresh branch off `origin/main` as a small follow-up PR
  (`merge`/auto mode, before teardown; the same routing applies to any skill
  edits the auto scan commits). Uneventful watch → don't touch it.
- **Any post-gate push re-opens the gate** — after the last exceptional push
  (amendment or approved skill edit), run the `/watch-pr` loop once more on
  the new tip before merge.
- **Update the personal wiki** — best-effort, `propose_entry` only (never
  autonomous writes); degrade silently if absent.
- **Recurring-pattern scan**: friction/deviations recurring across the last
  ~12 retro entries → numbered proposals. **Consult
  `skill-improvement-log.md` first** and skip anything already decided;
  **wait for explicit approval on each proposal — never edit a skill file
  unasked**; record **every** decision in the log (five-field format). No new
  recurrence → say so and stop. **Auto:** the panel adjudicates instead.

## Phase 12 — Teardown on merge (reclaim the worktree)

**The trigger is the merge, and only the merge**: right after a `merge`-mode
merge, or when a watch-only merge is confirmed *within this session*. Session
ends with the PR open → **leave the worktree** (the next run's Phase 1 GC
reclaims it once merged). Stuck/blocked/abandoned → **never** tear down.

Two preconditions, both required, then
`ExitWorktree(action: "remove", discard_changes: true)`:

1. The PR is actually **merged** (`pull_request_read` → `merged: true`).
2. **No unsaved work beyond what's merged**: `git status --porcelain` empty
   **and** `git rev-parse HEAD` equals `git rev-parse @{u}`. Either fails →
   land the work first; do **not** discard.

`discard_changes` is safe *only because* precondition 2 proved nothing
un-merged remains (a squash-merge means the branch commits aren't literally
on `main`). Leave the main checkout as you found it. Detail:
[`references/worktree-lifecycle.md`](references/worktree-lifecycle.md).

## When the pipeline stops

Wherever it stops — the gate, an untriageable red gate, a stuck PR — end with
a concise status: phase reached, branch and PR, what passed, what's blocking,
and the single next action needed from the user. The destination is a green
PR ready for their merge — say plainly whether you got there.
