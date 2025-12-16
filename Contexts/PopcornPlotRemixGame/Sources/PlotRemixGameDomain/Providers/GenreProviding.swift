//
//  GenreProviding.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 10/12/2025.
//

import Foundation

public protocol GenreProviding: Sendable {

    func movies() async throws(GenreProviderError) -> [Genre]

}

public enum GenreProviderError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
