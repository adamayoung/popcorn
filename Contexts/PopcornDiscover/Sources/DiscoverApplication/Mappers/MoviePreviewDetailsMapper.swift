//
//  MoviePreviewDetailsMapper.swift
//  PopcornDiscover
//
//  Created by Adam Young on 20/11/2025.
//

import CoreDomain
import DiscoverDomain
import Foundation

struct MoviePreviewDetailsMapper {

    func map(
        _ moviePreview: MoviePreview,
        genresLookup: [Genre.ID: Genre],
        logoURLSet: ImageURLSet?,
        imagesConfiguration: ImagesConfiguration
    ) -> MoviePreviewDetails {
        let genres = moviePreview.genreIDs.compactMap { genresLookup[$0] }
        let posterURLSet = imagesConfiguration.posterURLSet(for: moviePreview.posterPath)
        let backdropURLSet = imagesConfiguration.backdropURLSet(for: moviePreview.backdropPath)

        return MoviePreviewDetails(
            id: moviePreview.id,
            title: moviePreview.title,
            overview: moviePreview.overview,
            releaseDate: moviePreview.releaseDate,
            genres: genres,
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            logoURLSet: logoURLSet
        )
    }

}
