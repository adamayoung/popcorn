//
//  GenreRemoteDataSource.swift
//  PopcornGenres
//
//  Created by Adam Young on 09/12/2025.
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
