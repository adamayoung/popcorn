//
//  TVSeriesMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

struct TVSeriesMapper {

    private let genreMapper = GenreMapper()
    private let seasonMapper = TVSeasonMapper()

    func map(_ dto: TMDb.TVSeries) -> TVSeriesDomain.TVSeries {
        TVSeriesDomain.TVSeries(
            id: dto.id,
            name: dto.name,
            tagline: dto.tagline,
            overview: dto.overview ?? "",
            numberOfSeasons: dto.numberOfSeasons ?? 0,
            genres: dto.genres?.map(genreMapper.map),
            firstAirDate: dto.firstAirDate,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath,
            seasons: dto.seasons?.map(seasonMapper.map) ?? []
        )
    }

}
