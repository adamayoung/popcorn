//
//  MockFetchTVSeriesGenresUseCase.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresApplication
import GenresDomain

final class MockFetchTVSeriesGenresUseCase: FetchTVSeriesGenresUseCase, @unchecked Sendable {

    var executeCallCount = 0
    var executeStub: Result<[Genre], FetchTVSeriesGenresError>?

    func execute() async throws(FetchTVSeriesGenresError) -> [Genre] {
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
