//
//  TVEpisodeDetailsNavigating.swift
//  TVEpisodeDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``TVEpisodeDetailsViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations. The MVVM replacement for
/// the former `TVEpisodeDetailsFeature.Navigation` cases, which the parent reducer
/// intercepted.
@MainActor
public protocol TVEpisodeDetailsNavigating {

    func openTVEpisodeCastAndCrew(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)
    func openPersonDetails(id: Int)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpTVEpisodeDetailsNavigator: TVEpisodeDetailsNavigating {
        public init() {}
        public func openTVEpisodeCastAndCrew(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int) {}
        public func openPersonDetails(id: Int) {}
    }
#endif
