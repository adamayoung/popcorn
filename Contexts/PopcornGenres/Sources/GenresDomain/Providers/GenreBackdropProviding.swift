//
//  GenreBackdropProviding.swift
//  PopcornGenres
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol GenreBackdropProviding: Sendable {

    func backdropPath(forGenreID genreID: Genre.ID) async throws(GenreBackdropProviderError) -> URL?

}

public enum GenreBackdropProviderError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
