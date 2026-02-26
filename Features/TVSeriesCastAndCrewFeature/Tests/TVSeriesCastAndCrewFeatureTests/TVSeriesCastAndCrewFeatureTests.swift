//
//  TVSeriesCastAndCrewFeatureTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import TCAFoundation
import Testing
@testable import TVSeriesCastAndCrewFeature

@Suite("TVSeriesCastAndCrewFeature")
struct TVSeriesCastAndCrewFeatureTests {

    @Test("Initial state is initial")
    func initialStateIsInitial() {
        let state = TVSeriesCastAndCrewFeature.State(tvSeriesID: 66732)

        #expect(state.viewState == .initial)
        #expect(state.viewState.isLoading == false)
    }

}
