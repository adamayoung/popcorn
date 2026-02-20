# Story Execution Strategy

## When to use this reference

Read this file during Phase 6 (Execute Stories) after the user approves the plan. Contains the subagent orchestration strategy, prompt template, and failure handling.

## Execution Flow

1. **Analyse the dependency graph** — identify which stories can run in parallel (no blocking dependencies) and which must be sequential.

2. **Create tasks** — use `TaskCreate` for each user story with status `pending`. Set `addBlockedBy` for stories with dependencies.

3. **Launch parallel subagents** — for each independent track (stories with no pending dependencies), spawn a `general-purpose` agent via the Task tool.

4. **Sequential merge points** — when a story depends on completed stories, wait for all dependencies to finish, then launch the next subagent.

5. **Progress tracking** — use `TaskUpdate` to move stories through `pending → in_progress → completed`.

## Subagent Prompt Template

When spawning a subagent for a user story, provide this context:

```
You are implementing user story US-{N}: {Title} for the Popcorn app.

## Story
{Full user story description from PRD}

## Acceptance Criteria
{All acceptance criteria}

## Tech Elab
{Full Tech Elab section}

## Test Elab
{Full Test Elab section}

## Development Methodology
- Strict TDD: write failing tests FIRST, then implementation
- Follow patterns in the codebase — read existing files before writing new ones
- Run package-level verification after implementation:
  - `swift build` in the package directory
  - `swift test` in the package directory

## Architecture Context
- This is a modular Swift app using TCA (The Composable Architecture)
- Domain-driven design with 4 layers: Domain, Infrastructure, Application, Composition
- Features are separate Swift packages in `Features/`
- Contexts are separate Swift packages in `Contexts/`
- Read `docs/ARCHITECTURE.md` for full layer structure

## Code Patterns
- Read `docs/SWIFT.md` for code conventions
- Public types need `///` doc comments on type and all public properties
- All entities: `Identifiable`, `Equatable`, `Sendable`
- Swift Testing framework for tests (`@Suite`, `@Test`, `#expect`, `#require`)
- SwiftLint limits: function_body_length 50, file_length 400, type_body_length 350

## Verification
After implementation, run:
1. `swift build` in the package directory — must succeed with no warnings
2. `swift test` in the package directory — all tests must pass
3. Report any build or test failures
```

## Parallel Execution Rules

- **Maximum 3 concurrent subagents** — more than 3 risks resource contention and makes failure debugging harder
- **Independent tracks only** — never launch a story whose dependencies aren't completed
- **Wait at merge points** — when the next story depends on multiple tracks, wait for ALL of them before launching
- **Background agents** — use `run_in_background: true` for parallel stories, check output with `TaskOutput`

## Failure Handling

When a subagent reports build or test failures:

1. **Read the failure output** — understand what went wrong
2. **Check for cascade failures** — did a dependency story produce incorrect code that breaks this story?
3. **Fix locally if straightforward** — if the fix is small (typo, missing import, wrong type), fix it directly
4. **Ask the user if complex** — if the failure suggests a design flaw or architectural mismatch, surface it to the user
5. **Re-run verification** — after any fix, re-run package-level build + test before marking as completed
6. **Block dependent stories** — do NOT launch stories that depend on a failed story until the failure is resolved

## Completion Criteria

A story is considered complete when:
- All acceptance criteria are met
- All tests from Test Elab pass
- Package-level `swift build` succeeds (no warnings)
- Package-level `swift test` succeeds (all pass)
- New unit test targets are registered in `TestPlans/PopcornUnitTests.xctestplan` (NOT snapshot tests — those go in `PopcornSnapshotTests.xctestplan`)
- `TaskUpdate` marks the story as `completed`
