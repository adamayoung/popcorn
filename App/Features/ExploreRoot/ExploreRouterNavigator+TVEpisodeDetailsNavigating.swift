//
//  ExploreRouterNavigator+TVEpisodeDetailsNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import TVEpisodeDetailsFeature

extension ExploreRouterNavigator: TVEpisodeDetailsNavigating {

    // `openPersonDetails(id:)` also satisfies this protocol; its single witness
    // lives in the `MovieDetailsNavigating` extension.

    func openTVEpisodeCastAndCrew(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int) {
        router.path.append(
            .tvEpisodeCastAndCrew(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        )
    }

}
