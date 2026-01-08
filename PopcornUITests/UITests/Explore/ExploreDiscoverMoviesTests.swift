//
//  ExploreDiscoverMoviesTests.swift
//  Popcorn
//
//  Created by Adam Young on 08/01/2026.
//

import XCTest

@MainActor
final class ExploreDiscoverMoviesTests: PopcornUITestCase {

    var explore: ExploreScreen!

    func testNavigateToFirstDiscoverMovie() throws {
        let explore = ExploreScreen(app: app)
        explore.tapOnFirstDiscoverMovie()
    }

    func testNavigateToFirstTrendingMovie() throws {
        let explore = ExploreScreen(app: app)
        explore.tapOnFirstTrendingMovie()
    }

    func testNavigateToFirstPopularMovie() throws {
        let explore = ExploreScreen(app: app)
        explore.tapOnFirstPopularMovie()
    }

    func testNavigateToFirstTrendingTVSeries() throws {
        let explore = ExploreScreen(app: app)
        explore.tapOnFirstTrendingTVSeries()
    }

    func testNavigateToFirstTrendingPerson() throws {
        let explore = ExploreScreen(app: app)
        explore.tapOnFirstTrendingPerson()
    }

}
