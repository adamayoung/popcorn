//
//  MovieCastAndCrewFeatureTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Testing

@testable import MovieCastAndCrewFeature

@Suite("MovieCastAndCrewFeature")
struct MovieCastAndCrewFeatureTests {

    @Test("Initial state is initial")
    func initialStateIsInitial() {
        let state = MovieCastAndCrewFeature.State(
            movieID: 123,
            movieTitle: "Test Movie"
        )

        #expect(state.viewState == .initial)
        #expect(state.isLoading == false)
    }

}

extension MovieCastAndCrewFeature.ViewState: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.initial, .initial):
            true

        case (.loading, .loading):
            true

        case (.ready(let lhsSnapshot), .ready(let rhsSnapshot)):
            lhsSnapshot.castMembers == rhsSnapshot.castMembers
                && lhsSnapshot.crewMembers == rhsSnapshot.crewMembers

        case (.error, .error):
            true

        default:
            false
        }
    }

}
