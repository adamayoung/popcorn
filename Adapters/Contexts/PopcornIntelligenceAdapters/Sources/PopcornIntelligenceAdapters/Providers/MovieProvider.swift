//
//  MovieProvider.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import IntelligenceDomain
import MoviesApplication

///
/// An adapter that provides movie data for the intelligence domain.
///
/// Bridges the movies application layer to the intelligence domain by wrapping
/// the ``FetchMovieDetailsUseCase``.
///
final class MovieProviderAdapter: MovieProviding {

    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase

    ///
    /// Creates a movie provider adapter.
    ///
    /// - Parameter fetchMovieDetailsUseCase: The use case for fetching movie details.
    ///
    init(
        fetchMovieDetailsUseCase: some FetchMovieDetailsUseCase
    ) {
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
    }

    ///
    /// Fetches movie data by identifier.
    ///
    /// - Parameter movieID: The identifier of the movie.
    /// - Returns: A movie suitable for the intelligence domain.
    /// - Throws: ``MovieProviderError`` if the movie cannot be fetched.
    ///
    func movie(withID movieID: Int) async throws(MovieProviderError) -> IntelligenceDomain.Movie {
        let movieDetails: MovieDetails
        do {
            movieDetails = try await fetchMovieDetailsUseCase.execute(id: movieID)
        } catch let error {
            throw MovieProviderError(error)
        }

        let mapper = MovieMapper()
        return mapper.map(movieDetails)
    }

}

extension MovieProviderError {

    init(_ error: FetchMovieDetailsError) {
        switch error {
        case .notFound: self = .notFound
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

}
