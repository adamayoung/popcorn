//
//  DiscoverInfrastructureFactory.swift
//  PopcornDiscover
//
//  Copyright © 2026 Adam Young.
//

import DataPersistenceInfrastructure
import DiscoverDomain
import Foundation
import OSLog
import SwiftData

package final class DiscoverInfrastructureFactory {

    private static let logger = Logger.discoverInfrastructure

    private static let modelContainer: ModelContainer = {
        let schema = Schema([
            DiscoverMovieItemEntity.self,
            DiscoverMoviePreviewEntity.self,
            DiscoverTVSeriesItemEntity.self,
            DiscoverTVSeriesPreviewEntity.self
        ])

        let storeURL = URL.documentsDirectory.appending(path: "popcorn-discover.sqlite")

        return ModelContainerFactory.makeLocalModelContainer(
            schema: schema,
            url: storeURL,
            logger: logger
        )
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
