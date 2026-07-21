//
//  MoviePreviewMapper.swift
//  PopularMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

/// Maps a context ``MoviePreviewDetails`` to the feature's ``MoviePreview`` presentation model.
public struct MoviePreviewMapper {

    /// Creates a movie preview mapper.
    public init() {}

    /// Maps a context ``MoviePreviewDetails`` to a presentation ``MoviePreview``.
    ///
    /// Uses the `card` poster size rather than `thumbnail`: the popular grid renders
    /// posters at roughly 110pt wide, which the smaller thumbnail would upscale.
    public func map(_ moviePreviewDetails: MoviePreviewDetails) -> MoviePreview {
        MoviePreview(
            id: moviePreviewDetails.id,
            title: moviePreviewDetails.title,
            posterURL: moviePreviewDetails.posterURLSet?.card
        )
    }

    /// Maps a context ``MoviePreviewDetailsPage`` to a presentation ``MoviePreviewPage``,
    /// preserving the pagination metadata and mapping each movie in order.
    public func map(_ page: MoviePreviewDetailsPage) -> MoviePreviewPage {
        MoviePreviewPage(
            page: page.page,
            totalPages: page.totalPages,
            movies: page.movies.map { map($0) }
        )
    }

}
