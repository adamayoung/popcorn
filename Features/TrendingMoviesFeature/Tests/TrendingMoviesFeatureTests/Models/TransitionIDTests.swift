//
//  TransitionIDTests.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Testing
@testable import TrendingMoviesFeature

@Suite("TransitionID Tests")
struct TransitionIDTests {

    @Test("value joins the item identifier and context")
    func valueJoinsItemIDAndContext() {
        let transitionID = TransitionID(itemID: 42, context: "trending-movies-grid")

        #expect(transitionID.value == "42_trending-movies-grid")
    }

    @Test("value is the item identifier alone when there is no context")
    func valueIsItemIDWithoutContext() {
        let transitionID = TransitionID(itemID: 42)

        #expect(transitionID.value == "42")
    }

    @Test("a movie transition identifier is distinct from the Explore carousel's")
    func movieTransitionIDIsDistinctFromCarousel() {
        let movie = MoviePreview(id: 42, title: "The Odyssey")

        let gridID = TransitionID(movie: movie).value

        // The Explore carousel uses the "trending-movies" context for the same
        // movie, and both views are mounted in the same namespace while the grid
        // is pushed — the identifiers must not collide.
        #expect(gridID != "42_trending-movies")
        #expect(gridID == "42_trending-movies-grid")
    }

}
