//
//  MockTVSeriesRemoteDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain
import TVSeriesInfrastructure

final class MockTVSeriesRemoteDataSource: TVSeriesRemoteDataSource, @unchecked Sendable {

    var tvSeriesWithIDCallCount = 0
    var tvSeriesWithIDCalledWith: [Int] = []
    var tvSeriesWithIDStub: Result<TVSeries, TVSeriesRemoteDataSourceError>?

    func tvSeries(withID id: Int) async throws(TVSeriesRemoteDataSourceError) -> TVSeries {
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
    var imagesForTVSeriesStub: Result<ImageCollection, TVSeriesRemoteDataSourceError>?

    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRemoteDataSourceError) -> ImageCollection {
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

    var creditsForTVSeriesCallCount = 0
    var creditsForTVSeriesCalledWith: [Int] = []
    var creditsForTVSeriesStub: Result<Credits, TVSeriesRemoteDataSourceError>?

    func credits(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRemoteDataSourceError) -> Credits {
        creditsForTVSeriesCallCount += 1
        creditsForTVSeriesCalledWith.append(tvSeriesID)

        guard let stub = creditsForTVSeriesStub else {
            throw .unknown()
        }

        switch stub {
        case .success(let credits):
            return credits
        case .failure(let error):
            throw error
        }
    }

}
