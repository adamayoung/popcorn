//
//  ExploreRootFeatureTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
@testable import Popcorn
import Testing
import TVEpisodeDetailsFeature
import TVSeasonDetailsFeature
import TVSeriesDetailsFeature

@MainActor
@Suite("ExploreRootFeature Tests")
struct ExploreRootFeatureTests {

    @Test("tvSeriesDetails navigate seasonDetails appends tvSeasonDetails to path")
    func tvSeriesDetailsNavigateSeasonDetailsAppendsToPath() {
        var state = ExploreRootFeature.State()
        state.path.append(.tvSeriesDetails(TVSeriesDetailsFeature.State(tvSeriesID: 66732)))

        _ = ExploreRootFeature().reduce(
            into: &state,
            action: .path(.element(
                id: 0,
                action: .tvSeriesDetails(
                    .navigate(.seasonDetails(tvSeriesID: 66732, seasonNumber: 1, seasonName: "Season 1"))
                )
            ))
        )

        guard case .tvSeasonDetails(let seasonState) = state.path.last else {
            Issue.record("Expected tvSeasonDetails as last path element")
            return
        }
        #expect(state.path.count == 2)
        #expect(seasonState.tvSeriesID == 66732)
        #expect(seasonState.seasonNumber == 1)
        #expect(seasonState.seasonName == "Season 1")
    }

    @Test("tvSeasonDetails navigate episodeDetails appends tvEpisodeDetails to path")
    func tvSeasonDetailsNavigateEpisodeDetailsAppendsToPath() {
        var state = ExploreRootFeature.State()
        state.path.append(
            .tvSeasonDetails(
                TVSeasonDetailsFeature.State(
                    tvSeriesID: 1396,
                    seasonNumber: 1,
                    seasonName: "Season 1"
                )
            )
        )

        _ = ExploreRootFeature().reduce(
            into: &state,
            action: .path(.element(
                id: 0,
                action: .tvSeasonDetails(
                    .navigate(
                        .episodeDetails(tvSeriesID: 1396, seasonNumber: 1, episodeNumber: 1, episodeName: "Pilot")
                    )
                )
            ))
        )

        guard case .tvEpisodeDetails(let episodeState) = state.path.last else {
            Issue.record("Expected tvEpisodeDetails as last path element")
            return
        }
        #expect(state.path.count == 2)
        #expect(episodeState.tvSeriesID == 1396)
        #expect(episodeState.seasonNumber == 1)
        #expect(episodeState.episodeNumber == 1)
        #expect(episodeState.episodeName == "Pilot")
    }

}
