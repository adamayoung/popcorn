//
//  TVSeriesMapper.swift
//  PopcornTVSeriesAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TMDb
import TVSeriesDomain

///
/// A mapper that converts TMDb TV series data to the domain model.
///
struct TVSeriesMapper {

    ///
    /// Maps a TMDb TV series object to a domain TV series entity.
    ///
    /// - Parameter dto: The TMDb TV series data transfer object to map.
    ///
    /// - Returns: A ``TVSeriesDomain.TVSeries`` entity populated with the TMDb data.
    ///
    func map(_ dto: TMDb.TVSeries) -> TVSeriesDomain.TVSeries {
        TVSeriesDomain.TVSeries(
            id: dto.id,
            name: dto.name,
            tagline: dto.tagline,
            overview: dto.overview ?? "",
            numberOfSeasons: dto.numberOfSeasons ?? 0,
            firstAirDate: dto.firstAirDate,
            posterPath: dto.posterPath,
            backdropPath: dto.backdropPath
        )
    }

}
