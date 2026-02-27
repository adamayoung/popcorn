//
//  TVSeriesTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class TVSeriesTests: PopcornUITestCase {

    override var featureFlags: [FeatureFlag: Bool] {
        [
            .explore: true,
            .exploreTrendingTVSeries: true
        ]
    }

    override func setUp() async throws {
        try await super.setUp()
        let root = AppScreen(app: app)
        root.tapExploreTab()
        let explore = ExploreScreen(app: app)
        explore.tapOnTrendingTVSeries(index: 0)
    }

    func testNavigateToSeason1() {
        let tvSeries = TVSeriesDetailsScreen(app: app)
        tvSeries.tapOnSeason(index: 0)
    }

}
