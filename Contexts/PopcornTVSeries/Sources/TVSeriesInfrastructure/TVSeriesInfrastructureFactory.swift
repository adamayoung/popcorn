//
//  TVSeriesInfrastructureFactory.swift
//  Popcorn
//
//  Copyright © 2025 Adam Young.
//

import Caching
import Foundation
import TVSeriesDomain

package final class TVSeriesInfrastructureFactory {

    private static let cache: some Caching = CachesFactory.makeInMemoryCache(defaultExpiresIn: 60)

    private let tvSeriesRemoteDataSource: any TVSeriesRemoteDataSource

    package init(tvSeriesRemoteDataSource: some TVSeriesRemoteDataSource) {
        self.tvSeriesRemoteDataSource = tvSeriesRemoteDataSource
    }

    package func makeTVSeriesRepository() -> some TVSeriesRepository {
        let localDataSource = makeTVSeriesLocalDataSource()
        return DefaultTVSeriesRepository(
            remoteDataSource: tvSeriesRemoteDataSource,
            localDataSource: localDataSource
        )
    }

}

extension TVSeriesInfrastructureFactory {

    private func makeTVSeriesLocalDataSource() -> some TVSeriesLocalDataSource {
        let cache = makeCache()
        return CachedTVSeriesLocalDataSource(cache: cache)
    }

}

extension TVSeriesInfrastructureFactory {

    private func makeCache() -> some Caching {
        Self.cache
    }

}
