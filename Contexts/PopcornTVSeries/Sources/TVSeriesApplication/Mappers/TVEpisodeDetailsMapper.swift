//
//  TVEpisodeDetailsMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct TVEpisodeDetailsMapper {

    func map(
        _ episode: TVEpisode,
        season: TVSeason,
        series: TVSeries,
        imagesConfiguration: ImagesConfiguration
    ) -> TVEpisodeDetails {
        let stillURLSet = imagesConfiguration.stillURLSet(for: episode.stillPath)

        return TVEpisodeDetails(
            id: episode.id,
            name: episode.name,
            episodeNumber: episode.episodeNumber,
            seasonNumber: episode.seasonNumber,
            tvSeasonID: season.id,
            tvSeriesID: series.id,
            tvSeasonName: season.name,
            tvSeriesName: series.name,
            overview: episode.overview,
            airDate: episode.airDate,
            runtime: episode.runtime,
            stillURLSet: stillURLSet
        )
    }

}
