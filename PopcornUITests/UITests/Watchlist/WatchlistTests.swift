//
//  WatchlistTests.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import XCTest

@MainActor
final class WatchlistTests: PopcornUITestCase {

    override var featureFlags: [FeatureFlag: Bool] {
        [
            .watchlist: true,
            .explore: true,
            .exploreDiscoverMovies: true
        ]
    }

    func testNavigateToWatchlist() {
        let root = AppScreen(app: app)
        root.tapWatchlistTab()
    }

    func testAddMovieToWatchlist() {
        let root = AppScreen(app: app)
        root.tapExploreTab()
        let explore = ExploreScreen(app: app)
        let movieTitle = explore.discoverMovieTitle(index: 0)
        let movieDetails = explore.tapOnDiscoverMovie(index: 0)

        if movieDetails.isOnWatchlist() {
            movieDetails.tapRemoveFromWatchlist()
        }

        root.tapWatchlistTab()
        let watchlist = WatchlistScreen(app: app)
        watchlist.assertMovieDoesNotExist(withTitle: movieTitle)
        root.tapExploreTab()
        movieDetails.tapAddToWatchlist()

        root.tapWatchlistTab()
        watchlist.assertMovieExists(withTitle: movieTitle)
    }

    func testRemoveMovieToWatchlist() {
        let root = AppScreen(app: app)
        root.tapExploreTab()
        let explore = ExploreScreen(app: app)
        let movieTitle = explore.discoverMovieTitle(index: 0)
        let movieDetails = explore.tapOnDiscoverMovie(index: 0)

        if !movieDetails.isOnWatchlist() {
            movieDetails.tapAddToWatchlist()
        }

        root.tapWatchlistTab()
        let watchlist = WatchlistScreen(app: app)
        watchlist.assertMovieExists(withTitle: movieTitle)
        root.tapExploreTab()
        movieDetails.tapRemoveFromWatchlist()

        root.tapWatchlistTab()
        watchlist.assertMovieDoesNotExist(withTitle: movieTitle)
    }

}
