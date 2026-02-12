//
//  MockFetchMovieDetailsUseCase.swift
//  PopcornSearchAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import MoviesApplication

final class MockFetchMovieDetailsUseCase: FetchMovieDetailsUseCase, @unchecked Sendable {

    struct ExecuteCall: Equatable {
        let id: Int
    }

    var executeCallCount = 0
    var executeCalledWith: [ExecuteCall] = []
    var executeStub: Result<MovieDetails, FetchMovieDetailsError>?

    func execute(id: Int) async throws(FetchMovieDetailsError) -> MovieDetails {
        executeCallCount += 1
        executeCalledWith.append(ExecuteCall(id: id))

        guard let stub = executeStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let movieDetails):
            return movieDetails
        case .failure(let error):
            throw error
        }
    }

}
