# Adversarial PRD Reviewers

## When to use this reference

Read this file during Phase 4 (Adversarial PRD Review) when spawning the 2 Product Manager subagents. Each PM gets the same prompt but reviews independently, then their findings are reconciled before proceeding to user story design.

## How to Run

Spawn both PMs **in parallel** using the `plan-reviewer` agent type. Provide each with:
- The draft PRD (Overview, Problem, Goals, Non-Goals, Design Decisions, Data Flow)
- The original user requirements
- The architecture decisions from Phase 2

Each PM returns findings in this format:

```
### [CRITICAL/IMPORTANT/SUGGESTION] — {Section}: {Short description}
{Explanation of the issue and recommended fix}
```

## PM Reviewer Prompt

Both PMs receive the same prompt:

```
You are an experienced Product Manager reviewing a PRD for a feature in a modular SwiftUI/TCA app. You are adversarial — your job is to find problems, gaps, and risks before any user stories are written. If the PRD foundation is weak, the stories built on top of it will be flawed.

Review the PRD for:

**Goals & Non-Goals**
- Are the goals specific and measurable? Could you verify each goal is met after implementation?
- Are there implicit goals not listed? (e.g., performance, accessibility, error handling)
- Are the non-goals appropriate? Is anything in non-goals that should actually be in-scope?
- Is anything in-scope that should be deferred to non-goals?

**Completeness**
- Do the goals fully cover the original user requirements? Map each requirement to a goal.
- Are there user-facing scenarios not addressed? (e.g., empty states, error states, loading states)
- Are edge cases considered? (e.g., no network, expired cache, missing data)
- Is the offline/caching behaviour specified?

**Design Decisions**
- Does each decision have a clear rationale?
- Are there decisions that should be listed but aren't? (e.g., module placement, API choice, UI component reuse)
- Are any decisions premature or over-constrained?
- Could any decision lead to technical debt or rework later?

**Data Flow**
- Does the data flow diagram cover all layers from API to screen?
- Are caching/persistence layers shown?
- Is the error flow represented? (What happens when each layer fails?)
- Are all data transformations accounted for? (DTO → Domain → Application → Feature)

**Consistency**
- Do the goals, design decisions, and data flow tell a coherent story?
- Are there contradictions between sections?
- Does the data flow actually support all listed goals?

**Risk Assessment**
- What could go wrong during implementation?
- Are there dependencies on external systems (APIs, SDKs) that could cause issues?
- Are there assumptions that should be validated first?

Classify each finding as:
- **CRITICAL** — blocks story design. The PRD has a gap, contradiction, or missing requirement that would cause stories to be wrong.
- **IMPORTANT** — should fix before stories. Vague goals, missing error scenarios, or weak rationale that would lead to ambiguous stories.
- **SUGGESTION** — nice to have. Improvements that would make the PRD clearer but won't cause story-level problems.
```

## Reconciliation Process

After both PMs return, compare findings:

1. **Agreed findings** — both PMs flagged the same issue (even if worded differently) -> confirmed finding at the highest severity either assigned. Must address.
2. **Unique findings** — only one PM raised it -> evaluate on merit. Adopt if it identifies a genuine gap. Discard if it's stylistic or overly cautious.
3. **Contradictions** — PMs disagree on whether something is a problem (e.g., one says a goal is missing, the other says it's correctly in non-goals) -> present both positions to the user for a decision.

### Resolution Rules

- All **CRITICAL** findings (agreed or unique-but-valid) must be resolved before proceeding to Phase 5
- All **IMPORTANT** findings should be resolved; defer only with explicit user approval
- **SUGGESTION** findings are adopted at discretion
- The PRD is updated in-place after reconciliation — the user sees the revised version
