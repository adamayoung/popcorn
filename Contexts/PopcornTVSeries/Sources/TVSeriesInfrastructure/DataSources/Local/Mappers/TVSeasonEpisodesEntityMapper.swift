//
//  TVSeasonEpisodesEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

struct TVSeasonEpisodesEntityMapper {

    private let episodeMapper = TVEpisodeEntityMapper()

    func map(_ entity: TVSeasonEpisodesEntity) -> TVSeason {
        let episodes = entity.episodes
            .map { episodeMapper.map($0) }
            .sorted { $0.episodeNumber < $1.episodeNumber }

        return TVSeason(
            id: entity.seasonID,
            name: entity.seasonName,
            seasonNumber: entity.seasonNumber,
            overview: entity.overview,
            episodes: episodes
        )
    }

    func map(
        _ season: TVSeason,
        tvSeriesID: Int
    ) -> TVSeasonEpisodesEntity {
        let compositeKey = TVSeasonEpisodesEntity.makeCompositeKey(
            tvSeriesID: tvSeriesID,
            seasonNumber: season.seasonNumber
        )
        return TVSeasonEpisodesEntity(
            compositeKey: compositeKey,
            tvSeriesID: tvSeriesID,
            seasonID: season.id,
            seasonName: season.name,
            seasonNumber: season.seasonNumber,
            overview: season.overview,
            episodes: season.episodes.map { episodeMapper.map($0) }
        )
    }

    func map(
        _ season: TVSeason,
        to entity: TVSeasonEpisodesEntity
    ) {
        entity.seasonName = season.name
        entity.overview = season.overview
        entity.episodes = season.episodes.map { episodeMapper.map($0) }
        entity.cachedAt = .now
    }

}
