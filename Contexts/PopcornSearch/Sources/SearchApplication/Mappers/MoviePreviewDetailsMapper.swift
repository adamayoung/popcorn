//
//  MoviePreviewDetailsMapper.swift
//  PopcornSearch
//
//  Created by Adam Young on 20/11/2025.
//

import CoreDomain
import Foundation
import SearchDomain

struct MoviePreviewDetailsMapper {

    func map(_ moviePreview: MoviePreview, imagesConfiguration: ImagesConfiguration)
        -> MoviePreviewDetails
    {
        let posterURLSet = imagesConfiguration.posterURLSet(for: moviePreview.posterPath)
        let backdropURLSet = imagesConfiguration.posterURLSet(for: moviePreview.backdropPath)

        return MoviePreviewDetails(
            id: moviePreview.id,
            title: moviePreview.title,
            overview: moviePreview.overview,
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet
        )
    }

}
