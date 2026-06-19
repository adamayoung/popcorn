# Engineering Knowledge Base

Durable, project-specific knowledge for Popcorn — the things worth remembering
between tasks so they don't have to be re-learned or re-discovered. This is
**reference** material (why/what/gotcha), distinct from `CLAUDE.md`, which is
**imperative** (how to work here). `CLAUDE.md` carries only a thin index into this
directory; the detail lives here and is read on demand.

## What goes where

| File | Contents |
| --- | --- |
| [`decisions/`](decisions/) | **ADRs** — Architecture Decision Records, one per decision, numbered + dated. Use for any non-obvious design choice and its rationale. |
| [`gotchas.md`](gotchas.md) | Implementation quirks, things that bit us, tooling traps, SwiftData/CloudKit & TMDb-mapping surprises, and anything that needed a web search / lookup to resolve. |
| [`delivery-retros.md`](delivery-retros.md) | A short retrospective per feature delivered via `/deliver` (its Phase 6) — what worked, friction, deviations, one improvement. |
| [`skill-improvement-log.md`](skill-improvement-log.md) | Decisions on every skill-improvement proposal from `/deliver`'s Phase 6 recurring-pattern scan (applied / deferred / rejected), so the scan doesn't re-propose settled calls. |

There is no live-API notes file — Popcorn consumes TMDb through the TMDb Swift
package, not raw HTTP, so API-shape quirks (when they arise) go in `gotchas.md`.

## How to use it

- **Before solving a non-trivial problem**, skim the relevant file — the answer
  may already be here.
- **After learning something durable** (a gotcha, a SwiftData/CloudKit quirk, a
  decision), record it here in the same change — ideally via `/capture-knowledge`,
  which runs automatically before a PR in the `/deliver` pipeline.
- Keep entries **concise and dated**. Link related entries and ADRs.

## Maintenance & retention

The base is a **cache of currently-true facts, not an archive** — git history is
the archive. Keep it lean so a reader (or agent) finds the signal fast. The files
age differently:

- **`delivery-retros.md`** — cap with a **rolling window**: keep roughly the
  **last ~12 entries** in full prose, and distil older ones into a compact one-line
  archive table (`date · PR · weight · one-line outcome`), dropping the prose. A
  retro's job is to feed the Phase 6 recurring-pattern scan; once its lesson is
  folded into a skill and recorded `applied` in `skill-improvement-log.md`, the
  prose is spent — the scan reads only the recent window plus the log.
- **`skill-improvement-log.md`** is the scan's **dedup memory**, so it is *not*
  windowed the same way: keep **every** `deferred`/`rejected` entry (their
  "Reconsider when" is exactly what stops a settled *no* being re-proposed). Only an
  old `applied` entry — whose fix already lives in the skill — may be condensed to a
  one-liner. The **Decision** (status) and **Reconsider when** fields are the two the
  Phase 6 dedup keys on — keep them on every entry.
- **Curated reference** (`gotchas.md`) should *plateau*, not grow forever. **Retire
  entries that are no longer true:** when an upstream bug is fixed, a pinned version
  is lifted, the code is removed, or a quirk no longer reproduces, **delete** the
  entry (git preserves it). Describe the present, not the past.
- **ADRs** (`decisions/`) are one immutable file per decision — don't edit an
  Accepted ADR; **supersede** it with a new one that links back. No window needed.
- **Don't pre-split a file.** Split a section into its own file only when it
  genuinely dominates, mirroring the project's "promote a boundary only when the
  pain shows up" rule. The dated `###` headings (newest at top) are the index — keep
  them grep-friendly so a reader can pull one entry without reading the whole file.

## Relationship to other stores

This repo base is the **canonical, shareable** record (committed, reviewed in PRs,
travels with the code). It complements — does not replace — any personal/cross-
project notes. Put durable, project-specific facts here.
