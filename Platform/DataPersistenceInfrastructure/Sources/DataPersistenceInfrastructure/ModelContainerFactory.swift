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
        let cloudKitConfig = ModelConfiguration(schema: schema, url: url, cloudKitDatabase: cloudKitDatabase)

        do {
            return try ModelContainer(for: schema, migrationPlan: migrationPlan, configurations: [cloudKitConfig])
        } catch let error {
            // CloudKit may be unavailable — e.g. no iCloud entitlement (unsigned / CI
            // builds) or the user isn't signed into iCloud. Degrade to a local-only
            // store so the app still launches with on-device persistence rather than
            // crashing.
            logger.warning(
                "CloudKit ModelContainer unavailable, falling back to a local store: \(error.localizedDescription, privacy: .public)"
            )

            let localConfig = ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)

            do {
                return try ModelContainer(for: schema, migrationPlan: migrationPlan, configurations: [localConfig])
            } catch let error {
                logger.warning(
                    "Local ModelContainer creation failed, removing database: \(error.localizedDescription, privacy: .public)"
                )

                removeSQLiteFiles(at: url)

                do {
                    return try ModelContainer(for: schema, migrationPlan: migrationPlan, configurations: [localConfig])
                } catch let error {
                    logger.critical(
                        "Cannot create ModelContainer after reset: \(error.localizedDescription, privacy: .public)"
                    )
                    fatalError("Cannot create ModelContainer after reset: \(error.localizedDescription)")
                }
            }
        }
    }

    public static func removeSQLiteFiles(at url: URL) {
        let fileManager = FileManager.default
        let suffixes = ["", "-wal", "-shm"]

        let directory = url.deletingLastPathComponent()
        let filename = url.lastPathComponent

        for suffix in suffixes {
            let fileURL = directory.appending(path: filename + suffix)
            try? fileManager.removeItem(at: fileURL)
        }
    }

}
