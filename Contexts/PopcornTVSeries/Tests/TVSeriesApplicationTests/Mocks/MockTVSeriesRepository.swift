//
//  MockTVSeriesRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain

final class MockTVSeriesRepository: TVSeriesRepository, @unchecked Sendable {

    var tvSeriesWithIDCallCount = 0
    var tvSeriesWithIDCalledWith: [Int] = []
    var tvSeriesWithIDStub: Result<TVSeries, TVSeriesRepositoryError>?

    func tvSeries(withID id: Int) async throws(TVSeriesRepositoryError) -> TVSeries {
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

    var tvSeriesStreamCallCount = 0
    var tvSeriesStreamCalledWith: [Int] = []
    var tvSeriesStreamValues: [TVSeries?] = []

    func tvSeriesStream(withID id: Int) async -> AsyncThrowingStream<TVSeries?, Error> {
        tvSeriesStreamCallCount += 1
        tvSeriesStreamCalledWith.append(id)

        let values = tvSeriesStreamValues
        return AsyncThrowingStream { continuation in
            for value in values {
                continuation.yield(value)
            }
            continuation.finish()
        }
    }

    var imagesForTVSeriesCallCount = 0
    var imagesForTVSeriesCalledWith: [Int] = []
    var imagesForTVSeriesStub: Result<ImageCollection, TVSeriesRepositoryError>?

    func images(forTVSeries tvSeriesID: Int) async throws(TVSeriesRepositoryError)
    -> ImageCollection {
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
