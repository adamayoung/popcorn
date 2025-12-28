//
//  MovieLogoImageProviderAdapter.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import MoviesApplication
import TrendingDomain

///
/// An adapter that provides movie logo images for the Trending domain.
///
/// This adapter bridges the ``FetchMovieImageCollectionUseCase`` to the
/// ``MovieLogoImageProviding`` protocol required by the Trending domain.
///
final class MovieLogoImageProviderAdapter: MovieLogoImageProviding {

    private let fetchImageCollectionUseCase: any FetchMovieImageCollectionUseCase

    ///
    /// Creates a new movie logo image provider adapter.
    ///
    /// - Parameter fetchImageCollectionUseCase: The use case for fetching movie image collections.
    ///
    init(fetchImageCollectionUseCase: some FetchMovieImageCollectionUseCase) {
        self.fetchImageCollectionUseCase = fetchImageCollectionUseCase
    }

    ///
    /// Retrieves the logo image URL set for a movie.
    ///
    /// - Parameter movieID: The unique identifier of the movie.
    ///
    /// - Returns: The image URL set for the movie's logo, or `nil` if no logo is available.
    ///
    /// - Throws: ``MovieLogoImageProviderError`` if the image collection cannot be fetched.
    ///
    func imageURLSet(forMovie movieID: Int) async throws(MovieLogoImageProviderError)
    -> ImageURLSet? {
        let imageCollectionDetails: ImageCollectionDetails
        do {
            imageCollectionDetails = try await fetchImageCollectionUseCase.execute(movieID: movieID)
        } catch let error {
            throw MovieLogoImageProviderError(error)
        }

        return imageCollectionDetails.logoURLSets.first
    }

}

private extension MovieLogoImageProviderError {

    init(_ error: Error) {
        guard let error = error as? FetchMovieImageCollectionError else {
            self = .unknown(error)
            return
        }

        switch error {
        case .notFound:
            self = .notFound
        case .unauthorised:
            self = .unauthorised
        default:
            self = .unknown(error)
        }
    }

}
