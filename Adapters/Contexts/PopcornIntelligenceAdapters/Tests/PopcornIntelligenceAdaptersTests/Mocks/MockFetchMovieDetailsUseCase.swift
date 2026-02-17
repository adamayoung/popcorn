//
//  MockFetchMovieDetailsUseCase.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import MoviesApplication

final class MockFetchMovieDetailsUseCase: FetchMovieDetailsUseCase, @unchecked Sendable {

    var result: Result<MovieDetails, FetchMovieDetailsError>?
    private(set) var executeCalledWithID: Int?

    func execute(id: Int) async throws(FetchMovieDetailsError) -> MovieDetails {
        executeCalledWithID = id
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
