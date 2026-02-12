//
//  MovieCastAndCrewFeatureTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

@testable import MovieCastAndCrewFeature
import TCAFoundation
import Testing

@Suite("MovieCastAndCrewFeature")
struct MovieCastAndCrewFeatureTests {

    @Test("Initial state is initial")
    func initialStateIsInitial() {
        let state = MovieCastAndCrewFeature.State(movieID: 123)

        #expect(state.viewState == .initial)
        #expect(state.viewState.isLoading == false)
    }

}
