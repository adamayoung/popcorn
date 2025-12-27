//
//  DefaultDiscoverTVSeriesRepository.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import DiscoverDomain
import Foundation

final class DefaultDiscoverTVSeriesRepository: DiscoverTVSeriesRepository {

    private let remoteDataSource: any DiscoverRemoteDataSource
    private let localDataSource: any DiscoverTVSeriesLocalDataSource

    init(
        remoteDataSource: some DiscoverRemoteDataSource,
        localDataSource: any DiscoverTVSeriesLocalDataSource
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
    }

    func tvSeries(
        filter: TVSeriesFilter?,
        page: Int,
        cachePolicy: CachePolicy = .cacheFirst
    ) async throws(DiscoverTVSeriesRepositoryError) -> [TVSeriesPreview] {
        switch cachePolicy {
        case .cacheFirst:
            do {
                if let cachedTVSeries = try await localDataSource.tvSeries(filter: filter, page: page) {
                    return cachedTVSeries
                }
            } catch let error {
                throw DiscoverTVSeriesRepositoryError(error)
            }

            let tvSeries: [TVSeriesPreview]
            do {
                tvSeries = try await remoteDataSource.tvSeries(filter: filter, page: page)
            } catch let error {
                throw DiscoverTVSeriesRepositoryError(error)
            }

            do {
                try await localDataSource.setTVSeries(tvSeries, filter: filter, page: page)
            } catch let error {
                throw DiscoverTVSeriesRepositoryError(error)
            }

            return tvSeries

        case .networkOnly:
            let tvSeries: [TVSeriesPreview]
            do {
                tvSeries = try await remoteDataSource.tvSeries(filter: filter, page: page)
            } catch let error {
                throw DiscoverTVSeriesRepositoryError(error)
            }

            do {
                try await localDataSource.setTVSeries(tvSeries, filter: filter, page: page)
            } catch let error {
                throw DiscoverTVSeriesRepositoryError(error)
            }

            return tvSeries

        case .cacheOnly:
            do {
                if let cachedTVSeries = try await localDataSource.tvSeries(filter: filter, page: page) {
                    return cachedTVSeries
                }
            } catch let error {
                throw DiscoverTVSeriesRepositoryError(error)
            }

            throw .cacheUnavailable
        }
    }

}

extension DiscoverTVSeriesRepositoryError {

    init(_ error: DiscoverTVSeriesLocalDataSourceError) {
        switch error {
        case .persistence(let error):
            self = .unknown(error)
        case .unknown(let error):
            self = .unknown(error)
        }
    }

    init(_ error: DiscoverRemoteDataSourceError) {
        switch error {
        case .unauthorised:
            self = .unauthorised
        case .unknown(let error):
            self = .unknown(error)
        }
    }

}
