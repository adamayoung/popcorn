//
//  TVSeriesInfrastructureFactory.swift
//  PopcornTVSeries
//
//  Copyright © 2026 Adam Young.
//

import DataPersistenceInfrastructure
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
            TVEpisodeEntity.self,
            TVEpisodeDetailsCacheEntity.self,
            TVSeriesCreditsEntity.self,
            TVSeriesCastMemberEntity.self,
            TVSeriesCrewMemberEntity.self,
            TVSeriesAggregateCreditsEntity.self,
            TVSeriesAggregateCastMemberEntity.self,
            TVSeriesAggregateCrewMemberEntity.self
        ])

        let storeURL = URL.documentsDirectory.appending(path: "popcorn-tvseries.sqlite")

        return ModelContainerFactory.makeLocalModelContainer(
            schema: schema,
            url: storeURL,
            logger: logger
        )
    }()

    private let tvSeriesRemoteDataSource: any TVSeriesRemoteDataSource
    private let tvSeasonRemoteDataSource: any TVSeasonRemoteDataSource
    private let tvEpisodeRemoteDataSource: any TVEpisodeRemoteDataSource

    package init(
        tvSeriesRemoteDataSource: some TVSeriesRemoteDataSource,
        tvSeasonRemoteDataSource: some TVSeasonRemoteDataSource,
        tvEpisodeRemoteDataSource: some TVEpisodeRemoteDataSource
    ) {
        self.tvSeriesRemoteDataSource = tvSeriesRemoteDataSource
        self.tvSeasonRemoteDataSource = tvSeasonRemoteDataSource
        self.tvEpisodeRemoteDataSource = tvEpisodeRemoteDataSource
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

    package func makeTVEpisodeRepository() -> some TVEpisodeRepository {
        DefaultTVEpisodeRepository(
            remoteDataSource: tvEpisodeRemoteDataSource,
            localDataSource: Self.tvEpisodeLocalDataSource
        )
    }

    package func makeTVSeriesCreditsRepository() -> some TVSeriesCreditsRepository {
        DefaultTVSeriesCreditsRepository(
            remoteDataSource: tvSeriesRemoteDataSource,
            localDataSource: Self.tvSeriesCreditsLocalDataSource,
            aggregateCreditsLocalDataSource: Self.tvSeriesAggregateCreditsLocalDataSource
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

    private static let tvEpisodeLocalDataSource: some TVEpisodeLocalDataSource =
        SwiftDataTVEpisodeLocalDataSource(
            modelContainer: modelContainer
        )

    private static let tvSeriesCreditsLocalDataSource: some TVSeriesCreditsLocalDataSource =
        SwiftDataTVSeriesCreditsLocalDataSource(
            modelContainer: modelContainer
        )

    private static let tvSeriesAggregateCreditsLocalDataSource:
        some TVSeriesAggregateCreditsLocalDataSource =
        SwiftDataTVSeriesAggregateCreditsLocalDataSource(
            modelContainer: modelContainer
        )

}
