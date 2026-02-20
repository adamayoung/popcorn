//
//  TVEpisodeMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

struct TVEpisodeMapper {

    func map(_ dto: TMDb.TVEpisode) -> TVSeriesDomain.TVEpisode {
        TVSeriesDomain.TVEpisode(
            id: dto.id,
            name: dto.name,
            episodeNumber: dto.episodeNumber,
            seasonNumber: dto.seasonNumber,
            overview: dto.overview,
            airDate: dto.airDate,
            runtime: dto.runtime,
            stillPath: dto.stillPath
        )
    }

}
