//
//  MockFetchMovieCreditsUseCase.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

final class MockFetchMovieCreditsUseCase: FetchMovieCreditsUseCase, @unchecked Sendable {

    var result: Result<CreditsDetails, FetchMovieCreditsError>?
    private(set) var executeCalledWithMovieID: Int?

    func execute(movieID: Int) async throws(FetchMovieCreditsError) -> CreditsDetails {
        executeCalledWithMovieID = movieID
        guard let result else {
            throw .unknown(nil)
        }

        switch result {
        case .success(let details):
            return details

        case .failure(let error):
            throw error
        }
    }

}
