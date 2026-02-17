//
//  MoviePreviewDetailsMapper.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

struct MoviePreviewDetailsMapper {

    func map(
        _ moviePreview: MoviePreview,
        imageCollection: ImageCollection?,
        imagesConfiguration: ImagesConfiguration
    ) -> MoviePreviewDetails {
        let posterURLSet = imagesConfiguration.posterURLSet(for: moviePreview.posterPath)
        let backdropURLSet = imagesConfiguration.posterURLSet(for: moviePreview.backdropPath)
        let logoURLSet = imagesConfiguration.logoURLSet(for: imageCollection?.logoPaths.first)

        return MoviePreviewDetails(
            id: moviePreview.id,
            title: moviePreview.title,
            overview: moviePreview.overview,
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            logoURLSet: logoURLSet
        )
    }

}
