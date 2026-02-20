//
//  TVEpisodeSummaryMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesDomain

struct TVEpisodeSummaryMapper {

    func map(
        _ episode: TVEpisode,
        imagesConfiguration: ImagesConfiguration
    ) -> TVEpisodeSummary {
        let stillURLSet = imagesConfiguration.stillURLSet(for: episode.stillPath)

        return TVEpisodeSummary(
            id: episode.id,
            name: episode.name,
            episodeNumber: episode.episodeNumber,
            seasonNumber: episode.seasonNumber,
            overview: episode.overview,
            airDate: episode.airDate,
            runtime: episode.runtime,
            stillURLSet: stillURLSet
        )
    }

}
