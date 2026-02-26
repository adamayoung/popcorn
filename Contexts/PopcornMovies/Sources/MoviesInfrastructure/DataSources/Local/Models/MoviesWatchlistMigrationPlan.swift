//
//  MoviesWatchlistMigrationPlan.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import SwiftData

package enum MoviesWatchlistMigrationPlan: SchemaMigrationPlan {

    package static let schemas: [any VersionedSchema.Type] = [
        MoviesWatchlistSchemaV1.self
    ]

    package static let stages: [MigrationStage] = []

}
