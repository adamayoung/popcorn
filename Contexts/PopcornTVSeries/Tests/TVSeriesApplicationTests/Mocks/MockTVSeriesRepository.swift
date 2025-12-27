//
//  MockTVSeriesRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TVSeriesDomain

final class MockTVSeriesRepository: TVSeriesRepository, @unchecked Sendable {

    var tvSeriesWithIDCallCount = 0
    var tvSeriesWithIDCalledWith: [Int] = []
    var tvSeriesWithIDStub: Result<TVSeries, TVSeriesRepositoryError>?

    func tvSeries(
        withID id: Int,
        cachePolicy: CachePolicy
    ) async throws(TVSeriesRepositoryError) -> TVSeries {
        tvSeriesWithIDCallCount += 1
        tvSeriesWithIDCalledWith.append(id)

        guard let stub = tvSeriesWithIDStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let tvSeries):
            return tvSeries
        case .failure(let error):
            throw error
        }
    }

    var imagesForTVSeriesCallCount = 0
    var imagesForTVSeriesCalledWith: [Int] = []
    var imagesForTVSeriesStub: Result<ImageCollection, TVSeriesRepositoryError>?

    func images(
        forTVSeries tvSeriesID: Int,
        cachePolicy: CachePolicy
    ) async throws(TVSeriesRepositoryError) -> ImageCollection {
        imagesForTVSeriesCallCount += 1
        imagesForTVSeriesCalledWith.append(tvSeriesID)

        guard let stub = imagesForTVSeriesStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let imageCollection):
            return imageCollection
        case .failure(let error):
            throw error
        }
    }

}
