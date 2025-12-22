//
//  FetchMovieUseCase.swift
//  PopcornMovies
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesDomain

///
/// A use case that fetches comprehensive details for a specific movie.
///
/// This protocol defines the contract for retrieving movie details including
/// basic movie information, associated images, and watchlist status. The use case
/// aggregates data from multiple sources to provide a complete view of the movie.
///
/// Implementations of this protocol should coordinate fetching from:
/// - Movie repository for basic movie data
/// - Image repository for posters, backdrops, and logos
/// - Watchlist repository to determine if the movie is saved
/// - App configuration for image URL construction
///
/// - Note: All methods must be called from an async context.
///
public protocol FetchMovieDetailsUseCase: Sendable {

    ///
    /// Fetches comprehensive details for a movie by its identifier.
    ///
    /// This method retrieves all available information about a movie, including
    /// its metadata (title, overview, release date, etc.), image collection
    /// (posters, backdrops, logos), and current watchlist status.
    ///
    /// The method performs multiple concurrent operations to efficiently gather
    /// all required data, then aggregates the results into a single ``MovieDetails``
    /// object ready for presentation.
    ///
    /// - Parameter id: The unique identifier of the movie to fetch details for
    ///
    /// - Returns: A ``MovieDetails`` object containing comprehensive movie information
    ///
    /// - Throws: ``FetchMovieDetailsError`` if the movie cannot be retrieved. Possible errors include:
    ///   - ``FetchMovieDetailsError/notFound`` if the movie does not exist
    ///   - ``FetchMovieDetailsError/unauthorised`` if API access is denied
    ///   - ``FetchMovieDetailsError/unknown(_:)`` for unexpected errors
    ///
    func execute(id: Movie.ID) async throws(FetchMovieDetailsError) -> MovieDetails

}
