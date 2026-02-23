//
//  TVEpisodeDetailsCacheEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

struct TVEpisodeDetailsCacheEntityMapper {

    func map(_ entity: TVEpisodeDetailsCacheEntity) -> TVEpisode {
        TVEpisode(
            id: entity.episodeID,
            name: entity.name,
            episodeNumber: entity.episodeNumber,
            seasonNumber: entity.seasonNumber,
            overview: entity.overview,
            airDate: entity.airDate,
            runtime: entity.runtime,
            stillPath: entity.stillPath
        )
    }

    func map(
        _ episode: TVEpisode,
        tvSeriesID: Int
    ) -> TVEpisodeDetailsCacheEntity {
        let compositeKey = TVEpisodeDetailsCacheEntity.makeCompositeKey(
            tvSeriesID: tvSeriesID,
            seasonNumber: episode.seasonNumber,
            episodeNumber: episode.episodeNumber
        )
        return TVEpisodeDetailsCacheEntity(
            compositeKey: compositeKey,
            tvSeriesID: tvSeriesID,
            episodeID: episode.id,
            name: episode.name,
            episodeNumber: episode.episodeNumber,
            seasonNumber: episode.seasonNumber,
            overview: episode.overview,
            airDate: episode.airDate,
            runtime: episode.runtime,
            stillPath: episode.stillPath
        )
    }

    func map(
        _ episode: TVEpisode,
        to entity: TVEpisodeDetailsCacheEntity
    ) {
        entity.name = episode.name
        entity.episodeNumber = episode.episodeNumber
        entity.seasonNumber = episode.seasonNumber
        entity.overview = episode.overview
        entity.airDate = episode.airDate
        entity.runtime = episode.runtime
        entity.stillPath = episode.stillPath
        entity.cachedAt = .now
    }

}
