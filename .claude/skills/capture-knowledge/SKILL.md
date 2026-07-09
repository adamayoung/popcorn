---
name: capture-knowledge
description: Capture durable, project-specific learnings from the work just done into the knowledge/ base — gotchas, implementation quirks, tooling traps, SwiftData/CloudKit & TMDb-mapping surprises, things looked up or web-searched, and design decisions (as ADRs). Use before opening a PR (it runs automatically in /deliver), or any time you've learned something worth remembering. Records only non-obvious, reusable facts; skips anything already in the repo, CLAUDE.md, or git history.
---

# Capture Knowledge

Fold what you just learned into the committed knowledge base at `knowledge/`, so a
future session (or contributor) doesn't have to re-learn or re-discover it. Run
this **before a PR** — in `/deliver` it runs as the last step before `/pr`, so the
notes land in the same PR as the change. The `knowledge/` files are plain Markdown
(no code-review or CI gate on them), so readability is on you.

## What to capture (be selective)

Record only **durable, project-specific, non-obvious** facts — the test is "would
a future me waste time without this?":

- **Gotchas / quirks** → `knowledge/gotchas.md` — a trap you hit, a tooling
  surprise, a **SwiftData/CloudKit** quirk, a **TMDb-mapping** surprise (a
  nullable/absent field, an unexpected library shape), anything that needed a
  **web search or doc lookup** to resolve.
- **Design decisions** → a new **ADR** in `knowledge/decisions/` (next number),
  using `decisions/0000-template.md`. Any non-obvious choice and its rationale —
  why this approach over the alternatives (an MVVM boundary, a factory/DI wiring
  call, a SwiftData/CloudKit modelling decision, a Statsig gating choice).

There is **no live-API notes file**. Popcorn consumes TMDb through the TMDb Swift
package, not raw HTTP, so API-shape quirks go in `gotchas.md` — route to **gotchas
or an ADR only**.

## What NOT to capture

Mirror the discipline of a good memory — don't record:

- Anything already in the code, `CLAUDE.md`, `docs/*.md`, the DocC docs, or git
  history.
- Facts that only mattered to this one task and won't recur.
- Restatements of the obvious. If asked to record something obvious, capture the
  *non-obvious* part (what surprised you) or skip it.

Quality over volume: a few high-signal entries beat a long dump. **Capturing
nothing is a valid outcome** — don't manufacture entries to look productive.

This skill writes **`gotchas.md`** and **ADRs** only. It does **not** touch
`delivery-retros.md` or `skill-improvement-log.md` — those are written by
`/deliver`'s Phase 8 retrospective and Phase 11 wrap-up, not here.

## Steps

1. **Start from the candidates list, if one exists.** If the caller passed a
   **knowledge-candidates** list as the argument (`$ARGUMENTS` below — `/deliver`
   pastes its ledger list here), use that as your input — that's the reliable
   source, jotted while the learnings were fresh, and it reaches you intact even
   if the caller's context was compacted. Otherwise, reconstruct candidates by
   reviewing the work just done — the diff, the dead-ends, the things you looked
   up, the decisions you made.
2. **Filter** against "What NOT to capture". Drop the rest.
3. **Check for duplicates** — skim the relevant `knowledge/` file; **update** an
   existing entry rather than adding a near-duplicate.
4. **Write each entry** in the right file:
   - Gotchas: a short dated subsection (`### <title>`), newest at the top, under
     the right heading. Date it with today's date.
   - Decisions: copy `decisions/0000-template.md` to
     `decisions/NNNN-<kebab-title>.md` (next free number), fill in Status / Date /
     Deciders / Context / Decision / Consequences / Alternatives. Cross-link
     related ADRs.
5. **Retire what's no longer true.** The base is a **cache of current truths, not
   an archive** (git history is the archive — see
   [`knowledge/README.md`](../../../knowledge/README.md) → *Maintenance &
   retention*, the authority on retention). While you're in `gotchas.md`, scan the
   neighbouring entries and **delete** any now obsolete — an upstream bug fixed, a
   pinned dependency version lifted, the code removed, a quirk that no longer
   reproduces. The file should describe the present, not narrate the past. ADRs are
   immutable: **supersede** an outdated one with a new ADR that links back; never
   edit an Accepted ADR in place.
6. **Keep it tidy by hand** — blank lines around headings/lists/code fences, a
   language on every fence, one `#` H1 per file. `knowledge/` is **not** under any
   markdown lint or CI gate, so there's nothing to catch sloppiness for you —
   readability is on you. Aim for ~80-col prose; long URLs are fine.
7. **Update `knowledge/README.md`** only if you added a new file or category (the
   per-entry index inside each file is enough otherwise).

## Return

Report concisely what you captured: each entry → which file (and ADR number for
decisions), and note anything you deliberately skipped as not durable. If nothing
met the bar, say so plainly — capturing nothing is a valid outcome.

Arguments: $ARGUMENTS
