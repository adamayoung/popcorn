//
//  GenreRepository.swift
//  PopcornGenres
//
//  Created by Adam Young on 09/12/2025.
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
