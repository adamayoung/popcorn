//
//  MoviePreviewMapper.swift
//  MovieDetailsFeature
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

struct MoviePreviewMapper {

    func map(_ moviePreviewDetails: MoviePreviewDetails) -> MoviePreview {
        MoviePreview(
            id: moviePreviewDetails.id,
            title: moviePreviewDetails.title,
            posterURL: moviePreviewDetails.posterURLSet?.detail,
            backdropURL: moviePreviewDetails.backdropURLSet?.detail,
            logoURL: moviePreviewDetails.logoURLSet?.thumbnail
        )
    }

}
