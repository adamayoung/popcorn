# PRD Template

## When to use this reference

Read this file during Phase 3 (Draft PRD) and Phase 5h (Finalize PRD) for the full PRD format, user story structure, persona guidelines, sizing definitions, and quality rules.

## PRD Format

Write the PRD to `prds/{feature-name}.md` following this structure:

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

## Design Decisions

| Decision | Rationale |
|----------|-----------|
| ... | ... |

## Data Flow

[ASCII diagram showing data flow through all architecture layers]

---

## User Stories

### US-N: {Title} — `{Size}`

> As a **{persona}**, I want {what needs to be done} so that {reason why}.

**Acceptance Criteria**:
- [ ] {Testable criterion 1}
- [ ] {Testable criterion 2}
- ...

**Tech Elab**:
- {File to create/modify with full path}
- {Implementation details, patterns to follow}
- {Key technical considerations}

**Test Elab**:
- {Test case 1 — description}
- {Test case 2 — description}
- Edge case: {edge case description}
- ...

**Dependencies**: US-X, US-Y (or none)

---

[Repeat for each story]

## Story Dependency Graph

[ASCII diagram showing story dependencies and parallel tracks]

**Parallel tracks** (can start simultaneously):
- Track A: US-X (...)
- Track B: US-Y (...)

**Merge points**:
- US-Z requires US-X + US-Y

## Verification

1. `/format` — no violations
2. `/lint` — no violations
3. `/build` — build succeeds (warnings are errors)
4. `/test` — all tests pass
5. Manual: {manual verification steps}
6. Code review via `code-reviewer` agent with adversarial re-evaluation
```

## Persona Guidelines

Use the appropriate persona for each story:
- **User persona** ("As a **user**") — for UI-facing stories: screens, navigation, visual components
- **Developer persona** ("As a **developer**") — for infrastructure stories: domain models, data sources, mappers, use cases, wiring

## Story Sizing

Assign T-shirt sizes based on scope:

| Size | Scope | Files | Example |
|------|-------|-------|---------|
| **S** | Single-layer change | 1-3 | Add a mapper, domain entity |
| **M** | Multi-file within one layer, moderate complexity | 3-5 | Use case + models, adapter + data source |
| **L** | Cross-layer, significant logic | 5-10 | Full persistence layer, complete feature UI |
| **XL** | Full vertical slice, high complexity | 10+ | **Must be broken down** into smaller stories |

## Story Quality Rules

- Each story must be independently implementable and testable
- Acceptance criteria must be specific, testable assertions (not vague descriptions)
- Tech Elab must include full file paths and specific implementation patterns to follow
- Test Elab must include at least 2 edge cases per story
- Dependencies must be explicit — a story can only depend on other stories in this PRD
- **XL stories are not allowed** — break them into S/M/L stories during refinement

## User Story Checklist

Before finalising each story, verify:

- [ ] Description follows "As a [persona] I want [what] so that [why]" format
- [ ] Acceptance criteria are checkboxes with testable assertions
- [ ] Tech Elab lists every file to create or modify with full paths
- [ ] Tech Elab names specific patterns to follow (e.g., "follow BackdropImage pattern")
- [ ] Test Elab includes happy path, error path, and at least 2 edge cases
- [ ] Dependencies are listed (or explicitly "none")
- [ ] Size is S, M, or L (never XL)
