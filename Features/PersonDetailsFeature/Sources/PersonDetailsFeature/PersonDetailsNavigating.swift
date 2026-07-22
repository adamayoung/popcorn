//
//  PersonDetailsNavigating.swift
//  PersonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``PersonDetailsViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`).
///
/// Tapping a "Known For" item opens the related movie or TV series, so the
/// protocol routes to either detail screen.
@MainActor
public protocol PersonDetailsNavigating {

    /// Opens the details screen for the given movie.
    ///
    /// - Parameter id: The identifier of the movie to open.
    func openMovieDetails(id: Int)

    /// Opens the details screen for the given TV series.
    ///
    /// - Parameter id: The identifier of the TV series to open.
    func openTVSeriesDetails(id: Int)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpPersonDetailsNavigator: PersonDetailsNavigating {
        public init() {}
        public func openMovieDetails(id: Int) {}
        public func openTVSeriesDetails(id: Int) {}
    }
#endif
