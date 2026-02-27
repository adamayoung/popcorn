//
//  SearchHistoryMigrationPlan.swift
//  PopcornSearch
//
//  Copyright © 2026 Adam Young.
//

import SwiftData

package enum SearchHistoryMigrationPlan: SchemaMigrationPlan {

    package static let schemas: [any VersionedSchema.Type] = [
        SearchHistorySchemaV1.self
    ]

    package static let stages: [MigrationStage] = []

}
