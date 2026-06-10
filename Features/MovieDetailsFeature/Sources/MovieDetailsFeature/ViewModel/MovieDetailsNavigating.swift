//
//  MovieDetailsNavigating.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``MovieDetailsViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations.
@MainActor
public protocol MovieDetailsNavigating {

    func openMovieDetails(id: Int)
    func openMovieIntelligence(id: Int)
    func openPersonDetails(id: Int)
    func openMovieCastAndCrew(movieID: Int)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpMovieDetailsNavigator: MovieDetailsNavigating {
        public init() {}
        public func openMovieDetails(id: Int) {}
        public func openMovieIntelligence(id: Int) {}
        public func openPersonDetails(id: Int) {}
        public func openMovieCastAndCrew(movieID: Int) {}
    }
#endif
