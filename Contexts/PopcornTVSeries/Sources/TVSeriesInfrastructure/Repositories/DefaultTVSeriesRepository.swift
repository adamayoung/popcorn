//
//  DefaultTVSeriesRepository.swift
//  PopcornTVSeries
//
//  Copyright © 2025 Adam Young.
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

    func tvSeries(
        withID id: Int,
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(TVSeriesRepositoryError) -> TVSeriesDomain.TVSeries {
        switch cachePolicy {
        case .cacheFirst:
            do {
                if let cached = try await localDataSource.tvSeries(withID: id) {
                    return cached
                }
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

            let tvSeries: TVSeriesDomain.TVSeries
            do {
                tvSeries = try await remoteDataSource.tvSeries(withID: id)
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

            do {
                try await localDataSource.setTVSeries(tvSeries)
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

            return tvSeries

        case .networkOnly:
            let tvSeries: TVSeriesDomain.TVSeries
            do {
                tvSeries = try await remoteDataSource.tvSeries(withID: id)
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

            do {
                try await localDataSource.setTVSeries(tvSeries)
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

            return tvSeries

        case .cacheOnly:
            do {
                if let cached = try await localDataSource.tvSeries(withID: id) {
                    return cached
                }
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

            throw .cacheUnavailable
        }
    }

    func images(
        forTVSeries tvSeriesID: Int,
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(TVSeriesRepositoryError) -> TVSeriesDomain.ImageCollection {
        switch cachePolicy {
        case .cacheFirst:
            do {
                if let cached = try await localDataSource.images(forTVSeries: tvSeriesID) {
                    return cached
                }
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

            let imageCollection: TVSeriesDomain.ImageCollection
            do {
                imageCollection = try await remoteDataSource.images(forTVSeries: tvSeriesID)
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

            do {
                try await localDataSource.setImages(imageCollection, forTVSeries: tvSeriesID)
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

            return imageCollection

        case .networkOnly:
            let imageCollection: TVSeriesDomain.ImageCollection
            do {
                imageCollection = try await remoteDataSource.images(forTVSeries: tvSeriesID)
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

            do {
                try await localDataSource.setImages(imageCollection, forTVSeries: tvSeriesID)
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

            return imageCollection

        case .cacheOnly:
            do {
                if let cached = try await localDataSource.images(forTVSeries: tvSeriesID) {
                    return cached
                }
            } catch let error {
                throw TVSeriesRepositoryError(error)
            }

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
