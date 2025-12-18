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
        let span = SpanContext.startChild(
            operation: .repositoryGet,
            description: "Fetch TV Series #\(id)"
        )
        span?.setData([
            "entity_type": "TVSeries",
            "entity_id": id
        ])

        do {
            if let cached = try await localDataSource.tvSeries(withID: id) {
                span?.setData(key: "cache.hit", value: true)
                span?.finish()
                return cached
            }
        } catch let error {
            let e = TVSeriesRepositoryError(error)
            span?.setData(error: e)
            span?.finish(status: .internalError)
            throw TVSeriesRepositoryError(e)
        }

        span?.setData(key: "cache.hit", value: false)

        let tvSeries: TVSeriesDomain.TVSeries
        do {
            tvSeries = try await remoteDataSource.tvSeries(withID: id)
        } catch let error {
            let e = TVSeriesRepositoryError(error)
            span?.setData(error: e)
            span?.finish(status: .internalError)
            throw e
        }

        do {
            try await localDataSource.setTVSeries(tvSeries)
        } catch let error {
            let e = TVSeriesRepositoryError(error)
            span?.setData(error: e)
            span?.finish(status: .internalError)
            throw e
        }

        span?.finish()
        return tvSeries
    }

    func images(
        forTVSeries tvSeriesID: Int
    ) async throws(TVSeriesRepositoryError) -> TVSeriesDomain.ImageCollection {
        let span = SpanContext.startChild(
            operation: .repositoryGet,
            description: "Fetch TV Series Images #\(tvSeriesID)"
        )
        span?.setData([
            "entity_type": "ImageCollection",
            "entity_id": tvSeriesID
        ])

        do {
            if let cached = try await localDataSource.images(forTVSeries: tvSeriesID) {
                span?.setData(key: "cache.hit", value: true)
                span?.finish()
                return cached
            }
        } catch let error {
            let e = TVSeriesRepositoryError(error)
            span?.setData(error: e)
            span?.finish(status: .internalError)
            throw e
        }

        span?.setData(key: "cache.hit", value: false)

        let imageCollection: TVSeriesDomain.ImageCollection
        do {
            imageCollection = try await remoteDataSource.images(forTVSeries: tvSeriesID)
        } catch let error {
            let e = TVSeriesRepositoryError(error)
            span?.setData(error: e)
            span?.finish(status: .internalError)
            throw e
        }

        do {
            try await localDataSource.setImages(imageCollection, forTVSeries: tvSeriesID)
        } catch let error {
            let e = TVSeriesRepositoryError(error)
            span?.setData(error: e)
            span?.finish(status: .internalError)
            throw e
        }

        span?.finish()
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
