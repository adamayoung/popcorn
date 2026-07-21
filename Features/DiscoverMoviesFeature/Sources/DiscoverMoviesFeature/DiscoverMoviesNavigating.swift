//
//  DiscoverMoviesNavigating.swift
//  DiscoverMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``DiscoverMoviesViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations. The destination carries an
/// optional `transitionID` so the root can drive a zoom transition from the
/// poster the user tapped.
@MainActor
public protocol DiscoverMoviesNavigating {

    /// Requests that movie details are shown for the given movie.
    ///
    /// - Parameters:
    ///   - id: The identifier of the movie to show.
    ///   - transitionID: The zoom-transition source identifier of the tapped
    ///     poster, or `nil` when there is no zoom source.
    func openMovieDetails(id: Int, transitionID: String?)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpDiscoverMoviesNavigator: DiscoverMoviesNavigating {
        public init() {}
        public func openMovieDetails(id: Int, transitionID: String?) {}
    }
#endif
