//
//  GenreRemoteDataSource.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation
import GenresDomain

public protocol GenreRemoteDataSource: Sendable {

    func movieGenres() async throws(GenreRemoteDataSourceError) -> [Genre]

    func tvSeriesGenres() async throws(GenreRemoteDataSourceError) -> [Genre]

}

public enum GenreRemoteDataSourceError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
