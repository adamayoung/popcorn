//
//  TVSeasonDetailsNavigating.swift
//  TVSeasonDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

/// Navigation actions a ``TVSeasonDetailsViewModel`` can request.
///
/// The root coordinator supplies a concrete implementation (a `RouterNavigator`)
/// that translates these into pushes / presentations. The MVVM replacement for
/// the former `TVSeasonDetailsFeature.Navigation` cases, which the parent reducer
/// intercepted.
@MainActor
public protocol TVSeasonDetailsNavigating {

    func openEpisodeDetails(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int)

}

#if DEBUG
    /// A no-op navigator for previews and snapshot tests.
    public struct NoOpTVSeasonDetailsNavigator: TVSeasonDetailsNavigating {
        public init() {}
        public func openEpisodeDetails(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int) {}
    }
#endif
