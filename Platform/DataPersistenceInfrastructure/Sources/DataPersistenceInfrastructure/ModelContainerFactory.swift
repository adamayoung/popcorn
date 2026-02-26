//
//  ModelContainerFactory.swift
//  DataPersistenceInfrastructure
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import OSLog
import SwiftData

public enum ModelContainerFactory {

    public static func makeLocalModelContainer(
        schema: Schema,
        url: URL,
        logger: Logger
    ) -> ModelContainer {
        let config = ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)

        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch let error {
            logger.warning(
                "ModelContainer creation failed, removing database: \(error.localizedDescription, privacy: .public)"
            )

            removeSQLiteFiles(at: url)

            do {
                return try ModelContainer(for: schema, configurations: [config])
            } catch let error {
                logger.critical(
                    "Cannot create ModelContainer after reset: \(error.localizedDescription, privacy: .public)"
                )
                fatalError("Cannot create ModelContainer after reset: \(error.localizedDescription)")
            }
        }
    }

    public static func makeCloudKitModelContainer(
        schema: Schema,
        url: URL,
        cloudKitDatabase: ModelConfiguration.CloudKitDatabase,
        migrationPlan: (some SchemaMigrationPlan).Type,
        logger: Logger
    ) -> ModelContainer {
        let config = ModelConfiguration(schema: schema, url: url, cloudKitDatabase: cloudKitDatabase)

        do {
            return try ModelContainer(for: schema, migrationPlan: migrationPlan, configurations: [config])
        } catch let error {
            logger.critical(
                "Cannot create CloudKit ModelContainer: \(error.localizedDescription, privacy: .public)"
            )
            fatalError("Cannot create CloudKit ModelContainer: \(error.localizedDescription)")
        }
    }

    public static func removeSQLiteFiles(at url: URL) {
        let fileManager = FileManager.default
        let suffixes = ["", "-wal", "-shm"]

        for suffix in suffixes {
            let fileURL = URL(filePath: url.path() + suffix)
            try? fileManager.removeItem(at: fileURL)
        }
    }

}
