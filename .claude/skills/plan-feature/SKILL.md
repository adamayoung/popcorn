---
name: plan-feature
description: Plan a new feature end-to-end — explore patterns, design architecture, adversarial review, and generate a PRD with TDD task list
skills:
  - swift-concurrency
  - swiftui-expert-skill
  - tca-expert
  - swift-testing-expert
---

# Plan a New Feature

Orchestrates the full feature planning workflow: explore codebase patterns, ask clarifying questions, design the implementation layer-by-layer, run adversarial review, and generate a PRD with task list and TDD specs.

## Required Information

Ask the user for:
- **Feature description** — what does the feature do?
- **Requirements** — numbered list of specific requirements
- **Any constraints** — which context/feature it belongs to, design preferences

## Workflow

### Phase 1: Explore Existing Patterns

Launch up to 3 Explore agents in parallel to understand:

1. **Relevant context module** — directory structure, existing entities, repositories, data sources, mappers, use cases, factories, tests
2. **Relevant feature module** — reducer, client, models, mappers, views, navigation, tests
3. **UI patterns to reuse** — existing components in DesignSystem, carousel/grid/list patterns in other features

Key files to always check:
- `docs/ARCHITECTURE.md` — layer structure and workflows
- `docs/TMDB_MAPPING.md` — TMDb type reference (if TMDb data involved)
- The context's `Package.swift`, factory protocol, live factory
- The feature's reducer, client, view, and test files
- `AppDependencies/` wiring for the relevant context

### Phase 2: Clarify Architecture Decisions

Ask the user targeted questions about:
- **Module choice** — new context vs extend existing? (recommend with rationale)
- **Data source** — which API endpoint? Separate call or existing response?
- **UI component** — which DesignSystem components to reuse?
- **Navigation** — where does tapping lead? New feature or placeholder?
- **Feature flags** — should this be gated?

Present options with recommendations and reasons. Use `AskUserQuestion` with 2-4 options per question.

### Phase 3: Design Implementation

Design the layer-by-layer implementation following the project's 4-layer architecture:

```
1. Domain Layer      — Entities (value types in {Context}Domain)
2. Adapter Layer     — TMDb→Domain mappers (in {Context}Adapters)
3. Infrastructure    — Cache/persistence changes if needed
4. Application Layer — Application models, mappers, use cases
5. Composition       — Factory updates
6. AppDependencies   — TCA dependency wiring (if new use case)
7. Feature Layer     — Models, mappers, reducer, client, views
8. App Coordinator   — Navigation handling in root features
```

For each layer, specify:
- New files to create (with full paths)
- Existing files to modify (with specific changes)
- Code snippets for key implementations

### Phase 4: Adversarial Review

Spawn the `plan-reviewer` agent to review the plan. Provide it with:
- The complete implementation plan
- List of all files to create and modify
- The data flow pipeline

Address all CRITICAL and IMPORTANT findings before proceeding.

### Phase 5: Generate PRD

Write a PRD to `prds/{feature-name}.md` following this format:

```markdown
# PRD: {Feature Title}

## Overview
[1-2 sentence description]

## Problem
[What problem does this solve? Why is it needed?]

## Goals
[Numbered list of goals]

## Non-Goals
[What's explicitly out of scope]

---

## Requirements
[R1, R2, R3... — specific, testable requirements]

---

## Technical Design

### Architecture Layers
[Data flow diagram showing all layers]

### Key Design Decisions
[Table: Decision | Rationale]

---

## Task List

### Task N: {Layer/Component} — [ ]

**Goal**: [What this task achieves]

**TDD Tests** (`path/to/TestFile.swift`):
1. [Test case description]
2. [Test case description]
...

**Files to Create**:
| File | Purpose |
|------|---------|

**Files to Modify**:
| File | Change |
|------|--------|

**Verification**: [How to verify this task]

---
[Repeat for each task]

## Task Dependency Order
[ASCII diagram showing task dependencies]

## Development Methodology
- Strict TDD: write failing tests FIRST
- High code coverage for all new code
- Package-level verification after each task
- Pre-PR full verification: /format, /lint, /build, /test

## Acceptance Criteria
[Checkboxes for all acceptance criteria]
```

### Phase 6: Write Plan File

Write the technical implementation plan to the plan file (if in plan mode). The plan should contain:
- Context section (why this change)
- Design decisions
- Development methodology (strict TDD)
- Data flow diagram
- Implementation steps with file paths and code snippets
- Files summary (new + modified)
- Reusable components referenced
- Verification steps

### Phase 7: Code Review (after implementation)

After all tasks are implemented and the pre-PR checklist passes (`/format`, `/lint`, `/build`, `/test`), perform a final code review:

1. **Spawn the `code-reviewer` agent** with the full git diff of all changes (`git diff main...HEAD`). The code reviewer performs an initial review, then an adversarial re-evaluation, and returns only the findings both passes agree on.

2. **Address findings**:
   - Fix all CRITICAL and HIGH issues
   - Discuss MEDIUM issues with the user
   - Note LOW issues for awareness
   - If code changes were made, re-run the pre-PR checklist

3. **Final summary**: Present the agreed-upon review to the user with:
   - Strengths of the implementation
   - Any remaining issues by severity
   - Assessment: Ready to merge / Needs fixes

## Key References

| Document | Path | Use For |
|----------|------|---------|
| Architecture | `docs/ARCHITECTURE.md` | Layer structure, patterns |
| TMDb Mapping | `docs/TMDB_MAPPING.md` | TMDb types, mapping pipeline |
| TCA Guide | `docs/TCA.md` | Reducer, navigation, testing |
| Swift Style | `docs/SWIFT.md` | Code conventions |
| SwiftUI Guide | `docs/SWIFTUI.md` | View patterns |
| Git Guide | `docs/GIT.md` | Commit/PR conventions |
| Existing PRDs | `prds/` | PRD format reference |

## Patterns to Follow

### Domain Entity Pattern
- `public` structs in `*Domain` / `*Application` layers need `///` doc comments on the type and every public property (see `docs/SWIFT.md`)
- All properties are `let`, `Identifiable`, `Equatable`, `Sendable`

### Mapper Pattern
- Adapter: `struct {Name}Mapper { func map(_ dto: TMDb.X) -> Domain.X }`
- Application: `struct {Name}Mapper { func map(_ entity: Domain.X, imagesConfiguration:) -> App.X }`
- Feature: `struct {Name}Mapper { func map(_ appModel: App.X) -> Feature.X }`

### Localisation Pattern
- Every new `.xcstrings` key needs `"isCommentAutoGenerated" : true` alongside its comment
- Format-string keys (e.g. `"Value %lld"`) need an explicit `localizations` section with English translation — they won't get one automatically from Xcode

### Test Pattern
- Swift Testing framework (`@Suite`, `@Test`, `#expect`, `#require`)
- Mock factories: `static func mock(...defaults...) -> Entity`
- Feature tests: `TestStore` with `withDependencies`

### View Pattern
- Content views separate from store-connected views
- Callbacks for navigation (not store references)
- `#Preview` blocks with mock data
- Accessibility identifiers and labels
- In coordinator views (`ExploreRootView`, `SearchRootView`), each destination must be a `private func` helper — never inline in `switch` cases. Both coordinators must be updated consistently (see `docs/SWIFTUI.md`)

$ARGUMENTS
