//
//  TrendingInfrastructureFactory.swift
//  PopcornTrending
//
//  Copyright © 2025 Adam Young.
//

import Foundation
import TrendingDomain

package final class TrendingInfrastructureFactory {

    private let trendingRemoteDataSource: any TrendingRemoteDataSource

    package init(trendingRemoteDataSource: some TrendingRemoteDataSource) {
        self.trendingRemoteDataSource = trendingRemoteDataSource
    }

    package func makeTrendingRepository() -> some TrendingRepository {
        DefaultTrendingRepository(remoteDataSource: trendingRemoteDataSource)
    }

}
