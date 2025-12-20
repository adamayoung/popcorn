//
//  GenreRemoteDataSource.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol GenreRemoteDataSource: Sendable {

    func movieGenres() async throws(GenreRemoteDataSourceError) -> [Genre]

    func tvSeriesGenres() async throws(GenreRemoteDataSourceError) -> [Genre]

}

public enum GenreRemoteDataSourceError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
