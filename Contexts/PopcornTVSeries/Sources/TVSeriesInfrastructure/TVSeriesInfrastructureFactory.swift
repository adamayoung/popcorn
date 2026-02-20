//
//  TVSeriesInfrastructureFactory.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog
import SwiftData
import TVSeriesDomain

package final class TVSeriesInfrastructureFactory {

    private static let logger = Logger.tvSeriesInfrastructure

    private static let modelContainer: ModelContainer = {
        let schema = Schema([
            TVSeriesEntity.self,
            TVSeriesSeasonEntity.self,
            TVSeriesImageCollectionEntity.self,
            TVSeasonEpisodesEntity.self,
            TVEpisodeEntity.self
        ])

        let storeURL = URL.documentsDirectory.appending(path: "popcorn-tvseries.sqlite")
        let config = ModelConfiguration(schema: schema, url: storeURL, cloudKitDatabase: .none)

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch let error {
            logger.critical(
                "Cannot configure ModelContainer: \(error.localizedDescription, privacy: .public)"
            )
            fatalError(
                "PopcornTVSeries: Cannot configure ModelContainer: \(error.localizedDescription)"
            )
        }
    }()

    private let tvSeriesRemoteDataSource: any TVSeriesRemoteDataSource
    private let tvSeasonRemoteDataSource: any TVSeasonRemoteDataSource

    package init(
        tvSeriesRemoteDataSource: some TVSeriesRemoteDataSource,
        tvSeasonRemoteDataSource: some TVSeasonRemoteDataSource
    ) {
        self.tvSeriesRemoteDataSource = tvSeriesRemoteDataSource
        self.tvSeasonRemoteDataSource = tvSeasonRemoteDataSource
    }

    package func makeTVSeriesRepository() -> some TVSeriesRepository {
        DefaultTVSeriesRepository(
            remoteDataSource: tvSeriesRemoteDataSource,
            localDataSource: Self.tvSeriesLocalDataSource
        )
    }

    package func makeTVSeasonRepository() -> some TVSeasonRepository {
        DefaultTVSeasonRepository(
            remoteDataSource: tvSeasonRemoteDataSource,
            localDataSource: Self.tvSeasonLocalDataSource
        )
    }

}

extension TVSeriesInfrastructureFactory {

    private static let tvSeriesLocalDataSource: some TVSeriesLocalDataSource =
        SwiftDataTVSeriesLocalDataSource(
            modelContainer: modelContainer
        )

    private static let tvSeasonLocalDataSource: some TVSeasonLocalDataSource =
        SwiftDataTVSeasonLocalDataSource(
            modelContainer: modelContainer
        )

}
