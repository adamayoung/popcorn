//
//  SearchInfrastructureFactory.swift
//  PopcornSearch
//
//  Created by Adam Young on 28/05/2025.
//

import Foundation
import SearchDomain
import SwiftData

package final class SearchInfrastructureFactory {

    private static let cloudKitModelContainer: ModelContainer = {
        let schema = Schema([
            SearchMediaSearchHistoryEntryEntity.self
        ])

        let storeURL = URL.documentsDirectory.appending(path: "searchkit-cloudkit.sqlite")
        let config = ModelConfiguration(
            schema: schema,
            url: storeURL,
            cloudKitDatabase: .private("iCloud.uk.co.adam-young.Movies")
        )

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch let error {
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
