//
//  MovieProviding.swift
//  PopcornPlotRemixGame
//
//  Created by Adam Young on 05/12/2025.
//

import Foundation

public protocol MovieProviding: Sendable {

    func randomMovies(filter: MovieFilter, limit: Int) async throws(MovieProviderError) -> [Movie]

}

public enum MovieProviderError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
