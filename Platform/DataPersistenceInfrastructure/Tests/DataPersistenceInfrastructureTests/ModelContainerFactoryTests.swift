//
//  ModelContainerFactoryTests.swift
//  DataPersistenceInfrastructure
//
//  Copyright © 2026 Adam Young.
//

import DataPersistenceInfrastructure
import Foundation
import OSLog
import SwiftData
import Testing

@Suite("ModelContainerFactory")
struct ModelContainerFactoryTests {

    private let logger = Logger(subsystem: "test", category: "ModelContainerFactoryTests")

    // MARK: - makeLocalModelContainer

    @Test("creates a local ModelContainer successfully")
    func makeLocalModelContainerCreatesContainer() {
        let url = Self.temporarySQLiteURL()
        let schema = Schema([TestEntity.self])

        let container = ModelContainerFactory.makeLocalModelContainer(
            schema: schema,
            url: url,
            logger: logger
        )

        #expect(container.schema.entities.isEmpty == false)

        Self.cleanUpSQLiteFiles(at: url)
    }

    @Test("creates a local ModelContainer when no previous database exists")
    func makeLocalModelContainerCreatesContainerFreshInstall() {
        let url = Self.temporarySQLiteURL()

        #expect(FileManager.default.fileExists(atPath: url.path()) == false)

        let schema = Schema([TestEntity.self])

        let container = ModelContainerFactory.makeLocalModelContainer(
            schema: schema,
            url: url,
            logger: logger
        )

        #expect(container.schema.entities.isEmpty == false)

        Self.cleanUpSQLiteFiles(at: url)
    }

    // MARK: - makeCloudKitModelContainer

    @Test("creates a CloudKit ModelContainer with migration plan")
    func makeCloudKitModelContainerCreatesContainer() {
        let url = Self.temporarySQLiteURL()
        let schema = Schema([TestEntity.self])

        let container = ModelContainerFactory.makeCloudKitModelContainer(
            schema: schema,
            url: url,
            cloudKitDatabase: .none,
            migrationPlan: TestMigrationPlan.self,
            logger: logger
        )

        #expect(container.schema.entities.isEmpty == false)

        Self.cleanUpSQLiteFiles(at: url)
    }

    // MARK: - removeSQLiteFiles

    @Test("removes all SQLite files including WAL and SHM")
    func removeSQLiteFilesRemovesAllFiles() throws {
        let url = Self.temporarySQLiteURL()
        let walURL = URL(filePath: url.path() + "-wal")
        let shmURL = URL(filePath: url.path() + "-shm")

        try Data().write(to: url)
        try Data().write(to: walURL)
        try Data().write(to: shmURL)

        #expect(FileManager.default.fileExists(atPath: url.path()))
        #expect(FileManager.default.fileExists(atPath: walURL.path()))
        #expect(FileManager.default.fileExists(atPath: shmURL.path()))

        ModelContainerFactory.removeSQLiteFiles(at: url)

        #expect(FileManager.default.fileExists(atPath: url.path()) == false)
        #expect(FileManager.default.fileExists(atPath: walURL.path()) == false)
        #expect(FileManager.default.fileExists(atPath: shmURL.path()) == false)
    }

    @Test("handles non-existent files without error")
    func removeSQLiteFilesHandlesNonExistentFiles() {
        let url = Self.temporarySQLiteURL()

        #expect(FileManager.default.fileExists(atPath: url.path()) == false)

        ModelContainerFactory.removeSQLiteFiles(at: url)

        #expect(FileManager.default.fileExists(atPath: url.path()) == false)
    }

    @Test("removes only existing files when some journal files are missing")
    func removeSQLiteFilesRemovesPartialFiles() throws {
        let url = Self.temporarySQLiteURL()
        let walURL = URL(filePath: url.path() + "-wal")

        try Data().write(to: url)
        try Data().write(to: walURL)

        ModelContainerFactory.removeSQLiteFiles(at: url)

        #expect(FileManager.default.fileExists(atPath: url.path()) == false)
        #expect(FileManager.default.fileExists(atPath: walURL.path()) == false)
    }

}

// MARK: - Test Helpers

extension ModelContainerFactoryTests {

    private static func temporarySQLiteURL() -> URL {
        URL.temporaryDirectory.appending(path: "test-\(UUID().uuidString).sqlite")
    }

    private static func cleanUpSQLiteFiles(at url: URL) {
        ModelContainerFactory.removeSQLiteFiles(at: url)
    }

}

// MARK: - Test Model

@Model
private final class TestEntity {

    var name: String = ""

    init(name: String) {
        self.name = name
    }

}

// MARK: - Test Migration Plan

private enum TestSchemaV1: VersionedSchema {

    static let versionIdentifier = Schema.Version(1, 0, 0)

    static let models: [any PersistentModel.Type] = [
        TestEntity.self
    ]

}

private enum TestMigrationPlan: SchemaMigrationPlan {

    static let schemas: [any VersionedSchema.Type] = [
        TestSchemaV1.self
    ]

    static let stages: [MigrationStage] = []

}
