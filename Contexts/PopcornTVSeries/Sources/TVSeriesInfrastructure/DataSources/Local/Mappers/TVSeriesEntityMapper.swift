//
//  TVSeriesEntityMapper.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

struct TVSeriesEntityMapper {

    private let seasonMapper = TVSeriesSeasonEntityMapper()

    func map(_ entity: TVSeriesEntity) -> TVSeries {
        TVSeries(
            id: entity.tvSeriesID,
            name: entity.name,
            tagline: entity.tagline,
            overview: entity.overview,
            numberOfSeasons: entity.numberOfSeasons,
            firstAirDate: entity.firstAirDate,
            posterPath: entity.posterPath,
            backdropPath: entity.backdropPath,
            seasons: entity.seasons.map { seasonMapper.map($0) }.sorted { $0.seasonNumber < $1.seasonNumber }
        )
    }

    func map(_ tvSeries: TVSeries) -> TVSeriesEntity {
        TVSeriesEntity(
            tvSeriesID: tvSeries.id,
            name: tvSeries.name,
            tagline: tvSeries.tagline,
            overview: tvSeries.overview,
            numberOfSeasons: tvSeries.numberOfSeasons,
            firstAirDate: tvSeries.firstAirDate,
            posterPath: tvSeries.posterPath,
            backdropPath: tvSeries.backdropPath,
            seasons: tvSeries.seasons.map { seasonMapper.map($0) }
        )
    }

    func map(_ tvSeries: TVSeries, to entity: TVSeriesEntity) {
        entity.name = tvSeries.name
        entity.tagline = tvSeries.tagline
        entity.overview = tvSeries.overview
        entity.numberOfSeasons = tvSeries.numberOfSeasons
        entity.firstAirDate = tvSeries.firstAirDate
        entity.posterPath = tvSeries.posterPath
        entity.backdropPath = tvSeries.backdropPath
        entity.seasons = tvSeries.seasons.map { seasonMapper.map($0) }
        entity.cachedAt = .now
    }

}
