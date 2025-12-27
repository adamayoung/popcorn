//
//  DefaultTVSeriesRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
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

    func tvSeries(
        withID id: Int,
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(TVSeriesRepositoryError) -> TVSeriesDomain.TVSeries {
        let span = SpanContext.startChild(
            operation: .repositoryGet,
            description: "Fetch TV Series #\(id)"
        )
        span?.setData([
            "entity_type": "TVSeries",
            "entity_id": id,
            "cache.policy": String(describing: cachePolicy)
        ])

        switch cachePolicy {
        case .cacheFirst:
            do {
                if let cached = try await localDataSource.tvSeries(withID: id) {
                    span?.setData(key: "cache.hit", value: true)
                    span?.finish()
                    return cached
                }
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            span?.setData(key: "cache.hit", value: false)

            let tvSeries: TVSeriesDomain.TVSeries
            do {
                tvSeries = try await remoteDataSource.tvSeries(withID: id)
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            do {
                try await localDataSource.setTVSeries(tvSeries)
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            span?.finish()
            return tvSeries

        case .networkOnly:
            span?.setData(key: "cache.hit", value: false)

            let tvSeries: TVSeriesDomain.TVSeries
            do {
                tvSeries = try await remoteDataSource.tvSeries(withID: id)
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            do {
                try await localDataSource.setTVSeries(tvSeries)
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            span?.finish()
            return tvSeries

        case .cacheOnly:
            do {
                if let cached = try await localDataSource.tvSeries(withID: id) {
                    span?.setData(key: "cache.hit", value: true)
                    span?.finish()
                    return cached
                }
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            span?.setData(key: "cache.hit", value: false)
            span?.finish(status: .internalError)
            throw .cacheUnavailable
        }
    }

    func images(
        forTVSeries tvSeriesID: Int,
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(TVSeriesRepositoryError) -> TVSeriesDomain.ImageCollection {
        let span = SpanContext.startChild(
            operation: .repositoryGet,
            description: "Fetch TV Series Images #\(tvSeriesID)"
        )
        span?.setData([
            "entity_type": "ImageCollection",
            "entity_id": tvSeriesID,
            "cache.policy": String(describing: cachePolicy)
        ])

        switch cachePolicy {
        case .cacheFirst:
            do {
                if let cached = try await localDataSource.images(forTVSeries: tvSeriesID) {
                    span?.setData(key: "cache.hit", value: true)
                    span?.finish()
                    return cached
                }
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            span?.setData(key: "cache.hit", value: false)

            let imageCollection: TVSeriesDomain.ImageCollection
            do {
                imageCollection = try await remoteDataSource.images(forTVSeries: tvSeriesID)
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            do {
                try await localDataSource.setImages(imageCollection, forTVSeries: tvSeriesID)
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            span?.finish()
            return imageCollection

        case .networkOnly:
            span?.setData(key: "cache.hit", value: false)

            let imageCollection: TVSeriesDomain.ImageCollection
            do {
                imageCollection = try await remoteDataSource.images(forTVSeries: tvSeriesID)
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            do {
                try await localDataSource.setImages(imageCollection, forTVSeries: tvSeriesID)
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            span?.finish()
            return imageCollection

        case .cacheOnly:
            do {
                if let cached = try await localDataSource.images(forTVSeries: tvSeriesID) {
                    span?.setData(key: "cache.hit", value: true)
                    span?.finish()
                    return cached
                }
            } catch let error {
                let repositoryError = TVSeriesRepositoryError(error)
                span?.setData(error: repositoryError)
                span?.finish(status: .internalError)
                throw repositoryError
            }

            span?.setData(key: "cache.hit", value: false)
            span?.finish(status: .internalError)
            throw .cacheUnavailable
        }
    }

}

private extension TVSeriesRepositoryError {

    init(_ error: Error) {
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

    init(_ error: TVSeriesRemoteDataSourceError) {
        switch error {
        case .notFound: self = .notFound
        case .unauthorised: self = .unauthorised
        case .unknown(let error): self = .unknown(error)
        }
    }

    init(_ error: TVSeriesLocalDataSourceError) {
        switch error {
        case .persistence(let error): self = .unknown(error)
        case .unknown(let error): self = .unknown(error)
        }
    }

}
