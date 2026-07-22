# ADR-0005: Rank a person's "Known For" from combined credits, not Discover

- **Status:** Accepted
- **Date:** 2026-07-22
- **Deciders:** Adam Young, Claude

## Context

The person details screen shows a "Known For" carousel of a person's top 5 most
relevant movies **and/or** TV series (`FetchPersonKnownForUseCase`). "Relevance"
is not a field TMDb returns — it has to be derived. Two TMDb sources can rank a
person's titles:

- **Discover** (`discover/movie`, `discover/tv`) can sort server-side by
  popularity and filter by person — but only for **movies** (`with_people` /
  `with_cast` / `with_crew`). The **TV Discover** endpoint has **no person
  filter** at all, so it cannot return a person's TV credits.
- **Combined credits** (`person/{id}/combined_credits`) returns every movie *and*
  TV credit (cast + crew) in one call, each carrying a `popularity` score, but in
  no meaningful order.

The acceptance criteria require both media types, so a movies-only Discover
approach fails the "and/or TV series" requirement for TV-known people.

## Decision

We will source and rank "Known For" entirely from **one combined-credits call**,
ranked client-side in `DefaultFetchPersonKnownForUseCase`:

1. Filter to the person's `knownForDepartment` — cast credits for actors (`"Acting"`),
   otherwise crew credits whose `department` matches; fall back to all
   backdrop-bearing credits if that selects nothing.
2. Drop credits with no backdrop (the carousel cell is a backdrop image).
3. Deduplicate per `(mediaType, id)`, keeping the more popular instance.
4. Sort by TMDb `popularity` descending and take the top 5 **before** any image
   enrichment, so discarded credits never incur a logo fetch.

## Consequences

- One network call covers both media types with a single, consistent popularity
  scale — no merging of two differently-scaled Discover result sets.
- Ranking quality is bounded by TMDb's `popularity`, which is recency-weighted;
  this favours currently-trending titles over evergreen classics. Accepted as
  "good enough" and matching what TMDb's own "Known For" surfaces.
- The ranking is our own code, so it is unit-tested at the use-case layer
  (department filter, dedupe, backdrop filter, trim-before-enrichment, per-item
  logo-failure tolerance) rather than trusted to the server.
- A future contributor must **not** "optimise" this by switching to Discover:
  doing so silently drops TV series for TV-known people. That trap is why this
  ADR exists.

## Alternatives considered

- **Discover for movies + person TV-credits for TV, merged client-side** — two
  calls, and the two popularity scales still have to be merged by hand for the
  same end result. More complexity, no benefit over combined credits.
- **Movies-only via Discover** — fully server-ranked and simplest, but fails the
  "and/or TV series" acceptance criterion.
- **Weighted rating (vote average × vote count)** instead of popularity — favours
  critically-loved classics; rejected as diverging from TMDb's own "Known For"
  and from user expectation.
