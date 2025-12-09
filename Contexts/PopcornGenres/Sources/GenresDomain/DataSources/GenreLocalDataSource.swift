//
//  GenreLocalDataSource.swift
//  PopcornGenres
//
//  Created by Adam Young on 09/12/2025.
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
