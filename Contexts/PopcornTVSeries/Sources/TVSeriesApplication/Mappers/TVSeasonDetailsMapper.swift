//
//  TVSeasonDetailsMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct TVSeasonDetailsMapper {

    private let episodeMapper = TVEpisodeSummaryMapper()

    func map(
        _ season: TVSeason,
        tvSeries: TVSeries,
        imagesConfiguration: ImagesConfiguration
    ) -> TVSeasonDetails {
        let posterURLSet = imagesConfiguration.posterURLSet(for: season.posterPath)
        let episodes = season.episodes.map { episode in
            episodeMapper.map(episode, imagesConfiguration: imagesConfiguration)
        }

        return TVSeasonDetails(
            id: season.id,
            seasonNumber: season.seasonNumber,
            tvSeriesID: tvSeries.id,
            name: season.name,
            tvSeriesName: tvSeries.name,
            posterURLSet: posterURLSet,
            overview: season.overview,
            episodes: episodes
        )
    }

}
