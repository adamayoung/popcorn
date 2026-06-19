---
name: review-plan
description: Adversarially review the current implementation plan with three independent critic subagents, reconcile their findings into a consensus, and apply the agreed feedback to the plan. Use after drafting a plan (in plan mode or a plan/design doc) and before starting implementation, or whenever the user asks to pressure-test, critique, or harden a plan.
---

# Review Plan

Pressure-test the **current plan** before any code is written. Three independent
adversarial critics review the plan in parallel, each from a distinct lens; their
findings are reconciled into a consensus; and the agreed feedback is folded back
into the plan. The point is to surface the gaps, risks, and over-engineering that
a single pass misses — three skeptics, not one cheerleader.

> A plan that survives three hostile reviewers is worth implementing. A plan that
> nobody challenged is just the first idea that came to mind.

## Agent Behaviour Contract

The point of this skill: do these by default, without being reminded.

1. **Find the plan first; never invent one.** Locate the actual current plan
   (see *Locate the plan*). If there is no plan, say so and stop — do not
   fabricate a plan just to review it.
2. **Pick the weight, then run the right path.** Small, low-risk plans take the
   **lite path** (the existing `plan-reviewer` agent). Risky or large plans take
   the **full path** — the embedded `Workflow` script, which fans out exactly
   three critic agents in parallel, each pinned to the **`opus`** model at
   **`xhigh`** effort and forced to return a schema-validated verdict. Each
   carries a distinct adversarial mandate. Reviewers are read-only — they
   critique, they do not edit the plan or the code. (See *Lite vs full*.)
3. **Adversarial, not agreeable.** Each reviewer assumes the plan is flawed and
   hunts for the strongest objection. A reviewer that finds nothing must say so
   explicitly *and* justify why each common failure mode does not apply.
4. **Ground every finding in the codebase.** Findings must cite real files,
   symbols, or constraints (`file:line`) — not generic plan-review platitudes.
   An objection that cannot be tied to this repository's reality is noise.
5. **Reconcile to a consensus — you adjudicate.** Merge overlapping findings,
   record agreement level, and resolve direct contradictions yourself with a
   stated rationale. Do not just concatenate three reports.
6. **Apply the agreed feedback, then show your work.** Revise the plan in place,
   then report what changed, what was deliberately rejected, and why.

## Locate the plan

Use the first that applies:

1. **An explicit target** the user named — a file path (e.g. a design doc or
   `PLAN.md`), or plan text passed as the skill argument.
2. **The active plan-mode plan** — the most recent plan you presented via
   `ExitPlanMode`, or the plan you are currently drafting in plan mode.
3. **A plan in the conversation** — the most recent structured plan / task
   breakdown you produced (including a `TodoWrite` list framed as the plan).

If none of these exists, stop and tell the user there is no plan to review, and
offer to draft one (e.g. via the `Plan` agent or plan mode) first.

Before reviewing, restate in one or two sentences **what the plan is for** (the
underlying goal/task) — the reviewers need the problem, not just the proposed
solution, to judge whether the solution fits.

## Lite vs full

- **Lite path (single reviewer).** A small, localised, low-risk plan — an
  internal change inside one package, a new test, a bug fix with no public-API or
  cross-context impact, no SwiftData/CloudKit schema change, no new feature flag.
  Run the existing **`plan-reviewer`** agent once (`Agent` tool,
  `subagent_type: "plan-reviewer"`), pass it the plan + goal, and reconcile its
  single verdict. If it surfaces a `blocker`/`[CRITICAL]`, stop and apply before
  implementation.
- **Full path (three critics).** A risky or large plan — touches a public API or
  a context's Composition/factory wiring, spans multiple packages, changes a
  SwiftData `@Model`/schema (CloudKit migration risk), adds or changes a
  `FeatureFlag`/Statsig gate, adds a new feature/context/screen, or you are
  unsure. Run the embedded `Workflow` below.

When in doubt, go full — the cost of three Opus critics is cheap against a
flawed plan discovered mid-implementation.

## Run the full review (Workflow)

The three critics run as a single `Workflow` so that the **`opus`** model and
**`xhigh`** effort are guaranteed per agent (these are first-class `agent()`
options) and each verdict is **schema-validated** rather than free-text. Invoking
this skill is itself the opt-in to call the `Workflow` tool.

Pass the plan and goal as `args` — never inline them into the script body (they
contain arbitrary text). Call `Workflow` with `args: { plan: "<full plan text>",
goal: "<one–two sentence restatement of the underlying task>" }` and the script
below. The three lenses live in the script; only `args` changes per run.

> **Args may arrive stringified.** The harness sometimes delivers `args` to the
> script as a JSON **string** rather than an object, so reading `args.plan`
> directly yields `undefined` and the critics silently review an empty plan. The
> script below already guards against this (`typeof args === 'string' ?
> JSON.parse(args) : args`) — keep that guard. If a critic ever reports the plan
> or goal is literally `"undefined"`, this is the cause: the args weren't parsed.

```javascript
export const meta = {
  name: 'review-plan-critics',
  description: 'Three adversarial Opus critics review a plan in parallel',
  phases: [{ title: 'Review', detail: 'three opus/xhigh critics, one per lens' }],
  model: 'opus',
}

const RUBRIC = `Grade each finding by CONSEQUENCE IF THE PLAN SHIPS UNCHANGED, not by your confidence:
- blocker: the plan will fail or do harm as written (goal not met, wrong approach, breaking public API, CloudKit/SwiftData schema migration that loses data, data-race/Sendable violation that won't compile under Swift 6.2 strict concurrency, irreversible step with no rollback). Implementation must not start until resolved.
- major: can proceed but will likely cause real pain (missing edge case/error path, no test coverage for new behaviour at some layer, significant over-engineering or scope creep, missing factory/router wiring, ungated feature flag, violated project convention).
- minor: a refinement that does not change viability (step ordering, naming, small simplification, missing /// doc comment, preview/localization reminder).
If unsure whether a finding is real, set "confidence" to low/medium and say so in the claim — do NOT inflate or deflate severity to express doubt.`

const LENSES = [
  {
    key: 'correctness',
    title: 'Correctness & Architecture',
    brief: `Does the plan actually achieve the goal, and does it fit Popcorn's architecture? This is a modular SwiftUI app (Clean Architecture + DDD + MVVM — see CLAUDE.md and docs/ARCHITECTURE.md). Hunt for: missing steps, wrong assumptions about how the code works, unhandled edge cases and error paths, ordering/dependency mistakes, and "done" criteria that do not actually prove the feature works. Scrutinise the MVVM contract: an @Observable @MainActor view model exposing a ViewState<ViewSnapshot>, the .loading → .ready/.error lifecycle driven from .task(id:), the feature's *Dependencies struct (Sendable closures + live(services:)) and *Navigating protocol. Scrutinise Clean-Architecture layer boundaries: domain entities free of external deps; mappers at EVERY layer boundary (TMDb→Domain→Application→Feature); use cases in *Application; the Popcorn{Context}Factory exposing new use cases; the AppServices composition root and ViewModelFactory wiring. Verify the navigation wiring is complete: every router/navigator that hosts the feature implements the *Navigating requirement, each tab's Route enum gets its case, destinations are built via ViewModelFactory and rendered by a private func (not inline in the switch). Verify SwiftData/CloudKit modelling is sound (@Model shape, relationships, optionality CloudKit requires).`,
  },
  {
    key: 'risk',
    title: 'Risk & Failure Modes (red team)',
    brief: `Assume the plan ships and something breaks. Hunt for: breaking changes to a package's public API; Swift 6.2 strict-concurrency hazards (Sendable conformance, actor isolation, @MainActor crossing, non-Sendable @Model classes shared across tasks); SwiftData/CloudKit schema-migration risk (renamed/removed @Model properties, NSNumber→NSString store mismatches, reserved-name collisions like id/hash that only crash on the on-disk store, missing default values that break existing stores); hidden coupling and side effects; cross-context provider-protocol contracts (a context consuming another via a Provider port); feature-flag/Statsig gating gaps (a new FeatureFlag with no corresponding gate, or gated behaviour with no enabled/disabled test path); flaky or environment-dependent tests; and the absence of a rollback or verification path. Rank by blast radius — public-API and persisted-schema changes have the widest.`,
  },
  {
    key: 'simplicity',
    title: 'Simplicity, Scope & Test Coverage',
    brief: `Assume the plan does too much, the wrong way, and under-tests it. Hunt for over-engineering and speculative generality (YAGNI), scope creep beyond the stated goal, reinvention of something the codebase already provides (an existing use case, mapper, router pattern, DesignSystem component, Caching/Observability platform package), and divergence from established conventions — check a sibling implementation (e.g. Features/MovieDetailsFeature) and propose the simpler alternative the plan should have taken. Then enforce Popcorn's "tests at ALL layers" checklist: every new feature needs adapter mapper tests (property mapping, nil handling, empty arrays, fallback values), use-case tests (happy path AND error translation for each error type, app-config failure), and view-model tests (.loading → .ready/.error transitions, loading/ready guards, navigation calls, and BOTH enabled and disabled paths for any feature flag) — not just the happy path. Flag missing snapshot coverage for new views, and missing test-plan registration (new unit-test targets MUST be added to TestPlans/PopcornUnitTests.xctestplan or they never run; snapshot targets go to PopcornSnapshotTests.xctestplan).`,
  },
]

const VERDICT_SCHEMA = {
  type: 'object',
  additionalProperties: false,
  properties: {
    lens: { type: 'string' },
    stance: { type: 'string', enum: ['sound', 'sound-with-fixes', 'not-ready'] },
    findings: {
      type: 'array',
      items: {
        type: 'object',
        additionalProperties: false,
        properties: {
          severity: { type: 'string', enum: ['blocker', 'major', 'minor'] },
          confidence: { type: 'string', enum: ['high', 'medium', 'low'] },
          claim: { type: 'string', description: 'one-line statement of the problem' },
          evidence: { type: 'string', description: 'file:line or a concrete repo constraint' },
          suggestedChange: { type: 'string', description: 'concrete change to make to the plan' },
        },
        required: ['severity', 'confidence', 'claim', 'evidence', 'suggestedChange'],
      },
    },
    cleanNote: { type: 'string', description: 'if a category is clean, why each common failure mode does not apply' },
  },
  required: ['lens', 'stance', 'findings'],
}

// `args` can arrive as a JSON string rather than an object (a known harness
// gotcha), in which case `args.plan` / `args.goal` would be `undefined` and the
// critics would review an empty plan. Parse it back to an object first.
const input = typeof args === 'string' ? JSON.parse(args) : args
const plan = input.plan
const goal = input.goal

phase('Review')
const verdicts = await parallel(LENSES.map((lens) => () =>
  agent(
    `You are an ADVERSARIAL plan reviewer for the Popcorn iOS/macOS/visionOS app. Assume the plan is flawed and find the strongest objections through the lens of "${lens.title}".\n\n` +
    `${lens.brief}\n\n` +
    `THE GOAL THIS PLAN MUST ACHIEVE:\n${goal}\n\n` +
    `THE PLAN UNDER REVIEW:\n${plan}\n\n` +
    `You are READ-ONLY: read the codebase (CLAUDE.md, docs/ARCHITECTURE.md, sibling features/contexts) to verify your claims against real files/symbols, but do not edit anything or run mutating commands. Every finding MUST cite concrete evidence (file:line or a real repo constraint) — generic plan-review platitudes are noise and must be omitted. If your lens is genuinely clean, return an empty findings array and explain in "cleanNote" why each common failure mode does not apply.\n\n` +
    `SEVERITY RUBRIC:\n${RUBRIC}`,
    { label: `critic:${lens.key}`, phase: 'Review', model: 'opus', effort: 'xhigh', schema: VERDICT_SCHEMA }
  ).then((v) => v && { ...v, lens: lens.title })
))

return verdicts.filter(Boolean)
```

The script returns an array of up to three verdicts. If a critic dies, it drops
to `null` and is filtered out — note in your reconciliation if fewer than three
came back. To iterate on the script, edit the file path returned by the
`Workflow` tool and re-invoke with `{ scriptPath }` rather than resending it.

## Severity rubric

Every reviewer grades each finding against the same rubric, so severities are
comparable when you reconcile. Severity is about **consequence if the plan ships
unchanged**, not how confident the reviewer is.

- **`blocker`** — the plan will fail or do harm as written. The goal is not met,
  the approach is wrong, or it introduces a breaking public-API change, a
  CloudKit/SwiftData migration that loses data, a Swift 6.2 strict-concurrency
  violation that won't compile, or an irreversible step with no rollback.
  Implementation must not start until this is resolved. *Always must-apply.*
- **`major`** — the plan can proceed but will likely cause real pain: a missing
  edge case or error path, absent test coverage for new behaviour at some layer,
  significant over-engineering or scope creep, missing factory/router wiring, an
  ungated feature flag, or a violated project convention. Should be fixed now;
  cheap to address in the plan, expensive to discover mid-implementation.
- **`minor`** — a refinement that improves the plan without changing its
  viability: clearer step ordering, a naming nit, a small simplification, a
  missing `///` doc comment, or a preview/localization reminder. Apply if cheap;
  defer-able.

When a reviewer is unsure whether something is real, it states the uncertainty in
the finding rather than inflating or deflating the severity — you weigh
confidence during reconciliation.

## Reconcile to consensus

Synthesize the verdicts yourself — do not delegate this:

1. **Merge** findings that describe the same concern across reviewers.
2. **Label agreement:** unanimous (3), majority (2), or lone (1). (On the lite
   path there is one reviewer — treat its findings on the merits.)
3. **Decide what to apply.** A finding is **must-apply** if it is a `blocker`, or
   if ≥2 reviewers raise it. A lone `major`/`minor` is applied only if you judge
   it correct on the merits — say so. Reject findings that are wrong, out of
   scope for the stated goal, or contradicted by the code; record the reason.
4. **Adjudicate contradictions.** When reviewers conflict (e.g. "add X" vs "X is
   scope creep"), make the call and state why — usually favouring the smallest
   change that satisfies the goal and the project's conventions.

Present a short consensus table/summary: each finding, its agreement level,
severity, and your decision (apply / reject + reason).

## Apply the feedback

Revise the plan to incorporate every **must-apply** finding and any lone findings
you accepted:

- **Plan in a file** → edit the file in place.
- **Plan-mode plan** → produce the revised plan and re-present it (via
  `ExitPlanMode` when you are ready to exit plan mode, otherwise inline).
- **Plan in the conversation** → restate the corrected plan.

Then close with a brief change log:

- **Applied** — the changes folded in, grouped by the finding that drove them.
- **Rejected** — findings you deliberately did not apply, each with a one-line
  reason.
- **Open questions** — anything the reviewers surfaced that needs a human
  decision before implementation.

Do not silently drop a finding. Every reviewer finding ends up either applied or
explicitly rejected with a reason.
