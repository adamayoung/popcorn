//
//  DefaultTVSeriesRepository.swift
//  PopcornTVSeries
//
//  Created by Adam Young on 28/05/2025.
//

import Foundation
import Observability
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
        let tvSeries: TVSeriesDomain.TVSeries
        do {
            tvSeries = try await SpanContext.trace(
                operation: "repository.fetch",
                description: "Fetch TV Series #\(id)"
            ) { span in
                span?.setData([
                    "entity_type": "tvSeries",
                    "entity_id": id
                ])

                if let cached = try await localDataSource.tvSeries(withID: id) {
                    span?.setData(key: "cache.hit", value: true)
                    return cached
                }

                span?.setData(key: "cache.hit", value: false)
                let tvSeries = try await remoteDataSource.tvSeries(withID: id)
                try await localDataSource.setTVSeries(tvSeries)
                return tvSeries
            }
        } catch let error {
            throw TVSeriesRepositoryError(error)
        }

        return tvSeries
    }

    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRepositoryError) -> TVSeriesDomain.ImageCollection {
        let imageCollection: ImageCollection
        do {
            imageCollection = try await SpanContext.trace(
                operation: "repository.fetch",
                description: "Fetch TV Series Images #\(tvSeriesID)"
            ) { span in
                span?.setData([
                    "entity_type": "imageCollection",
                    "entity_id": tvSeriesID
                ])

                if let cached = try await localDataSource.images(forTVSeries: tvSeriesID) {
                    span?.setData(key: "cache.hit", value: true)
                    return cached
                }

                span?.setData(key: "cache.hit", value: false)
                let imageCollection = try await remoteDataSource.images(forTVSeries: tvSeriesID)
                try await localDataSource.setImages(imageCollection, forTVSeries: tvSeriesID)
                return imageCollection
            }
        } catch let error {
            throw TVSeriesRepositoryError(error)
        }

        return imageCollection
    }

}

extension TVSeriesRepositoryError {

    fileprivate init(_ error: Error) {
        if let error = error as? TVSeriesRemoteDataSourceError {
            self.init(error)
            return
        }

        if let error = error as? TVSeriesLocalDataSourceError {
            self.init(error)
            return
        }

        self = .unknown(error)
    }

    fileprivate init(_ error: TVSeriesRemoteDataSourceError) {
        switch error {
        case .notFound: self = .notFound
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

    fileprivate init(_ error: TVSeriesLocalDataSourceError) {
        switch error {
        case .persistence(let error): self = .unknown(error)
        case .unknown(let error): self = .unknown(error)

        }
    }

}
