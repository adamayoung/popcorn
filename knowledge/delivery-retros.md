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

### TV series details fetch-then-stream · `feature/tv-series-details-stream` (PR #TBD) · 2026-07-23 · full

*Phases / skills:* plan mode (2 Explore agents + a fable `plan-reviewer` pass — 0
blockers, all 4 should-fix + 4 nice-to-have folded into the plan) → `/deliver` →
`/review-plan` **skipped** (plan already reviewed this session) → `/implement-plan`
(Canon TDD; 3 commits: context stream layer → feature+app wiring → review error-path
fixes) → `/review-changes` (7-dimension fan-out: **0 crit/high, 3 medium, 0 dropped** —
all three were error-path test gaps, all applied) → `/security-review` (**clean**; the
fixes were test-only so the verdict stood, no re-run) → `/capture-knowledge` (ADR-0006 +
2 gotchas) → independent grader (**all 5 ACs met — PASS**). Added `tvSeriesStream`
end-to-end (domain → SwiftData observation + background TMDb refresh →
`StreamTVSeriesDetailsUseCase`), removed theme-colour extraction from the fetch, and
wired the feature's `observeTVSeriesUpdates()` — mirroring `MovieDetailsFeature`.

*What worked:*

- **Mirroring a merged sibling (movie details) end-to-end** made the plan and
  implementation fast and low-risk — the movie files were a near-complete blueprint at
  every layer.
- **The fable plan-review caught the movie code's latent per-tick `Task` hang** before
  implementation, so the TV copy *fixed* it (do/catch + continue; `finish(throwing:)` on
  terminal error) instead of inheriting it.
- **Phase 4 ∥ Phase 5 concurrent cold pass** — the 7-dimension code-review Workflow and
  the security agent ran simultaneously; the whole review stage cost one wall-clock.
- **Package-first verification** (`/test-package PopcornTVSeries`, 298 tests) validated
  the entire context layer before the slower full-app gate.

*Friction:*

- The Live `live()` function tripped `function_body_length` (50) once the stream closure
  was inlined — the TV Live closures carry Observability spans the movie ones don't, so
  the sibling's shape didn't fit; extracted a `makeStreamTVSeries` helper. One lint round.
- Testing the SwiftData notification re-yield is inherently flaky; settled on
  deterministic initial-snapshot tests + covered-by-reuse for the shared engine (gotcha).

*Deviations:* none from the approved plan; the three review fixes were additive
error-path tests (repo remote-failure, use-case terminal-error, view-model
stream-failure), no production change.

*One improvement:* for a "clone a sibling feature end-to-end" plan, make the plan-review
**explicitly diff the sibling for latent defects to carry-or-fix** — it did so here for
the `Task` hang, and that was the single highest-value catch; worth standardising for
clone-shaped plans.

### Person credits list from the "Known For" header · PR #88 · 2026-07-22 · full

*Phases / skills:* plan mode (3 Explore agents + 1 Plan agent, 3 product questions
answered up front) → `/deliver` → `/review-plan` **skipped** (ExitPlanMode approval)
→ `/implement-plan` (Canon TDD; 3 checkpoints: domain+adapter → use case → feature+
wiring) → `/review-changes` (7-dimension fan-out: **0 crit/high, 1 medium, 1 low, 0
dropped**; both applied) → `/security-review` (clean; delta re-check after fixes also
clean) → `/capture-knowledge` (1 gotcha) → independent grader (**all 4 ACs + entry
point met**). Added `PersonCredit.Role` payloads (character/job) + `releaseDate`,
`FetchPersonCreditsUseCase` (group-per-title, parts merge, newest-first/undated-first
sort), the `PersonCreditsFeature` package, and `.personCredits` routes in all three
tabs.

*What worked:*

- **Product questions before design.** Three AskUserQuestion decisions (cast+crew
  scope, flat newest-first layout, merged duplicate rows) settled the ambiguous 20%
  before the Plan agent ran — zero product rework downstream.
- **The Phase 4 ∥ Phase 5 concurrent cold pass** — security review and the
  7-dimension code-review Workflow ran simultaneously; the whole review stage cost
  one Workflow wall-clock.
- **Sibling templates carried the feature**: `MovieCastAndCrewFeature` for the
  view/VM/row shape, `PopularMoviesFeature` for the package shape, the documented
  5-part pbxproj edit applied cleanly first try.

*Friction:*

- One full-app gate failure: the feature's `CreditItemMapper` was `internal` but the
  App-layer Live builder needs it — package tests can't catch this (captured as a
  gotcha).
- A Haiku test-runner subagent returned "I'll wait" instead of running its command;
  needed a SendMessage nudge to get the result.

*Deviations:* none from the approved plan; review fixes were additive (error-mapping
test suite + destination-builder extraction).

*watch:* `Build (Release)` failed once — `CreditRow`'s unguarded `#Preview` used
DEBUG-only `CreditItem.mocks` (Debug gate can't catch it); fixed first attempt in
8d6b9063 after a local Release-build verify, then merged clean (squash ba2f771c).

*One improvement:* the `add-feature` scaffold (or its skill) should generate the
feature's context→presentation mapper as `public` with a public init from the start —
the internal-mapper trap will recur on every new feature otherwise.

### Person details "Known For" carousel · PR #87 · 2026-07-22 · full

*Phases / skills:* plan mode (inline exploration — Explore agents were declined, so
I read the code directly + 5 clarifying questions) → `/deliver` → `/review-plan`
**skipped** (ExitPlanMode approval counts as reviewed) → `/implement-plan` (Canon
TDD, per-package checkpoints) → `/review-changes` (7-dimension fan-out + adversarial
verify: **0 crit/high, 3 medium, 0 dropped**) → `/security-review` (clean) →
`/capture-knowledge` (1 new gotcha + 1 enhanced + ADR-0005) → independent grader
(**all 3 ACs PASS**). Added `FetchPersonKnownForUseCase` (combined-credits ranking),
two cross-context logo ports, the `KnownForCarousel`, and the Watchlist TV route set.

*What worked:*
- **Every hard part already had a merged reference.** The cross-context logo
  providers cloned Trending/Discover's `MovieLogoImageProviding` shape; the carousel
  cloned `RecommendedCarousel`; the Watchlist TV routes mirrored `SearchRoot`; the
  progressive per-section `knownForState` followed ADR-0002. Little was genuinely
  novel beyond the ranking heuristic (ADR-0005).
- **Per-package `swift test` green checkpoints** for the context (35→36 tests) and
  adapter (38) before the App was touched, then one full-app build/test/snapshot for
  the feature + wiring. Both reviews came back with nothing blocking.
- **The concurrent-mock segfault was diagnosed, not dismissed.** The logo fan-out's
  `withTaskGroup` crashed swift-testing with signal 11; recognised it as the
  documented unguarded-mock data race (not the scoping-traits flake) and fixed it
  with a `Mutex` — enhanced that gotcha with the masquerade note.

*Friction:*
- **A full restart from scratch, caused by writing to main-checkout paths.**
  `EnterWorktree` moves the Bash CWD, but `Edit`/`Write` take literal absolute
  paths — I passed `…/popcorn/Contexts/…` (main) instead of
  `…/popcorn/.claude/worktrees/<wt>/Contexts/…`, so the first ~9 files landed on the
  main working tree (empty `git status` in the worktree was the tell). A follow-up
  `rm` without `-C` then deleted files from the wrong tree. Recovered by reverting
  main clean and re-doing the work with worktree-prefixed paths. **Biggest time sink
  of the run.**
- **The reviewer's suggested `ForEach(id: \.element.id)` fix was unsafe** — TMDb
  movie/TV ids collide in a mixed-media list — so I applied only the valid half
  (drop the `Array` wrap, keep `\.offset`) and captured the trap.

*Deviations:*
- Security review **not** re-run after the Phase-4 fixes (they were a test + a
  below-the-fold view's identity/spacing — no security surface).
- No feature flag (Adam chose always-on), so no Statsig gate / `FeatureFlag` change.

*One improvement:* `/deliver` Phase 1 should state the **worktree-absolute path
prefix** once, explicitly, and every subsequent `Edit`/`Write`/`rm`/`cp` should use
it — the empty-worktree-`git status` check caught it, but only after 9 mis-targeted
files. Consider a Phase-1 reminder that `Edit`/`Write` paths are literal and do
**not** inherit the worktree CWD.

### Popular movies grid + paged popular pipeline · PR #83 · 2026-07-21 · full

*Phases / skills:* plan mode (`get_context` + 2 Explore + 1 Plan agent) → `/deliver`
→ `/review-plan` **skipped** (ExitPlanMode approval counts as reviewed) →
`/implement-plan` (Canon TDD, per-package checkpoints) → `/review-changes`
(7-dimension fan-out + adversarial verify: **0 findings, 0 dropped**) →
`/security-review` (clean) → `/capture-knowledge` (2 gotchas, no ADR) → independent
grader (**all 7 ACs met**). Threaded TMDb `page`/`totalPages` through the
`PopcornMovies` popular stack (mirroring Discover's cache-aware paged pipeline) and
mirrored `TrendingMoviesFeature` into a new `PopularMoviesFeature`, made the Explore
"Popular Movies" header tappable.

*What worked:*
- **The entire popular-movies backend already existed** — `FetchPopularMoviesUseCase`
  was wired into `AppServices` and already feeding the Explore carousel behind the
  registered `explorePopularMovies` flag. Exploration caught this up front, so the
  only real design work was making that use case paged; the feature + header were
  pure replication. No new flag, no Statsig gate.
- **Discover had already shipped the exact SwiftData change.** The optional
  `totalPages` on the cache entity + "nil totalPages ⇒ treat as a miss so it
  self-heals" pattern was copied 1:1 from `SwiftDataDiscoverMovieLocalDataSource`,
  which de-risked the only migration-touching part of the change.
- **Cloning the feature package via `cp -R` + `sed`** (Trending→Popular, with
  context-product names substituted first so the generic rename didn't catch them).
  Because every substitution was equal-or-shorter length, `make format` reported
  **0 files changed** and lint passed first try — the clone inherited the reference's
  formatting exactly.
- **Per-package green checkpoints, then one full-app pass.** `PopcornMovies` (117
  tests) + the adapter (99) validated via `swift test` before the App was touched;
  feature + wiring + Explore validated together via full-app build/test/snapshot.
  Code review (7 Opus dimensions) and security review both came back clean first pass.

*Friction:*
- **The 5-part `project.pbxproj` hand-edit again** (already in `gotchas.md` from
  PR #82) — mechanical but unforgiving; `plutil -lint` after the edit is the cheap
  safety check.
- **A `.disabled` adapter test suite silently swallows new coverage.**
  `TMDbMovieRemoteDataSourceListsTests` is disabled (swift-testing hangs on typed-throws
  async), so the two new popular page/clamp adapter tests compile but never run —
  captured to `gotchas.md`. Adapter paging is really validated by compile + full-app.
- **Snapshot re-records took two runs** (record `.missing` → assert-green), plus a
  manual delete of the stale `exploreView.1.png` before the record pass (an
  existing-but-changed baseline isn't auto-overwritten). Predictable, same as PR #82.

*Deviations:*
- **Skipped `/review-plan`'s critics.** The plan carried `ExitPlanMode` approval and
  was authored by a dedicated Plan agent; I additionally self-verified the two riskiest
  files (the popular repository + SwiftData local source) before implementing. Justified
  by the deliver rule, but worth noting the plan wasn't independently critic-reviewed.

*One improvement:*
- **The `( make … ) &` double-backgrounding bug recurred** — PR #82's retro already
  flagged it, and it bit again this run (the wrapper's `&` detached the real build, so
  the harness fired a premature "exit 0"). It cost a confused round-trip. This is now a
  twice-seen pattern: `/deliver`'s *Context & isolation* note should explicitly say
  **"never nest `&` inside a `run_in_background` gate command — let the job run the
  command in its foreground"**, not just describe the `EXIT=$?` marker.

### Discover movies grid + reusable PosterGrid · PR #82 · 2026-07-21 · full

*Phases / skills:* plan mode (`get_context` + 3 Explore + 1 Plan agent) → `/deliver`
→ `/review-plan` (3 Opus critics, all *sound-with-fixes*, 5 minor findings applied)
→ `/implement-plan` (Canon TDD, per-package checkpoints) → `/review-changes`
(7-dimension fan-out + adversarial verify: **0 Critical/High/Medium, 1 Low applied**)
→ `/security-review` (clean) → `/capture-knowledge` (ADR-0004 + 1 gotcha) →
independent grader (all 6 ACs met). Extracted the ADR-0003 grid into a shared
`DesignSystem.PosterGrid` and mirrored `TrendingMoviesFeature` into a new
`DiscoverMoviesFeature`.

*What worked:*
- **A full `PopcornDiscover` context already existed** — wired into `AppServices`,
  the `exploreDiscoverMovies` flag already registered, the local SwiftData cache
  already paginated. Exploration caught this up front, so the work was "add the
  ADR-0003 paged treatment to the movies path + a see-all screen", not greenfield —
  killing a lot of speculative scope before planning.
- **The PosterGrid extraction gated on trending's snapshot baselines** as the
  pixel-identity contract. Reproducing the exact cell view-tree (same constants,
  modifier order, a11y IDs) meant both trending baselines passed **unchanged** on the
  first snapshot run — proof the refactor was behaviour-preserving.
- **Per-package/per-layer green checkpoints.** `PopcornDiscover` (50 tests) + the two
  adapter packages (65 + 49) validated via `swift test` before the App was touched;
  the feature + wiring validated together via one full-app build/test/snapshot pass.
  Four tight commits, each green.
- **`/review-plan` earned its keep on the ripple.** The critics flagged the two
  compile-forced infra mocks, the dead adapter `movies(page:)` overload, and the
  verbatim-a11y-label regression *before* implementation, so all were handled inline
  rather than discovered at build time. The code review then found only 1 Low.

*Friction:*
- **Wiring a new feature package into `project.pbxproj` is a 5-part hand-edit**
  (Xcode-16 synchronized folders, empty `packageReferences`, a `membershipExceptions`
  entry) — non-obvious and undocumented by `add-feature`; captured to `gotchas.md`.
- **The plan-review critics hit a session usage limit** on the first run (2pm reset)
  and all three errored mid-flight; a retry one minute after the reset succeeded. One
  wasted 3×Opus×xhigh burst — nothing actionable beyond "retry after reset".
- **Snapshot re-records took three runs.** `record: .missing` writes new baselines
  but fails-on-first-run, and an existing-but-changed baseline (the ExploreView
  chevron) is **not** auto-overwritten — so: run → delete the stale `exploreView.1.png`
  → run (records) → run (assert-green). Predictable but three full-app snapshot passes.

*Deviations:*
- Ran the security review **in parallel** with a unit-test verification (both
  read-only against the same committed state) to save wall-clock, rather than strictly
  serial.

*One improvement:*
- The backgrounded-gate pattern (`make … > log 2>&1; echo "EXIT=$?"`, `run_in_background`)
  makes the harness completion notification report the trailing **echo's** exit (0),
  not make's — twice I had to grep the log's `EXIT=` marker for the real code, and once
  a `( … ) &` wrapper double-backgrounded the build so the notification fired for the
  immediately-exiting launcher. Worth a one-line note in the gate-running guidance:
  run the `make` command directly under `run_in_background` (no subshell), and always
  read the log's `EXIT=` marker — never trust the notification's exit code.

### Trending movies infinite scroll · PR #80 · 2026-07-21 · full

*Phases / skills:* plan mode (2 Explore + 1 Plan agent, `AskUserQuestion` on
end-of-list detection) → `/deliver` → `/implement-plan` (Canon TDD, per-package
checkpoints) → `swift-concurrency` (loadMore re-entrancy design) → `/review-changes`
(7-dimension fan-out + adversarial verify) → `/security-review` → `/capture-knowledge`
(ADR-0003 + 1 gotcha) → independent grader (all 6 ACs met). First infinite-scroll UI
in the codebase; also a mid-run live-simulator verification (see deviations).

*What worked:*
- **The `page:` param was already threaded end-to-end** (use case → repository →
  adapter → TMDb); exploration confirmed the gap was purely top-of-stack, so the diff
  concentrated in the view model + view + adapter metadata rather than a deep refactor.
- **Per-package TDD units.** Context (102 tests) and adapter (57 tests) validated via
  `/test-package`; the feature (which can't CLI-build) + composition verified together
  via one full-app `make test`. Fast where SwiftPM works, one xcodebuild pass where it
  doesn't.
- **Live-sim verification gave a definitive answer.** When the user reported scroll not
  loading, driving the *branch* build on a simulator (poster index climbed 11→179, the
  footer spinner observed) proved the feature works and the user was testing `main` —
  a fact, not a guess.
- **Consulting `swift-concurrency` before writing `loadMore`** confirmed the
  re-entrancy design (`isLoadingMore` set before the first `await` on `@MainActor`)
  up front, so the concurrency lens of the review was clean by construction — 0
  Critical/High overall, only 2 test-coverage edges (both applied).

*Friction:*
- **A feature package can't build via the SwiftPM CLI at all** — `swift build` (even
  sources-only) trips on committed `__Snapshots__` PNGs as unhandled resources, on top
  of the known UIKit-in-snapshot-target issue. Cost a subagent round-trip before it was
  clear; captured to `gotchas.md`. Every feature-code iteration pays full-app xcodebuild
  cost. **This is the third retro in a row to hit the feature-package-can't-CLI-build
  wall** (#79, explore-trending, this).
- **Strict test-file limits bit twice** — `type_body_length` is effectively 250 for
  tests under `--strict`; the pagination suite needed splitting into two suites + a
  shared support file after the first `make lint`.

*Deviations:*
- Skipped a standalone `/review-plan` — the plan went through plan-mode Explore+Plan
  design + an `AskUserQuestion` decision this session, and `ExitPlanMode` approval is
  the Phase 2 skip condition.
- Ran an **unplanned live-simulator verification** mid-run (user reported the feature
  not working). Not a pipeline phase, but the right call to answer "is it actually
  broken?" definitively rather than speculating — root cause was the user on `main`.

*One improvement:* the `/test-package` skill should **hard-gate feature packages** —
detect a snapshot-test target (or a `__Snapshots__` dir) and refuse up front with "use
the full-app gate", instead of leaving both blockers (UIKit + unhandled-resources) as
trailing notes that cost a wasted subagent run each time. Three consecutive retros now
carry this friction.

### Progressive movie & TV details render · PR #79 · 2026-07-21 · full

*Phases / skills:* plan mode (Explore + Plan agents) → `/deliver` → `/implement-plan`
(Canon TDD, 5 checkpoints A–E) → `/review-changes` (7-dimension fan-out + adversarial
verify) → `/security-review` → `/capture-knowledge` (ADR-0002 + 2 gotchas) → independent
grader (all 6 ACs met). Perf investigation → progressive render for both details screens,
recommendations-pipeline trim, theme colour off the critical path.

*What worked:*
- **Grounding the test list in sibling patterns first.** Reading the canonical
  `DefaultFetchTVSeriesDetailsUseCaseTests` + the closure-stub feature-VM pattern before
  writing any test meant the new suites matched house style and passed on the first
  full-app run — no test-shape churn.
- **Package-level gate per checkpoint, full-app gate once at the end.** A/B validated via
  `/test-package` (84 + 94 + 7 tests) kept the loop fast; the full `build-for-testing +
  test + test-snapshots` ran once for C–E. Warnings-as-errors caught the `CIContext`
  `nonisolated(unsafe)` slip immediately.
- **The review fan-out was clean by construction** — 0 Critical/High/dropped, only 2
  Medium (literal spacing → `.spacing*`), because the concurrency gotchas (`async let`
  vs serial tuple await, `Mutex`-guarded mocks for task-group fan-out) were consulted
  from `knowledge/` up front rather than rediscovered in review.

*Friction:*
- **A build subagent made an unrequested `Package.swift` edit** (adding
  `resources: [.process("__Snapshots__")]`) while "fixing" a sources build — reverted. A
  Haiku build/test subagent should report problems, not mutate the tree.
- The two planned "sections loading" snapshots recorded **near-blank** — the
  `StretchyHeaderScrollView` header fills the frame so the placeholders sit below the fold
  (new gotcha). Opening the PNGs (not trusting the green run) caught it; dropped both and
  covered the loading states in VM tests instead.

*Deviations:*
- Dropped the 2 loading-state snapshots the plan called for (below-fold, identical to the
  ready baseline — validate nothing); the section-state logic is fully covered by the VM
  suites. Noted in the feature commit and gotchas.
- Skipped a standalone `/review-plan` — the plan had just been through plan mode's
  Explore+Plan design with an adversarial 11-risk pass this session.

*One improvement:* the build/test Haiku subagents should be constrained to **read-only +
report**; an autonomous `Package.swift` "fix" during a sources build is exactly the kind
of silent tree mutation the worktree-diff-verification discipline exists to catch.

### Trending movies poster grid · `feature/explore-trending-movies-navigation` · 2026-07-20 · full

*Phases / skills:* plan mode → `/deliver` (no worktree — see deviations) →
`/review-changes` (7-dimension fan-out + adversarial verify) → `/security-review` →
`swiftui-accessibility-expert` → `/capture-knowledge` → independent grader. Scope grew
twice mid-run at the user's request: a zoom transition, then a `ViewState` migration.

*What worked:*
- The **review fan-out earned its cost outright.** It found that the `ExploreView`
  snapshot baseline was never re-recorded after the trending header became a button with
  a chevron. Confirmed by actually running the test — it failed, and would have turned CI
  red on merge. Zero of the Critical/High findings were dropped by adversarial verify.
- **Looking at recorded snapshots, not just their exit codes.** Both a wrong 3-across
  assumption and a bogus error-state test were caught by opening the PNG. A green
  snapshot run means "matches the baseline", not "the baseline is right".
- Consulting `swiftui-accessibility-expert` surfaced a missing `accessibilityHint` that
  the obvious sibling (`WatchlistView`) omits but eight other views implement.

*Friction:*
- `swift test` in the feature package can't build (snapshot target → UIKit), so every
  iteration paid full-app build cost. The `/test-package` skill documents this, but only
  in a trailing note — it cost a wasted subagent run before it was found.
- One `make test` died with `Failed to create a bundle instance representing
  PopcornTests.xctest` with **zero** failing tests; clean on retry. Cost a triage detour.
  Worth noting alongside the existing `Runner._applyScopingTraits` flake entry.
- Editing `.xcstrings` with a JSON round-trip reformatted the whole catalog (127-line
  diff, key reorder, lost trailing newline). Edit string catalogs **textually**.

*Deviations:*
- **No worktree.** Phase 1 found the branch had zero commits ahead of `main` with the
  entire Explore-navigation feature uncommitted; branching elsewhere would have stranded
  it. Committed it in place first (user-confirmed) and worked on the existing branch.
  The skill assumes a clean tree and has no branch for this.
- Skipped a second full fan-out after the fix commit — used the single-reviewer path,
  since the fix diff was small. Matches `/review-changes`'s own sizing rule.
- Left two known items unfixed by choice: a dead `openTVSeriesDetails(id:)` (user's own
  in-flight code, explicitly asked to preserve) and the sibling `TrendingPeople` /
  `TrendingTVSeries` view models, which have the same missing-error-state shape but are
  not yet reachable.

*One improvement:* `/deliver` Phase 1 should explicitly handle "uncommitted work already
in the tree" — commit-in-place on the current branch is the safe move, and the current
worktree-first instruction actively risks stranding the user's work.

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

## Archive

Distilled older entries — `date · PR · weight · one-line outcome` (full prose in git
history).

| Date | PR | Weight | Outcome |
| --- | --- | --- | --- |
| 2026-07-05 | #63 | medium | MediaSearch error/retry state; CI `claude-review` caught a real High (retry re-derived the loader from mutable `query`) the local reviewer missed; `.error` snapshot deferred to the iOS 26.5 baseline |
| 2026-07-05 | #62 | full (mechanical) | 22-site async-let sweep via subagent; green first try; surfaced the broken iOS 26.5 simruntime that dogged later runs |
