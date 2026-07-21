//
//  ExploreNavigating.swift
//  ExploreFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions an ``ExploreViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes. Each destination carries an optional
/// `transitionID` so the root can drive a zoom transition from the carousel cell.
@MainActor
public protocol ExploreNavigating {

    func openTrendingMovies()

    func openDiscoverMovies()

    func openPopularMovies()

    func openMovieDetails(id: Int, transitionID: String?)

    func openTVSeriesDetails(id: Int, transitionID: String?)

    func openPersonDetails(id: Int, transitionID: String?)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpExploreNavigator: ExploreNavigating {
        public init() {}
        public func openTrendingMovies() {}
        public func openDiscoverMovies() {}
        public func openPopularMovies() {}
        public func openMovieDetails(id: Int, transitionID: String?) {}
        public func openTVSeriesDetails(id: Int, transitionID: String?) {}
        public func openPersonDetails(id: Int, transitionID: String?) {}
    }
#endif
