//
//  DiscoverInfrastructureFactory.swift
//  PopcornDiscover
//
//  Created by Adam Young on 09/12/2025.
//

import DiscoverDomain
import Foundation
import SwiftData

package final class DiscoverInfrastructureFactory {

    private static let modelContainer: ModelContainer = {
        let schema = Schema([
            DiscoverMovieItemEntity.self,
            DiscoverMoviePreviewEntity.self,
            DiscoverTVSeriesItemEntity.self,
            DiscoverTVSeriesPreviewEntity.self
        ])

        let storeURL = URL.documentsDirectory.appending(path: "popcorn-discover.sqlite")
        let config = ModelConfiguration(schema: schema, url: storeURL, cloudKitDatabase: .none)

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch let error {
            fatalError(
                "PopcornDiscover: Cannot configure ModelContainer: \(error.localizedDescription)")
        }
    }()

    private let discoverRemoteDataSource: any DiscoverRemoteDataSource

    package init(discoverRemoteDataSource: some DiscoverRemoteDataSource) {
        self.discoverRemoteDataSource = discoverRemoteDataSource
    }

    package func makeDiscoverMovieRepository() -> some DiscoverMovieRepository {
        DefaultDiscoverMovieRepository(
            remoteDataSource: discoverRemoteDataSource,
            localDataSource: Self.discoverMovieLocalDataSource
        )
    }

    package func makeDiscoverTVSeriesRepository() -> some DiscoverTVSeriesRepository {
        DefaultDiscoverTVSeriesRepository(
            remoteDataSource: discoverRemoteDataSource,
            localDataSource: Self.discoverTVSeriesLocalDataSource
        )
    }

}

extension DiscoverInfrastructureFactory {

    private static let discoverMovieLocalDataSource: some DiscoverMovieLocalDataSource =
        SwiftDataDiscoverMovieLocalDataSource(modelContainer: modelContainer)

    private static let discoverTVSeriesLocalDataSource: some DiscoverTVSeriesLocalDataSource =
        SwiftDataDiscoverTVSeriesLocalDataSource(modelContainer: modelContainer)

}
