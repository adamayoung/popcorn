//
//  TVSeriesMapper.swift
//  TVSeriesDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

/// Maps a context ``TVSeriesDetails`` to the feature's ``TVSeries`` presentation model.
public struct TVSeriesMapper {

    private let genreMapper = GenreMapper()
    private let tvSeasonPreviewMapper = TVSeasonPreviewMapper()

    /// Creates a TV series mapper.
    public init() {}

    /// Maps a context ``TVSeriesDetails`` to a presentation ``TVSeries``.
    public func map(_ tvSeriesDetails: TVSeriesDetails) -> TVSeries {
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
            smallPosterURL: tvSeriesDetails.posterURLSet?.thumbnail,
            backdropURL: tvSeriesDetails.backdropURLSet?.full,
            logoURL: tvSeriesDetails.logoURLSet?.detail,
            seasons: tvSeriesDetails.seasons.map(tvSeasonPreviewMapper.map),
            themeColor: tvSeriesDetails.themeColor
        )
    }

}
