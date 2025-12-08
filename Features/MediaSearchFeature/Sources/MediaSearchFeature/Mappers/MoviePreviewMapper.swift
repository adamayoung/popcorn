//
//  MoviePreviewMapper.swift
//  MediaSearchFeature
//
//  Created by Adam Young on 21/11/2025.
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
