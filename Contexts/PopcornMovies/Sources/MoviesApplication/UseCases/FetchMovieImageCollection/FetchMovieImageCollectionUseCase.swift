//
//  FetchMovieImageCollectionUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// A use case that fetches the image collection for a specific movie.
///
/// This protocol defines the contract for retrieving all images associated with a movie,
/// including posters, backdrops, and logos at various resolutions.
///
public protocol FetchMovieImageCollectionUseCase: Sendable {

    ///
    /// Fetches the image collection for a movie by its identifier.
    ///
    /// - Parameter movieID: The unique identifier of the movie.
    /// - Returns: An ``ImageCollectionDetails`` containing resolved image URLs.
    /// - Throws: ``FetchMovieImageCollectionError`` if the images cannot be retrieved.
    ///
    func execute(movieID: Movie.ID) async throws(FetchMovieImageCollectionError)
        -> ImageCollectionDetails

}
