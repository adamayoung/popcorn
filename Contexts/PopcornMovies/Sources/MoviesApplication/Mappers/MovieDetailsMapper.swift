//
//  MovieDetailsMapper.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import MoviesDomain

struct MovieDetailsMapper {

    func map(
        _ movie: Movie,
        imageCollection: ImageCollection,
        isOnWatchlist: Bool = false,
        imagesConfiguration: ImagesConfiguration
    ) -> MovieDetails {
        let posterURLSet = imagesConfiguration.posterURLSet(for: movie.posterPath)
        let backdropURLSet = imagesConfiguration.posterURLSet(for: movie.backdropPath)
        let logoURLSet = imagesConfiguration.logoURLSet(for: imageCollection.logoPaths.first)

        return MovieDetails(
            id: movie.id,
            title: movie.title,
            overview: movie.overview,
            posterURLSet: posterURLSet,
            backdropURLSet: backdropURLSet,
            logoURLSet: logoURLSet,
            isOnWatchlist: isOnWatchlist
        )
    }

}
