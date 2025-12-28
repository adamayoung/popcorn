//
//  MovieMapper.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain
import MoviesApplication

///
/// A mapper that transforms movie models between application and domain layers.
///
/// Converts ``MovieDetails`` instances from the movies application layer to
/// ``Movie`` instances for use in the intelligence domain.
///
struct MovieMapper {

    ///
    /// Maps movie details to a movie for the intelligence domain.
    ///
    /// - Parameter movieDetails: The movie details from the movies application layer.
    /// - Returns: A movie suitable for the intelligence domain.
    ///
    func map(_ movieDetails: MovieDetails) -> Movie {
        Movie(
            id: movieDetails.id,
            title: movieDetails.title,
            overview: movieDetails.overview,
            releaseDate: movieDetails.releaseDate,
            posterPath: movieDetails.posterURLSet?.path,
            backdropPath: movieDetails.backdropURLSet?.path
        )
    }

}
