//
//  MovieProviderAdapter.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain
import MoviesApplication

final class MovieProviderAdapter: MovieProviding {

    private let fetchMovieDetailsUseCase: any FetchMovieDetailsUseCase

    init(
        fetchMovieDetailsUseCase: some FetchMovieDetailsUseCase
    ) {
        self.fetchMovieDetailsUseCase = fetchMovieDetailsUseCase
    }

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
