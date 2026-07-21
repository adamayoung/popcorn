//
//  PopularMoviesNavigating.swift
//  PopularMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``PopularMoviesViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations. The destination carries an
/// optional `transitionID` so the root can drive a zoom transition from the
/// poster the user tapped.
@MainActor
public protocol PopularMoviesNavigating {

    func openMovieDetails(id: Int, transitionID: String?)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpPopularMoviesNavigator: PopularMoviesNavigating {
        public init() {}
        public func openMovieDetails(id: Int, transitionID: String?) {}
    }
#endif
