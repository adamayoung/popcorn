//
//  GenreProviding.swift
//  PopcornDiscover
//
//  Copyright © 2025 Adam Young.
//

import Foundation

public protocol GenreProviding: Sendable {

    func movieGenres() async throws(GenreProviderError) -> [Genre]

    func tvSeriesGenres() async throws(GenreProviderError) -> [Genre]

}

public enum GenreProviderError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
