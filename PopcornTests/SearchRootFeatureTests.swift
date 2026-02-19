//
//  SearchRootFeatureTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import ComposableArchitecture
@testable import Popcorn
import Testing
import TVSeriesDetailsFeature

@MainActor
@Suite("SearchRootFeature Tests")
struct SearchRootFeatureTests {

    @Test("tvSeriesDetails navigate seasonDetails appends tvSeasonDetails to path")
    func tvSeriesDetailsNavigateSeasonDetailsAppendsToPath() {
        var state = SearchRootFeature.State()
        state.path.append(.tvSeriesDetails(TVSeriesDetailsFeature.State(tvSeriesID: 66732)))

        _ = SearchRootFeature().reduce(
            into: &state,
            action: .path(.element(
                id: 0,
                action: .tvSeriesDetails(.navigate(.seasonDetails(tvSeriesID: 66732, seasonNumber: 1)))
            ))
        )

        guard case .tvSeasonDetails(let placeholderState) = state.path.last else {
            Issue.record("Expected tvSeasonDetails as last path element")
            return
        }
        #expect(state.path.count == 2)
        #expect(placeholderState.tvSeriesID == 66732)
        #expect(placeholderState.seasonNumber == 1)
    }

}
