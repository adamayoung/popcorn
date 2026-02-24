//
//  TVSeriesMapper.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

struct TVSeriesMapper {

    private let genreMapper = GenreMapper()
    private let tvSeasonPreviewMapper = TVSeasonPreviewMapper()

    func map(_ tvSeriesDetails: TVSeriesDetails) -> TVSeries {
        let genres: [Genre]? = {
            guard let genres = tvSeriesDetails.genres else {
                return nil
            }

            return genres.map(genreMapper.map)
        }()

        return TVSeries(
            id: tvSeriesDetails.id,
            name: tvSeriesDetails.name,
            genres: genres,
            overview: tvSeriesDetails.overview,
            posterURL: tvSeriesDetails.posterURLSet?.detail,
            backdropURL: tvSeriesDetails.backdropURLSet?.full,
            logoURL: tvSeriesDetails.logoURLSet?.detail,
            seasons: tvSeriesDetails.seasons.map(tvSeasonPreviewMapper.map)
        )
    }

}
