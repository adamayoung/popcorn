//
//  MockFetchTVSeriesImageCollectionUseCase.swift
//  PopcornDiscoverAdapters
//
//  Copyright © 2025 Adam Young.
//

import CoreDomain
import Foundation
import TVSeriesApplication

final class MockFetchTVSeriesImageCollectionUseCase: FetchTVSeriesImageCollectionUseCase,
@unchecked Sendable {

    var executeCallCount = 0
    var executeCalledWith: [Int] = []
    var executeStub: Result<ImageCollectionDetails, FetchTVSeriesImageCollectionError>?

    func execute(
        tvSeriesID: Int
    ) async throws(FetchTVSeriesImageCollectionError) -> ImageCollectionDetails {
        executeCallCount += 1
        executeCalledWith.append(tvSeriesID)

        guard let stub = executeStub else {
            throw .unknown(nil)
        }

        switch stub {
        case .success(let imageCollection):
            return imageCollection
        case .failure(let error):
            throw error
        }
    }

}
