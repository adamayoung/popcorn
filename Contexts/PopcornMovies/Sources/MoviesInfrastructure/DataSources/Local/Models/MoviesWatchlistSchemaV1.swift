//
//  MoviesWatchlistSchemaV1.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

import SwiftData

package enum MoviesWatchlistSchemaV1: VersionedSchema {

    package static let versionIdentifier = Schema.Version(1, 0, 0)

    package static let models: [any PersistentModel.Type] = [
        MoviesWatchlistMovieEntity.self
    ]

}
