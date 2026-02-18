//
//  ExploreTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class ExploreTests: PopcornUITestCase {

    func testNavigateToFirstDiscoverMovie() {
        let root = AppScreen(app: app)
        let explore = root.tapExploreTab()

        explore.tapOnFirstDiscoverMovie()
    }

    func testNavigateToFirstTrendingMovie() {
        let root = AppScreen(app: app)
        let explore = root.tapExploreTab()

        explore.tapOnFirstTrendingMovie()
    }

    func testNavigateToFirstPopularMovie() {
        let root = AppScreen(app: app)
        let explore = root.tapExploreTab()

        explore.tapOnFirstPopularMovie()
    }

    func testNavigateToFirstTrendingTVSeries() {
        let root = AppScreen(app: app)
        let explore = root.tapExploreTab()

        explore.tapOnFirstTrendingTVSeries()
    }

    func testNavigateToFirstTrendingPerson() {
        let root = AppScreen(app: app)
        let explore = root.tapExploreTab()

        explore.tapOnFirstTrendingPerson()
    }

}
