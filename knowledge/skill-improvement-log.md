# Skill-Improvement Log

A durable record of every skill-improvement proposal raised by `/deliver`'s
**Phase 6 recurring-pattern scan**, and the decision on it. Newest at the top.

**Why this exists:** the Phase 6 scan surfaces proposals and waits for approval.
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

### 2026-07-05 — Run long gates as backgrounded Bash + Monitor, not a Haiku subagent · deferred

- **Pattern:** for the multi-minute `make lint`/`build`/`test` gates (PRs #62–#64), Haiku
  gate subagents repeatedly returned interim "still waiting" notes instead of a final
  consolidated result, needing nudges. Switching mid-run to a backgrounded `Bash`
  (`run_in_background`) that writes to a log + greps terminal markers (with a `Monitor` on CI)
  was reliable and kept logs out of context.
- **Decision:** *deferred* — pending owner approval. Candidate change: the `/deliver`
  gate guidance (and the `/build`/`/test` wrappers when not inside Xcode) should prefer a
  backgrounded shell command that self-reports on exit over a Haiku subagent for
  long-running, single-result gate steps.
- **Rationale:** a subagent that stops at an interim note is a reliability tax on every
  long gate; the backgrounded-command pattern gives one clean completion signal.
- **Reconsider when:** the owner reviews these, or subagent long-run reporting becomes reliable.
