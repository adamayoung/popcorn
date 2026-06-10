//
//  SearchInfrastructureFactory.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import OSLog
import SearchDomain
import SwiftData

package final class SearchInfrastructureFactory {

    private static let logger = Logger.searchInfrastructure

    private static let cloudKitModelContainer: ModelContainer = {
        let schema = Schema([
            SearchMediaSearchHistoryEntryEntity.self
        ])

        let oldStoreURL = URL.documentsDirectory.appending(path: "searchkit-cloudkit.sqlite")
        ModelContainerFactory.removeSQLiteFiles(at: oldStoreURL)

        let storeURL = URL.documentsDirectory.appending(path: "popcorn-search-cloudkit.sqlite")

        let cloudKitDatabase: ModelConfiguration.CloudKitDatabase =
            ModelContainerFactory.isCloudKitAvailable()
            ? .private("iCloud.uk.co.adam-young.Popcorn")
            : .none

        return ModelContainerFactory.makeCloudKitModelContainer(
            schema: schema,
            url: storeURL,
            cloudKitDatabase: cloudKitDatabase,
            migrationPlan: SearchHistoryMigrationPlan.self,
            logger: logger
        )
    }()

    private let mediaRemoteDataSource: any MediaRemoteDataSource

    package init(mediaRemoteDataSource: some MediaRemoteDataSource) {
        self.mediaRemoteDataSource = mediaRemoteDataSource
    }

    package func makeMediaRepository() -> some MediaRepository {
        DefaultMediaRepository(
            remoteDataSource: mediaRemoteDataSource,
            localDataSource: Self.mediaLocalDataSource
        )
    }

}

extension SearchInfrastructureFactory {

    private static let mediaLocalDataSource = SwiftDataMediaLocalDataSource(
        modelContainer: cloudKitModelContainer
    )

}
