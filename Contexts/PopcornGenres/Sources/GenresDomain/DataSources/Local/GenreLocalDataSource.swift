//
//  GenreLocalDataSource.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol GenreLocalDataSource: Sendable, Actor {

    func movieGenres() async throws(GenreLocalDataSourceError) -> [Genre]?

    func setMovieGenres(_ genres: [Genre]) async throws(GenreLocalDataSourceError)

    func tvSeriesGenres() async throws(GenreLocalDataSourceError) -> [Genre]?

    func setTVSeriesGenres(_ genres: [Genre]) async throws(GenreLocalDataSourceError)

}

public enum GenreLocalDataSourceError: Error {

    case persistence(Error)
    case unknown(Error? = nil)

}
