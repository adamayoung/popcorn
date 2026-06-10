//
//  TVSeriesDetailsNavigating.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``TVSeriesDetailsViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes and presentations.
@MainActor
public protocol TVSeriesDetailsNavigating {

    func openTVSeriesIntelligence(id: Int)
    func openSeasonDetails(tvSeriesID: Int, seasonNumber: Int)
    func openPersonDetails(id: Int)
    func openTVSeriesCastAndCrew(tvSeriesID: Int)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpTVSeriesDetailsNavigator: TVSeriesDetailsNavigating {
        public init() {}
        public func openTVSeriesIntelligence(id: Int) {}
        public func openSeasonDetails(tvSeriesID: Int, seasonNumber: Int) {}
        public func openPersonDetails(id: Int) {}
        public func openTVSeriesCastAndCrew(tvSeriesID: Int) {}
    }
#endif
