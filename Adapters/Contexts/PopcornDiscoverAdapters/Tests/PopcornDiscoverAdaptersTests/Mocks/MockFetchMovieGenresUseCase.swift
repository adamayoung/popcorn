//
//  MockFetchMovieGenresUseCase.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import GenresApplication
import GenresDomain

final class MockFetchMovieGenresUseCase: FetchMovieGenresUseCase, @unchecked Sendable {

    var executeCallCount = 0
    var executeStub: Result<[Genre], FetchMovieGenresError>?

    func execute() async throws(FetchMovieGenresError) -> [Genre] {
        executeCallCount += 1

        guard let stub = executeStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let genres):
            return genres
        case .failure(let error):
            throw error
        }
    }

}
