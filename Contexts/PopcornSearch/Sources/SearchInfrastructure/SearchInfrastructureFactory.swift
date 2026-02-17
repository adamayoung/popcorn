//
//  SearchInfrastructureFactory.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

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

        let storeURL = URL.documentsDirectory.appending(path: "searchkit-cloudkit.sqlite")
        let config = ModelConfiguration(
            schema: schema,
            url: storeURL,
            cloudKitDatabase: .private("iCloud.uk.co.adam-young.Popcorn")
        )

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch let error {
            logger.critical(
                "Cannot configure CloudKit ModelContainer: \(error.localizedDescription, privacy: .public)"
            )
            fatalError(
                "SearchKit: Cannot configure CloudKit ModelContainer: \(error.localizedDescription)"
            )
        }
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
