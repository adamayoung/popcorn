//
//  CreditsProviderAdapter.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import IntelligenceDomain
import MoviesApplication

final class CreditsProviderAdapter: CreditsProviding {

    private let fetchMovieCreditsUseCase: any FetchMovieCreditsUseCase

    init(
        fetchMovieCreditsUseCase: some FetchMovieCreditsUseCase
    ) {
        self.fetchMovieCreditsUseCase = fetchMovieCreditsUseCase
    }

    func credits(forMovie movieID: Int) async throws(CreditsProviderError) -> Credits {
        let credits: MoviesApplication.CreditsDetails
        do {
            credits = try await fetchMovieCreditsUseCase.execute(movieID: movieID)
        } catch let error {
            throw CreditsProviderError(error)
        }

        let mapper = CreditsMapper()
        return mapper.map(credits)
    }

}

extension CreditsProviderError {

    init(_ error: FetchMovieCreditsError) {
        switch error {
        case .notFound: self = .notFound
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

}
