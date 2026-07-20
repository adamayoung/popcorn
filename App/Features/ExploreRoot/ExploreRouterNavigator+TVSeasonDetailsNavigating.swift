//
//  ExploreRouterNavigator+TVSeasonDetailsNavigating.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import TVSeasonDetailsFeature

extension ExploreRouterNavigator: TVSeasonDetailsNavigating {

    func openEpisodeDetails(tvSeriesID: Int, seasonNumber: Int, episodeNumber: Int) {
        router.path.append(
            .tvEpisodeDetails(
                tvSeriesID: tvSeriesID,
                seasonNumber: seasonNumber,
                episodeNumber: episodeNumber
            )
        )
    }

}
