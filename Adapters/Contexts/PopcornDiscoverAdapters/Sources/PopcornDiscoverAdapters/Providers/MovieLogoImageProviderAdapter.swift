//
//  MovieLogoImageProviderAdapter.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import DiscoverDomain
import MoviesApplication

final class MovieLogoImageProviderAdapter: MovieLogoImageProviding {

    private let fetchImageCollectionUseCase: any FetchMovieImageCollectionUseCase

    init(fetchImageCollectionUseCase: some FetchMovieImageCollectionUseCase) {
        self.fetchImageCollectionUseCase = fetchImageCollectionUseCase
    }

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
