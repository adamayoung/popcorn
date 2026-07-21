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
