---
name: deliver
description: Take the current plan all the way to a ready-to-merge pull request — review the plan (scaled to risk), implement it test-first, code-review and fix, run the pre-PR gate, open the PR, and watch it green. Use after you have an approved plan (e.g. from plan mode) and want the rest of the feature pipeline run end-to-end. Invoking it is itself plan approval — it then runs autonomously to a single hard stop: ready-to-merge.
---

# Deliver

Drive the **current plan** through the whole feature pipeline to a PR that is green
and ready to merge — without you hand-running each step. This skill is an
**orchestrator**: it does not re-implement review, TDD, or PR logic; it sequences the
existing skills and the `code-reviewer` / `plan-reviewer` agents, adds the safety
gates, and keeps going across the long session until the PR is ready.

```text
you approve the plan ─▶ /deliver ─▶ branch ─▶ [review-plan] ─▶ implement ─▶
  review-changes + fix ─▶ capture ─▶ /pr reviewed ─▶ /watch-pr ─▶ GATE: ready-to-merge ─▶ retro
                                                                     ▲ the only hard stop
```

**Invoking `/deliver` on an approved plan is itself the plan-approval gate.** From
there it runs **autonomously** to a single hard stop — **ready-to-merge** — pausing
mid-run only for a genuine blocker (a plan-review blocker, or a red gate it cannot
triage). It **auto-scales** the machinery to the change's risk (see *Delivery
weight*), and ends with a short **retrospective** so the workflow keeps improving.

The plan itself is **not** part of this skill — create it first with the plan tool /
plan mode. `/deliver` picks up from there.

## Agent Behaviour Contract

These are non-negotiable. Do them by default, without being reminded.

1. **Invoking `/deliver` is plan approval — then run autonomously to the one gate.**
   Do not stop for a second "is the plan ok?" confirmation. Proceed through branch →
   (review-plan) → implement → review-changes/fix → capture → pr → watch-pr to the
   single hard stop, **Gate: ready-to-merge** (Phase 5). The only legitimate mid-run
   pauses are: a **blocker** raised by `/review-plan` (Phase 1), or a **red gate you
   cannot triage** (Contract §4).
2. **Delegate to the existing skills — don't reinvent them.** Invoke `/review-plan`,
   `/implement-plan`, `/review-changes`, `/capture-knowledge`, `/pr`, and `/watch-pr`.
   This skill only sequences and gates; the expertise lives in those pieces.
3. **Never work on `main`.** Branch first — before `/review-plan` or any file edit
   (see *Phase 0.5*). `CLAUDE.md` forbids editing `main`.
4. **A red gate triages before it stops.** If a check fails, first classify
   **in-diff vs pre-existing** (Phase 4). A failure your diff caused → fix it
   test-first and re-run; only **stop** if it can't converge in the cap. A
   **pre-existing / unrelated** failure (a check not touching your diff, often a
   transient CI flake) → re-run once; if it still fails and isn't yours, **surface it
   to the user** — Popcorn has no off-branch self-heal path, so don't hard-stop the
   pipeline on someone else's flake without saying so. Only a genuine, in-diff,
   unfixable break stops the pipeline.
5. **Test-first all the way.** Every fix in the code-review loop follows `/canon-tdd` —
   reproduce with a failing test, then fix. No untested patches.
6. **Keep a durable phase ledger.** This is a long session that may be summarised.
   Track it in a **`TaskCreate` task list — one task per phase** (Phase 0.5 → Phase 6),
   set `in_progress`/`completed` as you go, and record the branch name, PR number, and
   the delivery weight on the relevant tasks. (`TaskCreate` is a deferred tool — load
   it via `ToolSearch` before first use. If unavailable in this context, fall back to a
   markdown ledger file under `.claude/`.) A task list survives compaction better than
   prose, so you can resume cleanly.
7. **Jot knowledge candidates as you go.** Keep a running **knowledge-candidates** list
   (in the ledger) and append to it the *moment* a learning occurs during Phases 2–3 —
   a thing you had to look up or web-search, a gotcha or dead-end, a surprising
   SwiftData/CloudKit or TMDb-mapping behaviour, or a non-obvious decision. One line
   each (`<category>: <gist> [where]`). Reconstructing the list at the end loses the
   best material (and may not survive compaction). Phase 3.5 curates it.

## Auto mode (unattended)

`/deliver auto` runs the **entire** pipeline with **no human interaction** — every
mid-run decision that would normally stop and ask the user is instead resolved by an
**adversarial panel** of three Opus subagents, and the conductor acts on their
majority verdict and keeps going through Phase 6.

`/deliver auto` is **user-launched** — there is no cron/headless trigger in this repo.
And because Popcorn has **no off-branch self-heal path**, auto mode's unexplained-red-
check branch can only re-run-once or stop, so **auto mode hard-stops (or panel-stops)
more often than a richer pipeline would** — that's expected.

**The panel.** At each decision point, convene three subagents in parallel, each given
the same context (the decision, the evidence, the options):

- **Proceed** — argues the case for continuing the pipeline.
- **Stop** — argues the case for halting and handing back to the user.
- **Devil's advocate** — attacks whichever way looks easiest, so the other two can't
  converge on a comfortable answer unchallenged.

Each returns a one-line verdict (`proceed` / `stop`) and its reasoning. **Majority
wins.** The conductor records the outcome and continues — `proceed` resumes the
pipeline; `stop` ends the run with the usual status summary.

**Audit trail.** For **every** panel convened, write a ledger entry recording the
**four fields**: the **decision point**, the **three subagent verdicts**, the
**majority outcome**, and a **one-line rationale**. A run that went unattended must
still be reviewable.

**The one exception — never delegated.** A Phase 1 `blocker` where the plan would cause
**data loss** or a **breaking change** is **always a hard stop**, even in `auto`. It is
too consequential to hand to a panel: surface it to the user and wait. (Every other
decision point — including all *other* Phase 1 blockers — goes to the panel.)

Each decision point below marks its **Auto:** branch. In the default (attended) mode
those branches do not apply — the pipeline stops and asks, as written.

## Delivery weight — auto-scale to risk (lite vs full)

`/deliver` sizes its machinery to the change, automatically — no flag. Judge the weight
from the plan up front, and re-confirm from the actual diff after Phase 2:

- **Lite** — a small, mechanical, single-unit change that touches **no risky surface**:
  no concurrency (`Task`/actor/`Sendable`), no SwiftData `@Model`/CloudKit-schema
  changes, no new public API beyond a simple additive method, no cross-context wiring;
  roughly **under a few hundred changed lines**. Lite ⇒ **skip `/review-plan`'s
  three-critic pass** (Phase 1) and let `/review-changes` take its
  **single-reviewer** path (Phase 3) — it already self-scales.
- **Full** — anything risky or large: new concurrency, SwiftData/CloudKit model or
  migration changes, a new feature/context/use-case or public-API surface, factory/
  router wiring, feature-flag/Statsig gating, multi-package work, or a big diff. Full ⇒
  the **three-critic `/review-plan`** and the **fan-out + adversarial-verify**
  `/review-changes`.

When unsure, prefer **full** — the heavier review is cheap insurance. Record the chosen
weight in the ledger.

## Context & isolation (by design)

`/deliver` is a **lean main-context conductor** — it should hold only the plan
reference, the phase ledger, the one gate interaction, and a short summary returned
from each phase. The heavy or independent-judgment work is deliberately isolated:

- **Already isolated — keep it that way.** `/review-plan` runs its three Opus critics in
  a separate Workflow (only verdicts return); the `code-reviewer` agent reads the diff
  and docs in its own context; and `/build-for-testing`, `/test`, `/test-snapshots`,
  `make lint` delegate their logs to Xcode MCP or Haiku subagents.
- **Implement runs inline — on purpose.** `/implement-plan` stays in the main context so
  the Canon TDD test list and each red/green step are **visible** to the user, and so it
  can pause for any mid-implementation decision. Its noisy output is already delegated.
  **Do not** convert this phase to a silent subagent.
- **The gate stays in the main agent.** Subagents are non-interactive; the
  ready-to-merge gate is handed to the user, so the conductor owns it. Phases hand off
  via **git / the PR**, not via context.

## Phase 0 — Preconditions

- **A plan must exist.** Locate it (named target → plan-mode plan → most recent plan in
  the conversation). If there is no plan, stop and tell the user to create one first —
  do not invent one.
- **If the plan originates from a review finding, verify it first.** When the delivery
  comes from a code-review / source-review *finding* rather than a user-authored plan,
  treat the finding as a **hypothesis, not an approved plan**: do a quick `Explore` pass
  to confirm it against the actual code (Is it real? Is the framing right? Breaking or
  not?) **before** drafting the plan. Review findings have repeatedly been mis-framed.
- **State the goal** in a sentence so every downstream phase is anchored to it.
- **Pull relevant context** (best-effort). If the personal `wiki` MCP is available, call
  `get_context` on the goal; also skim the auto-memory (`MEMORY.md`) for durable
  preferences, prior decisions, or conventions that bear on the approach. **Degrade
  silently** if a store is absent — never block the pipeline on it.
- **Judge the delivery weight** (lite vs full) from the plan, and open the `TaskCreate`
  ledger (Contract §6).

## Phase 0.5 — Ensure a feature branch (before any edit)

Do this **before** Phase 1 — `/review-plan` applies its consensus by editing the plan,
and if the plan is a **tracked file** that edit must not land on `main` (`CLAUDE.md`
forbids editing `main`; Contract §3). Branch first.

```bash
git branch --show-current
```

If on `main` (or any protected base), create a branch off `main` with a conventional
prefix derived from the plan — `feature/<slug>` for new work, `fix/<slug>` for a bug
fix, etc.:

```bash
git checkout -b feature/<slug>
```

Record the branch name in the ledger. If already on a suitable feature branch, keep it.

**Invoked from plan mode?** If you reach `/deliver` while in plan mode with an approved
plan, that approval *is* the plan-approval gate: exit plan mode (the plan is your
input), branch, and proceed — no second "is the plan ok?" prompt.

## Phase 1 — Harden the plan (no separate approval stop)

The plan is already approved (Contract §1), so this phase only **hardens** it.

- **Lite change, or a plan already reviewed this session** (a recent `/review-plan` that
  converged, or a plan approved via plan mode) → **skip the critics** and proceed
  straight to Phase 2. Re-running critics on a settled or trivial plan is wasted work.
- **Full change with an unreviewed plan** → invoke **`/review-plan`** (three adversarial
  Opus critics → consensus → applied to the plan). Then:
  - Present the **revised** plan + a one-line change log (applied / rejected) as an
    **FYI**, and **keep going** — do not wait for re-approval.
  - **Exception — a `blocker`:** if a critic raises a blocker (the approach is wrong, a
    breaking change, data-loss, a CloudKit migration that would drop data, etc.), **stop
    and surface it** before implementing. Improvements/`major`/`minor` are folded in and
    you proceed.
    - **Auto:** a **data-loss or breaking-change** blocker is **always a hard stop** (the
      never-delegated exception). For **any other** blocker, convene the panel to decide
      proceed vs stop and act on the majority verdict.

## Phase 2 — Implement the plan

Invoke **`/implement-plan`**. It derives the Canon TDD test list (shown before any
code), drives the Red-Green-Refactor loop one test at a time, and finishes only when the
**test list is empty** and the suites are green (`/test` + `/test-snapshots` +
`/build-for-testing`). It pulls in `swift-concurrency`, `swift-testing-expert`,
`swiftui-expert`, `swiftdata-expert` as the work demands, and expects the PostToolUse
hook to reshape Swift files after writes.

It also **commits at logical checkpoints** as it goes — each commit a coherent, green,
lint-clean increment. This matters: Phase 3 reviews **committed** history (`git diff
main...HEAD`), so committing as you implement means the review sees the real change.

**Popcorn bookkeeping during implement:** if the change adds a `FeatureFlag`, create the
Statsig gate (CLAUDE.md → *Feature flag creation*); if it adds a unit-test target,
register it in `TestPlans/PopcornUnitTests.xctestplan` (or the snapshot test plan).

Do not advance until `/implement-plan` reports an empty test list with `/test` **and**
`/test-snapshots` passing and `/build-for-testing` clean, and the work committed.
Re-confirm the delivery weight from the actual diff now (a "lite" plan that ballooned is
`full`).

## Phase 3 — Code review + fix loop

**Skip this phase entirely if the change has no Swift source.** `/review-changes`
self-gates (it returns immediately when `git diff main...HEAD` touches no `*.swift`), so
a docs-only / config-only delivery sails straight to Phase 3.5. Code review is for Swift.

Review **stable** code, not work in progress — apply this independent, adversarial lens
once the design has settled, not after every Canon TDD item.

**Granularity by delivery weight:**

- **Lite / single-unit** → review **once**, on the full diff after Phase 2.
  `/review-changes` takes its single-`code-reviewer` path.
- **Full / multi-unit** → review **per cohesive unit** as each completes (a finished
  view model + its tests; a use case + mapper), rather than one large end-diff. Here
  **Phases 2 and 3 interleave**: review a unit as Phase 2 finishes it (relying on Phase
  2's commit-at-checkpoints so the review diffs *committed* history), fix per the loop
  below, then move on. Per *unit*, not per *test-list-item*.

Run the review via **`/review-changes`** (it scales: a single `code-reviewer` agent for
a small change, or a fan-out Workflow — per-dimension reviewers → dedup → adversarial-
verify each Critical/High → reconcile — for a large one). Then converge:

1. Read its severity-graded report (it follows `.github/CODE_REVIEW.md`; on the large
   path, Critical/High are independently verified, so they're high-confidence).
2. **If there are Critical or High findings**, fix each one **test-first** via
   `/canon-tdd` — failing test that captures the defect, then the fix — then re-run
   `/test` (+ `/test-snapshots` if UI changed) and **commit the fix**. The commit is
   required: `/review-changes` diffs **committed** history, so an uncommitted fix would
   re-review as still-broken.
3. **Re-invoke `/review-changes`** on the updated (committed) diff. Repeat until no
   Critical/High findings remain.
4. **Cap at 3 iterations.** If Critical/High issues persist after three rounds, stop and
   surface them to the user — don't loop forever or paper over them.
   - **Auto:** convene the panel. **Proceed** → note the unresolved findings in the PR
     description and continue; **stop** → surface to the user.

Medium/Low findings: apply the cheap, clearly-correct ones; note the rest in the PR
description rather than blocking on them.

This is the **single substantive review** of the change — so `/pr` is invoked in
`reviewed` mode (Phase 4), skipping its internal review of the identical code.

## Phase 3.5 — Capture learnings

Invoke **`/capture-knowledge`**, **passing the knowledge-candidates list you kept in the
ledger (Contract §7) as the skill argument** (`$ARGUMENTS`) — paste the list lines into
the invocation rather than assuming the skill can still see the ledger (it may have been
summarised away). Its job is to **curate** that list — filter to durable, non-obvious,
reusable items, dedup against existing `knowledge/` entries, and write them into
`gotchas.md` or a new ADR (it also retires entries no longer true).

Do this **before** `/pr` so the notes are committed in the **same PR**. Capturing
nothing is a valid outcome. The `knowledge/` files are Markdown, so they add no review
noise; keep entries tidy by hand.

## Phase 4 — Create the PR

Invoke **`/pr reviewed`** — the `reviewed` argument tells `/pr` to **skip its internal
`code-reviewer` pass**, because Phase 3 already reviewed and converged this exact code.
`/pr` then runs the **mandatory pre-PR gate** (the PostToolUse hook has already
formatted; `make lint` for the clean-tree lint + new-file `--no-cache` re-lint;
`/build-for-testing` warnings-as-errors; `/test`; `/test-snapshots`), pushes the branch
with `git push`, and opens the PR with a gitmoji title and structured body.

**Note on the gate's coverage:** the local gate builds Debug via `/build-for-testing`. A
**Release-only** failure (`release-build.yml`) is caught by CI, not locally — that's
expected; `/watch-pr` (Phase 5) handles it. And the Claude review (the `claude-review`
job) is a **non-blocking** neutral check — never treat it as a gate.

**If a gate step fails, triage before you stop** (Contract §4):

1. **Which check, and is it in your diff?** Compare the failing test/file against
   `git diff --name-only main...HEAD`.
2. **In-diff genuine failure** → it's yours: fix it (test-first), commit, re-run. Only
   **stop and report** if it can't converge.
   - **Auto:** when it can't converge, convene the panel. **Proceed** → open the PR with
     the known-failing check noted; **stop** → report.
3. **Pre-existing / unrelated** (a transient CI flake not in your diff) → re-run once; if
   it still fails and isn't yours, **surface it to the user** (no off-branch self-heal
   here). Don't patch an unrelated failure onto this branch, and don't hard-stop on it
   silently.

Record the PR number/URL in the ledger.

## Phase 5 — Watch to ready  → GATE: ready-to-merge

Invoke **`/watch-pr`** in **watch-only** mode (do not pass `merge`), and **run it in the
background** so the user can keep interacting while CI churns. It resolves review
threads and fixes failing checks, looping until the PR is **ready** (green checks,
threads resolved) or **stuck**.

**Ready means mergeable *now*.** Before the gate, `/watch-pr` brings the branch up to
date with `main` (`gh pr update-branch`) and waits for the re-run, so a PR reported
ready isn't `BEHIND` and waiting on a rebase. (See `/watch-pr` §3.)

**THE GATE — hard stop at ready-to-merge.** When the PR is ready, **stop and hand it to
the user for the final merge** — `/deliver` does not merge by default. Report the PR URL
and its ready state, then run Phase 6. If `/watch-pr` reports the PR is **stuck** (a
check it can't fix, or a human-decision review thread), stop and summarise what's
blocking.

> **Auto:** on a stuck PR, convene the panel to decide **wait-and-retry vs stop**.
> **Proceed** → schedule a later re-check with `ScheduleWakeup` and resume `/watch-pr`
> when it fires; **stop** → end the run and report what's blocking. The ready-to-merge
> gate itself is **not** a panel decision: in `auto` it behaves exactly as the `merge`
> opt-in below — once ready, proceed to Phase 6 (and merge if `merge` was passed).
>
> **Opt-in auto-merge:** if the user explicitly passes `merge` to `/deliver`, forward it
> to `/watch-pr` (`/watch-pr merge`) so it squash-merges once ready, and the gate becomes
> "report the merge" instead of stopping. Default is watch-only.

## Phase 6 — Retrospective (continuous improvement)

After the gate (PR ready, or merged in `merge` mode), run a **brief, honest
retrospective** so the workflow keeps improving — this is mandatory. Reflect on *this*
delivery and write a dated entry to
[`knowledge/delivery-retros.md`](../../../knowledge/delivery-retros.md):

- **Feature / PR**, date, and delivery weight (lite/full).
- **Phases completed / Skills invoked** — a compact one-liner each. Telemetry for the
  recurring-pattern scan: over time it shows which skills fire, which phases get
  skipped, and where deliveries stop.
- **What worked** — one or two things the pipeline did well.
- **Friction** — where it was rough, slow, or stopped unnecessarily.
- **Deviations** — anywhere you had to depart from this skill to do the right thing (a
  strong signal the skill has a gap).
- **One improvement** — the single highest-value change to `/deliver` (or a sub-skill)
  suggested by this run.

Keep it to a handful of bullets — a log, not a ceremony. Commit the retro with the PR
when possible (watch-only), or as a small follow-up when auto-merged.

**Keep the file windowed.** After adding the entry, if `delivery-retros.md` holds more
than **~12 full entries**, distil the oldest into its one-line archive table (`date · PR
· weight · one-line outcome`) and drop the prose — per
[`knowledge/README.md`](../../../knowledge/README.md) → *Maintenance & retention*.

### Recurring-pattern scan (after committing the retro)

Once the retro entry is committed, do a structured cross-delivery scan — this is what
turns one-off retros into reviewed skill improvements:

1. **Read the recent window + the log + the pipeline skills.** Read the **~last 12**
   entries of [`knowledge/delivery-retros.md`](../../../knowledge/delivery-retros.md),
   **all** of
   [`knowledge/skill-improvement-log.md`](../../../knowledge/skill-improvement-log.md),
   and every `SKILL.md` for the **pipeline skills and the sub-skills they invoke**
   (`deliver`, `review-plan`, `implement-plan`, `canon-tdd`, `review-changes`,
   `capture-knowledge`, `pr`, `watch-pr`, plus `/test-snapshots`, `/build-package`,
   `/test-package`, and the `swift-concurrency`/`swift-testing-expert`/`swiftui-expert`/
   `swiftdata-expert`/`documentation-writer` agents the pipeline pulls in). Skip the
   unrelated domain skills (`add-context`, `create-domain-model`, …) — a delivery retro
   won't drive a change there.
2. **Find what recurs.** For any friction, deviation, or improvement suggestion that
   appears in **more than one** retro entry, write a numbered proposal in this format:

   Pattern: [what keeps happening]
   Seen in: [retro dates / feature names]
   Skill: [relative path to SKILL.md]
   Current text: [exact existing wording, or "missing"]
   Proposed change: [exact new wording and location]
   Rationale: [one sentence on why this eliminates the pattern]

   **Skip any pattern already decided in `skill-improvement-log.md`** — one already
   **applied**, or **deferred/rejected** (don't re-propose a settled *no*; only resurface
   it if its recorded "Reconsider when" condition now holds).
3. **Stop and ask.** **Do not edit any skill files.** Present the proposals and wait for
   **explicit approval on each one**. If no *new* pattern recurs across multiple entries,
   **say so and stop** — emit no proposals.
   - **Auto:** don't wait. The panel reviews **each** proposal and **applies approved
     ones directly** (edit the skill, commit). Rejected proposals are still recorded in
     `skill-improvement-log.md` with the panel's rationale (step 4).
4. **Record every decision in the log.** For each proposal you presented, append an entry
   to
   [`knowledge/skill-improvement-log.md`](../../../knowledge/skill-improvement-log.md) in
   its five-field format (date · title · status; Pattern / Decision / Rationale /
   Reconsider when) — **applied** (with the skill + commit), **deferred**, or
   **rejected**. The **Decision** and **Reconsider when** fields are what step 2's dedup
   keys on; keep them on every entry.

## When the pipeline stops

Whether at the gate, a red gate it couldn't triage, or a stuck PR, always end with a
concise status: the phase reached, the branch and PR (if any), what passed, what's
blocking, and the single next action you need from the user. The destination is a green
PR ready for their merge — say plainly whether you got there.
