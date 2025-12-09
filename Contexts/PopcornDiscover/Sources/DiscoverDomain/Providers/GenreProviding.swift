//
//  GenreProviding.swift
//  PopcornDiscover
//
//  Created by Adam Young on 09/12/2025.
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
