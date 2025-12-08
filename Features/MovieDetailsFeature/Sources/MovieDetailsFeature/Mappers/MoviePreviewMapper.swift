//
//  MoviePreviewMapper.swift
//  MovieDetailsFeature
//
//  Created by Adam Young on 21/11/2025.
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
