# Delivery Retrospectives

A short, honest entry per feature delivered via `/deliver` (its Phase 6), newest at
the top. The point is **continuous improvement**: when the same friction or
deviation recurs across entries, fold the fix into the relevant skill. Keep each
entry to a handful of bullets — a log, not a ceremony.

Format: **Feature / PR** · date · weight · *phases completed / skills invoked* ·
*what worked* · *friction* · *deviations* · *one improvement*.

Retention: keep ~12 entries in full prose; distil older ones into a one-line archive
table (`date · PR · weight · one-line outcome`) — see [`README.md`](README.md) →
*Maintenance & retention*.

---

<!-- Newest entry goes here. -->

### Third-party dependency update · PR #76 · 2026-07-09 · full

- *Phases / skills:* worktree → (`review-plan` skipped — plan approved via `/deliver`) →
  manual bump + re-resolve → `review-changes` (single reviewer, clean) → `security-review`
  (no findings) → `capture-knowledge` → independent rubric grader (PASS) → retro → `pr`.
  Bumped TMDb 18.0.0→18.2.0 (×9 adapters), sentry-cocoa 9.17.0→9.21.0,
  swift-snapshot-testing 1.19.2→1.19.3; statsig-kit + SDWebImageSwiftUI already latest.
- *What worked:* release-note review at plan time flagged the only anticipated risk (the
  snapshot 1.19.3 safe-area fix — which proved benign, 18/18 passed, no re-record). The
  "enumerate all sites up front" discipline paid off: one type-driven grep found all three
  exhaustive switches over the affected enums, so the TMDb `Status.unknown` break was fixed
  completely rather than one build-error at a time. The independent grader re-swept every
  `Package.swift` and confirmed no third-party dep was missed.
- *Friction:* the "mechanical version bump" was **not** mechanical — TMDb 18.2.0 (a *minor*
  bump) silently added `Status.unknown`, breaking exhaustive switches at compile time; the
  build halts at the first, so the full blast radius isn't visible from a single failure.
  The SPM-vs-xcodebuild transitive-resolution divergence and the gitignored-per-package
  `Package.resolved` facts each needed investigation (both captured to `gotchas.md`).
- *Deviations:* skipped pure-TDD for the version bump itself (no new behaviour to drive) —
  the `Status.unknown` fix **was** done test-first at three layers. Applied one advisory-Low
  from review (a persistence round-trip test). Left a pre-existing, unrelated
  `'as' test is always true` warning (`MovieIntelligenceViewModel:100`, `LLMSession`
  typed-throws) untouched, per "don't patch unrelated issues onto this branch".
- *One improvement:* a dependency-bump plan should include a standing step — "grep the dep's
  public non-frozen enums and every exhaustive switch over them" — because a minor/patch bump
  adding an enum case is a recurring, compile-breaking surprise that a clean build reveals
  only one site at a time.

### DI de-coupling epic (feature packages → leaves) · PRs #66–#72 · 2026-07-05 · full (epic)

- *Phases / skills:* ADR-first, then a reference PR (MovieDetails) + 5 batch PRs
  (by context family); implement via per-batch subagents following ADR-0001, focused
  `code-reviewer` on the wrinkly batches, self-review on the mechanical ones, per-batch
  gate + CI watch + squash-merge. 7 PRs; all 20 feature packages now leaves.
- *What worked:* the reference-PR-then-recipe approach — once MovieDetails proved the
  pattern, batches were near-mechanical and parallel-safe (disjoint feature dirs).
  Build-driven import discovery (member-import-visibility diagnostics) reliably found each
  feature's exact `+Live` imports. The CI `claude-review` bot + self-review covered the
  mechanical batches cheaply; full `code-reviewer` caught the real subtleties (PersonDetails
  error re-dispatch, Explore's private helper, over-exposed MediaSearch mappers).
- *Friction:* two assumptions only surfaced at the finish line — the App got
  `AppDependencies` **transitively through the feature packages**, so converting the *last*
  one needed a direct App-target `.pbxproj` edge (corrected ADR-0001). Per-feature wrinkles
  (Intelligence dep-swaps, Developer's `#if DEBUG` + nested file, `*Application`→`*Domain`
  swaps) each needed empirical build iteration.
- *Deviations:* lighter self-review (not a full `code-reviewer`) on the mechanical batches
  to conserve budget — the CI bot backstopped it. Discovered the Trending features are
  **unwired/orphaned** (their `.live` has no caller) — made them leaves uniformly and
  flagged for a wire-or-delete decision rather than expanding scope.
- *One improvement:* an ADR that makes a "no project-file change needed" claim should be
  validated against the **whole** sweep, not just one instance — the transitive-crutch only
  bites at the last conversion.

### Test-debt ratchet (Trending + PlotRemixGame backfill) · PR #65 · 2026-07-05 · full

- *Phases / skills:* two parallel backfill subagents (disjoint contexts) + inline
  config/CI work; single `code-reviewer`; `capture-knowledge`; gate; CI watch; merge.
  181 new tests; coverage enabled; UI-test job re-added; 4 straggler placeholders deleted.
- *What worked:* parallelising the two context backfills against disjoint packages;
  characterization-test discipline, which surfaced **5 latent production bugs** (poster-sized
  backdrops, hardcoded game genre, progress off-by-one, error-type flattening, dead deps).
- *Friction:* the session limit hit mid-item — paused cleanly (no work committed yet) and
  resumed on reset. Backfill subagents returned interim "waiting" notes; had to nudge one.
  The full local suite hit the `_applyScopingTraits` SwiftData parallel-load flake
  (`TVListingsInfrastructureTests`), which isolation-passed 70/70.
- *Deviations:* the review's delete-list would have emptied 6 sole-file targets (caught in
  planning by the Fable review); deleted only the 4 true stragglers. People/Search deferred.
- *One improvement:* the pre-PR gate should auto-isolate-retry a flaked SwiftData suite and
  report it as a flake, not a scary full-suite `TEST FAILED`.

### SpanContext test data race · PR #64 · 2026-07-05 · full

- *Phases / skills:* implement (subagent) → `code-reviewer` → `capture-knowledge` → gate →
  watch → merge. Made the global provider bootstrap-only (`configure`), migrated 10 test
  sites to `$localProvider`, then `Mutex`-guarded the global (review's one Medium).
- *What worked:* clean root-cause fix; the reviewer's `Mutex` hardening completed the
  concurrency story; direct-`xcodebuild` targeted runs (351+36 tests) verified reliably.
- *Friction:* first discovery of the `make test` `DESTINATION`-override quoting trap (it
  silently ran against the broken iOS 26.5 runtime → 0 tests). Cost real time + a confusing
  subagent loop.
- *Deviations:* local verification via direct-`xcodebuild` targeted runs + `build-for-testing`
  rather than the flaky `make test` full-suite; CI as the authoritative full-suite gate.
- *One improvement:* pin the simulator reliably (UDID or a robust `DESTINATION` mechanism),
  or make the gate detect the FoundationModels dlopen / "0 tests executed" and fail loudly.

### MediaSearch error state + retry · PR #63 · 2026-07-05 · medium

- *Phases / skills:* implement test-first (subagent, 4 tests) → `code-reviewer` (1 Medium
  folded in) → gate → watch → merge.
- *What worked:* the CI `claude-review` bot earned its keep — it caught a real **High**
  (retry inferring the wrong loader from mutable `query`, stranding genres behind
  `guard case .initial`) that the local reviewer missed; fixed test-first with a
  deterministic divergence test.
- *Friction:* the `.error` snapshot had to be deferred — recording a new reference needs the
  broken iOS 26.5 runtime, and recording on 27.0 would mismatch CI's 26.5 baseline.
- *Deviations:* snapshot deferred to follow-up; local tests on iOS 27.0.
- *One improvement:* `/review-changes` could add a lens for "retry/reload target re-derived
  from mutable UI state that can change between failure and retry" — the exact class the bot
  caught and the local reviewer didn't.

### async-let use-case sweep · PR #62 · 2026-07-05 · full (mechanical)

- *Phases / skills:* implement (subagent, 22 sites) → `code-reviewer` → `capture-knowledge`
  → gate → watch → merge. Behaviour-preserving concurrency win.
- *What worked:* delegating the mechanical 22-site sweep kept the conductor context lean;
  code review confirmed byte-level correctness; CI green first try.
- *Friction:* the local iOS 26.5 simulator runtime is environmentally broken (FoundationModels
  symbol mismatch), so `make test` couldn't run — surfaced to the user, who directed iOS 27.0.
  This recurred for every subsequent item.
- *Deviations:* ran local tests on iOS 27.0 (not the Makefile default 26.5); deferred local
  snapshots to CI (no UI change).
- *One improvement:* the `/pr` gate should detect an SDK/simruntime mismatch (build succeeds
  but 0 tests execute) and fall back to another installed runtime — or surface it — instead
  of a confusing "test execute failed".
