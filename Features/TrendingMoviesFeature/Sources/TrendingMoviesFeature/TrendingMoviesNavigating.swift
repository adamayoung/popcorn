//
//  TrendingMoviesNavigating.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``TrendingMoviesViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations. The destination carries an
/// optional `transitionID` so the root can drive a zoom transition from the
/// poster the user tapped.
@MainActor
public protocol TrendingMoviesNavigating {

    func openMovieDetails(id: Int, transitionID: String?)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpTrendingMoviesNavigator: TrendingMoviesNavigating {
        public init() {}
        public func openMovieDetails(id: Int, transitionID: String?) {}
    }
#endif
