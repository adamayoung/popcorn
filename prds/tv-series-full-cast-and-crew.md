# TV Series Full Cast & Crew Screen

## Overview

Add navigation from the TV Series Details cast & crew carousel to a full Cast & Crew screen, mirroring the existing MovieCastAndCrewFeature pattern.

## Problem

The TV Series Details screen shows a carousel with the top 5 cast and crew members but provides no way to view the complete list. Users who want to see all cast and crew have no path to do so, unlike the Movie Details screen which navigates to a dedicated Cast & Crew screen.

## Goals

1. Create a `TVSeriesCastAndCrewFeature` package that displays full cast and crew for a TV series
2. Add a "See All" button to the cast & crew section header on the TV Series Details screen
3. Wire navigation from TV Series Details → Full Cast & Crew in ExploreRoot and SearchRoot coordinators
4. Support person details navigation from the full cast & crew screen

## Non-Goals

- Genericising MovieCastAndCrewFeature to support both media types (separate packages per convention)
- Genericising the feature to share code with MovieCastAndCrewFeature
- Adding a feature flag (the cast & crew section is already gated by `.tvSeriesDetailsCastAndCrew`)

## Design Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Separate vs generic feature | Separate `TVSeriesCastAndCrewFeature` | Follows project convention of per-media-type features; avoids touching working movie feature |
| Data fetching | Feature fetches own data via `fetchTVSeriesAggregateCredits` use case | Uses TMDb aggregate credits endpoint (`/tv/{id}/aggregate_credits`) to show roles/jobs per person with episode counts across all seasons |
| Caching | SwiftData with 1-day TTL | Reduces API calls on repeat visits; follows existing repository cache-first pattern |
| Models | Feature-specific models (not shared) | Each feature defines its own lightweight CastMember/CrewMember; follows existing convention |
| Navigation trigger | Section header button with chevron | Matches MovieDetailsContentView `sectionHeader` with action pattern |

## Data Flow

```
User taps "Cast & Crew >" header
         ↓
[TVSeriesDetailsContentView] navigateToCastAndCrew(tvSeries.id)
         ↓
[TVSeriesDetailsView] store.send(.navigate(.castAndCrew(tvSeriesID:)))
         ↓
[ExploreRoot/SearchRoot] state.path.append(.tvSeriesCastAndCrew(...))
         ↓
[TVSeriesCastAndCrewView] .task { store.send(.fetch) }
         ↓
[TVSeriesCastAndCrewClient] fetchTVSeriesAggregateCredits.execute(tvSeriesID:)
         ↓
[CreditsMapper] maps AggregateCreditsDetails → Credits (all members with roles/jobs and episode counts)
         ↓
[TVSeriesCastAndCrewView] List with CastSection + CrewSection (grouped by department)
         ↓
User taps person → .navigate(.personDetails(id:, transitionID:))
         ↓
[ExploreRoot/SearchRoot] state.path.append(.personDetails(...))
```

---

## User Stories

### US-1: Create TVSeriesCastAndCrewFeature Package (M)

**Description**: As a developer, I want a TVSeriesCastAndCrewFeature package so that users can view the full cast and crew for a TV series.

**Acceptance Criteria**:
- [ ] New Swift package at `Features/TVSeriesCastAndCrewFeature/`
- [ ] TCA reducer with `State(tvSeriesID:)`, `ViewSnapshot(castMembers:, crewMembers:, crewByDepartment:)`, `Navigation.personDetails(id:, transitionID:)`
- [ ] Client fetches credits via `@Dependency(\.fetchTVSeriesCredits)` and maps all members (no prefix limit)
- [ ] Views: main view with List, CastSection, CrewSection, CastMemberRow, CrewMemberRow
- [ ] Crew grouped by department with priority ordering (Directing, Writing, Production, etc.)
- [ ] Localised strings: `CAST_AND_CREW`, `CAST`, `CREW`
- [ ] Transition namespace support for matched geometry transitions
- [ ] Unit tests for reducer, mapper, and client
- [ ] Test target registered in `PopcornUnitTests.xctestplan`

**Dependencies**: None

**Tech Elab**:

Files to create (mirroring `MovieCastAndCrewFeature`):
- `Features/TVSeriesCastAndCrewFeature/Package.swift` — depends on `TVSeriesApplication` (not `MoviesApplication`), `AppDependencies`, `DesignSystem`, `TCAFoundation`, `Observability`, `ComposableArchitecture`
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/TVSeriesCastAndCrewFeature.swift` — reducer with `tvSeriesID` in State
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/TVSeriesCastAndCrewClient.swift` — uses `@Dependency(\.fetchTVSeriesCredits)`
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/Logger.swift`
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/Models/Credits.swift`
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/Models/CastMember.swift`
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/Models/CrewMember.swift`
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/Mappers/CreditsMapper.swift` — maps ALL members (no `.prefix(5)`)
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/Views/TVSeriesCastAndCrewView.swift`
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/Views/CastSection.swift`
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/Views/CrewSection.swift`
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/Views/CastMemberRow.swift`
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/Views/CrewMemberRow.swift`
- `Features/TVSeriesCastAndCrewFeature/Sources/TVSeriesCastAndCrewFeature/Localizable.xcstrings`
- `Features/TVSeriesCastAndCrewFeature/Tests/TVSeriesCastAndCrewFeatureTests/TVSeriesCastAndCrewFeatureTests.swift`
- `Features/TVSeriesCastAndCrewFeature/Tests/TVSeriesCastAndCrewFeatureTests/Mappers/CreditsMapperTests.swift`

Files to modify:
- `TestPlans/PopcornUnitTests.xctestplan` — register `TVSeriesCastAndCrewFeatureTests`

**Test Elab**:
- Reducer: fetch success populates ViewSnapshot, fetch failure sends loadFailed, skips fetch when already ready
- Mapper: maps all cast/crew (no limit), handles empty arrays, nil profile URLs, extracts `.detail` URL

---

### US-2: Wire Navigation from TV Series Details to Full Cast & Crew (S)

**Description**: As a user, I want to tap "Cast & Crew" on the TV Series Details screen to see the full cast and crew list.

**Acceptance Criteria**:
- [ ] Cast & Crew section header is a tappable button with chevron (matches Movie Details pattern)
- [ ] Tapping navigates to TVSeriesCastAndCrewFeature screen
- [ ] Navigation works from both Explore and Search flows
- [ ] Person details navigation from full cast & crew screen works
- [ ] Coordinator tests cover new navigation paths

**Dependencies**: US-1

**Tech Elab**:

Files to modify:
- `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/TVSeriesDetailsFeature.swift` — add `.castAndCrew(tvSeriesID: Int)` to `Navigation` enum
- `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Views/TVSeriesDetailsContentView.swift`:
  - Add `navigateToCastAndCrew` callback parameter
  - Change `sectionHeader("CAST_AND_CREW")` to use the action overload with `navigateToCastAndCrew(tvSeries.id)`
  - Add the `sectionHeader(_:action:)` overload (copy from MovieDetailsContentView pattern)
  - Update previews
- `Features/TVSeriesDetailsFeature/Sources/TVSeriesDetailsFeature/Views/TVSeriesDetailsView.swift` — pass `navigateToCastAndCrew` callback that sends `.navigate(.castAndCrew(tvSeriesID:))`
- `App/Features/ExploreRoot/ExploreRootFeature.swift`:
  - Add `case tvSeriesCastAndCrew(TVSeriesCastAndCrewFeature)` to Path enum
  - Add handler for `.tvSeriesDetails(.navigate(.castAndCrew(let id)))` → append `.tvSeriesCastAndCrew`
  - Add handler for `.tvSeriesCastAndCrew(.navigate(.personDetails(let id, _)))` → append `.personDetails`
  - Add `import TVSeriesCastAndCrewFeature`
- `App/Features/ExploreRoot/Views/ExploreRootView.swift`:
  - Add `case .tvSeriesCastAndCrew` to destination switch
  - Add `tvSeriesCastAndCrew(store:)` helper method
  - Add `import TVSeriesCastAndCrewFeature`
- `App/Features/SearchRoot/SearchRootFeature.swift` — same coordinator additions as ExploreRoot
- `App/Features/SearchRoot/Views/SearchRootView.swift` — same view additions as ExploreRoot
- `Features/TVSeriesDetailsFeature/Tests/TVSeriesDetailsFeatureTests/TVSeriesDetailsFeatureTests.swift` — add test for `.navigate(.castAndCrew(...))` returns `.none`
- `PopcornTests/ExploreRootFeatureTests.swift` — add tests for castAndCrew navigation and person details from cast & crew
- `PopcornTests/SearchRootFeatureTests.swift` — same tests

**Test Elab**:
- TVSeriesDetailsFeature: navigate castAndCrew returns .none
- ExploreRoot: tvSeriesDetails navigate castAndCrew appends tvSeriesCastAndCrew to path
- ExploreRoot: tvSeriesCastAndCrew navigate personDetails appends personDetails to path
- SearchRoot: same two tests

---

## Story Dependency Graph

```
US-1 (TVSeriesCastAndCrewFeature package)
  ↓
US-2 (Navigation wiring)
```

## Verification

- [ ] `/format` — no violations
- [ ] `/lint` — no violations
- [ ] `/build-for-testing` — builds with 0 warnings
- [ ] `/test` — all tests pass
- [ ] Manual: TV Series Details → tap "Cast & Crew >" → full list with sections → tap person → person details
