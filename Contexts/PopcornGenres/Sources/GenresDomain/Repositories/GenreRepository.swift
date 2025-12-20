//
//  GenreRepository.swift
//  PopcornGenres
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol GenreRepository: Sendable {

    func movieGenres() async throws(GenreRepositoryError) -> [Genre]

    func tvSeriesGenres() async throws(GenreRepositoryError) -> [Genre]

}

public enum GenreRepositoryError: Error {

    case unauthorised
    case unknown(Error?)

}
