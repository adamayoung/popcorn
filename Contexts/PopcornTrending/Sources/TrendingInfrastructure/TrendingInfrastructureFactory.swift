//
//  TrendingInfrastructureFactory.swift
//  PopcornTrending
//
//  Created by Adam Young on 28/05/2025.
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
