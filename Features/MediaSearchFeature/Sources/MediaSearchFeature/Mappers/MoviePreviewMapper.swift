//
//  MoviePreviewMapper.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import SearchApplication

struct MoviePreviewMapper {

    func map(_ moviePreviewDetails: MoviePreviewDetails) -> MoviePreview {
        MoviePreview(
            id: moviePreviewDetails.id,
            title: moviePreviewDetails.title,
            posterURL: moviePreviewDetails.posterURLSet?.thumbnail
        )
    }

}
