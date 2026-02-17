//
//  MovieProviding.swift
//  PopcornPlotRemixGame
//
//  Copyright © 2026 Adam Young.
//

import Foundation

public protocol MovieProviding: Sendable {

    func randomMovies(filter: MovieFilter, limit: Int) async throws(MovieProviderError) -> [Movie]

    func randomSimilarMovies(
        to movieID: Int,
        limit: Int
    ) async throws(MovieProviderError) -> [Movie]

}

public enum MovieProviderError: Error {

    case unauthorised
    case unknown(Error? = nil)

}
