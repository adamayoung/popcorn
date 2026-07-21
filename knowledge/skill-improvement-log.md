# Skill-Improvement Log

A durable record of every skill-improvement proposal raised by `/deliver`'s
**Phase 11 recurring-pattern scan**, and the decision on it. Newest at the top.

**Why this exists:** the Phase 11 scan surfaces proposals and waits for approval.
Without a memory of past decisions, it would re-propose ideas already **applied** or
deliberately **deferred/rejected** — wasting attention and re-litigating settled
calls. The scan **consults this log before proposing** and skips any pattern already
decided here. Record both the *yes* and the *no* (with rationale) — the *no*s are
what stop the loop repeating itself.

Status values: **applied** · **deferred** · **rejected**.

Format per entry:

```text
### <date> — <short title> · <applied|deferred|rejected>
- **Pattern:** what kept recurring (and the retro entries it appeared in).
- **Decision:** what was agreed, and where it landed (skill + commit/PR) if applied.
- **Rationale:** one or two sentences — why this call.
- **Reconsider when:** (deferred/rejected only) the condition under which the scan
  should resurface this — or `n/a` for applied entries.
```

Keep this five-field shape on every entry so the scan can parse the log
consistently — in particular **Decision** (status) and **Reconsider when** are the
two fields the dedup step keys on.

---

<!-- Newest entry goes here. -->

### 2026-07-21 — Scale review depth to per-unit novelty (the clone lane) · applied

- **Pattern:** in PR #83 (retro), a 2,786-line diff that was ~90% a faithful `cp`+`sed`
  clone of the already-merged Trending/Discover features still drew the full 7-dimension
  Opus adversarial fan-out. `/deliver` scales review to diff *size* and *risk* but not to
  *novelty*, so a whole-module clone of an already-reviewed sibling was re-reviewed from
  scratch (~4.7 min of the ~10.5 min review block).
- **Decision:** *applied* 2026-07-21 (owner-approved). Added a **per-unit novelty axis**
  (`novel` vs `clone-of:<merged-sibling-path>`) to `/deliver`'s *Delivery weight* section,
  a fourth **"clone of a merged sibling → parity review, not fan-out"** bullet to Phase 4's
  *Granularity by weight*, and a **"Clone-of-a-merged-sibling review"** subsection to
  `references/review-loops.md`. Novelty is judged **per unit, not per PR**: any
  non-mechanical delta reclassifies the unit `novel` and it takes the full fan-out. Paired
  with the #4 entry (`cp`+`sed` implementation) as the two halves of the clone lane. Landed
  via branch `docs/deliver-speedups` (PR #85).
- **Rationale:** re-reviewing a merged, already-reviewed sibling's clone from scratch buys
  nothing a parity diff can't; the guardrail (any non-mechanical delta → `novel` → full
  review) keeps it safe, and "shape-similarity ≠ clone status" stops the paged-pipeline
  false positive (real new migration code that only mirrors a sibling's shape).
- **Reconsider when:** n/a (applied).

### 2026-07-21 — De-duplicate the Phase 9 gate via a known-green base SHA · applied

- **Pattern:** in PR #83 (retro), Phase 3 finished on a green `build-for-testing` + `test`
  + `test-snapshots`, and Phase 9's `/pr reviewed` re-ran the identical three commands
  (~2.5 min) even though the only commits since were docs (the Phase 6 capture + Phase 8
  retro `.md`) and the rebase was a no-op. `/pr`'s docs-only fast gate keyed on *"the whole
  PR diff is docs-only"* — false here — so it missed the real signal, *"the delta since the
  last green gate is docs-only."*
- **Decision:** *applied* 2026-07-21 (owner-approved). `/deliver` Phase 3 now records a
  **green-gate SHA** in the ledger (HEAD at the last green finishing gate; updated after any
  re-gated code fix); Phase 9 passes it as `/pr reviewed base=<sha>`; `/pr`'s step-3 fast
  gate gained a **known-green-base** branch that skips build/test/snapshot (lint still runs)
  when `git merge-base --is-ancestor <base> HEAD` holds **and** `git diff --name-only <base>
  HEAD` is docs-only. Landed via branch `docs/deliver-speedups` (PR #85).
- **Rationale:** the identical tree already passed the identical gate at the green base
  (proven by is-ancestor + docs-only-delta), so the second run is pure redundancy; gating on
  `merge-base --is-ancestor` (not a name check) ensures a real rebase can't skip a needed
  build, and CI still runs the full matrix as the backstop.
- **Reconsider when:** n/a (applied).

### 2026-07-21 — Parallelize the cold Phase 4 ∥ Phase 5 read-only reviews · applied

- **Pattern:** across PR #82's retro (which ran the parallel-security trick ad hoc) and
  PR #83's, code review (Phase 4, ~4.7 min) and security review (Phase 5, ~1.8 min) ran
  sequentially even though both only **read** the same committed tree and both came back
  clean — the common case for a low-novelty change. The sequencing bought nothing.
- **Decision:** *applied* 2026-07-21 (owner-approved). Documented in `/deliver` Phases 4–5
  that the **cold first pass** of code-review and security-review may run **concurrently**,
  converging independently, and that the pipeline **serializes only on the fix path** (a fix
  from either re-runs the other on the fixed tree). Rubric verification (Phase 7) stays
  strictly after both converge, since it builds/tests. Landed via branch
  `docs/deliver-speedups` (PR #85).
- **Rationale:** two read-only lenses over the same immutable tree have no ordering
  dependency until one mutates it; making the ad-hoc trick the default reclaims the shorter
  review's wall-clock for free on the clean common case.
- **Reconsider when:** n/a (applied).

### 2026-07-21 — Make `cp`+`sed` cloning the documented clone-unit implementation · applied

- **Pattern:** in PR #83 (retro), cloning a whole feature module by `cp -R` + ordered `sed`
  was the *fastest* part of the delivery and inherited the sibling's tests + formatting
  (equal-or-shorter substitutions kept `make format` at 0 changes) — but it was done ad hoc,
  with two traps hit live (a generic rename corrupting specific module names; a `-depth` walk
  renaming a parent dir and leaving file paths stale).
- **Decision:** *applied* 2026-07-21 (owner-approved). Added a Phase 3 clone-implementation
  bullet to `/deliver` (tied to the `clone-of:<sibling>` tag), the full procedure + traps
  (name-order, dirs-before-files, snapshot / `.swiftformat` strip) to
  `references/review-loops.md` alongside the parity-review subsection, and a `canon-tdd`
  *pure-refactor-with-existing-coverage* carve-out note to `/implement-plan`. Paired with the
  #1 entry as the two halves of the clone lane (clone-and-substitute → parity-review). Landed
  via branch `docs/deliver-speedups` (PR #85).
- **Rationale:** the fastest, most faithful way to stand up a clone is to copy it, not
  retype it; documenting the ordered-substitution traps stops the two failure modes from
  recurring, and the existing-coverage carve-out keeps it honest with Canon TDD.
- **Reconsider when:** n/a (applied).

### 2026-07-21 — Don't nest `&` inside a backgrounded gate command · applied

- **Pattern:** across PR #82's retro and PR #83's, the backgrounded-gate pattern was
  written as `( make … ) &` inside a `run_in_background` Bash job. The harness already
  backgrounds the job, so the inner `&` double-backgrounds: the wrapper script exits
  immediately (detaching the real `make`), and the harness fires a premature
  completion notification reporting the wrapper's `exit 0` — not the gate's true
  result. Each time it cost a confused round-trip grepping the log to discover the
  build was actually still running. A specific pitfall of the already-applied
  2026-07-10 backgrounded-Bash gate pattern, which the *Context & isolation* note did
  not warn against.
- **Decision:** *applied* 2026-07-21 (owner-approved). Added an explicit
  **"Never nest `&` inside that command"** warning to `/deliver`'s *Context &
  isolation* bullet (`.claude/skills/deliver/SKILL.md`), with the correct foreground
  form `make … > log 2>&1; echo "EXIT=$?" >> log`. The Phase 9 gate note already
  defers to that bullet by reference, so no second edit was needed. Landed via branch
  `chore/deliver-nested-ampersand-note`.
- **Rationale:** a twice-seen reliability tax with a one-line documentation fix; the
  existing note described the `EXIT=$?` marker but not the double-backgrounding trap
  that makes the marker necessary.
- **Reconsider when:** n/a (applied).

### 2026-07-21 — /test-package should gate feature packages out up front · applied

- **Pattern:** across PRs #79, `feature/explore-trending-movies-navigation`, and #80,
  attempting `/test-package` on a **feature** package cost a wasted subagent run each
  time — a feature package can't be built or tested via the SwiftPM CLI at all (the
  snapshot target's `import UIKit` fails `swift build --build-tests` / `swift test` on
  macOS, and even sources-only `swift build` fails because the committed
  `__Snapshots__/*.png` are undeclared resources). The limitation lived only as an
  incomplete trailing note — which suggested a sources-only fallback that doesn't work.
- **Decision:** *applied* 2026-07-21 (owner-approved). Added a **"Gate first"** section
  at the top of `/test-package` (`.claude/skills/test-package/SKILL.md`) that detects a
  feature package (under `Features/`, or a `__Snapshots__/` dir / a
  `SnapshotTestHelpers`/`UIKit` test import) and refuses up front — routing to the
  full-app `/build-for-testing` / `/test` / `/test-snapshots` — and corrected the stale
  trailing note (there is no sources-only fallback). Landed via branch
  `chore/test-package-feature-gate`.
- **Rationale:** the check is a cheap precondition that removes a recurring wasted
  subagent round-trip; a gate up front beats a trailing note that was both easy to miss
  and factually wrong.
- **Reconsider when:** n/a (applied).

### 2026-07-05 — Gate should detect the "0 tests executed" silent failure · deferred

- **Pattern:** across PRs #62/#63/#64/#65 and the Item-5 gates, `make test` with a
  `DESTINATION` override to a non-default simulator OS silently fell back to the broken
  iOS 26.5 runtime, whose FoundationModels dlopen failure makes **all bundles fail to load
  → 0 tests run** while the step still reads like a plain "test failed". Cost real time and a
  confusing subagent loop before diagnosis.
- **Decision:** *deferred* — proposed at the end of the `/deliver auto` run, pending owner
  approval. Candidate change: the `/test` and `/pr`-gate skills should treat "Executed 0
  tests" / `dyld: Symbol not found` / `Failed to load the test bundle` as a **hard, loud
  failure distinct from a test-assertion failure**, and either fall back to another installed
  runtime or surface the SDK/simruntime mismatch explicitly.
- **Rationale:** a gate that reports green-ish noise on a 0-tests run is worse than one that
  fails loudly; this recurred on every item this run.
- **Reconsider when:** the owner reviews these proposals, or the local iOS 26.5 runtime is
  repaired (which removes the trigger but not the underlying detection gap).

### 2026-07-05 — Auto-isolate-retry a flaked SwiftData suite in the gate · deferred

- **Pattern:** in PR #65 and the Item-5 reference gate, the full local unit suite failed on a
  whole SwiftData suite (`TVListingsInfrastructureTests`, then `DataPersistenceInfrastructureTests`)
  under parallel load — each passed 100% in isolation (the known `Runner._applyScopingTraits`
  flake). Each time it required a manual isolation re-run to distinguish flake from regression.
- **Decision:** *deferred* — pending owner approval. Candidate change: the pre-PR gate (or
  `/diagnose-ci-failure`) should, on a full-suite failure whose failing tests are all in one
  SwiftData suite untouched by the diff, **auto re-run that suite in isolation** and classify
  a pass as the known flake rather than surfacing a scary `TEST FAILED`.
- **Rationale:** automates a diagnosis this run did by hand twice; keeps the gate trustworthy.
- **Reconsider when:** the owner reviews these, or the framework flake is fixed upstream.

### 2026-07-05 — Run long gates as backgrounded Bash + Monitor, not a Haiku subagent · applied

- **Pattern:** for the multi-minute `make lint`/`build`/`test` gates (PRs #62–#64, and again
  on PR #76's pre-PR gate), Haiku gate subagents repeatedly returned interim "still waiting"
  notes instead of a final consolidated result, needing nudges. Switching mid-run to a
  backgrounded `Bash` (`run_in_background`) that writes to a log + greps terminal markers
  was reliable and kept logs out of context.
- **Decision:** *applied* 2026-07-10 (owner-approved). Codified "prefer a backgrounded `Bash`
  that self-reports on exit over a Haiku subagent for long-running, single-result gate steps"
  in `/deliver`'s *Context & isolation* + Phase 9 gate note, the `/build`, `/build-for-testing`,
  `/test`, `/test-single`, and `/test-snapshots` wrapper fallbacks, and CLAUDE.md's *Build &
  Test Output Management* (a two-mechanism carve-out — the Haiku subagent stays the default
  for short/foreground summaries).
- **Rationale:** a subagent that stops at an interim note is a reliability tax on every
  long gate; the backgrounded-command pattern gives one clean completion signal while keeping
  the verbose log out of context via the log file.
- **Reconsider when:** n/a (applied).
