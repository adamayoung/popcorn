//
//  WatchlistTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class WatchlistTests: PopcornUITestCase {

    func testNavigateToWatchlist() {
        let root = AppScreen(app: app)
        root.tapWatchlistTab()
    }

}
