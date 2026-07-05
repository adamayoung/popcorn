//
//  MoviePreviewMapper.swift
//  TrendingMoviesFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TrendingApplication

/// Maps a context ``MoviePreviewDetails`` to the feature's ``MoviePreview`` presentation model.
public struct MoviePreviewMapper {

    /// Creates a movie preview mapper.
    public init() {}

    /// Maps a context ``MoviePreviewDetails`` to a presentation ``MoviePreview``.
    public func map(_ moviePreviewDetails: MoviePreviewDetails) -> MoviePreview {
        MoviePreview(
            id: moviePreviewDetails.id,
            title: moviePreviewDetails.title,
            posterURL: moviePreviewDetails.posterURLSet?.thumbnail
        )
    }

}
