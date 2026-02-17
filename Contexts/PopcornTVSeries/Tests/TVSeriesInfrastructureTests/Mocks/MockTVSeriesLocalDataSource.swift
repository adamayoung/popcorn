//
//  MockTVSeriesLocalDataSource.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import TVSeriesDomain
import TVSeriesInfrastructure

actor MockTVSeriesLocalDataSource: TVSeriesLocalDataSource {

    var tvSeriesWithIDCallCount = 0
    var tvSeriesWithIDCalledWith: [Int] = []
    nonisolated(unsafe) var tvSeriesWithIDStub: Result<TVSeries?, TVSeriesLocalDataSourceError>?

    func tvSeries(withID id: Int) async throws(TVSeriesLocalDataSourceError) -> TVSeries? {
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

    var setTVSeriesCallCount = 0
    var setTVSeriesCalledWith: [TVSeries] = []
    nonisolated(unsafe) var setTVSeriesStub: Result<Void, TVSeriesLocalDataSourceError>?

    func setTVSeries(_ tvSeries: TVSeries) async throws(TVSeriesLocalDataSourceError) {
        setTVSeriesCallCount += 1
        setTVSeriesCalledWith.append(tvSeries)

        guard let stub = setTVSeriesStub else {
            return
        }

        switch stub {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

    var imagesForTVSeriesCallCount = 0
    var imagesForTVSeriesCalledWith: [Int] = []
    nonisolated(unsafe) var imagesForTVSeriesStub: Result<ImageCollection?, TVSeriesLocalDataSourceError>?

    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLocalDataSourceError) -> ImageCollection? {
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

    var setImagesCallCount = 0
    var setImagesCalledWith: [(imageCollection: ImageCollection, tvSeriesID: Int)] = []
    nonisolated(unsafe) var setImagesStub: Result<Void, TVSeriesLocalDataSourceError>?

    func setImages(
        _ imageCollection: ImageCollection,
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesLocalDataSourceError) {
        setImagesCallCount += 1
        setImagesCalledWith.append((imageCollection: imageCollection, tvSeriesID: tvSeriesID))

        guard let stub = setImagesStub else {
            return
        }

        switch stub {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }

}
