//
//  MockFetchTVSeriesDetailsUseCase.swift
//  PopcornIntelligenceAdapters
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesApplication

final class MockFetchTVSeriesDetailsUseCase: FetchTVSeriesDetailsUseCase, @unchecked Sendable {

    var result: Result<TVSeriesDetails, FetchTVSeriesDetailsError>?
    private(set) var executeCalledWithID: Int?

    func execute(id: Int) async throws(FetchTVSeriesDetailsError) -> TVSeriesDetails {
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
