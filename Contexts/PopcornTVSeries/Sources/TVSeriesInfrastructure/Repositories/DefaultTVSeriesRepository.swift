//
//  DefaultTVSeriesRepository.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 28/05/2025.
//

import Foundation
import TVSeriesDomain

final class DefaultTVSeriesRepository: TVSeriesRepository {

    private let remoteDataSource: any TVSeriesRemoteDataSource
    private let localDataSource: any TVSeriesLocalDataSource

    init(
        remoteDataSource: some TVSeriesRemoteDataSource,
        localDataSource: some TVSeriesLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func tvSeries(withID id: Int) async throws(TVSeriesRepositoryError) -> TVSeriesDomain.TVSeries {
        if let cachedTVSeries = await localDataSource.tvSeries(withID: id) {
            return cachedTVSeries
        }

        let tvSeries = try await remoteDataSource.tvSeries(withID: id)
        await localDataSource.setTVSeries(tvSeries)
        return tvSeries
    }

    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRepositoryError) -> TVSeriesDomain.ImageCollection {
        if let cachedImageCollection = await localDataSource.images(forTVSeries: tvSeriesID) {
            return cachedImageCollection
        }

        let imageCollection = try await remoteDataSource.images(forTVSeries: tvSeriesID)
        await localDataSource.setImages(imageCollection, forTVSeries: tvSeriesID)
        return imageCollection
    }

}
