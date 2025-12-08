//
//  TVInfrastructureFactory.swift
//  TVKit
//
//  Created by Adam Young on 18/11/2025.
//

import Caching
import Foundation
import TVDomain

package final class TVInfrastructureFactory {

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

extension TVInfrastructureFactory {

    private func makeTVSeriesLocalDataSource() -> some TVSeriesLocalDataSource {
        let cache = makeCache()
        return CachedTVSeriesLocalDataSource(cache: cache)
    }

}

extension TVInfrastructureFactory {

    private func makeCache() -> some Caching {
        Self.cache
    }

}
