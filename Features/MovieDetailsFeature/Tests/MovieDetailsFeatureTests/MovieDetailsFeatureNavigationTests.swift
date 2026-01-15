//
//  MovieDetailsFeatureNavigationTests.swift
//  MovieDetailsFeature
//
//  Copyright © 2025 Adam Young.
//

import ComposableArchitecture
import Foundation
import Testing

@testable import MovieDetailsFeature

@MainActor
@Suite("MovieDetailsFeature navigate Tests")
struct MovieDetailsFeatureNavigationTests {

    @Test("navigate to movieDetails does not change state")
    func navigateToMovieDetailsDoesNotChangeState() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        }

        await store.send(.navigate(.movieDetails(id: 456)))
    }

    @Test("navigate to movieIntelligence does not change state")
    func navigateToMovieIntelligenceDoesNotChangeState() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        }

        await store.send(.navigate(.movieIntelligence(id: 123)))
    }

    @Test("navigate to personDetails does not change state")
    func navigateToPersonDetailsDoesNotChangeState() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        }

        await store.send(.navigate(.personDetails(id: 789)))
    }

    @Test("navigate to castAndCrew does not change state")
    func navigateToCastAndCrewDoesNotChangeState() async {
        let store = TestStore(
            initialState: MovieDetailsFeature.State(movieID: 123)
        ) {
            MovieDetailsFeature()
        }

        await store.send(.navigate(.castAndCrew(movieID: 123)))
    }

}
