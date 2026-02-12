//
//  ExploreDiscoverMoviesTests.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import XCTest

@MainActor
final class ExploreDiscoverMoviesTests: PopcornUITestCase {

    func testNavigateToFirstDiscoverMovie() {
        let explore = ExploreScreen(app: app)
        explore.tapOnFirstDiscoverMovie()
    }

    func testNavigateToFirstTrendingMovie() {
        let explore = ExploreScreen(app: app)
        explore.tapOnFirstTrendingMovie()
    }

    func testNavigateToFirstPopularMovie() {
        let explore = ExploreScreen(app: app)
        explore.tapOnFirstPopularMovie()
    }

    func testNavigateToFirstTrendingTVSeries() {
        let explore = ExploreScreen(app: app)
        explore.tapOnFirstTrendingTVSeries()
    }

    func testNavigateToFirstTrendingPerson() {
        let explore = ExploreScreen(app: app)
        explore.tapOnFirstTrendingPerson()
    }

}
