---
name: plan-feature
description: Plan a new feature end-to-end — explore patterns, write user stories with acceptance criteria and TDD specs, adversarial backlog refinement, and auto-execute via parallel subagents
skills:
  - swift-concurrency
  - swiftui-expert-skill
  - tca-expert
  - swift-testing-expert
---

# Plan a New Feature

Orchestrates the full feature planning workflow: explore codebase patterns, ask clarifying questions, design user stories with acceptance criteria and TDD specs, run adversarial backlog refinement, and auto-execute stories via parallel subagents.

## Required Information

Ask the user for:
- **Feature description** — what does the feature do?
- **Requirements** — numbered list of specific requirements
- **Any constraints** — which context/feature it belongs to, design preferences

## Workflow Mode Selection

Before starting, assess the feature's complexity to choose the right workflow mode:

| Mode | Criteria | Skips |
|------|----------|-------|
| **Full** | 4+ stories expected, cross-layer changes, new data sources, factory chain updates | Nothing — runs all phases |
| **Lightweight** | 3 or fewer stories, single context/feature, no new data pipelines | Phase 4 (PRD review), Phase 5f (story review) — goes straight from exploration → stories → plan |

If unsure, start with Phase 1 exploration. Once the scope is clear, choose the mode before Phase 3. When in doubt, prefer lightweight — the user can always ask for a full review.

### Phase 0: Setup

Create a feature branch from latest main before doing anything else:

1. `git fetch origin main`
2. `git checkout -b feature/<feature-name> origin/main`

Then verify which project resources exist:

1. Check for `docs/ARCHITECTURE.md` — if missing, skip architecture-specific exploration and rely on codebase patterns directly
2. Check for `docs/TMDB_MAPPING.md` — if missing or the feature doesn't involve TMDb data, skip all TMDb-specific steps (TMDb type exploration, adapter layer stories, TMDb service wiring)
3. Check for `docs/TCA.md` — if missing, skip TCA-specific guidance and infer patterns from existing features
4. Check for `prds/` directory — if missing, write the PRD to the plan file instead

This ensures the skill works for non-TMDb features and projects with different documentation structures.

### Phase 1: Explore Existing Patterns

Launch up to 3 Explore agents in parallel to understand:

1. **Relevant context module** — directory structure, existing entities, repositories, data sources, mappers, use cases, factories, tests
2. **Relevant feature module** — reducer, client, models, mappers, views, navigation, tests
3. **UI patterns to reuse** — existing components in DesignSystem, carousel/grid/list patterns in other features

Key files to check (if they exist — see Phase 0):
- `docs/ARCHITECTURE.md` — layer structure and workflows
- `docs/TMDB_MAPPING.md` — TMDb type reference (only if feature involves TMDb data)
- The context's `Package.swift`, factory protocol, live factory
- The feature's reducer, client, view, and test files
- `AppDependencies/` wiring for the relevant context

### Phase 2: Clarify Architecture Decisions

Ask the user targeted questions about:
- **Module choice** — new context vs extend existing? (recommend with rationale)
- **Data source** — which API endpoint? Separate call or existing response?
- **Caching** — Recommend SwiftData local caching by default for any feature that fetches remote data. Present it as a decision with rationale (e.g., "reduces API calls on repeat visits, follows existing repository pattern"). If the feature is read-heavy with repeat visits, recommend caching strongly. If the data changes frequently or is rarely revisited, note that caching may not be worth the complexity. Always ask the user — don't silently include or exclude it.
- **UI component** — which DesignSystem components to reuse?
- **Navigation** — where does tapping lead? New feature or placeholder?
- **Feature flags** — should this be gated?

Present options with recommendations and reasons. Use `AskUserQuestion` with 2-4 options per question.

### Phase 3: Draft PRD

Write the high-level PRD sections to `prds/{feature-name}.md`. Read `references/prd-template.md` for the full format. At this stage, write **only** the foundation sections — user stories come later in Phase 5.

Sections to write now:
- **Overview** — 1-2 sentence description
- **Problem** — what problem this solves and why it's needed
- **Goals** — numbered list of specific goals
- **Non-Goals** — what's explicitly out of scope
- **Design Decisions** — table of key decisions with rationale
- **Data Flow** — ASCII diagram showing data flow through all architecture layers

Leave the User Stories, Story Dependency Graph, and Verification sections empty — these are filled in after the PRD is reviewed and stories are designed.

### Phase 4: Adversarial PRD Review

> **Lightweight mode**: Skip this phase entirely. Proceed directly to Phase 5.

Spawn **2 adversarial Product Manager subagents in parallel** (using the `plan-reviewer` agent type) to independently review the draft PRD. Read `references/prd-reviewers.md` for the full reviewer prompts.

Provide each reviewer with:
- The draft PRD (all sections from Phase 3)
- The original user requirements
- The architecture decisions from Phase 2

Each PM reviews independently and returns findings classified as **CRITICAL**, **IMPORTANT**, or **SUGGESTION**.

#### 4a. Reconciliation

After both PMs return, compare their findings:

1. **Agreed findings** — both PMs flagged the same issue → confirmed, must address
2. **Unique findings** — only one PM raised it → evaluate on merit, adopt if valid
3. **Contradictions** — PMs disagree on an issue → present both positions to the user for a decision

#### 4b. Update PRD

Revise the draft PRD based on the agreed findings.

#### 4c. Re-review if Significant Changes

If the reconciliation resulted in **significant PRD changes** (e.g., new goals added, design decisions changed, data flow restructured, stories reorganised to fix compilation-order issues), re-run Phase 4 from the start — spawn 2 fresh PM reviewers against the updated PRD. Minor wording tweaks or adding clarifications do not require a re-review.

Continue re-reviewing until a round produces no CRITICAL findings and only minor IMPORTANT/SUGGESTION findings. The PMs must converge — do not proceed to story design until the PRD foundation (Goals, Non-Goals, Design Decisions, Data Flow) is stable.

### Phase 5: Design User Stories

Decompose the reviewed PRD into user stories. This is the most critical phase — poor story design leads to blocked subagents, missing wiring, and broken builds.

#### 5a. Map the Architecture Layers

Walk through the data flow from API to screen and identify which layers need work:

1. **Domain** — new entities, repository protocols
2. **Infrastructure** — data sources, SwiftData models, repository implementations
3. **Application** — use cases, application models, mappers
4. **Composition** — factory updates wiring infrastructure to application
5. **Adapters** — TMDb API bridges, adapter factory updates
6. **AppDependencies** — TCA dependency key registrations
7. **Feature** — reducer, client, models, mappers, views
8. **Coordinators** — navigation wiring in ExploreRoot/SearchRoot

Also identify **cross-cutting work** that doesn't fit neatly into one layer (e.g., adding a new DesignSystem component, adding URL support to `ImagesConfiguration`).

#### 5b. Decompose into Stories

Create one story per logical unit of work. Follow these rules:

- **One story per layer** is a good default — don't bundle Domain + Infrastructure + Application into one giant story
- **Cross-cutting work gets its own story** (e.g., "StillImage DesignSystem Component" is separate from the feature that uses it)
- **Factory chain updates** that span 5+ files should be in the same story as the layer that introduces the new dependency (typically the Adapter story)
- **Coordinator wiring** (ExploreRoot + SearchRoot) goes in the final feature story since it depends on everything else
- **Each story must be independently buildable and testable** — after implementing a story, `swift build` and `swift test` must pass in the relevant package. If the story only changes internal code within a single module (no public interface changes), package-level verification is sufficient. If it changes public interfaces or spans multiple packages, verify with a full-app build.

#### 5c. Size Each Story

| Size | Scope | Files | Example |
|------|-------|-------|---------|
| **S** | Single-layer, few files | 1-3 | Domain entity, TCA wiring, DesignSystem component |
| **M** | Multi-file within one layer | 3-5 | Use case + models + mapper, adapter + data source + mock |
| **L** | Cross-layer, significant logic | 5-10 | Full persistence layer, complete feature UI + coordinator |
| **XL** | NOT ALLOWED | 10+ | Must be broken into smaller stories |

#### 5d. Order Dependencies

Map which stories block which. Follow the natural architecture flow:

```
Domain → Infrastructure → Application → Composition → Adapters → AppDependencies → Feature → Coordinators
```

Identify parallel tracks (stories with no shared dependencies) and merge points (stories that need multiple tracks to complete).

#### 5e. Write Each Story

For every story, fill in ALL of these sections — no exceptions:

- **Description**: "As a [developer/user], I want [what] so that [why]" — use **developer** for infrastructure stories, **user** for UI stories
- **Acceptance Criteria**: Checkboxes with specific, testable assertions (not vague descriptions like "data is cached" — instead "SwiftData entity persisted with 24h TTL")
- **Tech Elab**: Every file to create or modify with full path, specific patterns to follow (e.g., "follow `BackdropImage` pattern"), key implementation details
- **Test Elab**: Happy path, error path, and at least 2 edge cases per story. **Every mapper, use case, and reducer must have a dedicated test file listed.** See `references/patterns.md` § Required Test Coverage Per Layer.
- **Dependencies**: Which stories must be done first (or "none")

#### 5f. Adversarial Story Review

> **Lightweight mode**: Skip this phase. Proceed directly to Phase 5h (Finalize PRD).

After drafting all stories, spawn **3 reviewer subagents in parallel** (using the `plan-reviewer` agent type) to critique the stories from different perspectives. Read `references/story-reviewers.md` for the full reviewer prompts.

Provide each reviewer with:
- The complete set of drafted user stories (all sections)
- The data flow diagram
- The story dependency graph
- The list of all files to create and modify across all stories

| Reviewer | Persona | Focus |
|----------|---------|-------|
| **Reviewer 1** | Product Manager | Story clarity, acceptance criteria completeness, user value, scope creep, missing requirements, story independence |
| **Reviewer 2** | Staff iOS Engineer & Architect | Architecture alignment, pattern compliance, dependency correctness, factory chain integrity, sizing accuracy, breaking changes |
| **Reviewer 3** | Staff Software Engineer in Test | Test coverage gaps, missing edge cases, testability of acceptance criteria, mock/helper needs, test file organisation |

Each reviewer returns findings classified as **CRITICAL**, **IMPORTANT**, or **SUGGESTION**.

#### 5g. Address Review Findings

Process findings from all 3 reviewers:

1. **CRITICAL** — must fix before proceeding (missing files, broken dependencies, untestable criteria)
2. **IMPORTANT** — should fix (coverage gaps, sizing issues, vague criteria)
3. **SUGGESTION** — consider and adopt if they improve quality

Update stories, acceptance criteria, Tech Elab, Test Elab, and the dependency graph based on findings. Break down any stories reviewers flag as too large.

#### 5h. Finalize PRD

Add the refined stories, story dependency graph, and verification sections to the PRD file (`prds/{feature-name}.md`). The PRD is now complete.

Final checklist:

- [ ] Every new file appears in exactly one story's Tech Elab
- [ ] Every modified file lists the specific change needed
- [ ] Factory chain updates are atomic (all files in one story)
- [ ] No story is XL — break it down if >10 files
- [ ] New unit test targets note `PopcornUnitTests.xctestplan` registration
- [ ] The dependency graph has no cycles
- [ ] Both ExploreRoot and SearchRoot coordinators are updated (if navigation changes)
- [ ] All CRITICAL and IMPORTANT review findings are addressed
- [ ] Every adapter mapper has a test file in the Test Elab
- [ ] Every use case has a test file in the Test Elab
- [ ] Every TCA reducer has a test file with `State: Equatable` noted

### Phase 6: Write Plan File

Write the technical implementation plan to the plan file (if in plan mode). The plan should contain:
- Context section (why this change)
- Design decisions table
- Development methodology (strict TDD, package-level verification)
- Data flow diagram
- Implementation steps mapped to user stories (with file paths)
- Story dependency graph
- Verification steps

### Phase 7: Execute Stories (After User Approval)

After the user approves the plan, auto-execute stories using subagents. Read `references/execution.md` for the full subagent orchestration strategy, prompt template, and failure handling.

### Phase 8: Pre-PR Verification

After all stories are implemented:

1. Run the full pre-PR checklist: `/format`, `/lint`, `/build`, `/test`
2. Fix any issues found
3. If fixes were made, re-run the full checklist

### Phase 9: Code Review (Optional)

> **Skip this phase if using `/pr` to create the pull request** — `/pr` already spawns the `code-reviewer` agent. Running it here too is redundant.

After the pre-PR checklist passes:

1. **Spawn the `code-reviewer` agent** with:
   - The full diff: `git diff main...HEAD`
   - The list of changed files: `git diff --name-only main...HEAD`
   - Instruct it to read full files (not just diff hunks) and compare with sibling implementations for pattern consistency

   The code reviewer performs an initial review, then an adversarial re-evaluation, and returns only the findings both passes agree on.

2. **Address findings**:
   - Fix all CRITICAL and HIGH issues
   - Discuss MEDIUM issues with the user
   - Note LOW issues for awareness
   - If code changes were made, re-run the pre-PR checklist

3. **Final summary**: Present the agreed-upon review to the user with:
   - Strengths of the implementation
   - Any remaining issues by severity
   - Assessment: Ready to merge / Needs fixes

## References

- `references/prd-template.md` — PRD format, user story template, persona guidelines, sizing, quality rules
- `references/prd-reviewers.md` — Adversarial PRD reviewer prompt for the 2 PM subagents (Phase 4)
- `references/story-reviewers.md` — Adversarial story reviewer prompts for the 3 personas (PM, Architect, SEiT)
- `references/patterns.md` — Domain entity, mapper, test, view, and localisation patterns
- `references/execution.md` — Subagent orchestration, prompt template, failure handling

## Key Documentation

| Document | Path | Use For |
|----------|------|---------|
| Architecture | `docs/ARCHITECTURE.md` | Layer structure, patterns |
| TMDb Mapping | `docs/TMDB_MAPPING.md` | TMDb types, mapping pipeline |
| TCA Guide | `docs/TCA.md` | Reducer, navigation, testing |
| Swift Style | `docs/SWIFT.md` | Code conventions |
| SwiftUI Guide | `docs/SWIFTUI.md` | View patterns |
| Git Guide | `docs/GIT.md` | Commit/PR conventions |
| Existing PRDs | `prds/` | PRD format reference |

$ARGUMENTS
