//
//  MoviesWatchlistSchemaV1Tests.swift
//  PopcornMovies
//
//  Copyright © 2026 Adam Young.
//

@testable import MoviesInfrastructure
import SwiftData
import Testing

@Suite("MoviesWatchlistSchemaV1")
struct MoviesWatchlistSchemaV1Tests {

    @Test("version identifier is 1.0.0")
    func versionIdentifierIs1_0_0() {
        #expect(MoviesWatchlistSchemaV1.versionIdentifier == Schema.Version(1, 0, 0))
    }

    @Test("models contains MoviesWatchlistMovieEntity")
    func modelsContainsWatchlistMovieEntity() {
        #expect(MoviesWatchlistSchemaV1.models.count == 1)
        #expect(MoviesWatchlistSchemaV1.models.first is MoviesWatchlistMovieEntity.Type)
    }

}
