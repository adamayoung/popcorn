//
//  MockFetchMovieImageCollectionUseCase.swift
//  PopcornTrendingAdapters
//
//  Copyright © 2026 Adam Young.
//

import CoreDomain
import Foundation
import MoviesApplication

final class MockFetchMovieImageCollectionUseCase: FetchMovieImageCollectionUseCase,
@unchecked Sendable {

    var executeCallCount = 0
    var executeCalledWith: [Int] = []
    var executeStub: Result<ImageCollectionDetails, FetchMovieImageCollectionError>?

    func execute(movieID: Int) async throws(FetchMovieImageCollectionError)
    -> ImageCollectionDetails {
        executeCallCount += 1
        executeCalledWith.append(movieID)

        guard let stub = executeStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let result):
            return result
        case .failure(let error):
            throw error
        }
    }

}
