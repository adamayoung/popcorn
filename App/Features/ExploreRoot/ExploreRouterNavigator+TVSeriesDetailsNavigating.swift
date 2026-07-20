//
//  ExploreRouterNavigator+TVSeriesDetailsNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import TVSeriesDetailsFeature

extension ExploreRouterNavigator: TVSeriesDetailsNavigating {

    // `openPersonDetails(id:)` also satisfies this protocol; its single witness
    // lives in the `MovieDetailsNavigating` extension.

    func openTVSeriesIntelligence(id: Int) {
        router.presentedTVSeriesIntelligence = PresentedTVSeriesIntelligence(tvSeriesID: id)
    }

    func openSeasonDetails(tvSeriesID: Int, seasonNumber: Int) {
        router.path.append(
            .tvSeasonDetails(tvSeriesID: tvSeriesID, seasonNumber: seasonNumber)
        )
    }

    func openTVSeriesCastAndCrew(tvSeriesID: Int) {
        router.path.append(.tvSeriesCastAndCrew(tvSeriesID: tvSeriesID))
    }

    // Convenience action, not required by `TVSeriesDetailsNavigating` (mirrors
    // `MovieDetailsNavigating.openMovieDetails(id:)`); pushes without a zoom.
    func openTVSeriesDetails(id: Int) {
        router.path.append(.tvSeriesDetails(id: id, transitionID: nil))
    }

}
