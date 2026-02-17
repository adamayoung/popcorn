//
//  GenreProviding.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol GenreProviding: Sendable {

    func movies() async throws(GenreProviderError) -> [Genre]

}

public enum GenreProviderError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
