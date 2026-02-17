//
//  MockFetchTVSeriesDetailsUseCase.swift
//  PopcornSearchAdapters
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesApplication

final class MockFetchTVSeriesDetailsUseCase: FetchTVSeriesDetailsUseCase, @unchecked Sendable {

    struct ExecuteCall: Equatable {
        let id: Int
    }

    var executeCallCount = 0
    var executeCalledWith: [ExecuteCall] = []
    var executeStub: Result<TVSeriesDetails, FetchTVSeriesDetailsError>?

    func execute(id: Int) async throws(FetchTVSeriesDetailsError) -> TVSeriesDetails {
        executeCallCount += 1
        executeCalledWith.append(ExecuteCall(id: id))

        guard let stub = executeStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let tvSeriesDetails):
            return tvSeriesDetails
        case .failure(let error):
            throw error
        }
    }

}
