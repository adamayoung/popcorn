//
//  TVListingsInfrastructureFactory.swift
//  Popcorn
//
//  Copyright © 2026 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import OSLog
import SwiftData
import TVListingsDomain

package final class TVListingsInfrastructureFactory {

    private static let logger = Logger.tvListingsInfrastructure

    private static let schema = Schema([
        TVChannelEntity.self,
        TVChannelNumberEntity.self,
        TVProgrammeEntity.self
    ])

    ///
    /// Builds the default on-disk model container for production use.
    /// Tests should inject an in-memory container instead of calling this.
    ///
    package static func makeDefaultModelContainer() -> ModelContainer {
        let storeURL = URL.documentsDirectory.appending(path: "popcorn-tvlistings.sqlite")

        return ModelContainerFactory.makeLocalModelContainer(
            schema: schema,
            url: storeURL,
            logger: logger
        )
    }

    ///
    /// Builds an in-memory container suitable for tests. Each call returns a fresh
    /// container backed by its own memory store.
    ///
    package static func makeInMemoryModelContainer() throws -> ModelContainer {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        return try ModelContainer(for: schema, configurations: [configuration])
    }

    private let remoteDataSource: any TVListingsRemoteDataSource
    private let localDataSource: any TVListingsLocalDataSource

    package init(
        remoteDataSource: some TVListingsRemoteDataSource,
        modelContainer: ModelContainer,
        calendar: Calendar = .ukGregorian
    ) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = SwiftDataTVListingsLocalDataSource(
            modelContainer: modelContainer,
            calendar: calendar
        )
    }

    package func makeTVChannelRepository() -> some TVChannelRepository {
        DefaultTVChannelRepository(localDataSource: localDataSource)
    }

    package func makeTVProgrammeRepository() -> some TVProgrammeRepository {
        DefaultTVProgrammeRepository(localDataSource: localDataSource)
    }

    package func makeTVListingsSyncRepository() -> some TVListingsSyncRepository {
        DefaultTVListingsSyncRepository(
            remoteDataSource: remoteDataSource,
            localDataSource: localDataSource
        )
    }

}
